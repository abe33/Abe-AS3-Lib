package aesia.com.ponents.monitors
{
	import aesia.com.mands.ProxyCommand;
	import aesia.com.mon.logs.LogEvent;
	import aesia.com.mon.logs.LogLevel;
	import aesia.com.mon.utils.KeyStroke;
	import aesia.com.mon.utils.Keys;
	import aesia.com.mon.utils.StringUtils;
	import aesia.com.patibility.lang._;
	import aesia.com.patibility.lang._$;
	import aesia.com.ponents.events.DebugEvent;
	import aesia.com.ponents.layouts.display.DOBoxSettings;
	import aesia.com.ponents.layouts.display.DOHBoxLayout;
	import aesia.com.ponents.scrollbars.annotations.Annotation;
	import aesia.com.ponents.scrollbars.annotations.AnnotationTypes;
	import aesia.com.ponents.scrollbars.annotations.ScrollBarAnnotations;
	import aesia.com.ponents.text.TextArea;
	import aesia.com.ponents.text.TextLineRuler;
	import aesia.com.ponents.utils.ContextMenuItemUtils;

	import flash.display.DisplayObject;
	import flash.events.ContextMenuEvent;
	import flash.events.Event;
	import flash.text.TextFieldType;

	[Event(name="notifyWarning",type="aesia.com.ponents.events.DebugEvent")]	[Event(name="notifyError",type="aesia.com.ponents.events.DebugEvent")]
	[Skinable(skin="LogView")]
	[Skin(define="LogView",
		  inherit="Text",

		  state__all__format="new txt::TextFormat ('Monospace', 11,0,false,false,false)"
	)]
	/**
	 * @author Cédric Néhémie
	 */
	public class LogView extends TextArea
	{
		protected var _logs : Array;		protected var _logsLimit : uint;		protected var _logsLevel : LogLevel;

		protected var _lineRuler : TextLineRuler;

		protected var _annotations : ScrollBarAnnotations;
		protected var _annotateErrors : Boolean;
		protected var _annotateWarnings : Boolean;
		protected var _annotateFatals : Boolean;

		protected var _notifyWarnings : Boolean;		protected var _notifyErrors : Boolean;

		public function LogView ()
		{
			super();
			_logsLimit = 100;
			_logs = [];
			_label.type = TextFieldType.DYNAMIC;
			_logsLevel = LogLevel.DEBUG;

			_annotateWarnings = true;			_annotateErrors = true;			_annotateFatals = true;

			_notifyWarnings = true;
			_notifyErrors = true;

			_lineRuler = new TextLineRuler(_label, this);
			addComponentChildBefore(_lineRuler, _label as DisplayObject);
			( _childrenLayout as DOHBoxLayout ).boxes.unshift( new DOBoxSettings(0, "left", "center", _lineRuler, false, true, false ) );

			_annotations = new ScrollBarAnnotations( _scrollbar );
			addComponentChildAfter(_annotations, _scrollbar);
			( _childrenLayout as DOHBoxLayout ).boxes.push( new DOBoxSettings(0, "left", "center", _annotations, false, true, false ) );

			invalidatePreferredSizeCache();

			/*FDT_IGNORE*/ FEATURES::MENU_CONTEXT { /*FDT_IGNORE*/
				createContextMenu();
			/*FDT_IGNORE*/ } /*FDT_IGNORE*/

			/*FDT_IGNORE*/ FEATURES::KEYBOARD_CONTEXT { /*FDT_IGNORE*/
				_keyboardContext[ KeyStroke.getKeyStroke( Keys.DELETE ) ] = new ProxyCommand( clear );				_keyboardContext[ KeyStroke.getKeyStroke( Keys.BACKSPACE ) ] = new ProxyCommand( clear );
			/*FDT_IGNORE*/ } /*FDT_IGNORE*/
		}

		public function get annotations() : ScrollBarAnnotations{ return _annotations; }
		public function get logsLevel () : LogLevel { return _logsLevel; }
		public function set logsLevel (logsLevel : LogLevel) : void
		{
			_logsLevel = logsLevel;
			/*FDT_IGNORE*/ FEATURES::MENU_CONTEXT { /*FDT_IGNORE*/
			updateFiltersMenuItemCaptions ();
			/*FDT_IGNORE*/ } /*FDT_IGNORE*/
			printLogs();
		}
		public function get logsLimit () : uint { return _logsLimit; }
		public function set logsLimit (logsLimit : uint) : void
		{
			var forcePrint : Boolean = false;
			var dif : uint = 0;

			if( logsLimit < _logsLimit )
			{
				forcePrint = true;
				dif = _logsLimit - logsLimit;
			}
			_logsLimit = logsLimit;

			if( forcePrint )
			{
				_logs.splice( 0, dif );
				printLogs();
			}

		}
		public function get annotateErrors() : Boolean { return _annotateErrors; }
		public function set annotateErrors(annotateErrors : Boolean) : void
		{
			_annotateErrors=annotateErrors;
			/*FDT_IGNORE*/ FEATURES::MENU_CONTEXT { /*FDT_IGNORE*/
			updateAnnotateMenuItemCaptions();
			/*FDT_IGNORE*/ } /*FDT_IGNORE*/
			printLogs();
		}
		public function get annotateWarnings() : Boolean { return _annotateWarnings; }
		public function set annotateWarnings(annotateWarnings : Boolean) : void
		{
			_annotateWarnings=annotateWarnings;
			/*FDT_IGNORE*/ FEATURES::MENU_CONTEXT { /*FDT_IGNORE*/
			updateAnnotateMenuItemCaptions();
			/*FDT_IGNORE*/ } /*FDT_IGNORE*/
			printLogs();
		}
		public function get annotateFatals() : Boolean { return _annotateFatals; }
		public function set annotateFatals(annotateFatals : Boolean) : void
		{
			_annotateFatals=annotateFatals;
			/*FDT_IGNORE*/ FEATURES::MENU_CONTEXT { /*FDT_IGNORE*/
			updateAnnotateMenuItemCaptions();
			/*FDT_IGNORE*/ } /*FDT_IGNORE*/
			printLogs();
		}
		public function get notifyWarnings() : Boolean { return _notifyWarnings; }
		public function set notifyWarnings(notifyWarnings : Boolean) : void
		{
			_notifyWarnings=notifyWarnings;
			/*FDT_IGNORE*/ FEATURES::MENU_CONTEXT { /*FDT_IGNORE*/
			updateNotifyMenuItemCaptions();
			/*FDT_IGNORE*/ } /*FDT_IGNORE*/
		}
		public function get notifyErrors() : Boolean { return _notifyErrors; }
		public function set notifyErrors(notifyErrors : Boolean) : void
		{
			_notifyErrors=notifyErrors;
			/*FDT_IGNORE*/ FEATURES::MENU_CONTEXT { /*FDT_IGNORE*/
			updateNotifyMenuItemCaptions();
			/*FDT_IGNORE*/ } /*FDT_IGNORE*/
		}

		/*FDT_IGNORE*/ FEATURES::MENU_CONTEXT { /*FDT_IGNORE*/
		protected function createContextMenu () : void
		{
			// Clear logs
			addNewContextMenuItemForGroup( _("Clear logs"), "clearLogs", clear, "logs" );

			// Filter logs
			addNewContextMenuItemForGroup( ContextMenuItemUtils.getBooleanContextMenuItemCaption(_("Filter by Debug and above"),
															_logsLevel == LogLevel.DEBUG ), "debugFilter", debugLevel, "filters" );

			addNewContextMenuItemForGroup( ContextMenuItemUtils.getBooleanContextMenuItemCaption(_("Filter by Info and above"),
															_logsLevel == LogLevel.INFO ), "infoFilter", infoLevel, "filters" );

			addNewContextMenuItemForGroup( ContextMenuItemUtils.getBooleanContextMenuItemCaption(_("Filter by Warn and above"),
															_logsLevel == LogLevel.WARN ), "warnFilter", warnLevel, "filters" );

			addNewContextMenuItemForGroup( ContextMenuItemUtils.getBooleanContextMenuItemCaption(_("Filter by Error and above"),
															_logsLevel == LogLevel.ERROR ), "errorFilter", errorLevel, "filters" );

			addNewContextMenuItemForGroup( ContextMenuItemUtils.getBooleanContextMenuItemCaption(_("Filter by Fatal"),
															_logsLevel == LogLevel.FATAL ), "fatalFilter", fatalLevel, "filters" );

			// Annotations
			addNewContextMenuItemForGroup( ContextMenuItemUtils.getBooleanContextMenuItemCaption(_("Annotate Warnings"),
															_annotateWarnings ), "warnAnnotation", annotateWarnHandler, "annotation" );

			addNewContextMenuItemForGroup( ContextMenuItemUtils.getBooleanContextMenuItemCaption(_("Annotate Errors"),
															_annotateErrors ), "errorAnnotation", annotateErrorHandler, "annotation" );

			addNewContextMenuItemForGroup( ContextMenuItemUtils.getBooleanContextMenuItemCaption(_("Annotate Fatal Errors"),
															_annotateFatals ), "fatalAnnotation", annotateFatalHandler, "annotation" );

			// Notifications
			addNewContextMenuItemForGroup( ContextMenuItemUtils.getBooleanContextMenuItemCaption(_("Notify Warnings"),
															_notifyWarnings ), "notifyWarning", notifyWarnHandler, "notification" );

			addNewContextMenuItemForGroup( ContextMenuItemUtils.getBooleanContextMenuItemCaption(_("Notify Errors"),
															_notifyErrors ), "notifyError", notifyErrorHandler, "notification" );
		}
		protected function notifyWarnHandler(event : ContextMenuEvent) : void
		{
			notifyWarnings = !notifyWarnings;
		}
		protected function notifyErrorHandler(event : ContextMenuEvent) : void
		{
			notifyErrors = !notifyErrors;
		}
		protected function annotateWarnHandler(event : ContextMenuEvent) : void
		{
			annotateWarnings = !annotateWarnings;
		}
		protected function annotateErrorHandler(event : ContextMenuEvent) : void
		{
			annotateErrors = !annotateErrors;
		}
		protected function annotateFatalHandler(event : ContextMenuEvent) : void
		{
			annotateFatals = !annotateFatals;
		}
		protected function debugLevel (event : ContextMenuEvent) : void
		{
			logsLevel = LogLevel.DEBUG;
		}
		protected function infoLevel (event : ContextMenuEvent) : void
		{
			logsLevel = LogLevel.INFO;
		}
		protected function warnLevel (event : ContextMenuEvent) : void
		{
			logsLevel = LogLevel.WARN;
		}
		protected function errorLevel (event : ContextMenuEvent) : void
		{
			logsLevel = LogLevel.ERROR;
		}
		protected function fatalLevel (event : ContextMenuEvent) : void
		{
			logsLevel = LogLevel.FATAL;
		}
		protected function updateNotifyMenuItemCaptions() : void
		{
			setContextMenuItemCaption( "notifyWarning", ContextMenuItemUtils.getBooleanContextMenuItemCaption(_("Notify Warnings"),
															_notifyWarnings ) );
			setContextMenuItemCaption( "notifyError", ContextMenuItemUtils.getBooleanContextMenuItemCaption(_("Notify Errors"),
															_notifyErrors ) );
		}
		protected function updateAnnotateMenuItemCaptions () : void
		{
			setContextMenuItemCaption( "warnAnnotation", ContextMenuItemUtils.getBooleanContextMenuItemCaption(_("Annotate Warnings"),
															_annotateWarnings ) );
			setContextMenuItemCaption( "errorAnnotation", ContextMenuItemUtils.getBooleanContextMenuItemCaption(_("Annotate Errors"),
															_annotateErrors ) );
			setContextMenuItemCaption( "fatalAnnotation", ContextMenuItemUtils.getBooleanContextMenuItemCaption(_("Annotate Fatal Errors"),
															_annotateFatals ) );
		}
		protected function updateFiltersMenuItemCaptions () : void
		{
			setContextMenuItemCaption( "debugFilter", ContextMenuItemUtils.getBooleanContextMenuItemCaption(_("Filter by Debug and above"),
															_logsLevel == LogLevel.DEBUG ) );
			setContextMenuItemCaption( "infoFilter", ContextMenuItemUtils.getBooleanContextMenuItemCaption(_("Filter by Info and above"),
															_logsLevel == LogLevel.INFO ) );
			setContextMenuItemCaption( "warnFilter", ContextMenuItemUtils.getBooleanContextMenuItemCaption(_("Filter by Warn and above"),
															_logsLevel == LogLevel.WARN ) );
			setContextMenuItemCaption( "errorFilter", ContextMenuItemUtils.getBooleanContextMenuItemCaption(_("Filter by Error and above"),
															_logsLevel == LogLevel.ERROR ) );
			setContextMenuItemCaption( "fatalFilter", ContextMenuItemUtils.getBooleanContextMenuItemCaption(_("Filter by Fatal"),
															_logsLevel == LogLevel.FATAL ) );
		}
		/*FDT_IGNORE*/ } /*FDT_IGNORE*/

		public function clear (... args) : void
		{
			_logs = [];
			printLogs();
		}
		public function logAdded ( e : LogEvent ) : void
		{
			if( e.keepHTML )
			{
				writeLine(_$("<p><b><font color='$0'>$1 : </font></b>$2</p>",
							e.level.color,
							e.level.name,
							e.msg ) );
			}
			else
			{
				var line : XML = <p><b><font color={e.level.color}>{e.level.name} : </font></b> {e.msg}</p>;
				XML.prettyPrinting = false;
				writeLine( line.toXMLString() );
			}
			if( e.level.level >= LogLevel.WARN.level )
			{
				if( _notifyWarnings &&
					e.level.level == LogLevel.WARN.level &&
					!isVisible )
					dispatchEvent( new DebugEvent( DebugEvent.NOTIFY_WARNING ) );				else if( _notifyErrors &&
						e.level.level >= LogLevel.ERROR.level &&
						!isVisible )
					dispatchEvent( new DebugEvent( DebugEvent.NOTIFY_ERROR ) );
			}
		}
		public function writeLine ( str : String ) : void
		{
			_logs.push( str );

			if( _logs.length > logsLimit )
				_logs.shift();

			if( displayed )
				printLogs();
		}

		override public function addedToStage (e : Event) : void
		{
			printLogs();
			super.addedToStage( e );
		}

		override public function repaint() : void
		{
			super.repaint();
			updateAnnotations();
			_lineRuler.repaint();
		}
		protected function printLogs () : void
		{
			var forceScroll : Boolean = ( _label.scrollV == _label.maxScrollV );

			value = _logs.filter( function( s : String, ... args ) : Boolean
			{
				var name : String = s.replace(/<p><b><font color=([^>]+)>([A-Z]+) :.+/gi, "$2" );
				var lev : LogLevel = LogLevel.getLevelByName(name);

				return lev.level >= _logsLevel.level;
			} ).join("");

			if( forceScroll )
				_label.scrollV = _label.maxScrollV;

			updateScrollBar();
			updateAnnotations();
		}
		protected function updateAnnotations() : void
		{
			var a : Array = [];
			for( var i:uint = 0; i<_label.numLines; i++ )
			{
				var line : String =  _label.getLineText( i );
				if( _annotateErrors  )
				{
					if( line.indexOf( "ERROR :" ) != -1 )
					{
						a.push( new Annotation( i,
												"Line : " + (i+1) + "\n" + getLogStartingWithLine( line ),
												AnnotationTypes.ERROR,
												AnnotationTypes.COLORS[ AnnotationTypes.ERROR ] ) );
					}
				}
				if( _annotateWarnings  )
				{
					if( line.indexOf( "WARN :" ) != -1 )
					{
						a.push( new Annotation( i,
												"Line : " + (i+1) + "\n" + getLogStartingWithLine( line ),
												AnnotationTypes.WARN,
												AnnotationTypes.COLORS[ AnnotationTypes.WARN ] ) );
					}
				}
				if( _annotateFatals  )
				{
					if( line.indexOf( "FATAL :" ) != -1 )
					{
						a.push( new Annotation( i,
												"Line : " + (i+1) + "\n" + getLogStartingWithLine( line ),
												AnnotationTypes.FATAL,
												AnnotationTypes.COLORS[ AnnotationTypes.FATAL ] ) );
					}
				}
			}
			_annotations.annotations = a;
			_annotations.repaint();
		}
		protected function getLogStartingWithLine(line : String) : String
		{
			for( var i : String in _logs )
			{
				if( StringUtils.stripTags( _logs[i] ).indexOf( StringUtils.trim( line ) ) != -1 )
					return _logs[i];
			}
			return null;
		}
		/*
		override protected function updateTextFormat() : void
		{
			super.updateTextFormat();
			updateAnnotations();
		}*/
	}
}
