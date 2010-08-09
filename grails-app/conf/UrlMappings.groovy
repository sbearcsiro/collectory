class UrlMappings {
    static mappings = {
      "/$controller/$action?/$id?"{
	      constraints {
			 // apply constraints here
		  }
	  }
      "/collection/view/$id?"(controller:'public', action:'show')
      "/institution/view/$id?"(controller:'public', action:'showInstitution')
      "/lookup/institution/$id"(controller:'lookup', action:'findInstitution')
      "/lookup/inst/$inst/coll/$coll"(controller:'lookup',action:'collection')
      "/admin/export/$table" (controller:'admin',action:'export')
      "/"(view:"/public/map")
	  "500"(view:'/error')
	}
}
