#
#	Dependency Injection mechanism
#
namespace eval DI {

	set structComponent {category class classid abstract}
	set structRequires {classId type wireName varName}

	interp alias {} component@ {} lsearch $structComponent
	interp alias {} requires@ {} lsearch $structRequires

	#
	#	Add injectable to the `components` list. 
	#
	proc injectableProcessor {options args} {
		variable components

		array set Options $options
		
		set category "default"
		if {[info exists Options(category)]} then {
			set category $Options(category)
		}

		set abstract no
		if {[info exists Options(abstract)]} then {
			set abstract $Options(abstract)
		}

		set classCode [info level -1]
		set classIdentifier [md5::md5 -hex $classCode]
		
		set className [lindex $args 2]
		if {[string first $className "::"] != 0} then {
			set className "::$className"
		}

		lappend components [list $category $className $classIdentifier $abstract]
	}
	
	#
	#	Add requirement to component 
	#
	proc wireSingleProcessor {options args} {
		variable requires
		if {[lindex $args 0] != "variable"} then {
			error "Expect to only wire to variables"
		}
		
		if {[info level] < 3} then {
			return -code error "Is this class injectable?"
		}

		# extract useful information from current context
		set classCode [info level -3]
		set className [lindex $classCode end-1]
		set varName [lindex $args 1]
		set wireClassName [lindex $options 0]
		set classIdentifier [md5::md5 -hex $classCode]
	
		# append "requirement" for this class to be wired
		lappend requires [list $classIdentifier single $wireClassName $varName]
		
		# initialize variable in object
		::oo::define $className variable $varName

		return skip-execution
	}

	proc wireAllProcessor {options args} {
		variable requires
		if {[lindex $args 0] != "variable"} then {
			error "Expect to only wire to variables"
		}
			
		set classCode [info level -3]
		set varName [lindex $args 1]
		set className [lindex $classCode end-1]
		set classIdentifier [md5::md5 -hex $classCode]
		
		# append "requirement" for this category to be wired
		lappend requires [list $classIdentifier category [lindex $options 0] [lindex $args 1]]
	
		# initialize variable in object
		::oo::define $className variable $varName

		return skip-execution
	}

	proc wireTypeProcessor {options args} {
		variable requires
		if {[lindex $args 0] != "variable"} then {
			error "Expect to only wire to variables"
		}
			
		set classCode [info level -3]
		set varName [lindex $args 1]
		set className [lindex $classCode 3]
		set classIdentifier [md5::md5 -hex $classCode]
		
		# append "requirement" for this category to be wired
		lappend requires [list $classIdentifier oftype [lindex $options 0] [lindex $args 1]]

		# initialize variable in object
		::oo::define $className variable $varName

		return skip-execution
	}


}