#!/usr/bin/tclsh

source "../../load.tcl"

namespace import html::*

set myhtml {}
html::render myhtml {
	<div> class= "mycomponent" {
		<form> action= ? method= post {
			<fieldset> {
				<label> ' "This is the first fieldset" 

				form::radiobuttons "age_group" {
					{child "0 to 17"}
					{adult "18 to 64"}
					{senior "65 and over"}
				}

				form::selectbox "mybox" {
					key1 value1
					key2 value2
					key3 value3
				} key2

				form::radiobuttons "radiobutton" {
					{value1 "My first button"}
					{value2 "My second button"}
					{value3 "My third button"}
					{value4 "My fourth button"}
				} value3
				
				form::checkbox "mycheckbox" "myvalue" 
				form::checkbox "mycheckbox" "myvalue2" yes
			}
		}
	}
}

puts "HTML output:\n$myhtml"
