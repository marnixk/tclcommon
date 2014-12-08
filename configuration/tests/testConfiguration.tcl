#!/usr/bin/tclsh

package require TclOO

source "../../load.tcl"

set config [Std::Configuration new]

set testdir [file dirname [info script]]

$config add system.os "GNU/Linux"
$config add app.build.author "Marnix"
$config add app.build.date 10/09/2014

$config add email.from "marnixkok+from@gmail.com"

$config add {
	email.address "marnixkok@gmail.com"
	email.smtp.host "localhost"
	email.smtp.port 25 
}

puts "ALL:\n[$config toList]"

set emailConfig [$config email]
puts "\n\nSubconfig:\n[$emailConfig toList]"

puts "address: [$emailConfig address]"
puts "address: [$emailConfig email.address]"
