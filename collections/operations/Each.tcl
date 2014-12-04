# add to dispatchable list 
lappend Std::Operations {each Std::Operations::Each}

#
#	Implementation of the each operator
#
namespace eval Std::Operations::Each {

	proc do {listObj closureObj} {
		set iterator [$listObj iterator]

		while {[$iterator hasNext?]} {
			$closureObj [$iterator next] 
		}

		return $listObj
	}

}
