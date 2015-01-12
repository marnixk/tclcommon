#
#	Exchange models are a bridge between javascript and TCL. The model definitions
#	can generate Javascript objects that know how to serialize its information
#	into a TCL form. Similarly, TCL will be able to transform contents to javascript
#

#                       oo                     dP 
#                                              88 
#     dP.  .dP          dP 88d8b.d8b. 88d888b. 88 
#      `8bd8'  88888888 88 88'`88'`88 88'  `88 88 
#      .d88b.           88 88  88  88 88.  .88 88 
#     dP'  `dP          dP dP  dP  dP 88Y888P' dP 
#                                     88          
#                                     dP  

namespace eval x {

	set currentEntity {}
	set entityInformation {}
	set DEFAULT_property_OPTIONS {-type string -multiple no -required no}

	#
	#	Set the entity name
	#
	proc entity {name body} {
		variable currentEntity
	
		set currentEntity $name

		uplevel 1 [subst -nocommands {
			oo::class create $name {

				# add `entityName` method
				method entityName {} {
					return "$name"
				}

				method properties {} {
					return [x::entityProperties [my entityName]]
				}

				# add shorthand for encoding this object
				method encode {} {
					return [x::encode [self]]
				}

				$body
			}
		}]

		set currentEntity ""
	}

	#
	#	Add property information for the current entity
	#
	proc property {name args} {
		variable currentEntity

		if {$currentEntity == {}} {
			return -code error "Cannot add property without having set `x::entityName`"
		}

		set propertyOptions [dict merge $x::DEFAULT_property_OPTIONS $args]

		uplevel 1 [subst -nocommands { 
			variable $name	

			lappend x::entityInformation [list -for $currentEntity -property $name -options [list {*}$propertyOptions]]
			method $name= {a_$name} {
				set $name \$a_$name
			}

			method $name {} {
				return \$$name
			}
		}]
	}

	#
	#	Get a list of all the entity names
	#
	proc entityNames {} {
		variable entityInformation
		lappend names
		foreach info $entityInformation {
			set forName [dict get $info -for]
			if {[lsearch $names $forName] == -1} {
				lappend names $forName
			}
		}

		return $names
	}

	proc isEntity {name} {
		return [expr {[lsearch [entityNames] $name] != -1}]
	}

	#
	#	Get all the entity propertys for a specific entity name
	#
	proc entityProperties {entityName} {
		variable entityInformation
		lappend properties
		foreach info $entityInformation {
			set forName [dict get $info -for]
			if {$forName == $entityName} then {
				lappend properties $info
			}
		}
		return $properties
	}

	#
	#	Output model information
	#
	proc printModel {} {
		variable entityInformation

		set names [entityNames]
		puts "Registered entities:"
		puts " - [join $names "\n - "]\n"

		foreach name $names {
			puts "getting: $name"
			printEntity $name
		}
	}

	#
	#	Output entity information
	#
	proc printEntity {name} {
		set properties [entityProperties $name]
		foreach property $properties {
			puts "|> $property"
		}
		puts ""
	}

}
