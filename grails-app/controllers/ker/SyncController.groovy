package ker

import app.IndexCard
import grails.converters.XML
import grails.converters.JSON
import mcs.Book
import org.springframework.http.HttpRequest

class SyncController {

//    def restClient
    def syncNote() {
        def response = request

        def p = new IndexCard()//params.product)
        p.summary = request.JSON.summary
        p.description = request.JSON.description
        p.sourceFree =  request.JSON.sourceFree
        p.originalId = request.JSON.id
//        p.dateCreated = Date.parse('ddMMyyy', request.JSON.dateCreated)
        p.lastUpdated = new Date()
//        p.lastReviewed = new Date()

        p.syncedOn = new Date()

         if (p.save(flush: true)) {
        render(['status': 'ok from remote PKM'] as XML)
        }
        else { println 'not saved'
            println p.errors
        }
    }

}
