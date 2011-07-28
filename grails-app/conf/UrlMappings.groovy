class UrlMappings {
    static mappings = {
      name standard: "/$controller/$action?/$id?"{
	      constraints {
			 // apply constraints here
		  }
	  }

        // temporary mock notification service
        "/ws/notify" (controller:'data', action:'notify')

      
      "/lookup/inst/$inst/coll/$coll"(controller:'lookup',action:'collection')
      "/admin/export/$table" (controller:'admin',action:'export')

      // data services
        "/ws/$entity/$uid?" (controller:'data') {
          action = [HEAD: 'head', GET:'getEntity', PUT:'saveEntity', DELETE:'delete', POST:'saveEntity']
          constraints {
            entity(inList:['collection','institution','dataProvider','dataResource','dataHub'])
          }
        }

        "/ws/$entity/summary" (controller:'data') {
          action = [HEAD: 'head', GET:'getEntity', PUT:'saveEntity', DELETE:'delete', POST:'saveEntity']
          constraints {
            entity(inList:['collection','institution','dataProvider','dataResource','dataHub'])
          summary = 'true'
          }
        }

      // data resource harvesting parameters
      "/ws/dataResource/$uid/connectionParameters" (controller:'data', action:'connectionParameters')

      // raw contact data
      "/ws/contacts/$id?" (controller: 'data', action: 'contacts')  

      // entity contacts
      "/ws/$entity/$uid/contacts/$id?" {
          controller = 'data'
          action = 'contactForEntity'
          constraints {
              entity(inList:['collection','institution','dataProvider','dataResource','dataHub'])
          }
      }

      // all contacts for an entity type
      // the next 5 rules should be able to be expressed as one rule in the same format as above
      // BUT /ws/$entity/contact does not work for some reason
      "/ws/collection/contacts" { controller = 'data'; action = 'contactsForEntities'; entity = 'collection'}
      "/ws/institution/contacts" { controller = 'data'; action = 'contactsForEntities'; entity = 'institution'}
      "/ws/dataProvider/contacts" { controller = 'data'; action = 'contactsForEntities'; entity = 'dataProvider'}
      "/ws/dataResource/contacts" { controller = 'data'; action = 'contactsForEntities'; entity = 'dataResource'}
      "/ws/dataHub/contacts" { controller = 'data'; action = 'contactsForEntities'; entity = 'dataHub'}

      // contacts to be notified on entity instance event
      "/ws/$entity/$uid/contacts/notifiable" {
            controller = 'data'
            action = 'notifyList'
            constraints {
                entity(inList:['collection','institution','dataProvider','dataResource','dataHub'])
            }
      }

      // html fragment representation
      "/ws/fragment/$entity/$uid" {
          controller = 'data'
          action = [HEAD: 'head', GET:'getFragment']
          constraints {
            entity(inList:['collection','institution'])
          }
      }
        
      // entities in a data hub
      "/ws/dataHub/$uid/institutions" (controller: 'data', action: 'institutionsForDataHub')
      "/ws/dataHub/$uid/collections" (controller: 'data', action: 'collectionsForDataHub')

      // citations
      "/ws/citations/$include?" (controller:'lookup', action:'citations')

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

      "/ws/codeMapDump" (controller:'data', action:'codeMapDump')

      "/ws/dataResource/harvesting" (controller:'reports', action: 'harvesters')

      "/"(controller:'public', action:'map')
      "500"(view:'/error')
	}
}
