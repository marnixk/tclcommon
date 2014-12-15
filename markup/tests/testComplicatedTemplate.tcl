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


proc renderPerson {person} {
	set tpl ""
	html::render tpl {
		<div> class= "person" {
			<p> class= name ' [$person fullName]
			<p> class= age {
				<span> ' [$person age]
				' "Totally"
			}
		}	
	}

	return $tpl
}


puts "HTML OUTPUT:" 
puts [renderPerson [Person new "Firstname" "Lastname" 29 "male" ]]