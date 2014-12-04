package require TclOO

oo::class create Closure {

	variable vars
	variable body
	variable scopeValues

	#
	#	Initialize data-members
	#
	constructor {aScopeVars aVars aBody} {
		lappend scopeValues
		foreach varName $aScopeVars {
			upvar 2 $varName varValue
			lappend scopeValues [list $varName $varValue]
		}

		set vars $aVars
		set body $aBody

	}

	#
	#	Execute the closure using the values provided in `values`
	#
	method _run {values} {

		# make sure there are enough 
		if {[llength $values] != [llength $vars]} then {
			error "Expected [llength $vars] parameters: [join $vars {, }]"
		}

		for {set idx 0} {$idx < [llength $vars]} {incr idx} {
			set [lindex $vars $idx] [lindex $values $idx]
		}

		unset idx

		foreach scopeValue $scopeValues {
			lassign $scopeValue name value
			set $name $value
		}

		if 1 $body
	}

	#
	#	By implementing this method we can make the closure work
	#	like a functor without having to go through the `_run`
	#	method explicitely
	#
	method unknown {args} {
		return [my _run {*}$args]
	}
}

proc -> {args} {
	
	if {[llength $args] > 3} then {
		error "Expected a maximum of two parameters: <{scopeincludes}> <{codenames}> {code}"
	}

	if {[llength $args] == 3} {
		return [Closure new {*}$args]
	} elseif {[llength $args] == 2} {
		return [Closure new {} {*}$args]
	} else {
		return [Closure new {} {it} [lindex $args 0]]
	}
}
