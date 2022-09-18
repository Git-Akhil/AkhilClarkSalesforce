/**
 * BootSideMenu v 1.02
 * Author: Kriit Technology
 * */
(function ($) {

	$.fn.BootSideMenu = function (userOptions) {

		var initialCode;
		var newCode;
		var menu;
		var prevStatus;
		var body = {};

		var defaults = {
			side: "left",
			duration: 500,
			remember: true,
			autoClose: false,
			pushBody: true,
			closeOnClick: true,
			width: "15%",
			height: "15%",
			onTogglerClick: function () {
				//code to be executed when the toggler arrow was clicked
			},
			onBeforeOpen: function () {
				//code to be executed before menu open
			},
			onBeforeClose: function () {
				//code to be executed before menu close
			},
			onOpen: function () {
				//code to be executed after menu open
			},
			onClose: function () {
				//code to be executed after menu close
			},
			onStartup: function () {
				//code to be executed when the plugin is called
			}
		};

		var options = $.extend({}, defaults, userOptions);


		body.originalMarginLeft = $("body").css("margin-left");
		body.originalMarginRight = $("body").css("margin-right");
		body.originalMarginBottom = $("body").css("margin-bottom");
		body.originalMarginTop = $("body").css("margin-top");
		body.width = $("body").width();
		body.height = $("body").height();

		initialCode = this.html();

		newCode = "<div class=\"row\">";
		newCode += "	<div class=\"col-xs-12 col-sm-12 col-md-12 col-lg-12\">\n" + initialCode + " </div>";
		newCode += "</div>";
		newCode += "<div class=\"toggler\" data-whois=\"toggler\">";
		newCode += "	<span class=\"glyphicon\">&nbsp;</span>";
		newCode += "</div>";

		this.empty();
		this.append(newCode);

		menu = $(this);

		menu.addClass("container");
		menu.addClass("sidebar");
		menu.css("width", options.width);
		menu.css("height", options.height);

		if (options.side == "left") {
			menu.addClass("sidebar-left");
		} else if (options.side == "right") {
			menu.addClass("sidebar-right");
		} else if (options.side == "bottom") {
			menu.addClass("sidebar-bottom");
		} else if (options.side == "top") {
			menu.addClass("sidebar-top");
		}

		menu.id = menu.attr("id");
		menu.cookieName = "bsm2-" + menu.id;
		menu.toggler = $(menu.children()[1]);
		menu.originalWidth = menu.width();
		menu.originalPushBody = options.pushBody;


		if (options.remember) {
			prevStatus = readCookie(menu.cookieName);
		} else {
			prevStatus = null;
		}

		switch (prevStatus) {
			case "opened":
				startOpened();
				break;
			case "closed":
				startClosed();
				break;
			default:
				startOpened();
				break;
		}

		if (options.onStartup !== undefined) {
			options.onStartup(menu);
		}

		//aggiungi icone a tutti i collapse
		$("[data-toggle=\"collapse\"]", menu).each(function () {
			alert('Yes');
			var icona = $("<span class=\"glyphicon glyphicon-chevron-right\"></span>");
			$(this).prepend(icona);
		});

		menu.off("click", "[data-whois=toggler]");
		menu.on("click", "[data-whois=toggler]", function () {
			toggle();
			if (options.onTogglerClick !== undefined) {
				options.onTogglerClick(menu);
			}
		});

		menu.off("click", ".list-group-item");
		menu.on("click", ".list-group-item", function () {
			menu.find(".list-group-item").each(function () {
				$(this).removeClass("active");
			});
			$(this).addClass("active");
			$(".glyphicon", this).toggleClass("glyphicon-chevron-right").toggleClass("glyphicon-chevron-down");
		});


		menu.off("click", "a.list-group-item");
		menu.on("click", "a.list-group-item", function () {
			if (options.closeOnClick) {
				if ($(this).attr("data-toggle") != "collapse") {
					closeMenu(true);
				}
			}
		});


		function toggle() {
			if (menu.status == "opened") {
				closeMenu(true);
			} else {
				openMenu(true);
			}
		}

		function switchArrow(side) {
			var span = menu.toggler.find("span.glyphicon");
			if (side == "left") {
				span.removeClass("glyphicon-chevron-left").addClass("glyphicon-chevron-right");
			} else if (side == "right") {
				span.removeClass("glyphicon-chevron-right").addClass("glyphicon-chevron-left");
			} else if (side == "bottom") {
				span.removeClass("glyphicon-chevron-down").addClass("glyphicon-chevron-up");
			} else if (side == "top") {
				span.removeClass("glyphicon-chevron-up").addClass("glyphicon-chevron-down");
			}
		}

		function startDefault() {
			if (options.side == "left") {
				if (options.autoClose) {
					menu.status = "closed";
					menu.hide().animate({
						left: -(menu.width() + 2)
					}, 1, function () {
						menu.show();
						switchArrow("left");
					});
				} else if (!options.autoClose) {
					switchArrow("right");
					menu.status = "opened";
					if (options.pushBody) {
						$("body").css("margin-left", menu.width() + 20);
					}
				}
			} else if (options.side == "right") {
				if (options.autoClose) {
					menu.status = "closed";
					menu.hide().animate({
						right: -(menu.width() + 2)
					}, 1, function () {
						menu.show();
						switchArrow("right");
					});
				} else {
					switchArrow("left");
					menu.status = "opened";
					if (options.pushBody) {
						$("body").css("margin-right", menu.width() + 20);
					}
				}
			} else if (options.side == "bottom") {
				if (options.autoClose) {
					menu.status = "closed";
					menu.hide().animate({
						bottom: -(menu.height() + 2)
					}, 1, function () {
						menu.show();
						switchArrow("bottom");
					});
				} else {
					switchArrow("top");
					menu.status = "opened";
					if (options.pushBody) {
						$("body").css("margin-bottom", menu.height() + 20);
					}
				}
			} else if (options.side == "top") {
				if (options.autoClose) {
					menu.status = "closed";
					menu.hide().animate({
						top: -(menu.height() + 2)
					}, 1, function () {
						menu.show();
						switchArrow("top");
					});
				} else {
					switchArrow("bottom");
					menu.status = "opened";
					if (options.pushBody) {
						$("body").css("margin-top", menu.height() + 20);
					}
				}
			}
		}

		function startClosed() {
			if (options.side == "left") {
				menu.status = "closed";
				menu.hide().animate({
					left: -(menu.width() + 2)
				}, 1, function () {
					menu.show();
					switchArrow("left");
				});
			} else if (options.side == "right") {
				menu.status = "closed";
				menu.hide().animate({
					right: -(menu.width() + 2)
				}, 1, function () {
					menu.show();
					switchArrow("right");
				})
			} else if (options.side == "bottom") {
				menu.status = "closed";
				menu.hide().animate({
					bottom: -(menu.height() + 2)
				}, 1, function () {
					menu.show();
					switchArrow("bottom");
				})
			} else if (options.side == "top") {
				menu.status = "closed";
				menu.hide().animate({
					top: -(menu.height() + 2)
				}, 1, function () {
					menu.show();
					switchArrow("top");
				})
			}
		}

		function startOpened() {
			if (options.side == "left") {
				switchArrow("right");
				menu.status = "opened";
				if (options.pushBody) {
					$("body").css("margin-left", menu.width() + 20);
				}

			} else if (options.side == "right") {
				switchArrow("left");
				menu.status = "opened";
				if (options.pushBody) {
					$("body").css("margin-right", menu.width() + 20);
				}
			} else if (options.side == "bottom") {
				switchArrow("top");
				menu.status = "opened";
				if (options.pushBody) {
					$("body").css("margin-bottom", menu.height() + 20);
				}
			} else if (options.side == "top") {
				switchArrow("bottom");
				menu.status = "opened";
				if (options.pushBody) {
					$("body").css("margin-top", menu.height() + 20);
				}
			}
		}

		function closeMenu(execFunctions) {
			if (execFunctions) {
				if (options.onBeforeClose !== undefined) {
					options.onBeforeClose(menu);
				}
			}
			if (options.side == "left") {
				if (options.pushBody) {
					$("body").animate({marginLeft: body.originalMarginLeft}, {duration: options.duration});
				}
				menu.animate({
					left: -(menu.width() + 2)
				}, {
					duration: options.duration,
					done: function () {
						switchArrow("left");
						menu.status = "closed";

						if (execFunctions) {
							if (options.onClose !== undefined) {
								options.onClose(menu);
							}
						}
					}
				});
			} else if (options.side == "right") {
				if (options.pushBody) {
					$("body").animate({marginRight: body.originalMarginRight}, {duration: options.duration});
				}
				menu.animate({
					right: -(menu.width() + 2)
				}, {
					duration: options.duration,
					done: function () {
						switchArrow("right");
						menu.status = "closed";

						if (execFunctions) {
							if (options.onClose !== undefined) {
								options.onClose(menu);
							}
						}
					}
				});
			} else if (options.side == "bottom") {
				if (options.pushBody) {
					$("body").animate({marginBottom: body.originalMarginBottom}, {duration: options.duration});
				}
				menu.animate({
					bottom: -(menu.height() + 2)
				}, {
					duration: options.duration,
					done: function () {
						switchArrow("bottom");
						menu.status = "closed";

						if (execFunctions) {
							if (options.onClose !== undefined) {
								options.onClose(menu);
							}
						}
					}
				});
			} else if (options.side == "top") {
				if (options.pushBody) {
					$("body").animate({marginTop: body.originalMarginTop}, {duration: options.duration});
				}
				menu.animate({
					top: -(menu.height() + 2)
				}, {
					duration: options.duration,
					done: function () {
						switchArrow("top");
						menu.status = "closed";

						if (execFunctions) {
							if (options.onClose !== undefined) {
								options.onClose(menu);
							}
						}
					}
				});
			}

			if (options.remember) {
				storeCookie(menu.cookieName, "closed");
			}

		}

		function openMenu(execFunctions) {
			if (execFunctions) {
				if (options.onBeforeOpen !== undefined) {
					options.onBeforeOpen(menu);
				}
			}

			if (options.side == "left") {
				if (options.pushBody) {
					$("body").animate({marginLeft: menu.width() + 20}, {duration: options.duration});
				}
				menu.animate({
					left: 0
				}, {
					duration: options.duration,
					done: function () {
						switchArrow("right");
						menu.status = "opened";

						if (execFunctions) {
							if (options.onOpen !== undefined) {
								options.onOpen(menu);
							}
						}
					}
				});
			} else if (options.side == "right") {
				if (options.pushBody) {
					$("body").animate({marginRight: menu.width() + 20}, {duration: options.duration});
				}
				menu.animate({
					right: 0
				}, {
					duration: options.duration,
					done: function () {
						switchArrow("left");
						menu.status = "opened";

						if (execFunctions) {
							if (options.onOpen !== undefined) {
								options.onOpen(menu);
							}
						}
					}
				});
			} else if (options.side == "bottom") {
				if (options.pushBody) {
					$("body").animate({marginBottom: menu.height() + 20}, {duration: options.duration});
				}
				menu.animate({
					bottom: 0
				}, {
					duration: options.duration,
					done: function () {
						switchArrow("top");
						menu.status = "opened";

						if (execFunctions) {
							if (options.onOpen !== undefined) {
								options.onOpen(menu);
							}
						}
					}
				});
			} else if (options.side == "top") {
				if (options.pushBody) {
					$("body").animate({marginTop: menu.height() + 20}, {duration: options.duration});
				}
				menu.animate({
					top: 0
				}, {
					duration: options.duration,
					done: function () {
						switchArrow("bottom");
						menu.status = "opened";

						if (execFunctions) {
							if (options.onOpen !== undefined) {
								options.onOpen(menu);
							}
						}
					}
				});
			}

			if (options.remember) {
				storeCookie(menu.cookieName, "opened");
			}
		}

		function storeCookie(nome, valore) {
			var d = new Date();
			d.setTime(d.getTime() + (24 * 60 * 60 * 1000));
			var expires = "expires=" + d.toUTCString();
			document.cookie = nome + "=" + valore + "; " + expires + "; path=/";
		}

		function readCookie(nome) {
			var name = nome + "=";
			var ca = document.cookie.split(";");
			for (var i = 0; i < ca.length; i++) {
				var c = ca[i];
				while (c.charAt(0) == " ")
					c = c.substring(1);
				if (c.indexOf(name) == 0) return c.substring(name.length, c.length);
			}
			return null;
		}


		function onResize() {
			menu.width(options.width);
			menu.height(options.height);

			if (menu.status == "closed") {
				startClosed();
			}
			if (menu.status == "opened") {
				startOpened();
			}
		}

		var resizeStart;
		var resizeEnd;
		var wait = 250;
		window.addEventListener("resize", function () {
			resizeStart = new Date().getMilliseconds();
			resizeEnd = resizeStart + wait;
			setTimeout(function () {
				var now = new Date().getMilliseconds();
				if (now > resizeEnd) {
					onResize();
				}
			}, wait);
		}, false);
		
		$.fn.BootSideMenu.open = function () {
			openMenu();
		};

		$.fn.BootSideMenu.close = function () {
			closeMenu();
		};

		$.fn.BootSideMenu.toggle = function () {
			toggle();
		};

		return this;
	}
}(jQuery));