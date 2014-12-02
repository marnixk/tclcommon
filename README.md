# Common TCL functions

This is a small library that has common TCL functionality currently mostly concerned with structuring and encapsulating information inside your programs.

## Structs

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

## Encapsulation

It also introduces the concept of `modules` which closely resembles that found in Ruby. 

    module MyModule {

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

                                                                                                                                                                                                                
       Simple annotations implemetnation for Tcl.                                                                                                                                                               
                                                                                                                                                                                                                                              
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


