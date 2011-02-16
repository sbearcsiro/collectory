class UrlMappings {
    static mappings = {
      name standard: "/$controller/$action?/$id?"{
	      constraints {
			 // apply constraints here
		  }
	  }
      "/lookup/inst/$inst/coll/$coll"(controller:'lookup',action:'collection')
      "/admin/export/$table" (controller:'admin',action:'export')

      // data services
        "/ws/$entity/$uid?" (controller:'data') {
          action = [HEAD: 'head', GET:'getEntity', PUT:'saveEntity', DELETE:'delete', POST:'saveEntity']
          constraints {
            entity(inList:['collection','institution','dataProvider','dataResource','dataHub'])
          }
        }

      // entity contacts
      "/ws/$entity/$uid/contact/$id?" {
          controller = 'data'
          action = 'contactForEntity'
          constraints {
              entity(inList:['collection','institution','dataProvider','dataResource','dataHub'])
          }
      }
      // the next 5 rules should be able to be expressed as one rule in the same format as above
      // BUT /ws/$entity/contact does not work for some reason
      "/ws/collection/contact" { controller = 'data'; action = 'contactsForEntities'; entity = 'collection'}
      "/ws/institution/contact" { controller = 'data'; action = 'contactsForEntities'; entity = 'institution'}
      "/ws/dataProvider/contact" { controller = 'data'; action = 'contactsForEntities'; entity = 'dataProvider'}
      "/ws/dataResource/contact" { controller = 'data'; action = 'contactsForEntities'; entity = 'dataResource'}
      "/ws/dataHub/contact" { controller = 'data'; action = 'contactsForEntities'; entity = 'dataHub'}

      // entities in a data hub
      "/ws/dataHub/$uid/institutions" (controller: 'data', action: 'institutionsForDataHub')
      "/ws/dataHub/$uid/collections" (controller: 'data', action: 'collectionsForDataHub')

      // citations
      "/ws/citations/$include" (controller:'lookup', action:'citations')

      // eml
      "/eml/$id?" (controller:'data',action:'eml')
      // preferred
      "/ws/eml/$id?" (controller:'data',action:'eml')

      "/ws/collection/contacts/$uid?" (controller:'data',action:'contactsForCollections')
      "/ws/institution/contacts/$uid?" (controller:'data',action:'contactsForInstitutions')
      "/ws/dataProvider/contacts/$uid?" (controller:'data',action:'contactsForDataProviders')
      "/ws/dataResource/contacts/$uid?" (controller:'data',action:'contactsForDataResources')
      "/ws/dataHub/contacts/$uid?" (controller:'data',action:'contactsForDataHubs')
      "/ws" (controller:'data',action:'catalogue')
      "/showConsumers/$id" (controller:'entity',action:'showConsumers')
      "/showProviders/$id" (controller:'entity',action:'showProviders')
      "/"(controller:'public', action:'map')
	  "500"(view:'/error')
	}
}
