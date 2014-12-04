# add to dispatchable list 
lappend Std::Operations {filter Std::Operations::Filter}

#
#	Implementation of the each operator
#
namespace eval Std::Operations::Filter {

	proc do {listObj closureObj} {

		# get the iterator
		set iterator [$listObj iterator]

		set outputList [Std::List new]

		while {[$iterator hasNext?]} {
			set item [$iterator next]
			set result [$closureObj $item]

			# true? within filter.
			if {$result} then {
				$outputList add $item
			}

		}

		return $outputList
	}

}
