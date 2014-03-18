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

package cmn

class Setting {  // entity id = 51

    String name
    String value
    String description
    Date dateCreated
    Date lastUpdated

    static constraints = {
        name(unique: true, nullable: false, blank: false)
        dateCreated(nullable: true)
        lastUpdated(nullable: true)

    }

    static mapping = {
        value(sqlType: 'longtext')
        description(sqlType: 'longtext')

    }

    public String entityCode() {
        return 'Y'
    }

    public String entityController() {
        return 'setting'
    }

    public String toString() {
        return 'record ' + id

        // new SimpleDateFormat("MMM dd yyyy HH:mm:ss").format(dateCreated)
    }


}
