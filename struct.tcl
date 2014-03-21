
#
#	Define a new structure of the name `$name` with array type description of the settings
#
proc struct {name args} {
	global types
	set base [list]
	set tail [lassign $args separator]

	# has a separator sign? Then interpret the next as a list of base elements, otherwise
	# the separator is /actually/ the settings list
	if {$separator == ":"} then {
		lassign $tail base settings
	} else {
		set settings $separator
	}

	#
	#	Iterate over all the base elements we are going to add
	#
	foreach base_el $base {
		lappend additional_settings [dict get $types $base_el]
	}

	# append the local settings
	lappend additional_settings $settings

	# store settings
	dict set types $name [join $additional_settings "\n"]

	# create getters and setters for this structure
	struct-create-methods-for $name $name
}

#
#	Creates 'type-checked' retrieval methods for all the elements inside this structure, 
#	it automatically recurses when it encounters a complex element 
#
proc struct-create-methods-for {type base} {
	global types
	set elements [struct-elements $type]

	set rest [lassign [split $base .] root_type ]

	foreach el $elements {
		set el_type [type-of $type $el]
		# puts "$base.$el : $el_type"

		#
		#	create a top level procedure that sets or retrieves
		#	content
		#
		uplevel #0 [subst {
			proc $base.$el {r_struct {val _no_value_}} {
				# check to see if we're dealing with the correct struct type
				upvar 1 \$r_struct struct
				array set struct_arr \$struct

				if {\$struct_arr(_type) != "$root_type"} then {
					error "$base'$el: incorrect type `\$struct_arr(_type)` expected `$root_type`"
				}

				if {\$val == "_no_value_" } then {	
					return \[struct-retrieve-value \$struct $root_type {$rest [split $el .]}\]
				} else { 
					struct-set-value struct \$val $root_type {$rest [split $el .]}
				}

			}
		}]

		if {[struct-exists $el_type]} {
			struct-create-methods-for $el_type "$base.$el"
		} 
	}
}	

#
#	Get the value from the structure
#
proc struct-retrieve-value {struct type sub_elements} {
	# puts "Getting value for $type at $sub_elements"
	array set struct_arr $struct

	# base case
	if {[llength $sub_elements] == 1} then {
		set sub_elements [string trim $sub_elements]
		# puts "$sub_elements -> $struct_arr($sub_elements)"
		return $struct_arr($sub_elements) 
	} 

	set head [lindex $sub_elements 0]
	set tail [lrange $sub_elements 1 end]

	# recurse until we hit basecase
	return [struct-retrieve-value $struct_arr($head) [type-of $type $head] $tail]
}

#
#	Set the value in the structure
#
proc struct-set-value {r_struct val type sub_elements} {

	upvar 1 $r_struct struct

	array set struct_arr $struct

	# base case
	if {[llength $sub_elements] == 1} then {
		set sub_elements [string trim $sub_elements]
		set struct_arr($sub_elements) $val
		set struct [array get struct_arr]
		# puts $struct
		return $struct
	}

	set head [lindex $sub_elements 0]
	set tail [lrange $sub_elements 1 end]

	set new_val [struct-set-value struct_arr($head) $val [type-of $type $head] $tail]
	set struct_arr($head) $new_val
	set struct [array get struct_arr]
	return [array get struct_arr]
}

#
#	Determine whether the struct exists or not
#
proc struct-exists {name} {
	global types
	return [dict exists $types $name]
}

#
#	Return a list of element names in the struct of the name `typename`
#
proc struct-elements {typename} {
	global types
	array set info [dict get $types $typename]

	return [array names info]
}

#
#	Determine the type of `typename`'s element `sub`
#
proc type-of {typename sub} {
	global types
	array set info [dict get $types $typename]

	foreach {name el_list} [array get info] {

		set default_value ""
		if {[llength $el_list] != 1} {
			lassign $el_list el_type default_value
		} else {
			set el_type $el_list
		}

		if {$name == $sub} then {
			return $el_type
		}
	}

	error "the struct `$typename` does not have an element `$sub`"
}

#
#	Get the default value for `typename.sub`
#
proc default-value-of {typename sub} {
	global types
	array set info [dict get $types $typename]

	foreach {name el_list} [array get info] {

		set default_value ""
		if {[llength $el_list] != 1} {
			lassign $el_list el_type default_value
		} else {
			set el_type $el_list
		}

		if {$name == $sub} then {
			return $default_value
		}
	}

	error "the struct `$typename` does not have an element `$sub`"
}

#
#	Create a new instance of struct of the type `type`
#
proc create {type} {

	if {[struct-exists $type] == 0} then {
		error "no such type `$type`"
	}

	set elements [struct-elements $type]
	
	set var(_type) $type

	foreach el_name $elements {
		set el_type [type-of $type $el_name]
		set el_default [default-value-of $type $el_name]

		# puts "Creating: $el_name -> $el_type"
		switch $el_type {
			"val" {
				set var($el_name) $el_default
			}

			"list" {
				lappend var($el_name)
				if {[llength $el_default] > 0} then {
					foreach value $el_default {
						lappend var($el_name) $value
					}
				}
			}

			"array" {
				array set var($el_name) $el_default
			}

			default {
				set var($el_name) [create $el_type]
			}
		}
	}

	return [array get var]

}

