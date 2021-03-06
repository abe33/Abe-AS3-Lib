package abe.com.ponents.monitors
{
	import abe.com.mands.ProxyCommand;
	import abe.com.mon.logs.LogLevel;
	import abe.com.mon.utils.KeyStroke;
	import abe.com.mon.utils.Keys;
	import abe.com.mon.utils.StringUtils;
	import abe.com.patibility.lang._;
	import abe.com.patibility.lang._$;
	import abe.com.ponents.layouts.display.DOBoxSettings;
	import abe.com.ponents.layouts.display.DOHBoxLayout;
	import abe.com.ponents.scrollbars.annotations.Annotation;
	import abe.com.ponents.scrollbars.annotations.AnnotationTypes;
	import abe.com.ponents.scrollbars.annotations.ScrollBarAnnotations;
	import abe.com.ponents.text.TextArea;
	import abe.com.ponents.text.TextLineRuler;
	import abe.com.ponents.utils.ContextMenuItemUtils;

	import flash.display.DisplayObject;
	import flash.events.ContextMenuEvent;
	import flash.events.Event;
	import flash.text.TextFieldType;
	
	import org.osflash.signals.Signal;

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
		protected var _logs : Array;
		protected var _logsLimit : uint;
		protected var _logsLevel : LogLevel;

		protected var _lineRuler : TextLineRuler;

		protected var _annotations : ScrollBarAnnotations;
		protected var _annotateErrors : Boolean;
		protected var _annotateWarnings : Boolean;
		protected var _annotateFatals : Boolean;

		protected var _notifyWarnings : Boolean;
		protected var _notifyErrors : Boolean;
		
		public var warningOccured : Signal;
		public var errorOccured : Signal;

		public function LogView ()
		{
			super( );
			
			warningOccured = new Signal();
			errorOccured = new Signal();
			
			_logsLimit = 100;
			_logs = [];
			_label.type = TextFieldType.DYNAMIC;
			_logsLevel = LogLevel.DEBUG;

			_allowHTML = true;
			_annotateWarnings = true;
			_annotateErrors = true;
			_annotateFatals = true;

			_notifyWarnings = true;
			_notifyErrors = true;

			_lineRuler = new TextLineRuler(_label, this);
            _lineRuler.name = "lineRuler";
			/*addComponentChildBefore(_lineRuler, _label as DisplayObject);
			( _childrenLayout as DOHBoxLayout ).boxes.unshift( new DOBoxSettings(0, "left", "center", _lineRuler, false, true, false ) );
*/
			_annotations = new ScrollBarAnnotations( _scrollbar );
            _annotations.name = "annotations";
			/*addComponentChildAfter(_annotations, _scrollbar);
			( _childrenLayout as DOHBoxLayout ).boxes.push( new DOBoxSettings(0, "left", "center", _annotations, false, true, false ) );
*/
			_leftGutter.addComponent( _lineRuler );
            _rightGutter.addComponent(_annotations );
            
            invalidatePreferredSizeCache();

			FEATURES::MENU_CONTEXT { 
				createContextMenu();
			} 

			FEATURES::KEYBOARD_CONTEXT { 
				_keyboardContext[ KeyStroke.getKeyStroke( Keys.DELETE ) ] = new ProxyCommand( clear );
				_keyboardContext[ KeyStroke.getKeyStroke( Keys.BACKSPACE ) ] = new ProxyCommand( clear );
			} 
		}

		public function get annotations() : ScrollBarAnnotations{ return _annotations; }
		public function get logsLevel () : LogLevel { return _logsLevel; }
		public function set logsLevel (logsLevel : LogLevel) : void
		{
			_logsLevel = logsLevel;
			FEATURES::MENU_CONTEXT { 
			    updateFiltersMenuItemCaptions ();
			} 
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
			FEATURES::MENU_CONTEXT { 
			    updateAnnotateMenuItemCaptions();
			} 
			printLogs();
		}
		public function get annotateWarnings() : Boolean { return _annotateWarnings; }
		public function set annotateWarnings(annotateWarnings : Boolean) : void
		{
			_annotateWarnings=annotateWarnings;
			FEATURES::MENU_CONTEXT { 
			    updateAnnotateMenuItemCaptions();
			} 
			printLogs();
		}
		public function get annotateFatals() : Boolean { return _annotateFatals; }
		public function set annotateFatals(annotateFatals : Boolean) : void
		{
			_annotateFatals=annotateFatals;
			FEATURES::MENU_CONTEXT { 
			    updateAnnotateMenuItemCaptions();
			} 
			printLogs();
		}
		public function get notifyWarnings() : Boolean { return _notifyWarnings; }
		public function set notifyWarnings(notifyWarnings : Boolean) : void
		{
			_notifyWarnings=notifyWarnings;
			FEATURES::MENU_CONTEXT { 
			    updateNotifyMenuItemCaptions();
			} 
		}
		public function get notifyErrors() : Boolean { return _notifyErrors; }
		public function set notifyErrors(notifyErrors : Boolean) : void
		{
			_notifyErrors=notifyErrors;
			FEATURES::MENU_CONTEXT { 
			    updateNotifyMenuItemCaptions();
			} 
		}

		FEATURES::MENU_CONTEXT { 
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
		} 

		public function clear (... args) : void
		{
			_logs = [];
			printLogs();
		}
		public function logAdded ( msg : String, level : LogLevel, keepHTML : Boolean ) : void
		{
			if( keepHTML )
			{
				writeLine(_$("<p><b><font color='$0'>$1 : </font></b>$2</p>",
							level.color,
							level.name,
							msg ) );
			}
			else
			{
				var line : XML = <p><b><font color={level.color}>{level.name} : </font></b> {msg}</p>;
				XML.prettyPrinting = false;
				writeLine( line.toXMLString() );
			}
			if( level.level >= LogLevel.WARN.level )
			{
				if( _notifyWarnings &&
					level.level == LogLevel.WARN.level &&
					!isVisible )
					warningOccured.dispatch( this );
				else if( _notifyErrors &&
						level.level >= LogLevel.ERROR.level &&
						!isVisible )
					errorOccured.dispatch( this );
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
			for( var i:uint = 0; i < _label.numLines; i++ )
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
