#!/usr/bin/tclsh

package require TclOO

source "../../load.tcl"

set config [Std::Configuration new]

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

