# add to dispatchable list 
lappend Std::Operations {reject Std::Operations::Reject}

#
#	Implementation of the each operator
#
namespace eval Std::Operations::Reject {

	proc do {listObj closureObj} {

		# get the iterator
		set iterator [$listObj iterator]

		set outputList [Std::List new]

		while {[$iterator hasNext?]} {
			set item [$iterator next]
			set result [$closureObj $item]

			# false? rejected element.
			if {!$result} then {
				$outputList add $item
			}

		}

		return $outputList
	}

}
