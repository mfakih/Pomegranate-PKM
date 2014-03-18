class UrlMappings {

    static mappings = {

      "/"(controller: 'page', action: 'main')

      "/$controller/$action?/$id?"{
	      constraints {
			 // apply constraints here
		  }
	  }
  
   	  "500"(view:'/error')
	}
}
