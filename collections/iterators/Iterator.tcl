oo::class create Std::Iterator {

	constructor {} {
		error "Iterator base-class, cannot instanciate"
	}

	method hasNext? {} {
		error "Please implement the `hasNext?` method"
	}

	method next {} {
		error "Please implement the `next` method"
	}

}