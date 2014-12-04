#!/usr/bin/tclsh

package require TclOO

source "../All.tcl"

set myList [Std::List new]

$myList addAll {10 20 30 40 50}

puts [$myList f->] 

