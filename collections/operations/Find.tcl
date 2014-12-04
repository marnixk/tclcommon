# add to dispatchable list 
lappend Std::Operations {find Std::Operations::Find}

#
#	Implementation of the each operator
#
namespace eval Std::Operations::Find {

	proc do {listObj closureObj} {
		set iterator [$listObj iterator]

		while {[$iterator hasNext?]} {
			set item [$iterator next]
			set result [$closureObj $item]

			if {$result} {
				return $item
			}
		}

		return {}
	}

}
