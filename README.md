# Common TCL functions

This is a small library that has common TCL functionality currently mostly concerned with structuring and encapsulating information inside your programs.

It contains:

* Module encapsulation
* Annotations
* Dependency Injection
* Closures
* Collections
** Datastructures
** Operations
* OO helper functions
* Configuration settings
* Logging facilities
* Typed exchange format

* Structs (to be deprecated)

Will contain in the future:

* Internationalization  

## Closures

Closures are a construct that allow you to pass around pieces of code, that have a context, and have them execute away from their original source. This package contains a function called `->` which instantiates a `Closure` class for you. There are three forms to call the `->` function in:


#### 1. Simple closure

    set simpleClosure [-> { puts "$it" }]
    $simpleClosure 10

#### 2. Named closure

    set namedClosure [-> {counter} { puts "$counter" }]
    $namedClosure 20

#### 3. Contextual closure

    set factor 2
    set contextualClosure [-> {factor} {counter} { puts "[expr $counter * $factor]" }]
    $contextualClosure 30

The Closure object that is generated by the `->` function can be passed around to other functions. Simply calling the object with an argument is going to execute the code in a proper context.

## Collections

A simple collection of datastructures and common chainable operations

### List

Contains a list object allowing you to get away from the cumbersome syntax of the default Tcl implementation

    set myList [Std::List new]
    $myList add <value>
    $myList addAll <list of values>
    $myList contains? <value>
    $myList empty?
    $myList toList      # returns the normal Tcl list
    $myList get <index>
    $myList first       # get the first element (head)
    $myList last        # get the last element
    $myList initial     # get all but the last element
    $myList rest        # get all but the first element (tail)
    $myList indexOf? <value> <optional start index>
    $myList size        # return the size


### Map

Contains a map implementation based on the default Tcl arrays.

    set myMap [Std::Map new]
    $myMap put <key> <value>
    $myMap putAll {<key> <value> ... }
    $myMap get <key>
    $myMap remove <key>
    $myMap size         # number of pairs in the list
    $myMap keys         # return a Std::List of all the keys
    $myMap values       # return a Std::List of all the values
    $myMap pairs        # return a Std::List of Std::Lists with all key/value pairs
    $myMap invert       # invert values and keys, returns a Std::Map
    $myMap pick <list-of-keys>   # returns a new map with only the keys in the whitelist
    $myMap omit <list-of-keys>   # returns a new map without the keys in the blacklist

### Function flow

Often times you'll find yourself wanting to chain a number of list operations together. Tcl's syntax, of course, allows you to nest results in the familiar bracket. However, when there is a large number of operations this becomes a little bit cumbersome. 

Introducing a simple closures implementation is able to cut down on the boilerplate that is necessary to operate on a list. We now are able to have functions such as these:

    set myList [Std::List new {10 20 30 40 50 60 70 80}]
    set multipliedList [map $myList { return [expr $it * 5 ]}]
    set over100List [filter $multipliedList { return [expr {$it > 100}] }]
 
Now, by introducing the `f>` function, we're able to concatenate pre-registered chainable functions, turning the above example into the following:

    set myList [Std::List new {10 20 30 40 50 60 70 80}]
    set over100List [
        f> $myList {} map { return [expr $it * 5] } \
                      filter { return [expr $it > 100] }
    ]                      

The empty {} allows you to put certain variables into the closure's execution context. For example:

    set myList [Std::List new {10 20 30 40 50 60 70 80}]
    
    set factor 5
    set gtThisValue 100

    set over100List [
        f> $myList {factor gtThisValue} \
                    map { return [expr $it * $factor] } \
                    filter { return [expr $it > $gtThisValue] }
    ]                      



## Encapsulation

It also introduces the concept of `modules` which closely resembles that found in Ruby. 

    Std::module MyModule {

        include OtherModule

        public procname {args} {
            .. body ..

            # calls from inside work fine
            otherproc 
        }

        protected otherproc {args} {
            .. body ..
        }

    }

    MyModule::procname ;# works fine
    MyModule::otherproc ;# will throw an error

As you can see, a module allows other modules to be included, procs to be either public or protected. If a proc is protected, it can only be called from inside the inclusion hierarchy.

## Annotations

Simple script that adds meaningful Java-style annotations to Tcl language

                                                                                                                                                                                                                
       Simple annotations implemetnation for Tcl                                                                                                                                                                                  
       To register an annotation:                                                                                        
               Annotations::register NameOfAnnotation [callback_processor_proc]                                                                                                                                                               
                                                                                                                                                                                                                                              
       This will create two new methods:                                                                                                                                                                                                      
               @NameOfAnnotation ..more code..                                                                                                                                                                                                
               @NameOfAnnotation( option list ) ..more code..                                                                                                                                                                                 
                                                                                                                                                                                                                                              

       The list of options is passed into the callback proc

## Dependency Injection

Simple dependency injection mechanism for TclOO using the annotations mechanism
described above. See examples below.

	@Component( category "class-type" ) class create MyClass {
		superclass MySuperClass
	}

	@Component class create MySecondClass {

		@Inject( MyClass ) variable cl
		@InjectCategory( class-type ) variable categoryList
		@InjectList( MySuperClass ) variable list

		method myMethod {} {
			puts $cl
			puts $list
			puts $categoryList
		}
	}


## Structs (to be deprecated)

By default TCL is typeless, however, the world around us deals with structured data which is usually identified by types. To increase the interoperability of TCL with other languages and the modelling of knowledge domains, the C concept of `structs` are introduced.

Declaring a struct:

    struct person {
        
        name {val "Unnamed"}
        age val
        psuedonyms list

    }

This declares a struct named 'person' and automatically generates a number of getters and setters:

    set p [create person]
    person.name p "My name"
    person.age p "This is my age"

It also sets the `name` attribute to 'Unnamed' when it is created.

It is also possible to point to other structs:

    struct company {
        name val
        url val
    }

    struct person {
        
        name val
        age val
        psuedonyms list
        works_for company

    }

Now a number of nested setters are generated:
    
    set p [create person]
    person.works_for.name p "Amazing Corp"
    person.works_for.url p "http://amazingt0rnat0r.co.nz"

You can also retrieve a copy of the company struct values:

    set c [person.works_for p]
    company.name "Not so amazing Corp!"

One can also use other structs as the base for this struct:

    struct substructure : {superstruct otherstruct} {

        name val
        .. etc ..
    }

Neat eh?

