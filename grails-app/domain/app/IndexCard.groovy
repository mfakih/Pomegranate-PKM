/*
 * Copyright (c) 2014. Mohamad F. Fakih (mail@mfakih.org)
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>
 */

package app

import app.parameters.Blog
import app.parameters.Markup
import app.parameters.Pomegranate
import app.parameters.WordSource
import cmn.DataChangeAudit
import mcs.Book
import mcs.Course
import mcs.Department
import mcs.Writing
import mcs.parameters.WritingType
//import app.parameters.WordSource
import mcs.parameters.WritingStatus
//import com.bloomhealthco.jasypt.GormEncryptedStringType

class IndexCard implements Comparable {  // entity id = 16


    static hasMany = [tags: Tag, contacts: Contact]

//    static searchable = [only: ['title', 'contents', 'mainHighlights', 'sideHighlights', 'reaction', 'extractedWords', 'notes']]

    static searchable = true

    // Fields

    Markup markup



    WordSource source
    Contact contact

    Book book

    String entityCode
    String recordId

    String fileName

    String sourceFree

    String summary = ''
    String shortDescription
    String description = '?'
    String password


    Writing writing
    Department department
    Course course



    String pages

    Integer reviewCount = 0
    Date lastReviewed


    WritingType type
    WritingStatus writingStatus
    WritingStatus status //new

    String contents
    String context
    Integer priority = 2


    Date writtenOn

    Integer orderInArticle

    Integer orderInWriting

    Integer orderInBook
    String bookCode

    String language = 'en'

    Blog blog
    String blogCode
    Date publishedOn
    Integer publishedNodeId
    Pomegranate pomegranate
    Date syncedOn
    Integer syncedId
    Integer originalId

    String mainHighlights

    String sideHighlights

    String reaction

    String extractedWords

    String notes

    Boolean bookmarked = false
    Boolean isPrivate = false

    Boolean isMerged = false
    Boolean isConverted = false



    Date dateCreated
    Date lastUpdated
    Date deletedOn

    static constraints = {
        writing()
        book()
        pages()
        type(nullable: true)
        summary()//blank: false, nullable: false)
        contents()
        description(nullable: false, blank: false)
        mainHighlights()
        sideHighlights()
        reaction()
        extractedWords()

        notes()
        dateCreated()
        lastUpdated()
        deletedOn()
    }

    static mapping = {
        description(sqlType: 'longtext')
        shortDescription(sqlType: 'longtext')
        mainHighlights(sqlType: 'longtext')
        sideHighlights(sqlType: 'longtext')
        reaction(sqlType: 'longtext')
        extractedWords(sqlType: 'longtext')
        notes(sqlType: 'longtext')
//        password type: GormEncryptedStringType
    }

    static namedQueries = {
        deleted { isNotNull 'deletedOn' }
    }

    public String toString() {
        return summary
    }

    public String entityCode() {
        return 'N'
    }

    public String entityController() {
        return 'indexCard'
    }


    public String fullString() {
        return 'writing||' + writing + ';;' + 'book||' + book + ';;' + 'pages||' + pages + ';;' + 'type||' + type + ';;' + 'summary||' + summary + ';;' + 'contents||' + contents + ';;' + 'mainHighlights||' + mainHighlights + ';;' + 'sideHighlights||' + sideHighlights + ';;' + 'reaction||' + reaction + ';;' + 'extractedWords||' + extractedWords + ';;'
    }

    int compareTo(obj) {
        if (id && obj.id)
        return id.compareTo(obj.id)
        else return 1
    }

    private formatDate(Date d) {
        return new java.text.SimpleDateFormat("dd.MM.yyyy HH:mm").format(d)
    }

    static auditable = [handlersOnly: true]

    def onSave = {
        DataChangeAudit dca = new DataChangeAudit([
                userName: ('System'),
                operationType: 'Create',
                entityId: '16', recordId: id,
                operationDetails: fullString(), datePerformed: new Date()])
        if (!dca.hasErrors() && dca.save()) {
            log.info "New  IndexCard inserted with id " + id + " by " + dca.userName + " at " + formatDate(new Date())
        }
        else {
            log.error "Something went wrong in logging the change to record " + id
        }
    }

    def onDelete = {
        DataChangeAudit dca = new DataChangeAudit([userName: ('System'), operationType: 'Delete',
                entityId: '16', recordId: id, operationDetails: fullString(),
                datePerformed: new Date()])
        if (!dca.hasErrors() && dca.save()) {
            log.info "A IndexCard was deleted with id " + id + " by " + dca.userName + " at " + formatDate(new Date())
        }
        else {
            log.error "Something went wrong in logging the change to record " + id
        }
    }

    def onChange = {oldMap, newMap ->

        String message = ''

        oldMap.each({key, oldVal ->
            if (oldVal != newMap[key]) {
                message += key + '||' + oldVal + '||' + newMap[key] + ";;"
            }
        })

        DataChangeAudit dca = new DataChangeAudit([userName: ('System'), operationType: 'Update',
                entityId: '16', recordId: id, operationDetails: message,
                datePerformed: new Date()])
        if (!dca.hasErrors() && dca.save()) {
            log.info "A IndexCard was changed with id " + id + " by " + dca.userName + " at " + formatDate(new Date())
        }
        else {
            log.error "Something went wrong in logging the change to record " + id
        }
    }

} // end of class
