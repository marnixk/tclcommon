# add to dispatchable list 
lappend Std::Operations {some Std::Operations::Some}

#
#	Implementation of the each operator
#
namespace eval Std::Operations::Some {

	proc do {listObj closureObj} {
		set iterator [$listObj iterator]

		while {[$iterator hasNext?]} {
			set item [$iterator next]
			set result [$closureObj $item]
			
			if {$result} {
				return true
			}
		}

		return false
	}

}
