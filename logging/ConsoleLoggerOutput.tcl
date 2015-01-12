oo::class create Std::ConsoleLoggerOutput {

	#
	#	Output the message
	#
	method out {message} {
		puts "$message"
		flush stdout
	}

}