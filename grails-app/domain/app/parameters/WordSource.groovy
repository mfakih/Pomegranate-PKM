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

package app.parameters

import cmn.DataChangeAudit
import app.Tag
import mcs.Course
import mcs.Department

class WordSource implements Comparable {  // entity id = 26


     static searchable = [only:['name', 'description', 'summary', 'notes' ]]

    static hasMany = [tags: Tag]

    // Fields

    String name
    String code
    Department department
    Course course

    String summary
    String description

    Boolean bookmarked
    Integer priority = 2

    String notes

    Date dateCreated
    Date lastUpdated
    Date deletedOn

    static constraints = {
        name()
        summary(blank: false, nullable: false)

        notes()
        dateCreated()
        lastUpdated()
        deletedOn()
    }

    static mapping = {

        // name (index:'name_index')
        description(sqlType: 'longtext')
        notes(sqlType: 'longtext')
    }




    static namedQueries = {
        deleted { isNotNull 'deletedOn' }
    }

    public String toString() {
        return name
    }

    public String entityCode() {
        return 'Z'
    }

    public String entityController() {
        return 'wordSource'
    }



    public String fullString() {
        return 'name||' + name + ';;'
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
                entityId: '26', recordId: id,
                operationDetails: fullString(), datePerformed: new Date()])
        if (!dca.hasErrors() && dca.save()) {
            log.info "New  WordSource inserted with id " + id + " by " + dca.userName + " at " + formatDate(new Date())
        }
        else {
            log.error "Something went wrong in logging the change to record " + id
        }
    }

    def onDelete = {
        DataChangeAudit dca = new DataChangeAudit([userName: ('System'), operationType: 'Delete',
                entityId: '26', recordId: id, operationDetails: fullString(),
                datePerformed: new Date()])
        if (!dca.hasErrors() && dca.save()) {
            log.info "A WordSource was deleted with id " + id + " by " + dca.userName + " at " + formatDate(new Date())
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
                entityId: '26', recordId: id, operationDetails: message,
                datePerformed: new Date()])
        if (!dca.hasErrors() && dca.save()) {
            log.info "A WordSource was changed with id " + id + " by " + dca.userName + " at " + formatDate(new Date())
        }
        else {
            log.error "Something went wrong in logging the change to record " + id
        }
    }

} // end of class
