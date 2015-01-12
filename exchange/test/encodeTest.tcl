#!/usr/bin/tclsh

source "../../load.tcl"

source "testmodel.tcl"

#
#	Setup some data to represent fake data
#

set currentAddress [Address new]
$currentAddress housenumber= 10
$currentAddress street= "Developer Street"
$currentAddress city= "Auckland"
$currentAddress zipcode= 1010

set oldAddress [Address new]
$oldAddress housenumber= 10
$oldAddress street= "Old Developer Street"
$oldAddress zipcode= "1010"
$oldAddress city= "Auckland"

set john [Person new]
$john fullName= "John Doe"
$john alternateNames= [list "John Legendary" "Johnny Doe"]
$john addresses= [list $currentAddress $oldAddress]
$john mainAddress= $currentAddress

# puts [$oldAddress entityName]

set personlist [PersonList new]
$personlist people= [list $john $john]

puts "ENCODING the PersonList:"
puts [$personlist encode]
