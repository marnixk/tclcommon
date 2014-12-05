# add to dispatchable list 
lappend Std::Operations {every Std::Operations::Every}

#
#	Implementation of the each operator
#
namespace eval Std::Operations::Every {

	proc do {listObj closureObj} {

		foreach item [$listObj toList] {
			set result [$closureObj $item]
			
			if {!$result} {
				return false
			}
		}

		return true
	}

}
