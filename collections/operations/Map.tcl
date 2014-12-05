# add to dispatchable list 
lappend Std::Operations {map Std::Operations::Map}

#
#	Implementation of the each operator
#
namespace eval Std::Operations::Map {

	proc do {listObj closureObj} {

		set outputList [Std::List new]

		foreach item [$listObj toList] {
			set transformedItem [$closureObj $item]
			$outputList add $transformedItem
		}

		return $outputList
	}

}
