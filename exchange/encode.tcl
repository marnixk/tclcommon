#
#	serialize objects
#
#	- catalog objects
#	- give them a number
#	- write structure and types and reference numbers
#


namespace eval x {

	set SIMPLE_TYPES {number string}

	#
	#	This function encodes an object
	#
	proc encode {data {enc ""} {tablevel 0} {skipFirstIndent false}} {
		set indent [string repeat "\t" $tablevel]

		if {$skipFirstIndent} {
			append enc "[$data entityName]\n"
		} else {
			append enc "$indent[$data entityName]\n"
		}

		foreach prop [$data properties] {
			set propName [dict get $prop -property]
			set propValue [$data $propName]
			set propType [dict get $prop -options -type]
			set propMultiple [dict get $prop -options -multiple]

			if {!$propMultiple} then {
				if {[x::isEntity $propType]} then {
					append enc "$indent\t$propName "
					set enc [encode $propValue $enc [expr $tablevel + 1] true]
				} else {
					append enc "$indent\t$propName $propType [encodeString $propValue]\n"
				}
			} else {
				append enc "$indent\t$propName list\n"
				set nItems [llength $propValue]

				foreach arrValue $propValue {
					if {[simpleType $prop]} then {
						append enc "$indent\t\t$propType $arrValue\n"
					} else {
						set enc [encode $arrValue $enc [expr $tablevel + 2]]
					}

				}
			}

		}
		return $enc
	}

	proc encodeString {str} {
		return [string map {\n \\n} $str]
	}


	proc simpleType {property} {
		set type [dict get $property -options -type]
		return [expr {[lsearch $x::SIMPLE_TYPES $type] != -1}]
	}

}