#
#	Adds some html helper methods to the `form` namespace
#
namespace eval form {


	proc checkbox {fieldname value {checked {}}} {
		set code [subst {<input/> type= "checkbox" name= "$fieldname" value= "$value"}]
		if {$checked != {}} then {
			append code { checked= "checked" }
		}

		uplevel 1 [subst $code]
	}

	#
	#	Generate HTML for a selectbox
	#
	proc selectbox {fieldname options {selectedValue {}}} {

		set selectHtml "<select> name= $fieldname {\n"
		foreach {key value} $options {
			append selectHtml "<option> value= \"$key\""
			if {$selectedValue == $key} then {
				append selectHtml " selected= selected"
			}
			append selectHtml " ' $value\n"
		}
		append selectHtml "}\n"

		uplevel 1 $selectHtml
	}


	proc radiobuttons {fieldname options {selectedValue {}}} {
		set html {}
		foreach vList $options {
			lassign $vList value label
			set inputHtml  [subst {<input/> type= radio value= $value }]
			if {$selectedValue == $value} {
				append inputHtml "checked= checked"
			}

			append html [subst { 
				<label> {
					$inputHtml
					' "$label"
				}
			}]
		}

		uplevel 1 $html
	}

	proc table {headers content} {
		
	}

}