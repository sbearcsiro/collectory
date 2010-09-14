class UrlMappings {
    static mappings = {
      name standard: "/$controller/$action?/$id?"{
	      constraints {
			 // apply constraints here
		  }
	  }
      "/pub/collection/$id?"(controller:'public', action:'show')
      "/pub/institution/$id?"(controller:'public', action:'showInstitution')
      "/lookup/inst/$inst/coll/$coll"(controller:'lookup',action:'collection')
      "/admin/export/$table" (controller:'admin',action:'export')
      "/co/$uid?" (controller:'data') {
          action = [GET:'getCollection', PUT:'saveCollection', DELETE:'delete', POST:'saveCollection']
       }
      "/in/$uid?" (controller:'data') {
          action = [GET:'getInstitution', PUT:'saveInstitution', DELETE:'delete', POST:'saveInstitution']
       }
      "/dp/$uid?" (controller:'data') {
          action = [GET:'getDataProvider', PUT:'saveDataProvider', DELETE:'delete', POST:'saveDataProvider']
       }
      "/dr/$uid?" (controller:'data') {
          action = [GET:'getDataResource', PUT:'saveDataResource', DELETE:'delete', POST:'saveDataResource']
       }
      "/dh/$uid?" (controller:'data') {
          action = [GET:'getDataHub', PUT:'saveDataHub', DELETE:'delete', POST:'saveDataHub']
       }
      "/"(controller:'public', action:'map')
	  "500"(view:'/error')
	}
}
