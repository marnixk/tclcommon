#!/usr/bin/tclsh

source "../../load.tcl"
source "testmodel.tcl"


set simpleAddress {Address
	housenumber string 110
	street string Developer Street 
	zipcode string 1010
	city string Auckland
}


set simplePerson {Person
	fullName string John Doe
	addresses list
		Address
			housenumber string 110
			street string Developer Street 
			zipcode string 1010
			city string Auckland
		Address
			housenumber string 110
			street string Developer Street 
			zipcode string 1010
			city string Auckland			
	alternateNames list
		string Johnny Doe
}


set complex {PersonList
	people list
		Person
			fullName string John Doe
			alternateNames list
				string Johnny Doe
			mainAddress Address
				housenumber string 110
				street string Developer Street 
				zipcode string 1010
				city string Auckland		
			addresses list
				Address
					housenumber string 110
					street string Developer Street 
					zipcode string 1010
					city string Auckland
				Address
					housenumber string 110
					street string Developer Street 
					zipcode string 1010
					city string Auckland
		Person
			fullName string John Doe
			alternateNames list
				string Johnny Doe
				string Little John
			mainAddress Address
				housenumber string 110
				street string Developer Street 
				zipcode string 1010
				city string Auckland
			addresses list
				Address
					housenumber string 110
					street string Developer Street 
					zipcode string 1010
					city string Auckland
				Address
					housenumber string 110
					street string Developer Street 
					zipcode string 1010
					city string Auckland}


set entities [x::parseList $complex]
