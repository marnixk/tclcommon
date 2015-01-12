namespace eval x {
	set VALID_TYPES {string number}


	proc parseList {input} {
		# parse
		set tree [x::ParseTree new]
		$tree parse $input

		set analyse [x::Analyser new]
		set entities [$analyse analyseTree $tree]
		return $entities
	}

	proc parse {input} {
		return [lindex [parseList $input] 0]
	}

}


#
#
#	Parse node is a tree node representative of a line of the 
#	stuff that is to be parsed.
#
oo::class create x::ParseNode {

	oo::property line
	oo::property children

	#
	#	Initialize data-members
	#
	constructor {aLine} {
		set line $aLine
		lappend children
	}

	#
	#	Destroy child nodes as well
	#
	destructor {
		foreach child $children {
			$child destroy
		}
	}

	#
	#	Add a child
	#
	method addChild {parseNode} {
		lappend children $parseNode
	}

	#
	#	Display the tree on screen
	#
	method toString {{indent 0}} {
		set strIndent [string repeat \t $indent]
		set nChildren [llength $children]

		if {$nChildren > 0} {
			puts "${strIndent}v $line ($nChildren)"
			foreach child $children {
				$child toString [expr $indent + 1]
			}
		} else {
			puts "$strIndent- $line"
		}
	}

}

#
#	This class generates a tree of parsable lines
#
oo::class create x::ParseTree {
	
	# root node
	oo::property rootNode

	# the current node that is being added to
	oo::property currentNode

	# the stack of nodes we want to keep track of
	oo::property nodeStack

	#
	#	Initialize data-members
	#
	constructor {} {
		set rootNode [x::ParseNode new "<root>"]
		set currentNode $rootNode
		lappend nodeStack $rootNode
	}

	#
	#	Parse the input
	#
	method parse {input} {
		set lines [split $input \n]
		set nextLineNr 1

		foreach line $lines {
			set nextLine [lindex $lines $nextLineNr]
			set nextLineIndent [my _countIndent $nextLine]
			set currentLineIndent [my _countIndent $line]

			if {[string trim $line] == {}} continue

			set childNode [x::ParseNode new [string trim $line]]

			# add current line to current node
			$currentNode addChild $childNode

			if {$nextLineIndent > $currentLineIndent} then {
				# if the next line is more indented then the child node should
				# become a parent to those, so we'll push it onto the stack
				my _push $childNode
			} elseif {$nextLineIndent < $currentLineIndent} then {
				# if the next line is less indented that means we're done with the
				# current node and should return to its parent

				# pop the delta of indentation
				set deltaIndent [expr $currentLineIndent - $nextLineIndent]
				for {set idx 0} {$idx < $deltaIndent} {incr idx} {
					my _pop					
				}
			}

			incr nextLineNr
		}
	}

	method _push {node} {
		lappend nodeStack $node
		set currentNode $node
	}

	method _pop {} {
		set currentNode [lindex $nodeStack end-1]
		set nodeStack [lrange $nodeStack 0 end-1]
	}


	#
	#	Determine the number of tabs
	#
	method _countIndent {line} {
		for {set idx 0} {$idx < [string length $line]} {incr idx} {
			if {[string index $line $idx] != "\t"} then {
				return $idx
			}
		}
		return [string length $line]
	}


}

#
#	This class is able to make sense from the mayhem that is the parse tree
#
oo::class create x::Analyser {

	#
	#	Analyse the tree
	#
	method analyseTree {tree} {
		lappend entities
		foreach child [[$tree rootNode] children] {
			lappend entities [my analyseEntity $child]
		}
		return $entities
	}

	#
	#	Analyse the structure of an entity
	#
	method analyseEntity {node {entityType {}}} {

		# get type name if not provided
		if {$entityType == {}} then {
			set entityType [$node line]
		}

		# exists?
		if {![x::isEntity $entityType]} then {
			return -code error "`$entityType` is not a registered entity"
		}	

		# instanciate
		set instance [$entityType new]

		# iterate over children value and interpret properly
		foreach entityChildNode [$node children] {
			set rest [lassign [$entityChildNode line] name type]
			set value [my getValue $entityChildNode]

			$instance $name= $value
		}

		return $instance
	}

	#
	#	Get the value 
	#
	method getValue {node {short no}} {

		# decipher form
		if {$short} {
			set rest [lassign [$node line] type]
		} else {
			set rest [lassign [$node line] name type]
		}

		if {[x::isEntity $type]} then {
			# is type an entity? then hook around and do the entity analysis
			set value [my analyseEntity $node $type]
		} elseif {$type == "list"} then {
			set value [my analyseList $node]
		} else {
			if {![my _validType $type]} then {
				return -code error "'$type' is not a valid type, (expecting: [join $x::VALID_TYPES ", "])."
			}
			if {![my _validValueForType $type $rest]} then {
				return -code error "'$rest' is not a valid value for type '$type', aborting."
			}
			set value $rest
		}		
		return $value
	}

	#
	#	Determine whether $type is a valid type name
	#
	method _validType {type} {
		if {[lsearch $x::VALID_TYPES $type] != -1} then {
			return true
		}
		return false
	}

	#
	#	Determine whether the value is actually a proper value for that type
	#
	method _validValueForType {type value} {
		return true
	}

	#
	#	Analyse the list and handle 
	#
	method analyseList {node} {
		lappend listValues
		foreach listElementNode [$node children] {
			set elDescr [$listElementNode line]
			lappend listValues [my getValue $listElementNode yes]

			# if {[x::isEntity $elDescr]} then {
			# 	# is this an entity? if so, recursively parse the
			# 	# node and add the return value to the listValues variable
			# 	lappend listValues [my analyseEntity $listElementNode]
			# } else {
			# 	set rest [lassign $elDescr type]
			# 	if {![my _validType $type]} then {
			# 		return -code error "'$type' is not a valid type, aborting."
			# 	}
			# 	if {![my _validValueForType $type $rest]} then {
			# 		return -code error "'$rest' is not a valid value for type '$type', aborting."
			# 	}
			# 	lappend listValues $rest
			# }
		}
		return $listValues
	}


}


