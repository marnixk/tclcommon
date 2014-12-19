namespace eval html {

	namespace export '

	set bufferNumber 0
	set outputStack {}

	set tagLevel 0

	# list of all html tags
	set alltags {
		html body div span applet object iframe
		h1 h2 h3 h4 h5 h6 p blockquote pre
		a abbr acronym address big cite code
		del dfn em img ins kbd q s samp
		small strike strong sub sup tt var
		b u i center
		dl dt dd ol ul li
		select option button
		fieldset form label legend
		table caption tbody tfoot thead tr th td
		article aside canvas details embed 
		figure figcaption footer header hgroup 
		menu nav output ruby section summary
		time mark audio video script
	}

	# list of tags that don't get to have content
	set simpletag {
		br hr input
	}

	#
	#	Add aliases for all the normal tag names
	#
	foreach tagname $alltags {
		interp alias {} <$tagname> {} html::fullTag $tagname
	}
	
	#
	#	Add aliases for all the short-hand tagnames
	#
	foreach tagname $simpletag {
		interp alias {} <$tagname/> {} html::simpleTag $tagname 		
		interp alias {} "<$tagname />" {} html::simpleTag $tagname		
	}


	#
	#	Setup the outputbuffer variable name and start rendering content
	#	in the scope above ours.
	#
	proc render {contents} {
		variable outputStack
		variable outputBuffer
		variable bufferNumber

		# new buffer name
		incr bufferNumber
		set varName "buffer$bufferNumber"

		uplevel 1 [subst {set $varName {}}]

		# add to stack
		lappend outputStack $varName

		# Change current buffer name
		set outputBuffer $varName

		# Execute render instructions
		uplevel 1 [subst { $contents }]

		# Level up
		set outputStack [lrange $outputStack 0 end-1]
		set outputBuffer [lindex $outputStack end]

		# get result
		set result [uplevel 1 [list set $varName]]

		uplevel 1 [list unset $varName]
		return $result
	}

	proc insert {html} {
		variable outputBuffer
		upvar 1 $outputBuffer output
		append output $html
	}

	#
	#	Simple tag has no content
	#
	proc simpleTag {tag args} {
		variable outputBuffer
		variable tagLevel

		if {![info exists outputBuffer]} {
			error "Make sure you only render inside a `renderHtml <varName> { ... }` block"
		}

		upvar 1 $outputBuffer output
		set attributes [getAttributes $args]
		append output "[string repeat \t $tagLevel]<$tag $attributes />\n"
	}

	#
	#	Renders a full tag
	#
	proc fullTag {tag args} {
		variable outputBuffer
		variable tagLevel

		if {![info exists outputBuffer]} {
			error "Make sure you only render inside a `renderInto <varName> { ... }` block"
		}

		upvar 1 $outputBuffer output

		# default settings, expecting body
		set rendersText no
		set optionsEndAt end-1
		set indent [string repeat \t $tagLevel]
		append output "$indent<$tag"

		# if second-to-last element is a ' then just output some text
		if {[lindex $args end-1] == "'"} then {
			set rendersText yes
			set optionsEndAt end-2
		}

		# render attributes
		set options [lrange $args 0 $optionsEndAt]
		if {[llength $options] != 0} then {
			append output " [getAttributes $options]"
		}

		append output ">"

		# get the thing to render recursively
		set body [lindex $args end]

		# just text? render on same line
		if {$rendersText} then {
			append output [escapeHtml [lindex $args end]]
			append output "</$tag>\n"
		} else {

			# execute uplevel-ed so that we can access variables etc.
			append output "\n"			
			incr tagLevel
			uplevel 1 $body
			incr tagLevel -1
			append output "$indent</$tag>\n"
		}
		
		return $output
	}


	#
	#	Return a string with the attributes in `options` they are shaped
	#	as follows:
	#
	#		{ key= value key2= value }
	#
	proc getAttributes {options} {
		
		set attrOutput {}
		set nAttributes [expr {[llength $options] / 2}]
		set idx 0

		foreach {name value} $options {

			if {[string index $name end] != "="} then {
				error "Expected an option, found `$name`"
			}

			# sane name is name without the equals sign
			set saneName [string range $name 0 end-1]

			# add to output
			append attrOutput "$saneName=\"[escapeHtml $value]\""

			# only add a space if there are more attributes to render
			incr idx
			if {$idx != $nAttributes} then {
				append attrOutput " "
			}
		}
		return $attrOutput
	}


	#
	#	Escapes most important HTML chars
	#
	proc escapeHtml {contents} {
		return [string map {< &lt; > &gt; & &amp; \" &quot;} $contents]
	}

	#
	#	Outputs text
	#
	proc ' {contents} {
		variable tagLevel
		variable outputBuffer
		upvar 1 $outputBuffer output
		append output "[string repeat \t $tagLevel][escapeHtml $contents]\n"
	}
}

