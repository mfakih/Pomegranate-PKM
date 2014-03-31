class UrlMappings {

    static mappings = {

      "/"(controller: 'page', action: 'main2')

      "/$controller/$action?/$id?"{
	      constraints {
			 // apply constraints here
		  }
	  }
  
        "/sync"(controller: "sync") {
            action = [PUT: "syncNote", POST: "syncNote", DELETE: "unsupported"]
        }
   "/m"(controller: "page") {
            action = [GET: 'mobile', DELETE: "unsupported"]
        }
   	  "500"(view:'/error')
	}
}
