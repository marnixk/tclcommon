
oo::class create Std::Operations::Dispatch {

	variable iterator

	#
	#	Initialize data-members
	#
	constructor {anIterator} {
		set iterator $anIterator
	}

	#
	#	Finds the operation that is requested
	#
	method findOperation {operation} {
		foreach items $Std::Operations {
			lassign $items name commandNamespace

			if {$operation == $name} {
				return $commandNamespace
			}
		}

		return {}
	}

	#
	#	Dispatcher method
	#
	method unknown {operation closure} {
	
		set op [my findOperation $operation]
		if {$op == {}} then {
			error "No such operation found `$operation`"
		}

		return [${op}::do $iterator $closure]
	}

}