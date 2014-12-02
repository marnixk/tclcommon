tcl-annotations
===============

Simple script that adds meaningful Java-style annotations to Tcl language

                                                                                                                                                                                                                
       Simple annotations implemetnation for Tcl.                                                                                                                                                               
                                                                                                                                                                                                                                              
       To register an annotation:                                                                                                                                                                                                             
                                                                                                                                                                                                                                              
               Annotations::register NameOfAnnotation [callback_processor_proc]                                                                                                                                                               
                                                                                                                                                                                                                                              
       This will create two new methods:                                                                                                                                                                                                      
               @NameOfAnnotation ..more code..                                                                                                                                                                                                
               @NameOfAnnotation< option list > ..more code..                                                                                                                                                                                 
                                                                                                                                                                                                                                              

       The list of options is passed into the callback proc
