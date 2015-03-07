package pkm

import app.parameters.ResourceType
import ker.OperationController
import mcs.Book
import org.apache.commons.lang.StringUtils

import java.text.DecimalFormat
import java.text.SimpleDateFormat

class PkmTagLib {

    static namespace = "pkm"

    def supportService

    def progressBar = { attrs ->

        def background = 'gray';
        def percent = (attrs?.percent?.toInteger() ? attrs?.percent?.toInteger() : 0)
    /*  switch(percent) {
                case 0..20:  background = 'yellow'
                break
                case 21..40: background = 'lightgreen'
                break
                case 40..70: background = 'darkgreen'
                break
                case 71..90: background = 'darkgray'
                break;
                case 91..100: background = 'lightgray'
                break
              }
              */
        background = 'gray'
        out << """
<div class="ui-progressbar ui-widget ui-widget-content ui-corner-all" style="width: 99%; height: 3px; border: none; display: block; margin-top:4px;">
   <div style="width: ${attrs.percent}%; background: ${background};" class="ui-progressbar-value ui-widget-header ui-corner-left"></div>
</div>
        """
    }

    def highlight = { attrs ->

        def str = attrs.text
        attrs.searchTerms.split(' ').each() {
            (attrs.text =~ /(?i:${it})/).eachWithIndex() { match, i ->
                str = str.replaceAll(match, '<b>' + match + '</b>')
            }
        }
        out << str
    }

    def summarize = { attrs ->
        if (attrs.text && attrs.text != '') {
            def text = attrs.text ? attrs.text.encodeAsHTML() : ''
            def length = attrs.length

            out << StringUtils.abbreviate(text, length.toInteger())?.replaceAll('>', ' ')?.replaceAll('<', ' ')?.encodeAsHTML()?.decodeHTML()
        } else {
            out << ''
        }
    }
    def listRecordFiles = { attrs ->
        def module = attrs.module
        def fileClass = attrs.fileClass
        def recordId = attrs.recordId
        def type = attrs.type
        def filesList = []
        try {
            def folders = [
                    OperationController.getPath('module.sandbox.' + module + '.path'),
                    OperationController.getPath('module.repository.' + module + '.path')
            ]
            folders.each() { folder ->
                if (folder && new File(folder).exists()) {
                    new File(folder).eachFileMatch(~/${recordId}[a-z][\S\s]*\.[\S\s]*/) {
                        filesList.add(it)
                    }
                }
            }
             folders = [
                    OperationController.getPath('module.sandbox.' + module + '.path') + '/' + recordId,
                    OperationController.getPath('module.repository.' + module + '.path') + '/' + recordId,
                     OperationController.getPath('pictures.repository.path') + '/' + module + '/' + recordId
            ]
            folders.each() { folder ->
                if (folder && new File(folder).exists()) {
                    new File(folder).eachFileMatch(~/[\S\s]*\.[\S\s]*/) {
                        filesList.add(it)
                    }
                }
            }
            if (module == 'R'){
                        def typeSandboxPath = ResourceType.findByCode(type).newFilesPath
                        def typeRepositoryPath = ResourceType.findByCode(type).repositoryPath
                folders = [
                        typeSandboxPath  + '/' + (recordId / 100).toInteger(),
                        typeRepositoryPath + '/' + (recordId / 100).toInteger()
                ]
                folders.each() { folder ->

                    if (new File(folder).exists()) {
                        new File(folder).eachFileMatch(~/${recordId}[a-z][\S\s]*\.[\S\s]*/) {
                            filesList.add(it)
                        }
                    }
                }
                folders = [
          typeSandboxPath +  '/' + (recordId / 100).toInteger() + '/' + recordId,

          typeRepositoryPath + '/' + (recordId / 100).toInteger() + '/' + recordId
                ]

                def b = Book.get(recordId)
                if (b.code){
                    folders.add(typeSandboxPath + '/' + b.code)
                    folders.add(typeRepositoryPath + '/' + b.code)
                }

                folders.each() { folder ->
                    if (new File(folder).exists()) {
                        new File(folder).eachFileMatch(~/[\S\s]*\.[\S\s]*/) {
                            filesList.add(it)
                        }
                    }
                }
                folders = [
                        OperationController.getPath('audio.excerpts.repository.path')  + '/' + type + '/' + recordId,
                        OperationController.getPath('video.excerpts.repository.path')  + '/' + type  + '/' + recordId,
                        OperationController.getPath('video.snapshots.repository.path')   + '/' + type + '/' + recordId
                ]
                folders.each() { folder ->
                    if (new File(folder).exists()) {
                        new File(folder).eachFileMatch(~/[\S\s]*\.[\S\s]*/) {
                            filesList.add(it)
                        }
                    }
                }
            }
        }
        catch (Exception e) {
            out << ''
            print 'Problem in listing record folder: ' + e.printStackTrace()
        }
        def output = "<ul style='padding: 5px; line-height: 20px;list-style: none; font-weight: normal; font-family: tahoma; font-size: 12px; text-decoration: none;'>"
        def c = 1
        for (i in filesList) {
            def fileId = new Date().format('HHmmssSSS') + c //Math.floor(Math.random()*1000)
            c++
            session[fileId] = i.path
            output += """<li>
<a href="${createLink(controller: 'operation', action: 'download', id: fileId)}" class="${fileClass}"
                          target="_blank"
                          title="${i.path}">
  ${i.name} <span style="font-size: smaller; color: gray;">
${prettySizeMethod(i.size())}
</span>
            </a>
</li>"""
        }
        output += "</ul>"
        out << output.decodeHTML()
//            }
//    out << ''
    }

    def listFiles = { attrs ->

        def folder = attrs.folder
        def fileClass = attrs.fileClass
        def initial = attrs.initial
        def recordId = attrs.recordId

//        println 'in list files ' + folder

        def filesList = []
        try {

            if (!initial || initial.toString().trim() == '')
                initial = ''
            if (new File(folder).exists())  {
                new File(folder).eachFileMatch(~/${initial}[\S\s]*/) {
                    filesList.add(it)
                }

                def output = "<ul style='padding: 5px; line-height: 20px;list-style: none; font-weight: bold; font-size: 12px; text-decoration: none;'>"
                def c = 1
                for (i in filesList) {
                    def fileId = new Date().format('HHmmssSSS') + c //Math.floor(Math.random()*1000)
                    c++
                    session[fileId] = i.path
                    output += """<li>
<a href="${createLink(controller: 'operation', action: 'download', id: fileId)}" class="${fileClass}"
                          target="_blank"
                          title="${folder}">
  ${i.name} <span style="font-size: smaller; color: gray;">
${prettySizeMethod(i.size())}
</span>

            </a>
</li>"""
//(${PrettySizeTagLib.display([size: i.size(), abbr: true])})

//                <a onclick="jQuery('#logRegion').load('/mcs6/operation/openFile/' + $fileId)"
//                            title="Open file">
//    
//                
//<a onclick="jQuery('#logRegion').load('/mcs6/operation/moveFile/' + $fileId)"
//                            title="Move file">
//                M
//            </a>

                }

                output += "</ul>"
                out << output.decodeHTML()
            }
            out << ''
        }
        catch (Exception e) {
            out << ''
            print 'Problem: ' + e.printStackTrace()

        }

    }

    def listVideos = { attrs ->

        def folder = attrs.folder
        def fileClass = attrs.fileClass
        def initial = attrs.initial
        def recordId = attrs.recordId

//        println 'in list files ' + folder

        def filesList = []
        try {

            if (!initial || initial.toString().trim() == '')
                initial = ''
            if (new File(folder).exists()) {
                new File(folder).eachFileMatch(~/${initial}[\S\s]*/) {
                    filesList.add(it)
                }

                def output = "<ul style='padding: 5px; line-height: 20px;list-style: none; font-weight: bold; font-size: 14px; text-decoration: none;'>"
                def c = 1
                for (i in filesList) {
                    def fileId = new Date().format('HHmmssSSS') + c //Math.floor(Math.random()*1000)
                    c++
                    session[fileId] = i.path
                    output += """<li>


<a href="${createLink(controller: 'operation', action: 'download', id: fileId)}" class="${fileClass}"
                          target="_blank"
                          title="${folder}">
  ${i.name} <span style="font-size: smaller; color: gray;">
${prettySizeMethod(i.size())}
</span>

            </a>
<br/>

   <video width="320" height="240" controls
source src="${createLink(controller: 'operation', action: 'download', id: fileId)}" class="${fileClass}">
                    Your browser does not support the video tag.
                </video>
</li>"""

                }

                output += "</ul>"
                out << output.decodeHTML()
            }
            out << ''
        }
        catch (Exception e) {
            out << 'Problem in folder ' + folder
            print 'Problem ' + e

        }

    }


    def listAudios = { attrs ->

        def folder = attrs.folder
        def fileClass = attrs.fileClass
        def initial = attrs.initial
        def recordId = attrs.recordId

//        println 'in list files ' + folder

        def filesList = []
        try {

            if (!initial || initial.toString().trim() == '')
                initial = ''
            if (new File(folder).exists()) {
                new File(folder).eachFileMatch(~/${initial}[\S\s]*/) {
                    filesList.add(it)
                }

                def output = "<ul style='padding: 5px; line-height: 20px;list-style: none; font-weight: bold; font-size: 14px; text-decoration: none;'>"
                def c = 1
                for (i in filesList) {
                    def fileId = new Date().format('HHmmssSSS') + c //Math.floor(Math.random()*1000)
                    c++
                    session[fileId] = i.path
                    output += """<li>

<a href="${createLink(controller: 'operation', action: 'download', id: fileId)}" class="${fileClass}"
                          target="_blank"
                          title="${folder}">
  ${i.name} <span style="font-size: smaller; color: gray;">
${prettySizeMethod(i.size())}
</span>

            </a>
<br/>

   <audio width="320" height="240" controls
source src="${createLink(controller: 'operation', action: 'download', id: fileId)}" class="${fileClass}">
                    Your browser does not support the video tag.
                </video>
</li>"""

                }

                output += "</ul>"
                out << output.decodeHTML()
            }
            out << ''
        }
        catch (Exception e) {
            out << 'Problem in folder ' + folder
            print 'Problem ' + e

        }

    }
    def listPictures = { attrs ->

        def folder = attrs.folder
        def fileClass = attrs.fileClass
        def initial = attrs.initial
        def recordId = attrs.recordId

//        println 'in list files ' + folder

        def filesList = []
        try {

            if (!initial || initial.toString().trim() == '')
                initial = ''
            if (new File(folder).exists()) {
                new File(folder).eachFileMatch(~/${initial}[\S\s]*.jpg/) {
                    filesList.add(it)
                }

                new File(folder).eachFileMatch(~/${initial}[\S\s]*.jpeg/) {
                    filesList.add(it)
                }

                
                new File(folder).eachFileMatch(~/${initial}[\S\s]*.png/) {
                    filesList.add(it)
                }

                
                def output = """ <div id="image-gallery-demoxx" class="content" style="display: block;">
<ul class="galleryxx clearfixxx"> """
                //<ul style='padding: 5px; line-height: 20px;list-style: none; font-weight: bold; font-size: 14px; text-decoration: none;'>"
                def c = 1
                for (i in filesList) {
                    def fileId = new Date().format('HHmmssSSS') + c //Math.floor(Math.random()*1000)
                    c++
                    session[fileId] = i.path

//                    rel="prettyPhotoxx[as]"
                    output += """
  <a href="${createLink(controller: 'operation', action: 'download', id: fileId)}" target="_blank" class="${fileClass}"
                          title="${i.name}">
<img src="${createLink(controller: 'operation', action: 'download', id: fileId)}" width="200" alt="${i.name}" />
            </a>
            <br/>
            <hr style="color: gray"/>
            <br/>
"""

                }

                output += """</div>
</ul>
"""
                out << output.decodeHTML()
            }
            out << ''
        }
        catch (Exception e) {
            out << 'Folder: ' + folder + ' has problem ' + e


        }

    }
    def checkFolder = { attrs ->

        def folder = attrs.folder
        def path = attrs.path
        def name = attrs.name

        def color = 'red'
        def output
        if (path) {



            if (!new File(path).exists()) {
                output = "<span style='color: ${color}' title='Path: $path'>" + folder + "</span>"
                out << output.decodeHTML()
            } else {
                color = 'green'
                output = "<span style='color: ${color}' title='Path: $path - name: $name'>" + folder + "</span>"
                out << output.decodeHTML()
            }
        } else
            color = 'darkorange'
            output = "<span style='color: ${color}' title='Name: $name'></span>"
            out << output.decodeHTML()

    }

    public static String labelize(String s) {
        (s =~ /[A-Z]/).eachWithIndex() { it, i ->
            s = s.replaceAll(it, ' ' + it)
        }
        return s
    }


    def datePicker = { attrs ->
        def fieldName = attrs.name
        def fieldId = attrs.id ?: fieldName
        def valueName = attrs.value
        def formattedValue = ''
        if (valueName != null) {
            formattedValue = new SimpleDateFormat("dd.MM.yyyy").format(valueName)
        }
        def cal = resource(dir: 'images', file: 'cal.png')

        out << """
      <input type="text" name="${fieldName}" id="${fieldId}" value="${formattedValue}" style="width:90px;" placeholder="${attrs.placeholder}" />
      <script>
    var pickerOpts = {
//    showOn: "both",
//    buttonImage: '${cal}',
//    buttonImageOnly: true,
    //appendText: " (dd.mm.yyyy)",
    dateFormat: "dd.mm.yy",
    firstDay:1
//    changeFirstDay: false,
//    changeMonth: true,
//    changeYear: true,
//    closeAtTop: true,
//    constrainInput: true,
//    duration: "fast",
    //minDate: "01.01.2003",
    //maxDate: "12.12.2011",
//    navigationAsDateFormat: true,
//    numberOfMonths: 1,
//    showOtherMonths: true,
//    showStatus: true,
//    showWeeks: true,
//    yearRange:"-35+3"

 };
    // onSelect: function(dateText, inst) { console.log('valude entered is: ' + dateText); this.value = dateText}
  jQuery("#${fieldId}").datepicker(pickerOpts);

  </script>
"""

    }

    def weekDate = { attrs ->

//        out << supportService.toWeekDate(attrs.date)

        if (attrs.date) {
            Calendar c = new GregorianCalendar()
            c.setLenient(false)
            c.setMinimalDaysInFirstWeek(4)
            c.setFirstDayOfWeek(java.util.Calendar.MONDAY)
            c.time = attrs.date
            def tmp = c.get(java.util.Calendar.DAY_OF_WEEK)
            def week = c.get(java.util.Calendar.WEEK_OF_YEAR)
            def year = c.get(java.util.Calendar.YEAR)
            out << '<b>' + (week < 10 ? '0' + week.toString() : week) + '' + (tmp == 1 ? 7 : tmp - 1) + '</b><sup>' + year.toString().substring(2, 4) + '</sup>'
        } else
            out << ''
    }

    def simpleModal = { attrs ->
        def modalId = UUID.randomUUID().toString()
        out << """
                <span id="${modalId}">
                    <a title="${attrs.title}" href="${attrs.link}">
                    ${attrs.body}
                    </a>
                </span>
     <script>
//         jQuery("#${modalId} a").gSimpleModal({theme : "osx"});
      </script>
"""

    }
    def modalBox = { attrs ->
        def modalId = UUID.randomUUID().toString()
        out << """
                <span id="${modalId}">
                    <a title="${attrs.title}" href="/mcs6/${attrs.controller}/${attrs.action}/${attrs.rid}" >
                  edit
                    </a>
                </span>
     <script>
//         jQuery("#${modalId} a").gSimpleModal({theme : "osx"});
      </script>
"""

    }





    def fileCount = { attrs ->
        def count = 0
        out << "" //<span style='color: darkorange; padding: 5px; font-weight: bolder;'>" + attrs.folder + '</span>'
        try {
            if (attrs.ext != '*') {
                attrs.ext.split(',').each() { ext ->
                    count = 0
                    new File(attrs.folder).eachFileRecurse { f ->
                        if (f.name.toLowerCase().matches(~/^[\s\S]*.${ext}/))
                            count++
                    }
                    out << "<b>" + count + "</b>  <i>" + ext + "</i> &nbsp;&nbsp;"
                }
            }
            else {
                count = 0
                if (attrs.folder && new File(attrs.folder).exists()){
                new File(attrs.folder).eachFileRecurse { f ->
                    count++
                }
                }
                out << count
            }
        } catch (Exception e) {
            print 'Problem ' + e
            out << '?'
        }
        out << '<br/>'
    }


    static final def BYTE = 1D
    static final def KILO_BYTE = 1024D
    static final def MEGA_BYTE = 1048576D
    static final def GIGA_BYTE = 1073741824D
    static final def TERA_BYTE = 1099511627776D
    static final def PETA_BYTE = 1125899906842624D
    static final def EXA_BYTE = 1152921504606846976D
    static final def ZETTA_BYTE = 1180591620717411303424D
    static final def YOTTA_BYTE = 1208925819614629174706176D

    def prettySize = { attrs ->
        def size = attrs.remove('size') as double
        def abbr = Boolean.valueOf(attrs.remove('abbr'))
        def formatter = attrs.remove('format')
        if (formatter) formatter = new DecimalFormat(formatter)

        if (!size || size < 0) {
            outMsg('prettysize.byte', 0, abbr, formatter)
        } else if (size >= YOTTA_BYTE) {
            outMsg('prettysize.yotta.byte', size.div(YOTTA_BYTE), abbr, formatter)
        } else if (size >= ZETTA_BYTE) {
            outMsg('prettysize.zetta.byte', size.div(ZETTA_BYTE), abbr, formatter)
        } else if (size >= EXA_BYTE) {
            outMsg('prettysize.exa.byte', size.div(EXA_BYTE), abbr, formatter)
        } else if (size >= PETA_BYTE) {
            outMsg('prettysize.peta.byte', size.div(PETA_BYTE), abbr, formatter)
        } else if (size >= TERA_BYTE) {
            outMsg('prettysize.tera.byte', size.div(TERA_BYTE), abbr, formatter)
        } else if (size >= GIGA_BYTE) {
            outMsg('prettysize.giga.byte', size.div(GIGA_BYTE), abbr, formatter)
        } else if (size >= MEGA_BYTE) {
            outMsg('prettysize.mega.byte', size.div(MEGA_BYTE), abbr, formatter)
        } else if (size >= KILO_BYTE) {
            outMsg('prettysize.kilo.byte', size.div(KILO_BYTE), abbr, formatter)
        } else {
            outMsg('prettysize.byte', size, abbr, formatter)
        }
    }

    String prettySizeMethod(size) {
        def abbr = true
        def formatter = new DecimalFormat("#,###.#")

        if (!size || size < 0) {
            outMsgMethod('prettysize.byte', 0, abbr, formatter)
        } else if (size >= YOTTA_BYTE) {
            outMsgMethod('prettysize.yotta.byte', size.div(YOTTA_BYTE), abbr, formatter)
        } else if (size >= ZETTA_BYTE) {
            outMsgMethod('prettysize.zetta.byte', size.div(ZETTA_BYTE), abbr, formatter)
        } else if (size >= EXA_BYTE) {
            outMsgMethod('prettysize.exa.byte', size.div(EXA_BYTE), abbr, formatter)
        } else if (size >= PETA_BYTE) {
            outMsgMethod('prettysize.peta.byte', size.div(PETA_BYTE), abbr, formatter)
        } else if (size >= TERA_BYTE) {
            outMsgMethod('prettysize.tera.byte', size.div(TERA_BYTE), abbr, formatter)
        } else if (size >= GIGA_BYTE) {
            outMsgMethod('prettysize.giga.byte', size.div(GIGA_BYTE), abbr, formatter)
        } else if (size >= MEGA_BYTE) {
            outMsgMethod('prettysize.mega.byte', size.div(MEGA_BYTE), abbr, formatter)
        } else if (size >= KILO_BYTE) {
            outMsgMethod('prettysize.kilo.byte', size.div(KILO_BYTE), abbr, formatter)
        } else {
            outMsgMethod('prettysize.byte', size, abbr, formatter)
        }
    }

    String outMsgMethod(code, units, abbr, formatter) {
        if (units <= 0) {
            return (message(code: 'prettysize.none'))
        } else {
            def sb = new StringBuilder(code)
            if (units > 1) sb << 's'
            if (abbr) sb << '.short'
            if (formatter) units = formatter.format(units)
            return (message(code: sb.toString(), args: [units]))
        }
    }

    def outMsg(code, units, abbr, formatter) {
        if (units <= 0) {
            out << message(code: 'prettysize.none')
        } else {
            def sb = new StringBuilder(code)
            if (units > 1) sb << 's'
            if (abbr) sb << '.short'
            if (formatter) units = formatter.format(units)
            out << message(code: sb.toString(), args: [units])
        }
    }

}