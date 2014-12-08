#!/usr/bin/tclsh

package require TclOO

source "../../load.tcl"

set testdir [file dirname [info script]]
set fileConfig [Std::ConfigurationFile new "$testdir/test.properties"]


set config [Std::Configuration new { myconfig "values" }]

$config addAll $fileConfig
puts "Merged config: [$config toList]"

$config destroy
$fileConfig destroy

