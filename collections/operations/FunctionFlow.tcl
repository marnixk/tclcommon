namespace eval Std {

	#
	#	f> symbolises 'function flow'. You pass it the list of context variables you want to be
	#	available in the closures. 
	#
	proc f> {listObj context args} {

		if {![oo::instanceof? $listObj Std::List]} then {
			error "Only accepts list object"
		}

		# move variables down here
		foreach var $context {
			upvar 1 $var $var
		}

		set dispatcher [Std::Operations::Dispatch new $listObj]

		foreach {op closure} $args {
			set closureObj [-> $context {it} $closure]
			set newList [$dispatcher $op $closureObj]
			set dispatcher [Std::Operations::Dispatch new $newList]
		}

		return $newList
	}

}