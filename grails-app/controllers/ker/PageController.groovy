
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

import grails.util.Environment
import org.eclipse.mylyn.wikitext.core.parser.MarkupParser
import org.eclipse.mylyn.wikitext.markdown.core.MarkdownLanguage

class PageController {

    static entityMapping = [
            'G': 'mcs.Goal',
            'T': 'mcs.Task',
            'P': 'mcs.Planner',

            'W': 'mcs.Writing',
            'N': 'app.IndexCard',

            'J': 'mcs.Journal',
            'I': 'app.IndicatorData',
            'K': 'app.Indicator',

            'Q': 'app.Payment',
            'L': 'app.PaymentCategory',

            'R': 'mcs.Book',
            'C': 'mcs.Course',
            'D': 'mcs.Department',
            'E': 'mcs.Excerpt',
            'S': 'app.Contact',

            'Y': 'cmn.Setting',
            'X': 'mcs.parameters.SavedSearch'
    ]

    static allClasses = [mcs.Task, mcs.Goal, mcs.Writing, app.IndexCard,
            app.Payment, app.IndicatorData,
           mcs.Journal, mcs.Planner, mcs.Book]

    static recentClasses = [mcs.Goal, mcs.Task, mcs.Planner, mcs.Journal, mcs.Writing, app.IndexCard,
            mcs.Book]


    def legacyAdd() {
        render(template: '/layouts/legacyAdd')
    }

    def help() {
        render(template: '/page/help')
    }


    def main() {

//        def environment
//        switch (Environment.current) {
//            case Environment.PRODUCTION:
//                environment = 'prod'
//                break
//            case Environment.DEVELOPMENT:
//                environment = 'dev'
//                break
//        }
//
//        environment = Environment.current.name

//        def wrtCount = 0
//        mcs.Writing.findAllByIsLatex(true).each() {
//            wrtCount += it.description?.count(' ') ?: 0 //length() ?: 0
//        }

//        def recentRecords = []
//        recentClasses.each() {
//            recentRecords += it.findAllByDateCreatedGreaterThanAndDeletedOnIsNull(new Date() - 1, [sort: 'dateCreated', order: 'desc', max: 50])
//        }

//        def filledInDates = ''
//        Journal.executeQuery("select  DATE_FORMAT(startDate, '%c/%e/%Y') from Journal group by date(startDate) order by startDate asc").each() {
//            filledInDates += it + ' '
//        }

        session['log'] = 1

        def text = """
Pomegranate-PKM
===============

Pomegranate PKM is a new open source web-based cross-platform work and knowledge management application for productive and prolific people.

PKM features text-based commands for adding, updating and searching records, thus providing powerful tools to manage information. It also allows the user to build up the navigation menu using saved searches.

Pomegranate PKM manages:

* Goals, tasks, and plans
* Journal and indicators
* Writings and notes
* Resources (books, articles, news, presentations, audiobooks, documentaries, movies etc),and book excerpts, mainly book chapters.
* Documents e.g. Word documents, Excels
* People


In technical terms, Pomegranate PKM is a combination of:

* Document management system
* Content management system
* Research index cards and reference management
* Bug tracking systems, applied for the software development and self development
* Lightweight project management
* Powerful task management
* Time tracking
* Blog (e.g. WordPress) client

My in-progress book at [LeanPub](https://leanpub.com/pomegranate) outlines the motivations, design principles and the features of Pomegranate PKM.

"""
        MarkupParser markupParser = new MarkupParser();
        markupParser.setMarkupLanguage(new MarkdownLanguage());
        String htmlContent = markupParser.parseToHtml(text);


        render(view: '/page/main', model: [
                htmlContent: htmlContent
//                environment: environment
                //,
//                filledInDates: filledInDates?.trim(),
                // wrtCount: wrtCount, recentRecords: recentRecords

        ])
    }

    def record() {
        render(view: '/page/record', model: [record:
                grailsApplication.classLoader.loadClass(entityMapping[params.entityCode]).get(params.id)
        ])
    }

    def panel() {
        render(template: '/page/panel', model: [entityCode: params.entityCode, record:
                grailsApplication.classLoader.loadClass(entityMapping[params.entityCode]).get(params.id)
        ])
    }

    def publish() {
        render(view: '/page/publish', model: [record:
                grailsApplication.classLoader.loadClass(entityMapping[params.entityCode]).get(params.id)
        ])
    }
    def presentation() {
        render(view: '/page/presentation', model: [record:
                grailsApplication.classLoader.loadClass(entityMapping[params.entityCode]).get(params.id)
        ])
    }


    def indicators() {
        render(view: '/page/indicators', model: [])
    }

    def calendar() {

        render(view: '/reports/calendar', model: [])
    }

    def kanban() {
        render(view: '/page/kanban', model: [])
    }

    def kanbanCrs() {
        render(view: '/page/kanbanCrs', model: [])
    }

    def mobile() {
        render(view: '/page/mobile', model: [])
    }

    def colors() {
        def colors = """AliceBlue;#F0F8FF
AntiqueWhite;#FAEBD7
Aqua;#00FFFF
Aquamarine;#7FFFD4
Azure;#F0FFFF
Beige;#F5F5DC
Bisque;#FFE4C4
Black;#000000
BlanchedAlmond;#FFEBCD
Blue;#0000FF
BlueViolet;#8A2BE2
Brown;#A52A2A
BurlyWood;#DEB887
CadetBlue;#5F9EA0
Chartreuse;#7FFF00
Chocolate;#D2691E
Coral;#FF7F50
CornflowerBlue;#6495ED
Cornsilk;#FFF8DC
Crimson;#DC143C
Cyan;#00FFFF
DarkBlue;#00008B
DarkCyan;#008B8B
DarkGoldenRod;#B8860B
DarkGray;#A9A9A9
DarkGreen;#006400
DarkKhaki;#BDB76B
DarkMagenta;#8B008B
DarkOliveGreen;#556B2F
DarkOrange;#FF8C00
DarkOrchid;#9932CC
DarkRed;#8B0000
DarkSalmon;#E9967A
DarkSeaGreen;#8FBC8F
DarkSlateBlue;#483D8B
DarkSlateGray;#2F4F4F
DarkTurquoise;#00CED1
DarkViolet;#9400D3
DeepPink;#FF1493
DeepSkyBlue;#00BFFF
DimGray;#696969
DodgerBlue;#1E90FF
FireBrick;#B22222
FloralWhite;#FFFAF0
ForestGreen;#228B22
Fuchsia;#FF00FF
Gainsboro;#DCDCDC
GhostWhite;#F8F8FF
Gold;#FFD700
GoldenRod;#DAA520
Gray;#808080
Green;#008000
GreenYellow;#ADFF2F
HoneyDew;#F0FFF0
HotPink;#FF69B4
IndianRed ;#CD5C5C
Indigo ;#4B0082
Ivory;#FFFFF0
Khaki;#F0E68C
Lavender;#E6E6FA
LavenderBlush;#FFF0F5
LawnGreen;#7CFC00
LemonChiffon;#FFFACD
LightBlue;#ADD8E6
LightCoral;#F08080
LightCyan;#E0FFFF
LightGoldenRodYellow;#FAFAD2
LightGray;#D3D3D3
LightGreen;#90EE90
LightPink;#FFB6C1
LightSalmon;#FFA07A
LightSeaGreen;#20B2AA
LightSkyBlue;#87CEFA
LightSlateGray;#778899
LightSteelBlue;#B0C4DE
LightYellow;#FFFFE0
Lime;#00FF00
LimeGreen;#32CD32
Linen;#FAF0E6
Magenta;#FF00FF
Maroon;#800000
MediumAquaMarine;#66CDAA
MediumBlue;#0000CD
MediumOrchid;#BA55D3
MediumPurple;#9370DB
MediumSeaGreen;#3CB371
MediumSlateBlue;#7B68EE
MediumSpringGreen;#00FA9A
MediumTurquoise;#48D1CC
MediumVioletRed;#C71585
MidnightBlue;#191970
MintCream;#F5FFFA
MistyRose;#FFE4E1
Moccasin;#FFE4B5
NavajoWhite;#FFDEAD
Navy;#000080
OldLace;#FDF5E6
Olive;#808000
OliveDrab;#6B8E23
Orange;#FFA500
OrangeRed;#FF4500
Orchid;#DA70D6
PaleGoldenRod;#EEE8AA
PaleGreen;#98FB98
PaleTurquoise;#AFEEEE
PaleVioletRed;#DB7093
PapayaWhip;#FFEFD5
PeachPuff;#FFDAB9
Peru;#CD853F
Pink;#FFC0CB
Plum;#DDA0DD
PowderBlue;#B0E0E6
Purple;#800080
Red;#FF0000
RosyBrown;#BC8F8F
RoyalBlue;#4169E1
SaddleBrown;#8B4513
Salmon;#FA8072
SandyBrown;#F4A460
SeaGreen;#2E8B57
SeaShell;#FFF5EE
Sienna;#A0522D
Silver;#C0C0C0
SkyBlue;#87CEEB
SlateBlue;#6A5ACD
SlateGray;#708090
Snow;#FFFAFA
SpringGreen;#00FF7F
SteelBlue;#4682B4
Tan;#D2B48C
Teal;#008080
Thistle;#D8BFD8
Tomato;#FF6347
Turquoise;#40E0D0
Violet;#EE82EE
Wheat;#F5DEB3
White;#FFFFFF
WhiteSmoke;#F5F5F5
Yellow;#FFFF00
YellowGreen;#9ACD32"""
        render(template: '/page/colors', model: [colors: colors])
    }

} // end of class