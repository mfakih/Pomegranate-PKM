package app


      import app.*
      import app.parameters.*

      import cmn.*
      import grails.converters.*
      import org.codehaus.groovy.grails.commons.ConfigurationHolder as CH
      import java.text.SimpleDateFormat
    
import jxl.*
import jxl.format.*
import jxl.write.*
import mcs.Writing
import org.apache.commons.lang.WordUtils

class IndexCardController { // entity id = 16


	def supportService

	// the delete, save and update actions only accept POST requests
	static allowedMethods = [delete:'POST', save:'POST', update:'POST']

	def list () {

		//params.max = (params.max ?: 15)
		params.sort = (params.sort ? params.sort: 'lastUpdated')
		params.order = (params.order? params.order: 'desc')

        render(template: "/indexCard/list", model: [
			list: IndexCard.list(params),
			total: IndexCard.count()
		])

	}

    def report () {

		params.max = (params.max ?: 3)
		params.sort = (params.sort ? params.sort: 'lastUpdated')
		params.order = (params.order? params.order: 'desc')

		render(template: "/indexCard/report", model: [
			list: IndexCard.list(params),
			total: IndexCard.count()
		])

	}

	def changes () {
		def changes = DataChangeAudit.findAllByEntityIdAndRecordId(16, params.id)
		render(template: "/indexCard/changes", model: [changes: changes])
	}

	def documents () {
		def documents = Document.executeQuery("from Document where entityId = ? and recordId = ?",
			[new Long(16), params.id.toLong()], [sort: 'dateCreated', order: 'desc'])

		render(template: "/indexCard/documents", model: [changes: changes])
	}




	def delete () {
		def indexCardInstance = IndexCard.get(params.id)
		if (indexCardInstance) {
		 try {
			indexCardInstance.delete()
			//indexCardInstance.deletedOn = new Date()
			
			 flash.message = "IndexCard.deleted"
			 flash.args = [params.id]
			 flash.defaultMessage = "IndexCard ${params.id} deleted"
			 render "IndexCard ${params.id} deleted"
		}
		catch (org.springframework.dao.DataIntegrityViolationException e) {
			 flash.message = "indexCardInstance.not.deleted"
			 flash.args = [params.id]
			 flash.defaultMessage = "IndexCard ${params.id} could not be deleted"
			 render "IndexCard ${params.id} could not be deleted" //redirect(action:'show',id:params.id)
		 }
		}
		else {
			flash.message = "indexCardInstance.not.found"
			flash.args = [params.id]
			flash.defaultMessage = "IndexCard not found with id ${params.id}"
			render "IndexCard not found with id ${params.id}" //redirect(action:'list')
		}
	} // end of delete

def update () {
		def indexCardInstance = IndexCard.get(params.id)
		if (indexCardInstance) {
			if (params.version) {
				def version = params.version.toLong()
				if (indexCardInstance.version > version) {
					 indexCardInstance.errors.rejectValue("version", "optimistic.locking.failure", "Another user has updated this IndexCard while you were editing")
					 
					 render(template: "/indexCard/edit", model:[indexCardInstance:indexCardInstance])
				}
			}
			indexCardInstance.properties = params
            if (!params['book.id'])
                indexCardInstance.book = null


			if (!indexCardInstance.hasErrors() && indexCardInstance.save(flush: true) ) {
				flash.message = "IndexCard.updated"
				flash.args = [params.id]
				flash.defaultMessage = "IndexCard ${params.id} updated"

                render(template: "/gTemplates/recordSummary", model:[record: indexCardInstance, justUpdated: true])
			}
			else {
                render(template: "/indexCard/edit", model:[indexCardInstance:indexCardInstance])
			}
		}
		else {
			render ("indexCard.not.found")

		}
	} // end of update


	def edit () {

		def indexCardInstance = IndexCard.get(params.id)
		if (!indexCardInstance) {
			flash.message = "IndexCard.not.found"
			flash.args = [params.id]
			flash.defaultMessage = "IndexCard not found with id ${params.id}"

			render 'Record not found'
		}
		else {
			render(template: "/indexCard/edit", model: [indexCardInstance: indexCardInstance, updateRegion: "CRecord${params.id}"])
		}

	} // end of edit

	def attach () {

		def indexCardInstance = new IndexCard(params)

		if (!indexCardInstance.hasErrors() && indexCardInstance.save(flush: true)) {
			/* save the last entered value to speed up data entry */
			session['lastIcdTypeId'] = indexCardInstance.type?.id
//			session['lastSourceType'] = indexCardInstance.sourceType?.id
			session['lastSource'] = indexCardInstance.source?.id
			flash.message = "indexCard.created"
			flash.args = [indexCardInstance.id]
			flash.defaultMessage = "IndexCard ${indexCardInstance.id} created"

			// params.max = (params.max ?: 10)
			params.sort = (params.sort ? params.sort: 'lastUpdated')
			params.order = (params.order? params.order: 'desc')
			
//			render(template: "/gTemplates/recordListing", model: [
//				list: IndexCard.findAllByEntityCodeAndRecordId(indexCardInstance.entityCode, indexCardInstance.recordId, params)
//			])
def recordEntityCode = indexCardInstance.entityCode
def recordId = indexCardInstance.recordId

if (indexCardInstance.writing){
recordEntityCode = 'W'
recordId = indexCardInstance?.writing?.id
}
else if (indexCardInstance.book){
recordEntityCode = 'B'
recordId = indexCardInstance?.book?.id
}


            render(template: "/indexCard/add", model: [
                    indexCardInstance: new IndexCard(),
                    recordEntityCode: recordEntityCode,
                    recordId: recordId,
                    writingId:indexCardInstance?.writing?.id,
                    bookId: indexCardInstance?.book?.id

			])
		}
		else {
			render(template: "/indexCard/add", model:[
				indexCardInstance:indexCardInstance,
                    recordEntityCode: indexCardInstance.entityCode,
                    recordId: indexCardInstance.recordId
			])
		}
	} // end of save
	def save () {

		def indexCardInstance = new IndexCard(params)

		if (!indexCardInstance.hasErrors() && indexCardInstance.save(flush: true)) {
			/* save the last entered value to speed up data entry */
			session['lastIcdTypeId'] = indexCardInstance.type?.id
			session['lastSourceType'] = indexCardInstance.sourceType?.id
			session['lastSource'] = indexCardInstance.source?.id
			flash.message = "indexCard.created"
			flash.args = [indexCardInstance.id]
			flash.defaultMessage = "IndexCard ${indexCardInstance.id} created"

			// params.max = (params.max ?: 10)
			params.sort = (params.sort ? params.sort: 'lastUpdated')
			params.order = (params.order? params.order: 'desc')

//			render(template: "/gTemplates/recordListing", model: [
//				list: IndexCard.findAllByEntityCodeAndRecordId(indexCardInstance.entityCode, indexCardInstance.recordId, params)
//			])
            render(template: "/indexCard/list", model: [
                    indexCardInstance: new IndexCard(), list: IndexCard.list(params), total: IndexCard.count()

			])
		}
		else {
			render(template: "/indexCard/list", model:[
				indexCardInstance:indexCardInstance,
				list: IndexCard.list(params),
				total: IndexCard.count()
			])
		}
	} // end of save

    def rss() {
        render(feedType: "rss", feedVersion: "2.0") {
            title = "Index cards"
            link = CH.config.grails.serverURL + "/mcs/indexCard/rss"
            description = "Index cards"

//NewsItem.findAllByApprovedOnIsNotNullAndByRss([sort: 'dateCreated', order: 'desc', max: 25]).each() { article ->
            IndexCard.findAll([sort: 'course', order: 'asc']).each() { article ->
                //def title =
                    entry(article?.title) {
//  entry(article.title + ' (' + article.type.toString() + ' / ' + article.writingStatus.toString() + ' - ' + (article?.body ? article?.body?.count(' ') : '0') + ' words)') {
                        link = CH.config.grails.serverURL + "/writing/show/${article.id}"
                        publishedDate = article.dateCreated
                        author = (article.course ? article.course.toString() : '')
                        content(type: 'text/html', value: article.contents.replaceAll('\n', '</p><p>'))
                        //.replaceAll('', '')
                    }
                }
            }
        }

} // end of class