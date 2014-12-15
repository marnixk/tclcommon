#!/usr/bin/tclsh

source "../../load.tcl"

set fileLogOut [Std::FileLoggerOutput new ./test.log]
set logger [Std::Logger new]

$logger setOutput $fileLogOut
$logger debug "This is my debug message"
$logger info "This is my info message"
$logger "This is my message on the default level"

# clean up after ourselves
$logger destroy
$fileLogOut destroy

file delete ./test.log
