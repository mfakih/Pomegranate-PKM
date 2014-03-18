 
/**
 * Notify v.0.5.0
 * 
 * jQuery Notification System.
 *
 * Copyright (c) 2009 Drew Wilson (http://www.geedew.com, http://www.alldorks.com/notify)
 * Licensed under the MIT http://www.alldorks.com/notfy/license
 *
 *
 **/

 
 Array.prototype.remove = function(from, to) {
	var rest = this.slice((to || from) + 1 || this.length);
		this.length = from < 0 ? this.length + from : from;
		return this.push.apply(this, rest);
 };
 
 (function($) {
	
	var notifyConfig = {
			container : "notify-history",	
			innerContainer : "notify-group",
			showHistory : false, // Set to false to hide the history link
			limit : 4 , // Limits how much is viewable on screen, Does not include sticky elements
			historyLink : {}, // This holds the link so that it is accessible to anythings
			historyLinkId : "notify-history-link" , // This is the id of the link for the history
			historyLinkText : "Show History" ,
			hideHistoryLinkText : "Hide History",
			onHistory : function(historyLink) { return true; },
			timers : [] , // Holds the timers for the notifications
			data : [] , // Holds all of the notification for history control
			defaults : {
				/*General Configurations */
					/*Should the message go above(before) or below(after) the last one */
					mode : "after", //before or after | defaults to above/before
					sticky : false, // Doesn't disappear
					appearance : 2000, // Appear for 3 seconds
					showClose : true, // Whether or not to show the close icon
					noHistory : false, // Whether to push to history or not
					
					/*Not Implemented*/
					showTime : true, // Displays a timestamp ***NOT ACTIVE YET**
					attention : true, // If no mouse movement is noticed, this will not dissapear ** NOT ACTIVE YET **
					
					/* Basic Message Styling */
					notifyClass : "notification", // Entire Notification 
					activestatus : "notify-active", // History or Active
					inactivestatus : "notify-history", // What class when inactive.
					messageClass : "notify-message", // Class that depicts the message within the notification
					hoverClass : "hover", // Change status on hover
					closeClass : "notify-close", // So you can change this easier for your liking
					closeText : "close", //Close text, or html like an image
					removeClass: "notify-remove", 
					removeText : "remove", //Close text, or html
					
					/* Opening|UnPausing Animation */
					openAnimateParams : { opacity: 0.8 },
					openAnimateDuration : 700,
					openAnimateEasing : "linear",
					openAnimateCallback : function() { return true },
					/* Closing|Removing Animation */
					closeAnimateParams :  { opacity: 0 },
					closeAnimateDuration : 1000,
					closeAnimateEasing : "linear",
					closeAnimateCallback : function() { return true },
					/* Pausing|Hovering Animation */
					pauseAnimateParams : { opacity: 0.8 },
					pauseAnimateDuration : 400 ,
					pauseAnimateEasing : "swing",
					pauseAnimateCallback : function() { return true },
									
				/* Required Configurations | Should not have to Edit*/
					message : "", // Empty message, on purpose
					currentlyActive : false, // This is true when hovering (for removal purposes
					group : false, // Allows for grouping the notifications, a String here will set the Group
					
					/** Hooks | default actions**/
					onClose : function(self, options) {return true; }, //Function to run on Close to History
					onOver : function(self, options) {return true; }, // Function to run on Hover
					onOut : function(self, options) { return true;}, // Function to run when off Hover
					onOpen : function(self, options) {return true; }, // Function to run on Open
					onRemove : function(self, options) {return true; } // Function to run when removed from History
			}	
	}
	
	$.fn.extend({
		notify : function(options) {
			var settings = $.extend({ }, notifyConfig.defaults,options);
		
			return this.each(function() {
				var o = settings;
				/* Check to see if we are wanting a variable */
				$.notify($(this).text(),o);
			}); //End Each
		} 
	}); // End Extend
	
	var historyAction = function() {
		
		/* Watch when this is opened or closed */
		if(!$(notifyConfig.historyLink).data("open")) $(notifyConfig.historyLink).data("open",true);
		else $(notifyConfig.historyLink).data("open", false)
		notifyConfig.onHistory(notifyConfig.historyLink);
		/* Loop through all of the data elements */
		var historyCount = 0;
		$(notifyConfig.data).each(function() {
			var options = this[0];
			var elem = this[1];
			/* if the history is not open, and this item is in history */
			if(!$(notifyConfig.historyLink).data("open") && $(elem).hasClass(options.inactivestatus)) {
				$(notifyConfig.historyLink).html(notifyConfig.historyLinkText);
				$(elem).animate(options.closeAnimateParams, options.closeAnimateDuration, options.closeAnimateEasing, function() { if(options.closeAnimateCallback()) $(elem).hide();});
			}
			/* if this item is in history */
			else if($(elem).hasClass(options.inactivestatus)) {
				/*Only show what's in the history, remove others */
				$(notifyConfig.historyLink).html(notifyConfig.hideHistoryLinkText);
				$(elem).animate(options.openAnimateParams, options.openAnimateDuration, options.openAnimateEasing).show();
			} 
		});
	}
	
	/* This is a singleton type pattern */
	$.notifyinit = function() {
		var container = false; // Return false by default
		/* Make sure that the default container is always created */
		if($("#"+notifyConfig.container).length < 1) {
			var container = $("<ol />")
					.attr("id", notifyConfig.container)
					.appendTo("body");
			if(notifyConfig.showHistory) {
				/* Create the history Link */
				
				notifyConfig.historyLink = $("<li />")
					.attr("id", notifyConfig.historyLinkId)
					.html(notifyConfig.historyLinkText)
					.hide() // Not visible until elements are added
					.click(function() {
						historyAction();
					})
					.prependTo(container);
					
			}
		}
		if(arguments[0] && $("#"+arguments[0]).length < 1) {
			var container = $("<ol />")
					.attr("id", arguments[0])
					.addClass(notifyConfig.innerContainer)
					.appendTo("#"+notifyConfig.container);
					$(container).wrap("<li />"); // Wrap the element so that it also works in the form.
					
		}
		return container; // return the container last created or false
	}
	
	
	$.notify = function() {
		
		var options = $.extend({ },notifyConfig.defaults, arguments[1]); // Does not change defaults!!! Important.
		var message = arguments[0] || options.message;
		var container = options.group || notifyConfig.container;
		var current =  $.notifyinit(container) || "#"+container; // Make sure the program is ready
		
		var notifyTimer;
		var pauseNotification = function(note,options) {
			if(!options.sticky) {
				/* Stop the interval */
				options.currentlyActive = true;
				/* Not sure if notifyTimer will work every time */
				clearInterval(notifyTimer || notifyConfig.timers[note]);
				$(note).stop().animate(options.pauseAnimateParams, options.pauseAnimateDuration, options.pauseAnimateEasing);
				return true;
			}
			return false;
		}
		var continueNotification = function(note, options) {
			$(note).animate(
				options.openAnimateParams, 
				options.openAnimateDuration, 
				options.openAnimateEasing,
				function() {
					if(options.onOpen(note, options)){
						/* Show or hide the notification after a period of time */
						if(!options.sticky) {
							notifyTimer = notifyConfig.timers[note] = setInterval(function() {
										closeNotification(note, options);
										clearInterval(notifyTimer);
									}, options.appearance);
							options.currentlyActive = false;
							return true;
						}
						return false;
					}
				}).show();
		}
		
		var closeNotification = function(elem, options) {
			if(options.onClose(elem, options)) {
				
				/* Change the notification to a history item */
				$(note)
					.animate(
						options.closeAnimateParams, 
						options.closeAnimateDuration,
						options.closeAnimateEasing,
						function() {
							if(options.closeAnimateCallback()) {
								/* Always hide the element.. only do the other things if it isn't already in history */
								$(this)
									.hide();
									
								/* If Not in History already */
								if($(this).hasClass(options.activestatus)) {
									$(this)
										.removeClass(options.activestatus)
										.addClass(options.inactivestatus)
										/* Remove the previous actions*/
										.unbind("mouseover") 
										.unbind("mouseout")
										/* Using bind mouseover so it can be unbound later. */
										.bind('mouseover',function() {
											showRemove(this, options);
											return false;
										})
										.bind('mouseout',function() {
											hideRemove(this, options);
											return false;
										});
								}
								
								/* update the history? */
								if($(notifyConfig.historyLink).data("open")) {
									$(notifyConfig.historyLink).data("open", false);
									historyAction();
								}
							}
							
							/* Change the close button to a remove button */
							$(close).html(options.removeText)
								.removeClass(options.closeClass)
								.addClass(options.removeClass)
								/* Unbind the close click so it doesn't fire again */
								.unbind("click")
								.click(function() {
									removeNotification(note, options);
								});
							
							/* If it is not to go into history, then fire the remove */
							if(options.noHistory) removeNotification(note,options);
							
							/* Configure the History to show correctly */
							if(notifyConfig.showHistory && notifyConfig.data.length > 0) 
								$(notifyConfig.historyLink).show(); 
								 
						})
					
					
				
			}
		}
		
		var removeNotification = function(elem, options) {
			if(options.onRemove(elem, options)) {
				/* find the element in the data store */
				$(notifyConfig.data).each(function(i) {
					if(this[1] === elem) {
						$(elem).remove(); // remove the element
						notifyConfig.data.remove(i); // remove from data store
						return false; // break the each
					}
					return true;// continue to loop
				})
			}
			if(notifyConfig.data.length < 1) $(notifyConfig.historyLink).hide().html(notifyConfig.historyLinkText);
		}
		
		var showClose = function(element,options) {
			$(element).children("."+options.closeClass).show();
		}
		
		var hideClose = function(element,options) {
			$(element).children("."+options.closeClass).hide();
		}
		
		var showRemove = function(element, options) {
			$(element).children("."+options.removeClass).show();
		}
		var hideRemove = function(element,options) {
			$(element).children("."+options.removeClass).hide();
		}
		
		var note = $("<li />")
			.html($("<div />").addClass(options.messageClass).html(message))
			.addClass(options.notifyClass+" "+options.activestatus)
			/*Using bind so I can unbind later (".hover" will not allow this) */
			.bind("mouseover",function() {
				/* Pause on over */
				pauseNotification(this, options);
				options.onOver(this, options);
				$(this).addClass(options.hoverClass);
				if(options.showClose|| (options.sticky && !options.showClose)) showClose(this, options);
				
			})
			.bind("mouseout",function() {
				/* Unpause the notification */
				continueNotification(this, options);
				options.onOut(this, options);
				$(this).removeClass(options.hoverClass);
				hideClose(this, options);
			});
		if(options.mode == "after")
			$(note).appendTo(current).hide(); /* Start it out hidden */
			else if (options.mode == "before")
			$(note).prependTo(current).hide(); /* Start it out hidden */
			
			
		
		/* Show or don'g show the close button */
		var close = $("<div />")
			.html(options.closeText)
			.addClass(options.closeClass)
			.appendTo(note)
			.hide()
			.click(function() {
				closeNotification(note, options);
			});
		
		/* Add the new note to the history data */
		var history = [options, note];
		/* Limit how many notification can be saved and/or showing at any time */
		if(notifyConfig.data.length >= notifyConfig.limit) {
			/* Do not remove sticky elements continue to remove until one found.*/
			for(i=0;i<notifyConfig.data.length;i++) {
				/* Do not remove it if it is currently being hovered over */
				if(!notifyConfig.data[i][0].sticky && !notifyConfig.data[i][0].currentlyActive) {
					$(notifyConfig.data[i][1]).remove();
					notifyConfig.data.remove(i);
					break;
				} 
			}
		}
		/* Push the new notification into History */
		notifyConfig.data.push(history);
		
		
		/* Start the clock */
		continueNotification(note,options);
		
		/* Bind the close action */
		$(note).bind("close",function() { closeNotification(note,options); });
		return note;
	}
})(jQuery);
