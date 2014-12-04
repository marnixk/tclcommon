namespace eval ::oo {

	#
	#	Shortcut for the weird looking instanceof functionality in the `info` ensemble
	#
	#	usage: [instanceof? $myobject CheckForThisType]
	#
	proc instanceof? {obj type} {
		return [info object isa typeof $obj $type]
	}

}