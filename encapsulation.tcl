proc module {name body} {
	uplevel 1 [subst { namespace eval $name {$body} }]
}

proc include {ns} {

	set includables [subst -nocommands "\${${ns}::includables}"]

	uplevel 1 [subst {
		lappend _included "::${ns}"
	}]


	foreach procname $includables {
		uplevel 1 [subst {
			proc $procname {[info args ${ns}::$procname]} {[info body ${ns}::$procname]}
		}]
	}

}

#
#	Make this a public method that gets copied when included
#
proc public {name args body} {
	uplevel 1 [subst {
		lappend includables $name
		proc $name {$args} {$body}
	}]
}

#
#	This method gets copied when included, but is only allowed to be called
#	by any other public or protected method
#
proc protected {name args body} {

	set owner_ns [uplevel 1 namespace current]

	uplevel 1 [subst {
		lappend includables $name

		proc $name {$args} {
			variable _included
			set caller_ns \[uplevel 1 namespace current\]

			if {![info exists \$_included] && "$owner_ns" != \[namespace current\]} then {
				return -code error "`$name` illegally called from outside module"
			}

			if {\$caller_ns != "$owner_ns" && \[lsearch \$_included "$owner_ns"\] == -1} then {
				return -code error "`$name` illegally called from \$caller_ns"
			}

			if 1 {$body}
		}

	}]

}