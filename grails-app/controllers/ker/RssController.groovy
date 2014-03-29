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



package ker

import app.IndexCard
import app.IndicatorData
import app.Payment
import cmn.Setting
import com.sun.syndication.feed.synd.SyndCategoryImpl
import mcs.*
import mcs.parameters.ResourceStatus
import mcs.parameters.WritingStatus
import org.apache.commons.lang.StringUtils

class RssController {

    def feeds(String type) {

        if (!type) {
            render 'No type specified'
        } else {
            def feedTitle
            def feedLink
            def feedDescription

            def entries = Task.list()
            def entrySummary = { it?.summary }
            def entryDescription = { it?.description }

            def linkType = type.length() == 1 ? type : 'B'
            def entryLink = { OperationController.getPath('app.URL') + "/page/record?entityCode=" + linkType + '&id=' + it?.id }

            def entryPublishedDate = { it?.dateCreated }
            def entryAuthor = { it?.status }
            def entryCategory = { it?.location?.name }

            render(feedType: "rss", feedVersion: "2.0") {

                switch (type) {
                    case 'T':
                        feedTitle = "Tasks"
                        feedLink = "mydomain/tasks"
                        feedDescription = "List of all tasks..."
                        entries = Task.findAllByBookmarked(true, [sort: 'course'])
                        entrySummary = { (it?.department ? it?.department?.code + ' ' : '') + it?.summary }
                        entryDescription = { it?.description?.replaceAll('\n', '<br/>') }
                        entryPublishedDate = { it?.dateCreated }
                        entryAuthor = { it?.status?.name }
                        entryCategory = { it?.location?.name }
                        break
                    case 'J':
                        feedTitle = "Journal"
                        feedLink = "mydomain/tasks"
                        feedDescription = "List of all journal entries..."
                        entries = Journal.list([sort: 'startDate'])
                        entrySummary = { it.startDate.format('dd.MM.yyyy') + ' ' + StringUtils.abbreviate(it?.description, 80) }
                        entryDescription = { it?.description }
                        entryPublishedDate = { it?.dateCreated }
                        entryAuthor = { it?.level }
                        entryCategory = { it?.type?.name }
                        break
                    case 'K':
                        feedTitle = "Indicators"
                        feedLink = "mydomain/tasks"
                        feedDescription = "List of all indicator data..."
                        entries = IndicatorData.list([sort: 'date'])
                        entrySummary = { it.date?.format('dd.MM.yyyy') + ' ' + it.indicator?.code + ': ' + it.value }
                        entryDescription = { it?.notes ?: '' }
                        entryPublishedDate = { it?.dateCreated }
                        entryAuthor = { it?.indicator?.code }
                        entryCategory = { it?.indicator?.category.toString() }
                        break
                    case 'E':
                        feedTitle = "Expenses"
                        feedLink = "mydomain/tasks"
                        feedDescription = "List of all expenses..."
                        entries = Payment.list([sort: 'date'])
                        entrySummary = { it.date.format('dd.MM.yyyy') + ' ' + it.category?.name + ': ' + it.amount }
                        entryDescription = { it?.description }
                        entryPublishedDate = { it?.dateCreated }
                        entryAuthor = { it?.date.format('dd.MM.yyyy') }
                        entryCategory = { it?.category?.name }
                        break
                    case 'X':
                        feedTitle = "Excercises"
                        feedLink = "mydomain/tasks"
                        feedDescription = "List of all exercises..."
                        entries = Exercise.list([sort: 'dateCreated'])
                        entrySummary = { 'X-' + it.id + ' ' + it.title }
                        entryDescription = { it?.source?.title }
                        entryPublishedDate = { it?.dateCreated }
                        entryAuthor = { it?.source?.toString() }
                        entryCategory = { it?.source?.course.toString() }
                        break
                    case 'P':
                        feedTitle = "Planner"
                        feedLink = "mydomain/tasks"
                        feedDescription = "List of all planner entries..."
                        entries = Planner.list([sort: 'startDate'])
                        entrySummary = { it.startDate.format('dd.MM.yyyy') + ' ' + StringUtils.abbreviate(it?.description, 80) }
                        entryDescription = { it?.description + (it.reality ? ' - Reality: ' : '') }
                        entryPublishedDate = { it?.dateCreated }
                        entryAuthor = { it?.level }
                        entryCategory = { it?.type?.name }
                        break
                    case 'G':
                        feedTitle = "Goals"
                        feedLink = "mydomain/goals"
                        feedDescription = "List of all goals..."
                        entries = Goal.findAllByBookmarked(true, [sort: 'course'])
                        entrySummary = { (it?.department ? it?.department?.code + ' ' : '') + (it?.course ? it?.course?.code + ' ' : '') + it?.summary }
                        entryDescription = { it?.type?.name + '/' + it?.status?.name + (it.description ? it.description + ': ' : '') }
                        entryPublishedDate = { it?.dateCreated }
                        entryAuthor = { it?.status?.name }
                        entryCategory = { it?.type?.name }
                        break

                    case 'C':
                        feedTitle = "Index Cards"
                        feedLink = "mydomain/icards"
                        feedDescription = "List of all index cards..."
                        entries = IndexCard.list([sort: 'type'])
                        entrySummary = { it.summary ?: StringUtils.abbreviate(it?.description, 80) }
                        entryDescription = { it?.type?.name + ': ' + it.description }
                        entryPublishedDate = { it?.dateCreated }
                        entryAuthor = { it?.status?.name }
                        entryCategory = { it?.type?.name }
                        break
                    case 'R':
                        feedTitle = "Excerpts"
                        feedLink = "mydomain/icards"
                        feedDescription = "List of all excerpts..."
                        entries = Excerpt.list([sort: 'book'])
                        entrySummary = { it.title ?: 'From: ' + it?.book.title }
                        entryDescription = { it?.book?.description }
                        entryPublishedDate = { it?.dateCreated }
                        entryAuthor = { it?.priority }
                        entryCategory = { it?.book?.course.toString() }
                        break
                    case 'W':
                        feedTitle = "Writings"
                        feedLink = "mydomain/writings"
                        feedDescription = "List of all writings"
                        entries = Writing.findAllByStatusNot(WritingStatus.get(12), [sort: 'course'])
                        entrySummary = { it?.summary }
                        entryDescription = { it?.type?.name + ': ' + it.description }
                        entryPublishedDate = { it?.dateCreated }
                        entryAuthor = { it?.course.toString() }
                        entryCategory = { it?.type?.name }
                        break
                    case 'B':
                        feedTitle = "Textbooks"
                        feedLink = "mydomain/Textbooks"
                        feedDescription = "List of all Textbooks"
                        // entries = Book.findAllByStatusAndBookmarked([ResourceStatus.get(1),true], [sort:  'course'])
                        entries = Book.findAllByBookmarked(true, [sort: 'course'])
                        entrySummary = { (it?.department ? it?.department?.code + ' ' : '') + (it?.course ? it?.course?.code + ' ' : '') + (it?.title ? it?.title + ' ' : '') + (it.legacyTitle ?: '') }
                        entryDescription = { """ <img style="width: 100px; display:inline" src="book/viewImage/${it.id}"/>""" + (it?.author ?: '') + '  ' + (it.description ?: '') }
                        entryPublishedDate = { it?.dateCreated }
                        entryAuthor = { it?.course.toString() }
                        entryCategory = { it?.course.toString() }
                        break
                    case 'RANDOM':
                        feedTitle = "Random books"
                        feedLink = "mydomain/Textbooks"
                        feedDescription = "List of all Textbooks"
//                      def list = [:]
//                      Book.findAllByTitleIsNotNull().eachWithIndex() { b, i ->
//            if (b.id)
//                          list[i] = b.id
//                      }
                        entries = mcs.Book.get(Math.floor(Math.random() * mcs.Book.countByTitleIsNotNull()).toInteger())
                        entrySummary = { (it?.title ?: '') + ' ' + (it.legacyTitle ?: '') }
                        entryDescription = { """ <img style="width: 100px; display:inline" src="${OperationController.getPath('app.URL')}/book/viewImage/${it.id}"/>""" + (it?.author ?: '') + '  ' + (it.description ?: '') }
                        entryPublishedDate = { it?.dateCreated }
                        entryAuthor = { it?.course.toString() }
                        entryCategory = { it?.course.toString() }
                        break
                    case 'EBK':
                        feedTitle = "All books"
                        feedLink = "mydomain/allbooks"
                        feedDescription = "List of all books"
                        entries = Book.findAllByStatusNotEqual(ResourceStatus.get(11), [sort: 'lastUpdated', order: 'desc', max: 100])
                        entrySummary = { (it?.title ?: 'No title') + ' ' + (it.legacyTitle ?: '') }
                        entryDescription = { """ <img style="width: 100px; display:inline" src="${OperationController.getPath('app.URL')}/book/viewImage/${it.id}"/> """ + (it?.author ?: '') + '  ' + (it.description ?: '') }
//                    entryLink = {"/rss/" + type + '/' + it?.id}
                        entryPublishedDate = { it?.dateCreated }
                        entryAuthor = { it?.course.toString() }
                        entryCategory = { it?.course.toString() }
                        break
                }

                        title = feedTitle
                        link = feedLink
                        description = feedDescription

                        entries.each() {
                            def record = it
                            entry(entrySummary(it)) {
                                link = entryLink(record)
                                publishedDate = entryPublishedDate(record)
                                author = entryAuthor(record)

                                def c = new SyndCategoryImpl() // only one category is allowed
                                c.setName(entryCategory(record))
                                categories = [c]

                                entryDescription(record)?.replaceAll('\n', '<br/>')
                            }
                        }

                }

                //            render(feedType: "rss", feedVersion: "2.0") {
                //                title = "Tasks"
                //                link = ConfigurationHolder.config.grails.serverURL + "/task/rss"
                //                description = "Tasks"
                //
                //                //NewsItem.findAllByApprovedOnIsNotNullAndByRss([sort: 'dateCreated', order: 'desc', max: 25]).each() { article ->
                //                Task.findAll([sort: 'name', order: 'asc']).each() { article ->
                //                    //def title =
                //                    entry((article.location ?: '') + (article.isTodo ? ' Todo ' : '') + article.name) {
                //                        link = ConfigurationHolder.config.grails.serverURL + "/task/show/${article.id}"
                //                        publishedDate = article.dateCreated
                //                        author = article.course
                //                        article.description ?: ''
                //                        //.replaceAll('', '')
                //                    }
                //                }
                //            }
        }
    }

} // end of class