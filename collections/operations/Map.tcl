# add to dispatchable list 
lappend Std::Operations {map Std::Operations::Map}

#
#	Implementation of the each operator
#
namespace eval Std::Operations::Map {

	proc do {listObj closureObj} {
		set iterator [$listObj iterator]
		set outputList [Std::List new]

		while {[$iterator hasNext?]} {
			set transformedItem [$closureObj [$iterator next]]
			$outputList add $transformedItem
		}

		return $outputList
	}

}
