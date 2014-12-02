#!/usr/bin/tclsh

package require TclOO

#
#	Simple annotations implemetnation for Tcl.
#
#	To register an annotation: 
#
#		Annotations::register NameOfAnnotation [callback_processor_proc]
#
#	This will create two new methods:
#		@NameOfAnnotation ..more code..
#		@NameOfAnnotation< option list > ..more code..
#
#
#	The list of options is passed into the callback proc
#
namespace eval ::Annotations {

	variable listOfAnnotations
	
	#
	#	The default @ implementation, checks whether there is a valid
	#	annotation with this name, if so, it will execute the code
	#	in args on the uplevel 1
	#
	proc @ {name options args} {
		if {![Annotations::is_registered_annotation $name]} {
			error "not a valid registered annotation $name"
		}
		uplevel 1 $args
	}

	#
	#	Register a new annotation
	#
	proc register {name {processor {}}} {
		variable listOfAnnotations
		lappend listOfAnnotations $name

		if {$processor == {}} then {
			set processor Processors::$name
		}

		# create two methods one for the annotation without option
		# and one for the annotation with option parsing
		uplevel 1 [subst {

			# normal method variation
			proc ::@$name {args} {
				if {\[info procs $processor\] != {}} then {
					$processor {} {*}\$args
				}
				return \[Annotations::@ $name {} {*}\$args\]
			}

			# option based method variation
			proc ::@${name}( {args} {

				# try to find the end of the annotation
				set gtidx \[lsearch \$args )\]
				if { \$gtidx == -1 } then {
					error "Expected a ')'"
				}

				set optionlist \[lrange \$args 0 \$gtidx-1\]
				set body \[lrange \$args \$gtidx+1 end\]

				if {\[info procs $processor\] != {}} then {
					set output \[$processor \$optionlist {*}\$body\]
					if {\$output == "skip-execution"} then {
						return
					} else {
						return \[Annotations::@ $name \$optionlist {*}\$body\]
					}
				} else {
					return \[Annotations::@ $name \$optionlist {*}\$body\]
				}
			}
		}]
	}

	# 
	#	Is this a registered annotation?
	#
	proc is_registered_annotation {name} {
		variable listOfAnnotations
		if {[lsearch $listOfAnnotations $name] != -1} then {
			return true
		} else {
			return false
		}
	}

}
