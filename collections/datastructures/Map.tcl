package require TclOO

#
#	Map implementation
#
oo::class create Std::Map {

	variable mapValues

	#
	#	Initialize data-members
	#
	constructor {{initialValues {}}} {
		array set MapValues $initialValues
		set mapValues [array get MapValues]
	}

#
# .d8888b. .d8888b. .d8888b. .d8888b. .d8888b. .d8888b. 
# 88'  `88 88'  `"" 88'  `"" 88ooood8 Y8ooooo. Y8ooooo. 
# 88.  .88 88.  ... 88.  ... 88.  ...       88       88 
# `88888P8 `88888P' `88888P' `88888P' `88888P' `88888P' 
#                                                      
              

	#
	#	Get an item
	#
	method get {key} {
		array set MapValues $mapValues
		return $MapValues($key)
	}

	#
	#	Remove a key
	#
	method remove {key} {
		array set MapValues $mapValues
		unset MapValues($key)
		set mapValues [array get MapValues]
	}

	#
	#	Put a key and value
	#
	method put {key value} {
		array set MapValues $mapValues
		set MapValues($key) $value
		set mapValues [array get MapValues]
	}

	#
	#	Put multiple keys
	#
	method putAll {listOfPairs} {
		foreach {key val} $listOfPairs {
			my put $key $val
		}
	}



	#
	#	Get all keys
	#
	method keys {} {
		lappend keys
		foreach {key val} $mapValues {
			lappend keys $key
		}
		return [Std::List new $keys]
	}

	#
	#	Get all values
	#
	method values {} {
		lappend values
		foreach {key val} $mapValues {
			lappend values $val
		}
		return [Std::List new $values]
	}

#                                                dP   oo                            
#                                                88                                 
# .d8888b. 88d888b. .d8888b. 88d888b. .d8888b. d8888P dP .d8888b. 88d888b. .d8888b. 
# 88'  `88 88'  `88 88ooood8 88'  `88 88'  `88   88   88 88'  `88 88'  `88 Y8ooooo. 
# 88.  .88 88.  .88 88.  ... 88       88.  .88   88   88 88.  .88 88    88       88 
# `88888P' 88Y888P' `88888P' dP       `88888P8   dP   dP `88888P' dP    dP `88888P' 
#          88                                                                       
#          dP 

	#
	#	Return the size of the map
	#
	method size {} {
		return [expr {$mapValues / 2}]
	}

	#
	#	Return true if the map is empty
	#
	method empty? {} {
		return [expr {[llength $mapValues] == 0}]
	}
	
	#
	#	Return true if the value is contained in the values list
	#
	method containsValue? {value} {
		return [[my values] contains? $value]		
	}

	#
	#	Return true if the key is contained in the key list
	#
	method containsKey? {key} {
		return [[my keys] contains? $key]
	}

	#
	#	get list representation
	#
	method toList {} {
		return $mapValues
	}

	#
	#	Return a list of lists of pairs
	#
	method pairs {} {
		lappend pairs
		foreach {key val} $mapValues {
			lappend pairs [Std::List new [list $key $val]]
		}
		return [Std::List new $pairs]
	}

	#
	#	Invert the mapping
	#
	method invert {} {
		set invertedMap [Std::Map new]
		foreach {key value} $mapValues {
			$invertedMap put $value $key
		}
		return $invertedMap
	}

	#
	#	Filter the map to only have a certain amount of elements, returns
	#	a new map
	#
	method pick {listOfKeys} {
		lappend pickMap

		foreach {key value} $mapValues {
			if {[lsearch $listOfKeys $key] != -1} then {
				lappend pickMap $key $value
			}
		}

		return [Std::Map new $pickMap]
	}

	#
	#	Filter the map to not have the keys in `listOfKeys` in them, returns
	#	a new map
	#
	method omit {listOfKeys} {
		lappend omitMap

		foreach {key value} $mapValues {
			if {[lsearch $listOfKeys $key] == -1} then {
				lappend omitMap $key $value
			}
		}

		return [Std::Map new $omitMap]
	}

}