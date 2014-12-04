#
#	List iterator implementation
#
oo::class create Std::ListIterator {

	superclass Std::Iterator

	variable cursor
	variable instance

	#
	#	Initialize data-members
	#
	constructor {anInstance} {
		set cursor 0
		set instance $anInstance
	}

	method hasNext? {} {
		return [expr {$cursor < [$instance size]}]
	}

	method next {} {
		set result [$instance get $cursor]
		incr cursor
		return $result
	}

}