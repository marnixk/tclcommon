set collPackagePath [file dirname [info script]]

# datastructures
source "$collPackagePath/datastructures/List.tcl"

# iterators
source "$collPackagePath/iterators/Iterator.tcl"
source "$collPackagePath/iterators/ListIterator.tcl"

# operators
source "$collPackagePath/operations/Dispatch.tcl"
source "$collPackagePath/operations/Each.tcl"
source "$collPackagePath/operations/Map.tcl"
source "$collPackagePath/operations/Filter.tcl"
source "$collPackagePath/operations/Reject.tcl"
source "$collPackagePath/operations/Find.tcl"
source "$collPackagePath/operations/Every.tcl"
source "$collPackagePath/operations/Some.tcl"
