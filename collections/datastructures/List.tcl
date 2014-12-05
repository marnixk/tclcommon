package require TclOO

#
#	List implementation
#
oo::class create Std::List {

	variable items

	#
	# initialize list
	#
	constructor {{initialItems {}}} {
		lappend items

		foreach item $initialItems {
			lappend items $item
		}
	}


#
# .d8888b. .d8888b. .d8888b. .d8888b. .d8888b. .d8888b. 
# 88'  `88 88'  `"" 88'  `"" 88ooood8 Y8ooooo. Y8ooooo. 
# 88.  .88 88.  ... 88.  ... 88.  ...       88       88 
# `88888P8 `88888P' `88888P' `88888P' `88888P' `88888P' 
#                                                      

	#
	#	Add one item
	#
	method add {item} {
		lappend items $item
	}

	#
	# 	Add all items
	#
	method addAll {items} {
		foreach item $items {
			my add $item
		}
	}

	#
	#	Get element at `index` index
	#
	method get {index} {
		return [lindex $items $index]
	}


	#
	#	Get the first element
	#
	method first {} {
		return [my get 0]
	}

	#
	#	Get the last element
	#
	method last {} {
		return [my get [my size]-1]
	}

	#
	#	Everything except last
	#
	method initial {} {
		set initialList [lrange $items 0 end-1]
		return [Std::List new $initialList]
	}

	#
	#	Everything except first
	#
	method rest {} {
		set restList [lrange $items 1 end]
		return [Std::List new $restList]
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
	#	Contains an item?
	#
	method contains? {item} {
		foreach storedItem $items {
			if {$storedItem == $item} {
				return true
			}
		}

		return false
	}

	#
	#	What's the index of this item?
	#	
	method indexOf {item {startAt 0}} {
		return [lsearch -start $startAt $items $item]
	}

	#
	#	Size of list
	#
	method size {} {
		return [llength $items]
	}
	#
	#	Empty?
	#
	method empty? {} {
		return [expr {[llength $items] == 0}]

	}

	#
	#	Return the native representation of the list
	#
	method toList {} {
		return $items
	}

}