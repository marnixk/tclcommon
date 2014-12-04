# add to dispatchable list 
lappend Std::Operations {every Std::Operations::Every}

#
#	Implementation of the each operator
#
namespace eval Std::Operations::Every {

	proc do {listObj closureObj} {
		set iterator [$listObj iterator]

		while {[$iterator hasNext?]} {
			set item [$iterator next]
			set result [$closureObj $item]
			
			if {!$result} {
				return false
			}
		}

		return true
	}

}
