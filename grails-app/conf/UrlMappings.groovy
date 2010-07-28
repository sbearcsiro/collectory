class UrlMappings {
    static mappings = {
      "/$controller/$action?/$id?"{
	      constraints {
			 // apply constraints here
		  }
	  }
      "/collection/$id?"(controller:'public', action:'show')
      "/institution/$id?"(controller:'public', action:'showInstitution')
      "/lookup/institution/code/$code"(controller:'lookup', action:'findInstitution')
      "/lookup/institution/$id"(controller:'lookup', action:'findInstitution')
      "/"(view:"/public/map")
	  "500"(view:'/error')
	}
}
