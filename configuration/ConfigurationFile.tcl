package require TclOO

#
#	Configuration file
#
oo::class create Std::ConfigurationFile {
	
	superclass Std::Configuration

	variable filename

	#
	#	Initialize data-members
	#
	constructor {aFilename} {
		next {}
		set filename $aFilename

		my loadFromFile
	}

	#
	#	Load from file
	#
	method loadFromFile {} {
		puts "Starting to load from file"

		set fp [open $filename r]
		while {![eof $fp]} {
			set line [gets $fp]

			# Is this a comment? skip.
			if {[my _isComment? $line]} then {
				continue
			}

			my _parseLine $line

		}
		close $fp
	}


	#
	#	Is this a comment?
	#
	method _isComment? {line} {
		return [expr {[string range $line 0 0] == "#"}]
	}

	#
	#	Parse the line properly.
	#
	method _parseLine {line} {
		set eqSignIdx [string first "=" $line]
		if {$eqSignIdx == -1} then {
			error "Cannot parse properties file, missing '=' on line `$line`"
		}

		set key [string trim [string range $line 0 $eqSignIdx-1]]
		set value [string trim [string range $line $eqSignIdx+1 end]]

		my add $key $value
	}

}