#!/usr/bin/tclsh

package require TclOO
namespace import oo::*

source "../Closure.tcl"


proc countWithClosure {closureBody} {
	countWithClosureObject [-> {counter} $closureBody]
}

proc countWithClosureObject  {closureObj} {
	puts "Start"
	for {set idx 0} {$idx < 10} {incr idx} {
		$closureObj $idx
	}
	puts "End"
}

set factor 2

# include "factor" from the environment
[-> {factor} {counter} { puts [expr $factor * $counter] }] 10
[-> {counter} { puts "This is passed into the closure: $counter" }] 10
[-> { puts "The simplest form of a closure: $it" }] 10

# countWithClosure  { puts "$counter" }
# countWithClosureObject [-> {counter} {puts $counter}]

# [-> {puts $it}] "marnix"