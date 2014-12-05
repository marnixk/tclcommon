# add to dispatchable list 
lappend Std::Operations {filter Std::Operations::Filter}

#
#	Implementation of the each operator
#
namespace eval Std::Operations::Filter {

	proc do {listObj closureObj} {

		set outputList [Std::List new]

		foreach item [$listObj toList] {
			set result [$closureObj $item]

			# true? within filter.
			if {$result} then {
				$outputList add $item
			}

		}

		return $outputList
	}

}
