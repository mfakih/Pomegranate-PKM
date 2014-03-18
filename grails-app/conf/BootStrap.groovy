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

import security.Role
import security.User
import security.UserRole
import org.codehaus.groovy.grails.commons.GrailsDomainClass

class BootStrap {

     def init = { servletContext ->
         log.info 'Initializing the application'




         log.info 'User home is ' + System.getProperty("user.home")
         println 'User home: ' + System.getProperty("user.home")

//         if (new File(System.getProperty("user.home") + '/.pomegranate.properties').exists())
//             println 'Log file found'
//         else println 'Log file not found'

         if (User.count() == 0){
         def adminRole = new Role(authority: 'ROLE_ADMIN').save(flush: true)
         def userRole = new Role(authority: 'ROLE_USER').save(flush: true)

         def adminUser = new User(username: 'admin', enabled: true, password: 'admin')
         def testUser = new User(username: 'guest', enabled: true, password: 'guest')

         adminUser.save(flush: true)
         testUser.save(flush: true)

         UserRole.create(adminUser, adminRole, true)
         UserRole.create(testUser, userRole, true)
         }
     }
     def destroy = {
         log.info 'Destroying the application'
     }
} 