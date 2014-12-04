package require TclOO

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

	method get {index} {
		return [lindex $items $index]
	}

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
	method indexOf? {item {startAt 0}} {
		for {set idx $startAt} {$idx < [my size]} {incr idx} {
			set storedItem [my get $idx]
			if {$storedItem == $item} {
				return $idx
			}
		}
		return -1
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
		return [expr [my size] == 0]

	}

	#
	#	Get an iterator
	#
	method iterator {} {
		return [Std::ListIterator new [self]]
	}

	#
	#	f> symbolises 'function flow'. You pass it the list of context variables you want to be
	#	available in the closures. 
	#
	method f> {context args} {

		# move variables down here
		foreach var $context {
			upvar 1 $var $var
			puts "$var == [set $var]"
		}

		set dispatcher [Std::Operations::Dispatch new [self]]

		foreach {op closure} $args {
			set closureObj [-> $context {it} $closure]
			set newList [$dispatcher $op $closureObj]
			set dispatcher [Std::Operations::Dispatch new $newList]
		}

		return $newList
	}

}