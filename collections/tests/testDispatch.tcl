#!/usr/bin/tclsh

package require TclOO
source "../../load.tcl"


set testList [Std::List new {10 20 40 50}]

set factor 20

puts "Original: "
Std::f> $testList {factor} each { puts ".. $it + $factor = [expr $it + $factor]" }

# map list and then filter it
set filteredList [
	Std::f> $testList {} \
		   map { return [expr $it * 20] } \
		   filter { return [expr {$it > 500}] } 
]

puts "\nFiltered list:"
Std::f> $filteredList {} each { puts ".. $it"}

puts "\nTest rejection:"
Std::f> $testList {} \
	   map { return [expr $it * 20] } \
	   reject { return [expr {$it > 500}] } \
	   each { puts $it }

set returnedValue [
	Std::f> $filteredList {} find { return [expr $it == 800] }
]

puts "Found: 800 ? $returnedValue"