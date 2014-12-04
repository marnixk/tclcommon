#!/usr/bin/tclsh

package require TclOO

source "../All.tcl"

set myList [Std::List new]

$myList addAll {10 20 30 40 50}

puts "All items: [$myList toList]"
puts "First: [$myList first]"
puts "Last: [$myList last]"
puts "Index of 30: [$myList indexOf 30]"
puts "Initial: [[$myList initial] toList]"
puts "Tail: [[$myList rest] toList]"

