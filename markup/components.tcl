#!/usr/bin/tclsh

package require TclOO


namespace eval html {

	set COMPONENT_DEFAULTS {
		-wrapper "component"
		-html {}
		-context {}
		-controller {}
	}

	set componentList {}

	#
	#	Defines a component
	#
	proc defineComponent {name options} {
		variable componentList
		set options [dict merge ${html::COMPONENT_DEFAULTS} $options]
		lappend componentList $name $options
	}

	proc getComponent {name} {
		variable componentList
		array set ComponentList $componentList
		return $ComponentList($name)
	}


	#
	#	Render the component with `componentName` using the values
	#	in the `context` dictionary list. It will 
	#
	proc renderComponent {componentName context} {
		set _component [getComponent $componentName]
		set _htmlMarkup [dict get $_component -html]
		set _controller [dict get $_component -controller]
		set _contextVariables [dict get $_component -context] 

		# make all context variables local
		foreach contextVar $_contextVariables {
			if {![dict exists $context $contextVar]} then {
				error "Missing context variable names `$contextVar` expected for $componentName"
			}

			set var [dict get $context $contextVar]
			set $contextVar [uplevel 1 "[list expr $var]"]
		}


		if 1 $_controller

		set _htmlMarkup [subst {
			<div> class= "[dict get $_component -wrapper]" {
				$_htmlMarkup
			}
		}]
		return [html::render $_htmlMarkup]

	}
 
}
