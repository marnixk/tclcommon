# add to dispatchable list 
lappend Std::Operations {find Std::Operations::Find}

#
#	Implementation of the each operator
#
namespace eval Std::Operations::Find {

	proc do {listObj closureObj} {

		foreach item [$listObj toList] {
			set result [$closureObj $item]

			if {$result} {
				return $item
			}
		}

		return {}
	}

}
