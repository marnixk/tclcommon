#!/usr/bin/tclsh

source "../../load.tcl"

namespace import html::*

set param "This is my link"
set myclass "blue-h1"
set mylist [list alice bob ewan]

set myOutput [html::render {
	<div> class= "mycomponent" {
		<h1> class= $myclass ' "List of siblings"
		
		' "Lone text"

		<p> ' "So happy to see you could all make it today."

		<br/>

		<ul> {
			foreach element $mylist {
				<li> {
					<a> href= "/people/$element" {
						' "This is person \"<$element>\""
					}
				}
			}
		}

		html::insert [html::render {
					<p> ' "My inbetween rendering"
				}]

		<form> action= "/myformendpoint" method= "POST" {
			<fieldset> {
				<label> ' "First set of controls"
				<select> {
					<option> value= "1" ' "First"
					<option> value= "2" ' "Second"
					<option> value= "3" ' "Third"
					<option> value= "4" ' "Fourth"
				}
			}
		}

	}
}]

puts "HTML output:\n$myOutput"
