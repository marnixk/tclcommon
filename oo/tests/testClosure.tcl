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

countWithClosure { puts $counter }
countWithClosureObject [-> {counter} {puts $counter}]

[-> {puts $it}] "marnix"