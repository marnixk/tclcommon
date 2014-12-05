# add to dispatchable list 
lappend Std::Operations {each Std::Operations::Each}

#
#	Implementation of the each operator
#
namespace eval Std::Operations::Each {

	proc do {listObj closureObj} {

		foreach item [$listObj toList] {
			$closureObj $item
		}

		return $listObj
	}

}
