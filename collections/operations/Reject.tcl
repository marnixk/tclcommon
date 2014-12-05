# add to dispatchable list 
lappend Std::Operations {reject Std::Operations::Reject}

#
#	Implementation of the each operator
#
namespace eval Std::Operations::Reject {

	proc do {listObj closureObj} {

		set outputList [Std::List new]

		foreach item [$listObj toList] {
			set result [$closureObj $item]

			# false? rejected element.
			if {!$result} then {
				$outputList add $item
			}

		}

		return $outputList
	}

}
