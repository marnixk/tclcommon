#!/usr/bin/tclsh

package require TclOO

source "../../load.tcl"

namespace import html::*

oo::class create Person {

	variable name
	variable surname
	variable age
	variable gender

	constructor {aName aSurname anAge aGender} {
		set name $aName
		set surname $aSurname
		set age $anAge
		set gender $aGender
	}


	method fullName {} {
		return "$name $surname"
	}

	method age {} {
		return $age
	}

}

#
#	Person component definition
#
html::defineComponent PersonComponent {

	-context {person nTimes} 
	-controller {

		set someCustomStuff [string repeat "[$person fullName], " $nTimes]
		set personId "[$person fullName]_[$person age]"
	}

	-html {
		<div> class= "person" {
			<p> ' "Repeating this $nTimes!"
			<span> ' "$someCustomStuff"
			<a> href= "/person/id/$personId" ' "[$person fullName]"
			<span> class= "age" ' [$person age]
		}
	}

}


set person [Person new "Marnix" "Cook" 29 "male"]

puts [html::renderComponent PersonComponent { 
		person $person 
		nTimes 5 
}]
