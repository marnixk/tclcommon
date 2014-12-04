#!/usr/bin/tclsh

package require TclOO

source "../All.tcl"

set l [Std::List new {10 20 40 50}]
set d [Std::Operations::Dispatch new [$l iterator]]

$d each {
	puts $it
}

