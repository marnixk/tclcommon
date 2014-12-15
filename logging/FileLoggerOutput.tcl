oo::class create Std::FileLoggerOutput {

	variable filename
	variable fp

	#
	#	Initialize data-members
	#
	constructor {filename} {
		set filename $filename
		set fp [open $filename a]
	}

	destructor {
		close $fp
	}

	#
	#	Output the message
	#
	method out {message} {
		puts $fp "$message"
		flush $fp
	}

}