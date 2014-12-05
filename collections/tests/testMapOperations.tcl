#!/usr/bin/tclsh

package require TclOO

source "../../load.tcl"

set map [Std::Map new]

$map putAll { 
	1 "zondag"
	2 "maandag"
	3 "dinsdag"
	4 "woensdag"
	5 "donderdag"
	6 "vrijdag"
	7 "zaterdag"
}

puts "Day 2: [$map get 2]"

Std::f> [$map values] {} each { puts "Value: $it" }
Std::f> [$map keys] {} each { puts "Key: $it" }
Std::f> [$map pairs] {} each { 
	puts "Key: [$it get 0] => Value: [$it get 1]"
}

puts "inverted map:"
Std::f> [[$map invert] pairs] {} each {
	lassign [$it toList] key value
	puts "Inverted: Key: $key => Value: $value"
}

