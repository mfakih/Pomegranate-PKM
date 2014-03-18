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

package mcs.parameters


      import mcs.*
      import mcs.parameters.*

      import cmn.*
      import grails.converters.*
      import org.codehaus.groovy.grails.commons.ConfigurationHolder as CH
      import java.text.SimpleDateFormat
    

class RelationshipType implements Comparable {  // entity id = 452


    // static auditable = true

    

	// static searchable = [only:['name', 'notes' ]]

    // Fields
	
  String name
  String inverseName
    String style


	
	String enteredBy
	String lastUpdatedBy
	String notes

	Date dateCreated
	Date lastUpdated
	Date deletedOn

	static constraints = {
        name(unique: true, nullable: false, blank: false)

		dateCreated()
		lastUpdated()
		deletedOn()
    }

	static mapping = {
     table 'relationship_type'
      
	  notes (sqlType: 'longtext')
    }
    
    static namedQueries = {
		active{ isNotNull 'deletedOn' }    
    }

    public String toString(){
      return name
    }

    int compareTo(obj){
      if (id && obj.id)
        return id.compareTo(obj.id)
                else return 1
      }

} // end of class
