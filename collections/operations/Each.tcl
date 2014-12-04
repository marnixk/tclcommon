# add to dispatchable list 
lappend Std::Operations {each Std::Operations::Each}

#
#	Implementation
#
namespace eval Std::Operations::Each {

	proc do {iterator closure} {

#		eval {subst {proc ::current_closure {it} { $closure }}}

		while {[$iterator hasNext?]} {
			current_closure [$iterator next] 
		}

	}

}