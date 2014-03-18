/**
 * @license almond 0.2.9 Copyright (c) 2011-2014, The Dojo Foundation All Rights Reserved.
 * Available via the MIT or new BSD license.
 * see: http://github.com/jrburke/almond for details
 */

/*!
 * Tiny Scrollbar 1.66
 * http://www.baijs.nl/tinyscrollbar/
 *
 * Copyright 2010, Maarten Baijs
 * Dual licensed under the MIT or GPL Version 2 licenses.
 * http://www.opensource.org/licenses/mit-license.php
 * http://www.opensource.org/licenses/gpl-2.0.php
 *
 * Date: 13 / 11 / 2011
 * Depends on library: jQuery
 * 
 */

(function(window){var requirejs,require,define;(function(e){function h(e,t){return f.call(e,t)}function p(e,t){var n,r,i,s,o,a,f,l,h,p,d,v=t&&t.split("/"),m=u.map,g=m&&m["*"]||{};if(e&&e.charAt(0)===".")if(t){v=v.slice(0,v.length-1),e=e.split("/"),o=e.length-1,u.nodeIdCompat&&c.test(e[o])&&(e[o]=e[o].replace(c,"")),e=v.concat(e);for(h=0;h<e.length;h+=1){d=e[h];if(d===".")e.splice(h,1),h-=1;else if(d===".."){if(h===1&&(e[2]===".."||e[0]===".."))break;h>0&&(e.splice(h-1,2),h-=2)}}e=e.join("/")}else e.indexOf("./")===0&&(e=e.substring(2));if((v||g)&&m){n=e.split("/");for(h=n.length;h>0;h-=1){r=n.slice(0,h).join("/");if(v)for(p=v.length;p>0;p-=1){i=m[v.slice(0,p).join("/")];if(i){i=i[r];if(i){s=i,a=h;break}}}if(s)break;!f&&g&&g[r]&&(f=g[r],l=h)}!s&&f&&(s=f,a=l),s&&(n.splice(0,a,s),e=n.join("/"))}return e}function d(t,r){return function(){return n.apply(e,l.call(arguments,0).concat([t,r]))}}function v(e){return function(t){return p(t,e)}}function m(e){return function(t){s[e]=t}}function g(n){if(h(o,n)){var r=o[n];delete o[n],a[n]=!0,t.apply(e,r)}if(!h(s,n)&&!h(a,n))throw new Error("No "+n);return s[n]}function y(e){var t,n=e?e.indexOf("!"):-1;return n>-1&&(t=e.substring(0,n),e=e.substring(n+1,e.length)),[t,e]}function b(e){return function(){return u&&u.config&&u.config[e]||{}}}var t,n,r,i,s={},o={},u={},a={},f=Object.prototype.hasOwnProperty,l=[].slice,c=/\.js$/;r=function(e,t){var n,r=y(e),i=r[0];return e=r[1],i&&(i=p(i,t),n=g(i)),i?n&&n.normalize?e=n.normalize(e,v(t)):e=p(e,t):(e=p(e,t),r=y(e),i=r[0],e=r[1],i&&(n=g(i))),{f:i?i+"!"+e:e,n:e,pr:i,p:n}},i={require:function(e){return d(e)},exports:function(e){var t=s[e];return typeof t!="undefined"?t:s[e]={}},module:function(e){return{id:e,uri:"",exports:s[e],config:b(e)}}},t=function(t,n,u,f){var l,c,p,v,y,b=[],w=typeof u,E;f=f||t;if(w==="undefined"||w==="function"){n=!n.length&&u.length?["require","exports","module"]:n;for(y=0;y<n.length;y+=1){v=r(n[y],f),c=v.f;if(c==="require")b[y]=i.require(t);else if(c==="exports")b[y]=i.exports(t),E=!0;else if(c==="module")l=b[y]=i.module(t);else if(h(s,c)||h(o,c)||h(a,c))b[y]=g(c);else{if(!v.p)throw new Error(t+" missing "+c);v.p.load(v.n,d(f,!0),m(c),{}),b[y]=s[c]}}p=u?u.apply(s[t],b):undefined;if(t)if(l&&l.exports!==e&&l.exports!==s[t])s[t]=l.exports;else if(p!==e||!E)s[t]=p}else t&&(s[t]=u)},requirejs=require=n=function(s,o,a,f,l){if(typeof s=="string")return i[s]?i[s](o):g(r(s,o).f);if(!s.splice){u=s,u.deps&&n(u.deps,u.callback);if(!o)return;o.splice?(s=o,o=a,a=null):s=e}return o=o||function(){},typeof a=="function"&&(a=f,f=l),f?t(e,s,o,a):setTimeout(function(){t(e,s,o,a)},4),n},n.config=function(e){return n(e)},requirejs._defined=s,define=function(e,t,n){t.splice||(n=t,t=[]),!h(s,e)&&!h(o,e)&&(o[e]=[e,t,n])},define.amd={jQuery:!0}})(),define("../../node_modules/almond/almond",function(){}),define("jquery",[],function(){return window.jQuery}),define("DateTime",["require","jquery"],function(e){function n(e,t,r,i,s,o){function u(e,t,n,r,i,s){r=r||0,i=i||0,s=s||0;var o=new Date(e,t-1,n,r,i,s,0);if(o.toString()==="Invalid Date"||t!==o.getMonth()+1||e!==o.getFullYear()||n!==o.getDate()||r!==o.getHours()||i!==o.getMinutes()||s!==o.getSeconds())throw Error("Invalid Date: "+e+"-"+t+"-"+n+" "+r+":"+i+":"+s);return o}if(arguments.length===0)this.date=new Date;else if(e instanceof Date)this.date=new Date(e.getTime());else if(e instanceof n)this.date=new Date(e.date.getTime());else if(typeof e=="string")this.date=new Date(e);else{if(typeof e!="number")throw Error("None of supported parameters was used for constructor: "+Array.prototype.slice.call(arguments).join(", "));this.date=u(+e,+t,+r,+i,+s,+o)}}function r(e){var t=e.split("-");return{year:+t[0],month:+t[1],day:+t[2]}}function i(e){if(e){var t=e.split(":");return{hours:+t[0],minutes:+t[1],seconds:+t[2]||0}}return{hours:0,minutes:0}}var t=e("jquery");return n.SUNDAY=0,n.MONDAY=1,n.TUESDAY=2,n.WEDNESDAY=3,n.THURSDAY=4,n.FRIDAY=5,n.SATURDAY=6,n.daysInMonth=[31,28,31,30,31,30,31,31,30,31,30,31],n.y2kYear=50,n.monthNumbers={Jan:0,Feb:1,Mar:2,Apr:3,May:4,Jun:5,Jul:6,Aug:7,Sep:8,Oct:9,Nov:10,Dec:11},n.fromDateTime=function(e,t,r,i,s){return new n(e,t,r,i,s)},n.fromDate=function(e,t,r){return n.fromDateTime(e,t,r,0,0)},n.fromDateObject=function(e){return n.fromMillis(e.getTime())},n.fromIsoDate=function(e){var t=/^\d{4}-[01]\d-[0-3]\d(T[0-2]\d:[0-5]\d([+-][0-2]\d:[0-5]\d|Z?))?$/;if(!t.test(e))throw Error(e+" is not valid ISO Date (YYYY-MM-DD or YYYY-MM-DDTHH:MM)");var i=r(e.split("T")[0]);return n.fromDate(i.year,i.month,i.day)},n.fromIsoDateTime=function(e){var t=/\d{4}-[01]\d-[0-3]\dT[0-2]\d:[0-5]\d([+-][0-2]\d:[0-5]\d|Z?)/;if(!t.test(e))throw Error(e+" is not valid ISO Date (YYYY-MM-DDTHH:MM)");var s=e.split("T"),o=i(s.length===2&&s[1]),u=r(s[0]);return new n(u.year,u.month,u.day,o.hours,o.minutes,o.seconds)},n.fromMillis=function(e){return new n(new Date(e))},t.each(["getTime","getFullYear","getDate","getDay","getHours","getMinutes","getSeconds","getMilliseconds"],function(e,t){n.prototype[t]=function(){return this.date[t]()}}),n.prototype.withResetMS=function(){var e=this.clone();return e.date.setMilliseconds(0),e},n.prototype.withTime=function(e,t){if(typeof e=="string"){var n=e.split(":");e=n[0],t=n[1]}var r=this.clone();return r.date.setHours(e),r.date.setMinutes(t),r.date.setSeconds(0),r.date.setMilliseconds(0),r},n.SECOND=1e3,n.MINUTE=60*n.SECOND,n.HOUR=60*n.MINUTE,n.DAY=24*n.HOUR,n.WEEK=7*n.DAY,n.now=function(){return typeof n._now=="undefined"&&(n._now=new n),n._now},n.today=function(){return typeof n._today=="undefined"&&(n._today=(new n).getOnlyDate()),n._today},n.getDaysInMonth=function(e,t){if(t>12||t<1)throw new Error("Month must be between 1-12");var r=e*12+t;return n.fromDate(Math.floor(r/12),r%12+1,1).minusDays(1).getDate()},n.getDayInYear=function(e,t,r){return n.fromDate(e,1,1).distanceInDays(n.fromDate(e,t,r))+1},n.prototype.getDaysInMonth=function(){return n.getDaysInMonth(this.getFullYear(),this.getMonth())},n.prototype.getDayInYear=function(){return n.getDayInYear(this.getFullYear(),this.getMonth(),this.getDate())},n.prototype.plusDays=function(e){var t=this.clone(),r=this.getHours();t.date.setTime(this.getTime()+e*n.DAY);var i=r-t.getHours();return i!==0&&(i>12&&(i-=24),i<-12&&(i+=24),t.date.setTime(t.getTime()+i*n.HOUR)),t},n.prototype.minusDays=function(e){return this.plusDays(-e)},n.prototype.compareTo=function(e){if(!e)return 1;var t=this.getTime(),n=e.getTime();return t<n?-1:t>n?1:0},n.prototype.isToday=function(){return this.equalsOnlyDate(n.today())},n.prototype.getWeekInYear=function(e){if(e!=="US"&&e!=="ISO")throw"Week numbering system must be either US or ISO, was "+e;var t=(new Date(this.getFullYear(),0,1)).getDay();if(e==="US")return Math.ceil((this.getDayInYear()+t)/7);var r=4,i=this.getDay();i===0&&(i=7),t===0&&(t=7);if(this.getMonth()===12&&this.getDate()>=29&&this.getDate()-i>27)return 1;if(this.getMonth()===1&&this.getDate()<4&&i>r)return(new n(new Date(this.getFullYear()-1,11,31))).getWeekInYear("ISO");var s=Math.ceil((this.getDayInYear()+t-1)/7);return t>r&&s--,s},n.prototype.clone=function(){return new n(this.date)},n.prototype.isOddMonth=function(){return this.getMonth()%2===0},n.prototype.equalsOnlyDate=function(e){return e?this.getMonth()===e.getMonth()&&this.getDate()===e.getDate()&&this.getFullYear()===e.getFullYear():!1},n.prototype.isBetweenDates=function(e,t){if(e.getTime()>t.getTime())throw Error("start date can't be after end date");var n=this.getOnlyDate();return n.compareTo(e.getOnlyDate())>=0&&n.compareTo(t.getOnlyDate())<=0},n.prototype.firstDateOfMonth=function(){return n.fromDate(this.getFullYear(),this.getMonth(),1)},n.prototype.lastDateOfMonth=function(){return n.fromDate(this.getFullYear(),this.getMonth(),this.getDaysInMonth())},n.prototype.distanceInDays=function(e){var t=parseInt(this.getTime()/n.DAY,10),r=parseInt(e.getTime()/n.DAY,10);return r-t},n.prototype.withWeekday=function(e){return this.plusDays(e-this.getDay())},n.prototype.getOnlyDate=function(){return n.fromDate(this.getFullYear(),this.getMonth(),this.getDate())},n.prototype.isWeekend=function(){return this.getDay()===6||this.getDay()===0},n.prototype.toString=function(){return this.toISOString()},n.prototype.getFirstDateOfWeek=function(e){var t=e?e.firstWeekday:n.MONDAY;return t<this.getDay()?this.plusDays(t-this.getDay()):t>this.getDay()?this.plusDays(t-this.getDay()-7):this.clone()},n.prototype.toISOString=function(){function e(e){return e<10?"0"+e:""+e}return t.map([this.getFullYear(),this.getMonth(),this.getDate()],e).join("-")+"T"+t.map([this.getHours(),this.getMinutes(),this.getSeconds()],e).join(":")},n.prototype.getMonth=function(){return this.date.getMonth()+1},n}),define("DateFormat",["require","./DateTime"],function(require){var DateTime=require("./DateTime"),DateFormat={};return DateFormat.formatFunctions={count:0},DateFormat.hoursAndMinutes=function(e,t){return(Math.round((e+t/60)*100)/100).toString()},DateFormat.format=function(e,t,n){DateFormat.formatFunctions[t]===undefined&&DateFormat.createNewFormat(e,t,n);var r=DateFormat.formatFunctions[t];return e[r]()},DateFormat.shortDateFormat=function(e,t){return DateFormat.format(e,t?t.shortDateFormat:"n/j/Y",t)},DateFormat.formatRange=function(e,t){return e._hasTimes?t.daysLabel(e.days())+" "+t.hoursLabel(e.hours(),e.minutes()):DateFormat.shortDateFormat(e.start,t)+" - "+DateFormat.shortDateFormat(e.end,t)},DateFormat.formatDefiningRangeDuration=function(e,t){var n=parseInt(e.days()/360,10);if(n>0)return t.yearsLabel(n);var r=parseInt(e.days()/30,10);return r>0?t.monthsLabel(r):t.daysLabel(e.days())},DateFormat.getGMTOffset=function(e){return(e.date.getTimezoneOffset()>0?"-":"+")+DateFormat.leftPad(Math.floor(e.getTimezoneOffset()/60),2,"0")+DateFormat.leftPad(e.getTimezoneOffset()%60,2,"0")},DateFormat.leftPad=function(e,t,n){var r=String(e);n===null&&(n=" ");while(r.length<t)r=n+r;return r},DateFormat.escape=function(e){return e.replace(/('|\\)/g,"\\$1")},DateFormat.patterns={ISO8601LongPattern:"Y-m-d H:i:s",ISO8601ShortPattern:"Y-m-d",ShortDatePattern:"n/j/Y",FiShortDatePattern:"j.n.Y",FiWeekdayDatePattern:"D j.n.Y",FiWeekdayDateTimePattern:"D j.n.Y k\\lo G:i",LongDatePattern:"l, F d, Y",FullDateTimePattern:"l, F d, Y g:i:s A",MonthDayPattern:"F d",ShortTimePattern:"g:i A",LongTimePattern:"g:i:s A",SortableDateTimePattern:"Y-m-d\\TH:i:s",UniversalSortableDateTimePattern:"Y-m-d H:i:sO",YearMonthPattern:"F, Y"},DateFormat.createNewFormat=function(dateTime,format,locale){var funcName="format"+DateFormat.formatFunctions.count++;DateFormat.formatFunctions[format]=funcName;var code="DateTime.prototype."+funcName+" = function(){return ",special=!1,ch="";for(var i=0;i<format.length;++i)ch=format.charAt(i),!special&&ch==="\\"?special=!0:special?(special=!1,code+="'"+DateFormat.escape(ch)+"' + "):code+=DateFormat.getFormatCode(ch,locale);eval(code.substring(0,code.length-3)+";}")},DateFormat.getFormatCode=function(e){var t={d:"DateFormat.leftPad(this.getDate(), 2, '0') + ",D:"locale.shortDayNames[this.getDay()] + ",j:"this.getDate() + ",l:"locale.dayNames[this.getDay()] + ",w:"this.getDay() + ",z:"this.getDayInYear() + ",F:"locale.monthNames[this.getMonth()-1] + ",m:"DateFormat.leftPad(this.getMonth(), 2, '0') +",M:"locale.monthNames[this.getMonth()-1].substring(0, 3) + ",n:"(this.getMonth()) + ",t:"this.getDaysInMonth() + ",Y:"this.getFullYear() + ",y:"('' + this.getFullYear()).substring(2, 4) + ",a:"(this.getHours() < 12 ? 'am' : 'pm') + ",A:"(this.getHours() < 12 ? 'AM' : 'PM') + ",g:"((this.getHours() %12) ? this.getHours() % 12 : 12) + ",G:"this.getHours() + ",h:"DateFormat.leftPad((this.getHours() %12) ? this.getHours() % 12 : 12, 2, '0') + ",H:"DateFormat.leftPad(this.getHours(), 2, '0') + ",i:"DateFormat.leftPad(this.getMinutes(), 2, '0') + ",s:"DateFormat.leftPad(this.getSeconds(), 2, '0') + ",O:"DateFormat.getGMTOffset(this) + ",Z:"(this.getTimezoneOffset() * -60) + "};return e in t?t[e]:"'"+DateFormat.escape(e)+"' + "},DateFormat}),define("DateParse",["require","./DateTime"],function(e){var t=e("./DateTime"),n={};return n.parseRegexes=[],n.defaultFormat="n/j/Y",n.parse=function(e,r){if(e==="today")return t.today();var i=r?r.shortDateFormat:n.defaultFormat,s=n.parseDate(e,i);return s?s:new t(e)},n.parseDate=function(e,r){function s(e){var n=o(e);return new t(n.Y,n.m?n.m:n.n,n.d?n.d:n.j)}function o(e){var t={},n=r.replace(/[^djmnY]/g,"").split("");return n.map(function(n,r){t[n]=+e[r+1]}),t}function u(){return n.parseRegexes[r]===undefined&&(n.parseRegexes[r]=new RegExp(r.replace(/[djmnY]/g,"(\\d+)").replace(/\./g,"\\."))),n.parseRegexes[r]}var i=e.match(u());return i?s(i):null},n.parseTime=function(e){function r(e){if(e.indexOf(".")!==-1)return e.split(".");var t={4:[e.slice(0,2),e.slice(2,4)],3:[e.slice(0,1),e.slice(1,3)],2:[e,0]};return t[e.length]||[-1,-1]}function i(e){return!isNaN(e)&&e>=0&&e<=59}function s(e){return!isNaN(e)&&e>=0&&e<=23}var t=r(e.replace(/:|,/i,".")),n=[+t[0],+t[1]];return s(n[0])&&i(n[1])?n:null},n}),define("locale/FI",["require","../DateTime","../DateFormat"],function(e){var t=e("../DateTime"),n=e("../DateFormat");return{id:"FI",monthNames:["tammikuu","helmikuu","maaliskuu","huhtikuu","toukokuu","kesäkuu","heinäkuu","elokuu","syyskuu","lokakuu","marraskuu","joulukuu"],dayNames:["sunnuntai","maanantai","tiistai","keskiviikko","torstai","perjantai","lauantai"],shortDayNames:["su","ma","ti","ke","to","pe","la"],yearsLabel:function(e){return e+" "+(e===1?"vuosi":"vuotta")},monthsLabel:function(e){return e+" "+(e===1?"kuukausi":"kuukautta")},daysLabel:function(e){return e+" "+(e===1?"päivä":"päivää")},hoursLabel:function(e,t){var r=n.hoursAndMinutes(e,t).replace(".",",");return r+" "+(+r===1?"tunti":"tuntia")},clearRangeLabel:"Poista valinta",clearDateLabel:"Poista valinta",shortDateFormat:"j.n.Y",weekDateFormat:"D j.n.Y",dateTimeFormat:"D j.n.Y k\\lo G:i",firstWeekday:t.MONDAY}}),define("locale/EN",["require","../DateTime","../DateFormat"],function(e){var t=e("../DateTime"),n=e("../DateFormat");return{id:"EN",monthNames:["January","February","March","April","May","June","July","August","September","October","November","December"],dayNames:["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"],shortDayNames:["Su","Mo","Tu","We","Th","Fr","Sa"],yearsLabel:function(e){return e+" "+(e===1?"Year":"Years")},monthsLabel:function(e){return e+" "+(e===1?"Months":"Months")},daysLabel:function(e){return e+" "+(e===1?"Day":"Days")},hoursLabel:function(e,t){var r=n.hoursAndMinutes(e,t);return r+" "+(+r===1?"Hour":"Hours")},clearRangeLabel:"Clear Range",clearDateLabel:"Clear Date",shortDateFormat:"n/j/Y",weekDateFormat:"D n/j/Y",dateTimeFormat:"D n/j/Y G:i",firstWeekday:t.SUNDAY}}),define("locale/AU",["require","../DateTime","../DateFormat"],function(e){var t=e("../DateTime"),n=e("../DateFormat");return{id:"AU",monthNames:["January","February","March","April","May","June","July","August","September","October","November","December"],dayNames:["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"],shortDayNames:["Su","Mo","Tu","We","Th","Fr","Sa"],yearsLabel:function(e){return e+" "+(e===1?"Year":"Years")},monthsLabel:function(e){return e+" "+(e===1?"Months":"Months")},daysLabel:function(e){return e+" "+(e===1?"Day":"Days")},hoursLabel:function(e,t){var r=n.hoursAndMinutes(e,t);return r+" "+(+r===1?"Hour":"Hours")},clearRangeLabel:"Clear Range",clearDateLabel:"Clear Date",shortDateFormat:"j/n/Y",weekDateFormat:"D j/n/Y",dateTimeFormat:"D j/n/Y G:i",firstWeekday:t.SUNDAY}}),define("locale/ET",["require","../DateTime","../DateFormat"],function(e){var t=e("../DateTime"),n=e("../DateFormat");return{id:"ET",monthNames:["Jaanuar","Veebruar","Märts","Aprill","Mai","Juuni","Juuli","August","September","Oktoober","November","Detsember"],dayNames:["Pühapäev","Esmaspäev","Teisipäev","Kolmapäev","Neljapäev","Reede","Laupäev"],shortDayNames:["P","E","T","K","N","R","L"],yearsLabel:function(e){return e+" "+(e===1?"Aasta":"Aastat")},monthsLabel:function(e){return e+" "+(e===1?"Kuu":"Kuud")},daysLabel:function(e){return e+" "+(e===1?"Päev":"Päeva")},hoursLabel:function(e,t){var r=n.hoursAndMinutes(e,t).replace(".",",");return r+" "+(+r===1?"Tund":"Tundi")},clearRangeLabel:"TODO",clearDateLabel:"TODO",shortDateFormat:"j.n.Y",weekDateFormat:"D j.n.Y",dateTimeFormat:"D j.n.Y k\\l G:i",firstWeekday:t.MONDAY}}),define("locale/RU",["require","../DateTime","../DateFormat"],function(e){function r(e,t){var n=e%100,r="";if(n>10&&n<20||e===0)r=t[2];else switch(Math.abs(e%10)){case 1:r=t[0];break;case 2:case 3:case 4:r=t[1];break;default:r=t[2]}return[e,r].join(" ")}var t=e("../DateTime"),n=e("../DateFormat");return{id:"RU",monthNames:["Январь","Февраль","Март","Апрель","Май","Июнь","Июль","Август","Сентябрь","Октябрь","Ноябрь","Декабрь"],dayNames:["Воскресенье","Понедельник","Вторник","Среда","Четверг","Пятница","Суббота"],shortDayNames:["Вс","Пн","Вт","Ср","Чт","Пт","Сб"],yearsLabel:function(e){return r(e,["Год","Года","Лет"])},monthsLabel:function(e){return r(e,["Месяц","Месяца","Месяцев"])},daysLabel:function(e){return r(e,["День","Дня","Дней"])},hoursLabel:function(e,t){var r=n.hoursAndMinutes(e,t).replace(".",",");return r+" Часа"},clearRangeLabel:"Очистить диапазон",clearDateLabel:"Очистить дату",shortDateFormat:"j.n.Y",weekDateFormat:"D j.n.Y",dateTimeFormat:"D j.n.Y k\\lo G:i",firstWeekday:t.MONDAY}}),define("locale/SV",["require","../DateTime","../DateFormat"],function(e){var t=e("../DateTime"),n=e("../DateFormat");return{id:"SV",monthNames:["Januari","Februari","Mars","April","Maj","Juni","Juli","Augusti","September","Oktober","November","December"],dayNames:["Söndag","Måndag","Tisdag","Onsdag","Torsdag","Fredag","Lördag"],shortDayNames:["Sö","Må","Ti","On","To","Fr","Lö"],yearsLabel:function(e){return e+" "+(e===1?"År":"År")},monthsLabel:function(e){return e+" "+(e===1?"Månad":"Månader")},daysLabel:function(e){return e+" "+(e===1?"Dag":"Dagar")},hoursLabel:function(e,t){var r=n.hoursAndMinutes(e,t).replace(".",",");return r+" "+(+r===1?"Minut":"Minuter")},clearRangeLabel:"TODO",clearDateLabel:"TODO",shortDateFormat:"j.n.Y",weekDateFormat:"D j.n.Y",dateTimeFormat:"D j.n.Y k\\lo G:i",firstWeekday:t.MONDAY}}),define("locale/LV",["require","../DateTime","../DateFormat"],function(e){var t=e("../DateTime"),n=e("../DateFormat");return{id:"LV",monthNames:["Janvāris","Februāris","Marts","Aprīlis","Maijs","Jūnijs"," Jūlijs","Augusts","Septembris","Oktobris","Novembris","Decembris"],dayNames:["Svētdiena","Pirmdiena","Otrdiena","Trešdiena","Ceturtdiena","Piektdiena","Sestdiena"],shortDayNames:["Sv","P","O","T","C","Pk","S"],yearsLabel:function(e){return e+" "+(e===1?"G":"G")},monthsLabel:function(e){return e+" "+(e===1?"Mēnesī":"Mēnešiem")},daysLabel:function(e){return e+" "+(e===1?"Diena":"Dienas")},hoursLabel:function(e,t){var r=n.hoursAndMinutes(e,t);return r+" "+(+r===1?"Stundas":"Minūtes")},clearRangeLabel:"TODO",clearDateLabel:"TODO",shortDateFormat:"j.n.Y",weekDateFormat:"D j.n.Y",dateTimeFormat:"D j.n.Y k\\lo G:i",firstWeekday:t.MONDAY}}),define("DateLocale",["require","./locale/FI","./locale/EN","./locale/AU","./locale/ET","./locale/RU","./locale/SV","./locale/LV"],function(e){var t=e("./locale/FI"),n=e("./locale/EN"),r=e("./locale/AU"),i=e("./locale/ET"),s=e("./locale/RU"),o=e("./locale/SV"),u=e("./locale/LV"),a={FI:t,EN:n,AU:r,ET:i,RU:s,SV:o,LV:u};return a.fromArgument=function(e){return typeof e=="string"?a[e.toUpperCase()]:e},a}),define("DateRange",["require","jquery","./DateTime","./DateFormat","./DateParse"],function(e){function s(e,t){if(!e||!t)throw"two dates must be specified, date1="+e+", date2="+t;this.start=e.compareTo(t)>0?t:e,this.end=e.compareTo(t)>0?e:t,this._days=0,this._hours=0,this._minutes=0,this._valid=!0}var t=e("jquery"),n=e("./DateTime"),r=e("./DateFormat"),i=e("./DateParse");return s.emptyRange=function(){function e(){this.start=null,this.end=null,this.days=function(){return 0},this.shiftDays=t.noop,this.hasDate=function(){return!1},this.clone=function(){return s.emptyRange()},this.expandDaysTo=function(){return this},this.hasEndsOnWeekend=function(){return!1},this.isPermittedRange=function(){return!0},this.hasSelection=function(){return!1}}return new e},s.rangeWithMinimumSize=function(e,t,n,r){function u(){return t&&e.days()<=t}function a(e){return-((e+1)%7+1)}if(u()){var i=e.expandDaysTo(t);if(n&&i.hasEndsOnWeekend()){var o=i.shiftDays(a(i.end.getDay())).shiftInside(r);while(!o.isPermittedRange(t,n,r)||o.end.compareTo(r.end)>0){if(!o.isPermittedRange(t,!1,r))return s.emptyRange();o=o.shiftDays(1)}i=o}return i.isPermittedRange(t,!1,r)?i:s.emptyRange()}return e},s.prototype._setDaysHoursAndMinutes=function(){if(this._hasTimes){var e=parseInt(this.end.getTime()-this.start.getTime(),10);this._days=parseInt(e/n.DAY,10),e-=this._days*n.DAY,this._hours=parseInt(e/n.HOUR,10),e-=this._hours*n.HOUR,this._minutes=parseInt(e/n.MINUTE,10)}},s.prototype._dateWithTime=function(e,t){return e.withTime(t[0],t[1])},s.prototype.hours=function(){return this._hours},s.prototype.minutes=function(){return this._minutes},s.prototype.hasDate=function(e){return e.isBetweenDates(this.start,this.end)},s.prototype.isValid=function(){return this._valid&&this.end.getTime()-this.start.getTime()>=0},s.prototype.days=function(){return this._hasTimes?this._days:Math.round(this.start.distanceInDays(this.end)+1)},s.prototype.shiftDays=function(e){return new s(this.start.plusDays(e),this.end.plusDays(e))},s.prototype.expandTo=function(e){var t=this.start.clone(),n=this.end.clone();return e.compareTo(this.start)<0?t=e:e.compareTo(this.end)>0&&(n=e),new s(t,n)},s.prototype.expandDaysTo=function(e){return new s(this.start,this.start.plusDays(e-1))},s.prototype.hasValidSize=function(e){return e<0||this.days()>=e},s.prototype.hasValidSizeAndEndsOnWorkWeek=function(e){return this.hasValidSize(e)&&this.hasEndsOnWeekend()},s.prototype.and=function(e){var t=this.start.compareTo(e.start)>0?this.start:e.start,n=this.end.compareTo(e.end)>0?e.end:this.end;return t.compareTo(n)<0?new s(t,n):s.emptyRange()},s.prototype.isInside=function(e){return this.start.compareTo(e.start)>=0&&this.end.compareTo(e.end)<=0},s.prototype.hasEndsOnWeekend=function(){return this.start.isWeekend()||this.end.isWeekend()},s.prototype.withTimes=function(e,t){var n=i.parseTime(e),r=i.parseTime(t),s=this.clone();return n&&r?(s._valid=!0,s._hasTimes=!0,s.start=this._dateWithTime(this.start,n),s.end=this._dateWithTime(this.end,r),s._setDaysHoursAndMinutes()):s._valid=!1,s},s.prototype.clone=function(){return new s(this.start,this.end)},s.prototype.toString=function(){return["DateRange:",this.start.toString(),"-",this.end.toString(),this._days,"days",this._hours,"hours",this._minutes,"minutes",this._valid?"valid":"invalid"].join(" ")},s.prototype.isPermittedRange=function(e,t,n){return this.hasValidSize(e)&&(!t||!this.hasEndsOnWeekend())&&this.isInside(n)},s.prototype.shiftInside=function(e){if(this.days()>e.days())return s.emptyRange();var t=this.start.distanceInDays(e.start),n=this.end.distanceInDays(e.end);return t>0?this.shiftDays(t):n<0?this.shiftDays(n):this},s.prototype.hasSelection=function(){return this.days()>0},s}),define("CalendarBody",["require","jquery","./DateFormat","./DateTime"],function(e){var t=e("jquery"),n=e("./DateFormat"),r=e("./DateTime");return function(e,i,s,o,u,a){function m(){var e=t('<tr><th class="month"></th><th class="week">&nbsp;</th>');return t(s.dayNames).each(function(n){var r=t("<th>").append(s.shortDayNames[(n+s.firstWeekday)%7]).addClass("weekDay");e.append(r)}),t("<thead>").append(e)}function g(e){var t=n.format(r.today(),"Ymd",s);t in e&&T(e[t]).addClass("today").wrapInner("<div>")}function y(){function o(e,t,n){e.push("<tr>"),e.push(a(t,n)),e.push(c(t));for(var r=0;r<7;r++){var i=t.plusDays(r);e.push(u(i))}e.push("</tr>")}function u(e){var t='<td class="'+b(e)+'" date-cell-index="'+l.length+'">'+e.getDate()+"</td>";return f[n.format(e,"Ymd",s)]=l.length,l.push(e),t}function a(e,t){var n='<th class="month '+w(e);return t||e.getDate()<=7?(n+=' monthName">',n+=s.monthNames[e.getMonth()-1]):(n+='">',e.getDate()<=14&&e.getMonth()===1&&(n+=e.getFullYear())),n+"</th>"}function c(e){return'<th class="week '+w(e)+'">'+e.getWeekInYear("ISO")+"</th>"}var e=i.start.getFirstDateOfWeek(s),t=!0,r=[];while(e.compareTo(i.end)<=0)o(r,e.clone(),t),t=!1,e=e.plusDays(7);return"<tbody>"+r.join("")+"</tbody>"}function b(e){return t.trim(["date",w(e),E(e),S(e),x(e)].sort().join(" "))}function w(e){return e.isOddMonth()?"odd":""}function E(e){var t=u&&e.isWeekend(),n=a[e.getOnlyDate().date],r=!i.hasDate(e);return r||t||n?"disabled":""}function S(e){return e.isToday()?"today":""}function x(e){return e.getDay()===0?"holiday":""}function T(e){return t(d[e])}var f={},l=[],c=t('<table class="calendarHeader">').append(m()),h=t('<table class="calendarBody">').append(y()),p=t('<div class="calendarScrollContent">').append(h);e.append(c),o?(h.addClass("overview"),p.addClass("viewport"),e.append(t('<div class="tinyscrollbar"></div>').append('<div class="scrollbar"> <div class="track"> <div class="thumb"> <div class="end"></div> </div> </div> </div>').append(p))):e.append(p);var d=t("td.date",e).get();g(f);var v=t("th.month",c);return{bodyTable:h,scrollContent:p,dateCells:d,yearTitle:v,dateCellMap:f,dateCellDates:l,dateStyles:b,getDateCell:T}}}),define("RangeEvents",["require","jquery","./DateFormat","./DateRange","./DateTime"],function(e){var t=e("jquery"),n=e("./DateFormat"),r=e("./DateRange"),i=e("./DateTime");return function(e,s,o,u,a,f,l,c,h,p,d,v,m,g){function x(){A(),w=b.clone(),O(e,s.bodyTable),I()}function T(e,t){e&&t&&(b=new r(e,t)),B()}function N(){if(t(".rangeLengthLabel",e).isEmpty()){var n=t('<div class="label"><span class="rangeLengthLabel"></span></div>');t(".continuousCalendar",e).append(n)}}function C(e){e.append('<span class="separator"> - </span>').append('<span class="endDateLabel"></span>')}function k(){if(a.allowClearDates){var n=t('<span class="clearDates clickable"></span>').text(u.clearRangeLabel),r=t('<div class="label clearLabel"></div>').append(n);t(".continuousCalendar",e).append(r)}}function L(){e.data("calendarRange",b),o(b)}function A(){b=c&&h?new r(c,h):r.emptyRange(),!b.start&&!b.end&&t("span.separator",e).hide()}function O(e,n){t("span.rangeLengthLabel",e).text(u.daysLabel(b.days())),a.allowClearDates&&t("span.clearDates",e).click(j),n.addClass(a.selectWeek?"weekRange":"freeRange"),n.mousedown(M).mouseover(P).mouseup(B),D(n.get(0))}function M(e){function o(e){return X(e)&&K(e)}function l(e,t){return a.selectWeek?o(e)||V(e):V(e)||J(e)||t}function c(e,n){if(a.selectWeek&&o(e)||V(e)){S=E.NONE;var i=f(t(e).parent().children(".date").get(0));return h(i)}if(J(e)){S=E.NONE;var s=f(t(e).siblings(".date").get(0));return new r(s.firstDateOfMonth(),s.lastDateOfMonth(),u)}return n&&b.days()>0&&o(e)?(S=E.NONE,b=b.expandTo(f(e)),b):b}function h(e){var t=e,n=e.plusDays(6);return a.disableWeekends&&(t=e.withWeekday(i.MONDAY),n=e.withWeekday(i.FRIDAY)),(new r(t,n,u)).and(p)}var n=e.target,s=e.shiftKey;l(n,s)?b=c(n,s):(S=E.CREATE_OR_RESIZE,y=f(n),y.equalsOnlyDate(b.end)?y=b.start:y.equalsOnlyDate(b.start)?y=b.end:b.hasDate(y)?S=E.MOVE:o(n)&&_())}function _(){b=new r(y,y,u)}function D(e){t(e).css("MozUserSelect","none"),t(e).bind("selectstart",function(){return!1}),t(e).mousedown(function(){return!1})}function P(e){if(S!==E.NONE){var t=f(e.target),n={move:function(){var e=y.distanceInDays(t),n=b.shiftDays(e).and(p);H(n)&&(y=t,b=n)},create:function(){var n=new r(y,t,u);K(e.target)&&H(n)&&(b=n)}};t&&n[S](),I()}}function H(e){return e.isPermittedRange(a.minimumRange,a.disableWeekends,p)}function B(){S=E.NONE,F()&&(b=r.emptyRange()),I(),z()}function j(e){b=r.emptyRange(),I(),z()}function F(){for(var e=0;e<g.length;e++)if(b.hasDate(new i(g[e])))return!0;return!1}function I(){b=r.rangeWithMinimumSize(b,a.minimumRange,a.disableWeekends,p),q(b),t("span.rangeLengthLabel",e).text(u.daysLabel(b.days()));var n=t("span.clearDates",e);n.toggle(b.hasSelection())}function q(n){t("td.selected",e).removeClass("selected").removeClass("rangeStart").removeClass("rangeEnd").removeClass("invalidSelection"),R(n),w=n.clone()}function R(r){function f(e){return s.dateCellMap[n.format(e,"Ymd",u)]}if(r.days()>0){var i=f(r.start),o=f(r.end);for(var a=i;a<=o;a++)s.getDateCell(a).get(0).className=U(s.dateCellDates[a],r.start,r.end).join(" ");F()&&t("td.selected",e).addClass("invalidSelection")}}function U(e,t,n){var r=[s.dateStyles(e)];return e.equalsOnlyDate(n)?r.concat("selected rangeEnd"):e.equalsOnlyDate(t)?r.concat("selected rangeStart"):e.isBetweenDates(t,n)?r.concat("selected"):r}function z(){F()&&(b=r.emptyRange(),setTimeout(function(){q(b)},200));var n=m(b.start),i=m(b.end);e.data("calendarRange",b),d(n),v(i),W(),a.selectWeek&&l.close(t("td.selected",e).first()),o(b)}function W(){b||A();if(b.start&&b.end){var r=u.weekDateFormat;t("span.startDateLabel",e).text(n.format(b.start,r,u)),t("span.endDateLabel",e).text(n.format(b.end,r,u)),t("span.separator, span.clearRangeLabel",e).show(),t("span.startDateLabel",e).closest(".label").show()}else b.start||(t("span.startDateLabel",e).empty(),t("span.startDateLabel",e).closest(".label").hide()),b.end||t("span.endDateLabel",e).empty(),t("span.separator, span.clearRangeLabel",e).hide()}function X(e){return t(e).closest("[date-cell-index]").hasClass("date")}function V(e){return t(e).hasClass("week")}function J(e){return t(e).hasClass("month")}function K(e){return!t(e).hasClass("disabled")}var y=null,b,w,E={CREATE_OR_RESIZE:"create",MOVE:"move",NONE:"none"},S=E.NONE;return{showInitialSelection:W,initEvents:x,addRangeLengthLabel:N,addEndDateLabel:C,addDateClearingLabel:k,setSelection:T,performTrigger:L}}}),define("SingleDateEvents",["require","jquery","./DateFormat","./DateParse"],function(e){var t=e("jquery"),n=e("./DateFormat"),r=e("./DateParse");return function(e,i,s,o,u,a,f,l){function c(){l&&(m(l),t(".clearDates",e).show())}function h(){b(),d(p(u.startField)||l)}function p(e){return e.length>0&&e.val().length>0?r.parse(e.val(),o):null}function d(e){var t=e&&n.format(e,"Ymd",o);t in i.dateCellMap&&v(e,i.getDateCell(i.dateCellMap[t]))}function v(n,r){t("td.selected",e).removeClass("selected"),r.addClass("selected"),m(n)}function m(t){e.data("calendarRange",t),u.startField.val(n.shortDateFormat(t,o)),w(n.format(t,o.weekDateFormat,o))}function g(){if(u.allowClearDates){var n=t('<span class="clearDates clickable"></span>').hide();n.text(o.clearDateLabel);var r=t('<div class="label clearLabel"></div>').append(n);t(".continuousCalendar",e).append(r)}}function y(){e.data("calendarRange",l),s(l)}function b(){t(".date",e).bind("click",function(){var e=t(this);if(!e.hasClass("disabled")){var n=a(e.get(0));v(n,e),f.close(this),s(n)}}),t(".clearDates",e).click(E)}function w(n){t("span.startDateLabel",e).text(n),u.allowClearDates&&t(".clearDates",e).toggle(n!=="")}function E(){t("td.selected",e).removeClass("selected"),u.startField.val(""),w("")}return{showInitialSelection:c,initEvents:h,addRangeLengthLabel:t.noop,addEndDateLabel:t.noop,addDateClearingLabel:g,setSelection:d,performTrigger:y}}}),function(e){function t(t,n){function m(){return r.update(),y(),r}function g(){f.obj.css(c,p/u.ratio),o.obj.css(c,-p),v.start=f.obj.offset()[c];var e=h.toLowerCase();u.obj.css(e,a[n.axis]),a.obj.css(e,a[n.axis]),f.obj.css(e,f[n.axis])}function y(){f.obj.bind("mousedown",b),f.obj[0].ontouchstart=function(e){return e.preventDefault(),f.obj.unbind("mousedown"),b(e.touches[0]),!1},a.obj.bind("mouseup",S),n.scroll&&this.addEventListener?(i[0].addEventListener("DOMMouseScroll",w,!1),i[0].addEventListener("mousewheel",w,!1)):n.scroll&&(i[0].onmousewheel=w)}function b(t){v.start=l?t.pageX:t.pageY;var n=parseInt(f.obj.css(c),10);return d.start=n=="auto"?0:n,e(document).bind("mousemove",S),document.ontouchmove=function(t){e(document).unbind("mousemove"),S(t.touches[0])},e(document).bind("mouseup",E),f.obj.bind("mouseup",E),f.obj[0].ontouchend=document.ontouchend=function(t){e(document).unbind("mouseup"),f.obj.unbind("mouseup"),E(t.touches[0])},!1}function w(t){if(!(o.ratio>=1)){i.trigger("scroll"),t=t||window.event;var r=t.wheelDelta?t.wheelDelta/120:-t.detail/3;p-=r*n.wheel,p=Math.min(o[n.axis]-s[n.axis],Math.max(0,p)),f.obj.css(c,p/u.ratio),o.obj.css(c,-p),t=e.event.fix(t),t.preventDefault()}}function E(){return e(document).unbind("mousemove",S),e(document).unbind("mouseup",E),f.obj.unbind("mouseup",E),document.ontouchmove=f.obj[0].ontouchend=document.ontouchend=null,!1}function S(e){return i.trigger("scroll"),o.ratio>=1||(d.now=Math.min(a[n.axis]-f[n.axis],Math.max(0,d.start+((l?e.pageX:e.pageY)-v.start))),p=d.now*u.ratio,o.obj.css(c,-p),f.obj.css(c,d.now)),!1}var r=this,i=t,s={obj:e(".viewport",t)},o={obj:e(".overview",t)},u={obj:e(".scrollbar",t)},a={obj:e(".track",u.obj)},f={obj:e(".thumb",u.obj)},l=n.axis=="x",c=l?"left":"top",h=l?"Width":"Height",p,d={start:0,now:0},v={};return this.update=function(e){var t=n.axis;s[t]=s.obj[0]["offset"+h],o[t]=o.obj[0]["scroll"+h];var r=o[t],i=s[t];o.ratio=i/r,u.obj.toggleClass("disable",o.ratio>=1),a[t]=n.size=="auto"?i:n.size;var l=a[t];f[t]=Math.min(l,Math.max(0,n.sizethumb=="auto"?l*o.ratio:n.sizethumb));var c=f[t];u.ratio=n.sizethumb=="auto"?r/l:(r-i)/(l-c),p=e=="relative"&&o.ratio<=1?Math.min(r-i,Math.max(0,p)):0,p=e=="bottom"&&o.ratio<=1?r-i:isNaN(parseInt(e,10))?p:parseInt(e,10),g()},m()}e.tiny=e.tiny||{},e.tiny.scrollbar={options:{axis:"y",wheel:40,scroll:!0,size:"auto",sizethumb:"auto"}},e.fn.tinyscrollbar=function(n){var n=e.extend({},e.tiny.scrollbar.options,n);return this.each(function(){e(this).data("tsb",new t(e(this),n))}),this},e.fn.tinyscrollbar_update=function(t){return e(this).data("tsb").update(t)}}(jQuery),define("jquery.tinyscrollbar-1.66/jquery.tinyscrollbar",function(){}),define("jquery.continuousCalendar",["require","jquery","./DateFormat","./DateParse","./DateLocale","./DateRange","./DateTime","./CalendarBody","./RangeEvents","./SingleDateEvents","./jquery.tinyscrollbar-1.66/jquery.tinyscrollbar"],function(e){var t=e("jquery"),n=e("./DateFormat"),r=e("./DateParse"),i=e("./DateLocale"),s=e("./DateRange"),o=e("./DateTime"),u=e("./CalendarBody"),a=e("./RangeEvents"),f=e("./SingleDateEvents");e("./jquery.tinyscrollbar-1.66/jquery.tinyscrollbar"),t.continuousCalendar={version:"4.5.3"},t.fn.continuousCalendar=function(e){function l(e){function L(){C=c.disabledDates?c.disabledDates.split(" "):[],k=c.disabledDates?D(C):{},N=M(c),E=H(c.isPopup),S=P(K()),c.fadeOutDuration=+c.fadeOutDuration,b=B(),b.click(function(e){e.stopPropagation()}),t(".startDateLabel",g).isEmpty()&&j(g,E,S),E.initUI(),S.showInitialSelection(),S.performTrigger()}function A(){c.customScroll&&(x=t(".tinyscrollbar",g).tinyscrollbar(c.scrollOptions))}function O(){T.scrollContent||(T=t.extend(T,u(b,N,h,c.customScroll,c.disableWeekends,k)),_(),E.initState(),S.addRangeLengthLabel(),S.addDateClearingLabel(),S.initEvents(),F())}function M(e){function u(e,n){return e?r.parse(e,h):t.plusDays(n)}var t=(p||o.today()).getFirstDateOfWeek(h),n=u(e.firstDate,-e.weeksBefore*7),i=u(e.lastDate,e.weeksAfter*7+6);return new s(n,i)}function _(){if(c.customScroll)x||A(),x.bind("scroll",I);else{var e=!1;T.scrollContent.scroll(function(){e||(setTimeout(function(){e=!1,I()},250),e=!0)})}}function D(e){var n={};return t.each(e,function(e,t){n[r.parse(t,h).date]=!0}),n}function P(e){var t=[g,T,z,h,c,W,E,p],n=[d,N,X,V,J,C];return e?a.apply(null,t.concat(n)):f.apply(null,t)}function H(e){function r(){return O(),b.is(":visible")?(b.fadeOut(c.fadeOutDuration),t(document).unbind("click.continuousCalendar")):(b.show(),w&&(A(),R(),I(),w=!1),S.setSelection(U(c.startField),U(c.endField)),F(),t(document).bind("click.continuousCalendar",r)),!1}var n={initUI:function(){b.addClass("popup").hide();var e=t('<a href="#" class="calendarIcon">'+v.getDate()+"</a>").click(r);g.prepend("<div></div>"),g.prepend(e)},initState:t.noop,getContainer:function(e){return t('<div class="popUpContainer">').append(e)},close:function(e){r.call(e)},addDateLabelBehaviour:function(e){e.addClass("clickable"),e.click(r)}},i={initUI:O,initState:q,getContainer:function(e){return e},close:t.noop,addDateLabelBehaviour:t.noop};return e?n:i}function B(){var e=t(".continuousCalendar",g);if(e.exists())return e;var n=t('<div class="continuousCalendar">');return g.append(E.getContainer(n)),n}function j(e,n,r){var i=t('<div class="label"><span class="startDateLabel"></span></div>');r.addEndDateLabel(i),e.prepend(i),n.addDateLabelBehaviour(i.children())}function F(){var e=t(".selected",T.scrollContent).get(0)||t(".today",T.scrollContent).get(0);if(e){var n=e.offsetTop-(T.scrollContent.height()-e.offsetHeight)/2;if(c.customScroll){var r=T.bodyTable.height(),i=r-T.scrollContent.height(),s=n>i?i:n;x.tinyscrollbar_update(s>0?s:0)}else T.scrollContent.scrollTop(n)}}function I(){var e=T.scrollContent.get(0),n=t("table",e).get(0),r=c.customScroll?-t(".overview",b).position().top:e.scrollTop,i=parseInt(r/y,10),s=W(n.rows[i].cells[2]);T.yearTitle.text(s.getFullYear())}function q(){A(),R(),I()}function R(){y=parseInt(T.bodyTable.height()/t("tr",T.bodyTable).size(),10)}function U(e){return e.length>0&&e.val().length>0?r.parse(e.val(),h):null}function z(e){c.callback.call(g,e),g.trigger("calendarChange",e)}function W(e){return T.dateCellDates[t(e).closest("[date-cell-index]").attr("date-cell-index")]}function X(e){c.startField.val(e)}function V(e){c.endField.val(e)}function J(e){return e?n.shortDateFormat(e,h):""}function K(){return c.endField&&c.endField.length>0}var l={weeksBefore:26,weeksAfter:26,firstDate:null,lastDate:null,startField:t("input.startDate",this),endField:t("input.endDate",this),isPopup:!1,selectToday:!1,locale:i.EN,disableWeekends:!1,disabledDates:null,minimumRange:-1,selectWeek:!1,fadeOutDuration:0,callback:t.noop,customScroll:!1,scrollOptions:{sizethumb:"auto"},theme:"",allowClearDates:!1},c=t.extend({},l,e),h=i.fromArgument(c.locale),p=U(c.startField),d=U(c.endField),v=o.today();if(c.selectToday){var m=J(v);p=v,d=v,X(m),V(m)}var g=this,y,b,w=!0,E,S,x,T={},N,C,k;t(this).addClass("continuousCalendarContainer").addClass(c.theme).append("&nbsp;"),L()}return this.each(function(){l.call(t(this),e)})},t.fn.calendarRange=function(){return t(this).data("calendarRange")},t.fn.exists=function(){return this.length>0},t.fn.isEmpty=function(){return this.length===0}}),require(["jquery.continuousCalendar"]),require("jquery.continuousCalendar"),window.DateFormat=require("DateFormat"),window.DateParse=require("DateParse"),window.DateLocale=require("DateLocale"),window.DateTime=require("DateTime"),window.DateRange=require("DateRange")})(window);