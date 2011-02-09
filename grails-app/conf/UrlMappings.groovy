class UrlMappings {
    static mappings = {
      name standard: "/$controller/$action?/$id?"{
	      constraints {
			 // apply constraints here
		  }
	  }
      "/lookup/inst/$inst/coll/$coll"(controller:'lookup',action:'collection')
      "/admin/export/$table" (controller:'admin',action:'export')
      "/ws/collection/$uid?" (controller:'data') {
          action = [GET:'getCollection', PUT:'saveCollection', DELETE:'delete', POST:'saveCollection']
       }
      "/ws/institution/$uid?" (controller:'data') {
          action = [GET:'getInstitution', PUT:'saveInstitution', DELETE:'delete', POST:'saveInstitution']
       }
      "/ws/dataProvider/$uid?" (controller:'data') {
          action = [GET:'getDataProvider', PUT:'saveDataProvider', DELETE:'delete', POST:'saveDataProvider']
       }
      "/ws/dataResource/$uid?" (controller:'data') {
          action = [GET:'getDataResource', PUT:'saveDataResource', DELETE:'delete', POST:'saveDataResource']
       }
      "/ws/dataHub/$uid?" (controller:'data') {
          action = [GET:'getDataHub', PUT:'saveDataHub', DELETE:'delete', POST:'saveDataHub']
       }
      "/eml/$id?" (controller:'data',action:'eml')
      "/ws/collection/contacts/$uid?" (controller:'data',action:'contactsForCollections')
      "/ws/institution/contacts/$uid?" (controller:'data',action:'contactsForInstitutions')
      "/ws/dataProvider/contacts/$uid?" (controller:'data',action:'contactsForDataProviders')
      "/ws/dataResource/contacts/$uid?" (controller:'data',action:'contactsForDataResources')
      "/ws/dataHub/contacts/$uid?" (controller:'data',action:'contactsForDataHubs')
      "/showConsumers/$id" (controller:'entity',action:'showConsumers')
      "/showProviders/$id" (controller:'entity',action:'showProviders')
      "/"(controller:'public', action:'map')
	  "500"(view:'/error')
	}
}
