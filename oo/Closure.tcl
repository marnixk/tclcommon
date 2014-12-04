package require TclOO

oo::class create Closure {

	variable vars
	variable body

	#
	#	Initialize data-members
	#
	constructor {aVars aBody} {
		set vars $aVars
		set body $aBody
	}

	#
	#	Execute the closure using the values provided in `values`
	#
	method run {values} {

		# make sure there are enough 
		if {[llength $values] != [llength $vars]} then {
			error "Expected [llength $vars] parameters: [join $vars {, }]"
		}

		for {set idx 0} {$idx < [llength $vars]} {incr idx} {
			set [lindex $vars $idx] [lindex $values $idx]
		}
		unset idx

		if 1 $body
	}

	#
	#	By implementing this method we can make the closure work
	#	like a functor without having to go through the `run`
	#	method explicitely
	#
	method unknown {args} {
		return [my run {*}$args]
	}
}

proc -> {args} {
	
	if {[llength $args] > 2} then {
		error "Expected a maximum of two parameters: <{varnames}> {code}"
	}

	if {[llength $args] == 2} {
		return [Closure new {*}$args]
	} else {
		return [Closure new {it} [lindex $args 0]]
	}
}
