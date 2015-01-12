package require TclOO


#
#	The logger class is to be inserted
#
@Component oo::class create Std::Logger {

	variable allLevels
	variable defaultLevel
	variable activeLevel
	variable activeLevelIdx
	variable output 

	#
	#	Initialize data-members
	#
	constructor {} {
		set allLevels {DEBUG INFO WARN ERROR}
		my setLogLevel DEBUG
		my setDefaultLevel INFO
		my setOutput [Std::ConsoleLoggerOutput new]
	}

	# ------------------------------------------------------------------------
	#	Log levels
	# ------------------------------------------------------------------------

	method unknown {args} {
		if {[llength $args] > 1} then {
			error "Expected only one argument"
		}
		my _message $defaultLevel [lindex $args 0]
	}

	method debug {msg} {
		my _message "DEBUG" $msg
	}

	method info {msg} {
		my _message "INFO" $msg
	}

	method warn {msg} {
		my _message "WARN" $msg
	}

	method error {msg} {
		my _message "ERROR" $msg
	}

	# ------------------------------------------------------------------------
	#	Level setting related functionality
	# ------------------------------------------------------------------------

	method setDefaultLevel {aDefaultLevel} {
		set defaultLevel $aDefaultLevel
	}

	#
	#	Set the logger
	#
	method setOutput {anOutput} {
		set output $anOutput
	}

	#
	# 	Set the current log level
	#
	method setLogLevel {levelName} {
		if {[lsearch $allLevels $levelName] == -1} then {
			error "$levelName is not a valid log level, pick one of the following: $allLevels"
		}
		set activeLevel $levelName
		set activeLevelIdx [lsearch $allLevels $activeLevel]
	}

	# ------------------------------------------------------------------------
	#	Private methods
	# ------------------------------------------------------------------------


	#
	#	Determine whether this is an active level
	#
	method _isActiveLevel {level} {
		return [expr {[lsearch $allLevels $level] >= $activeLevelIdx}]
	}

	#
	#	Log the message if active log level
	#
	method _message {type msg} {
		if {[my _isActiveLevel $type]} {
			set timestamp [clock format [clock seconds] -format "%D %T"]
			set source [uplevel 2 { info script }]
			set saneSource [string range [file rootname $source] [string length [file dirname $source]]+1 end]
			$output out "$timestamp *$type* - $saneSource - $msg"
		}
	}

}

#
#	Shortcut for writing @Inject( Std::Logger ) all the time.
#
interp alias {} @Logger {} @Inject( Std::Logger )
