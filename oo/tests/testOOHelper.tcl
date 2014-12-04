#!/usr/bin/tclsh

package require TclOO
source "OOHelpers.tcl"

namespace import oo::*

class create TestClass {
}

class create TestClass2 {

}

class create TestClass3 {
	superclass TestClass
}

set i1 [TestClass new]
set i2 [TestClass2 new]
set i3 [TestClass3 new]

puts "i1 == TestClass? [instanceof? $i1 TestClass]"
puts "i2 == TestClass2? [instanceof? $i2 TestClass2]"
puts "i2 != TestClass? [instanceof? $i2 TestClass]"
puts "i3 == TestClass? [instanceof? $i3 TestClass]"
