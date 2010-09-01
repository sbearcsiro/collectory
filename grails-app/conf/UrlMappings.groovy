class UrlMappings {
    static mappings = {
      "/$controller/$action?/$id?"{
	      constraints {
			 // apply constraints here
		  }
	  }
      "/pub/collection/$id?"(controller:'public', action:'show')
      "/pub/institution/$id?"(controller:'public', action:'showInstitution')
      "/lookup/inst/$inst/coll/$coll"(controller:'lookup',action:'collection')
      "/admin/export/$table" (controller:'admin',action:'export')
      "/"(controller:'public', action:'map')
	  "500"(view:'/error')
	}
}
