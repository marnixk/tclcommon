
#                               dP          dP 
#                               88          88 
#     88d8b.d8b. .d8888b. .d888b88 .d8888b. 88 
#     88'`88'`88 88'  `88 88'  `88 88ooood8 88 
#     88  88  88 88.  .88 88.  .88 88.  ... 88 
#     dP  dP  dP `88888P' `88888P8 `88888P' dP 
#        

x::entity Address {

	x::property housenumber -required yes 
	x::property street 
	x::property zipcode
	x::property city 
	x::property country

	constructor {} {
		set housenumber 10
		set street "n/a"
		set zipcode {}
		set city {}
		set country {}
	}

	method show {} {
		puts $housenumber
	}

}

x::entity Person {
	x::property fullName -type string
	x::property alternateNames -type string -multiple yes
	x::property mainAddress -type Address
	x::property addresses -type Address -multiple yes

	constructor {} {
		set fullName {}
		set alternateNames {}
		set mainAddress {}
		set addresses {}
	}
}

x::entity PersonList {
	x::property people -type person -multiple yes
}


# x::printModel

