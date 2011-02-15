package aesia.com.ponents.tools
{
	import aesia.com.mands.ProxyCommand;
	import aesia.com.mon.geom.Range;
	import aesia.com.mon.geom.dm;
	import aesia.com.mon.logs.Log;
	import aesia.com.mon.logs.LogEvent;
	import aesia.com.mon.utils.KeyStroke;
	import aesia.com.mon.utils.Keys;
	import aesia.com.mon.utils.Reflection;
	import aesia.com.mon.utils.StageUtils;
	import aesia.com.mon.utils.StringUtils;
	import aesia.com.motion.Impulse;
	import aesia.com.patibility.lang._;
	import aesia.com.patibility.lang._$;
	import aesia.com.patibility.settings.SettingsManagerInstance;
	import aesia.com.ponents.actions.ActionManagerInstance;
	import aesia.com.ponents.actions.ProxyAction;
	import aesia.com.ponents.actions.builtin.BuiltInActionsList;
	import aesia.com.ponents.actions.builtin.ClearSettingsBackendAction;
	import aesia.com.ponents.actions.builtin.ForceGC;
	import aesia.com.ponents.actions.builtin.LocateWithMouse;
	import aesia.com.ponents.actions.builtin.SaveLogs;
	import aesia.com.ponents.actions.builtin.ShowSettingsBackendAction;
	import aesia.com.ponents.buttons.ButtonDisplayModes;
	import aesia.com.ponents.containers.Panel;
	import aesia.com.ponents.containers.ToolBar;
	import aesia.com.ponents.events.ComponentEvent;
	import aesia.com.ponents.events.DebugEvent;
	import aesia.com.ponents.layouts.components.BorderLayout;
	import aesia.com.ponents.layouts.components.GridLayout;
	import aesia.com.ponents.models.SpinnerNumberModel;
	import aesia.com.ponents.monitors.GraphMonitor;
	import aesia.com.ponents.monitors.GraphMonitorCaption;
	import aesia.com.ponents.monitors.GraphMonitorRuler;
	import aesia.com.ponents.monitors.LogView;
	import aesia.com.ponents.monitors.recorders.FPSRecorder;
	import aesia.com.ponents.monitors.recorders.ImpulseListenerRecorder;
	import aesia.com.ponents.monitors.recorders.MemRecorder;
	import aesia.com.ponents.skinning.icons.magicIconBuild;
	import aesia.com.ponents.spinners.Spinner;
	import aesia.com.ponents.tabs.SimpleTab;
	import aesia.com.ponents.tabs.TabbedPane;
	import aesia.com.ponents.text.Label;
	import aesia.com.ponents.text.TextFieldImpl;
	import aesia.com.ponents.text.TextInput;
	import aesia.com.ponents.tools.prettify.GPrettify;
	import aesia.com.ponents.utils.CardinalPoints;
	import aesia.com.ponents.utils.ComponentResizer;
	import aesia.com.ponents.utils.Insets;
	import aesia.com.ponents.utils.Inspect;
	import aesia.com.ponents.utils.KeyboardControllerInstance;

	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.system.Capabilities;
	import flash.text.StyleSheet;
	import flash.utils.setTimeout;
	/**
	 * @author cedric
	 */
	public class DebugPanel extends TabbedPane
	{
		[Embed(source="../skinning/icons/components/graph.png")]
		static private var monitorIcon : Class;

		[Embed(source="../skinning/icons/components/logs.png")]
		static private var logsIcon : Class;
		
		[Embed(source="../skinning/icons/tools/zoom.png")]
		static private var inspectIcon : Class;
		
		[Embed(source="../skinning/icons/page_white_text.png")]
		static private var saveLogsIcon : Class;
		
		[Embed(source="../skinning/icons/database_delete.png")]
		static private var clearSettingsIcon : Class;
		
		static private var msgTpl : String = "<p><font color='#008800'>exec command $0</font>\n$1</p>";
		
		static protected var prettifier : GPrettify = new GPrettify();
		
		protected var _resizer : ComponentResizer;
		protected var _monitor1 : GraphMonitor;
		protected var _monitor2 : GraphMonitor;
		protected var _logView : LogView;
		protected var _commandInput : TextInput;		protected var _monitorsToolbar : ToolBar;		protected var _logsToolbar : ToolBar;
		protected var _monitorsPanel : Panel;
		protected var _notifier : Notifier;
		
		protected var _commandsList : Object;
		
		protected function help( res : Array ) : void
		{
			var s : String = "";
			var command : String = StringUtils.trim(res[2]);
			if( command )
			{
				if( _commandsList.hasOwnProperty(command) )
				{
					s = helpForCommand(command);
				}
				else 
				{
					Log.error(_$(_("Unknown command '$0'."), command));
					return;
				}
			}
			else
			{
				var keys : Array = [];
				for( var i : String in _commandsList )
					keys.push( (_commandsList[i] as DebugCommandDescriptor).usage );
				
				keys.sort();
				
				s = _$("<li><code>$0</code></li>", keys.join("</code></li><li><code>"));
			}
			
			_logView.writeLine( _$(msgTpl, res[0], s ) );
		}
		protected function helpForCommand( command : String ) : String
		{
			var d : DebugCommandDescriptor = _commandsList[command];
			var opt : String ="";
			var s : String;
			
			if( d.options && d.options.length > 0 )
			{
				opt = _$("\n<h2>Options</h2><li>$0</li>", d.options.map( function(o:DebugCommandDescriptor,... args):*
					{ 
						return "<code>" + o.usage + "</code> : " + o.description; 
				} ).join("</li><li>"));	
			}
			
			s = _$(_("<h1>Command <code>$0</code></h1><h2>Usage</h2>$1\n\n<h2>Description</h2>$2$3" ), 
					d.name, 
					d.usage, 
					d.description,
					opt );
			
			return s;
		}
		protected function locate( res : Array ) : void
		{
			_logView.writeLine( _$(msgTpl, res[0], Inspect.pathTo( Inspect.locate( res[2] ) ) ) );
		}
		protected function inspect( res : Array ) : void
		{
			var s : String = prettifier.prettyPrintOne( Inspect.inspect( Inspect.resolvePath( res[ 2 ] ) ), null, true );
			//Log.debug(s); 
			_logView.writeLine( _$(msgTpl, res[0],  s ) );
		}
		protected function list( res: Array ) : void
		{
			var l : uint = res.length;
			if( l == 2 )
			{
				_logView.writeLine( _$(msgTpl, 
											res[0], 
											Inspect.listDisplay( StageUtils.root, 0 ) ) );
			}
			else
			{
				var recursive : String;
				var recursiveArgs : String;
				var onlyComponents : String;
				var path : String = res[ res.length - 1 ];
				if( !Inspect.isValidPath(path) )
				{
					Log.error(_$(_("Path '$0' is not a valid path in command '$1'.\n$2"), path, res[0], helpForCommand(res[1]) ),true );
					return;
				}
				for( var i : uint = 2; i < l-1; i++ )
				{
					var arg : String = res[i];
					switch(arg)
					{
						case "-c" : 
							if( !onlyComponents )
								onlyComponents = arg;
							break;
						case "-r" : 
							if( !recursive )
							{
								recursive = arg;
								if( (/^\d+$/).test(res[i+1]) )
								{
									recursiveArgs = res[++i];
								}
							}
							break;
						default : 
							Log.error(_$(_("The list command don't accept any arguments like '$0'.\n$2"),arg, helpForCommand(res[1])),true);
							return;
					}
				}
				if( recursive )
				{
					if( !recursiveArgs )
						_logView.writeLine( _$(msgTpl, 
												res[0], 
												Inspect.listDisplay( Inspect.resolvePath( path ) as DisplayObjectContainer, 
																	 0, 
																	 onlyComponents != null ) ) );
					else
						_logView.writeLine( _$(msgTpl, 
												res[0], 
												Inspect.listDisplay( Inspect.resolvePath( path ) as DisplayObjectContainer, 
																	 parseInt( recursiveArgs ), 
																	 onlyComponents != null ) ) );
				}
				else
					_logView.writeLine( _$(msgTpl, res[0], Inspect.listDisplay( Inspect.resolvePath( path ) as DisplayObjectContainer, 
																				-1, 
																				 onlyComponents != null ) ) );
			}
			
				
		}
		protected function eval ( res : Array ) : void
		{
			_logView.writeLine( _$(msgTpl, res[0], Reflection.get( res.slice(2).join(" ") ) ) );
		}
		
		public function DebugPanel ( dock : String = "south" )
		{
			super( dock == "south" ? CardinalPoints.NORTH : CardinalPoints.SOUTH );
			id = "debugPanelTabbedPane";
			
			_preferredSize = dm(150,150 );
			
			buildDefaultTools();
			
			_commandsList = { 
							  'list':new DebugCommandDescriptor("list",
							  									_("<p>List the children of the object in the display list at the specified <code>PATH</code>, if provided, or from the root if no parameters are specified.</p><p>By default, if no path is specified, the command list all the objects recursively from the root. If a path is pecified the listing is not recursive, to list the display list recursively from a specific path use the <code>-r</code> option.</p>"),
							  									"list [-r [RECURSIONS]] [-c] [PATH]",
							  									[ 
							  										new DebugCommandDescriptor("recursive",
							  																 _("Perform the listing recursively if <code>-r</code> is specified. If a value is specified for <code>-r</code> it's use as the maximum number of recursion, otherwise the command list the whole structure."),
							  																 ["-r","-r RECURSIONS"]),
							  										new DebugCommandDescriptor("only components",
							  																 _("While the process encounter a Component, only the component structure is listed."),
							  																 "-c"),						
							  									],
							  									list ),							  'locate':new DebugCommandDescriptor("locate", 
							  									  _("<p>Returns the path to the first object in the display list which name match the passed-in value.</p><p>If there is no objects with this name, the command returns an empty string.</p>"), 
							  									  "locate NAME", 
							  									  null, 
							  									  locate ),							  'inspect':new DebugCommandDescriptor("inspect", 
							  									   _("<p>Inspects the object at <code>PATH</code> in the display list and print the details of its properties in the logs.</p>"), 
							  									   "inspect PATH", 
							  									   null, 
							  									   inspect),
							  'help':new DebugCommandDescriptor("help", 
							  									_(""), 
							  									"help [COMMAND]", 
							  									null, 
							  									help ),
							  'clear':new DebugCommandDescriptor("clear",
							  									 _("<p>Clear the content of the logs.</p>"), 
							  									 "clear", 
							  									 null, 
							  									 _logView.clear),
							  'eval': new DebugCommandDescriptor("eval",
							  									 _("<p>Evaluate <code>EXPRESSION</code> as a source string for the <code>Reflection.get</code> function and print the result.</p>"), 
							  									 "eval EXPRESSION", 
							  									 null, 
							  									 eval )
							};

			KeyboardControllerInstance.addGlobalKeyStroke(KeyStroke.getKeyStroke( Keys.F4 ), new ProxyCommand(swapVisibility ) );
			_logView.writeLine( _$( _("<p>Press the <code>F4</code> key to show/hide the debug tools.\nPlayer Version : <code>$0 $1$2</code>\nOperating System : <code>$3</code>\nSandbox type : <code>$4</code>\n$5</p>"),
						Capabilities.version,
						Capabilities.playerType,						Capabilities.isDebugger ? _(" Debug") : "",
						Capabilities.os,
						Capabilities.localFileReadDisable ? _("Local with file access") : _("Network only"),
						Capabilities.localFileReadDisable ? "" : _("If you experience errors such as <code>SecurityError</code> while loading a file, it's probably due to the sandbox restrictions, please allow the directory where this file is stored in the <font color='#0000ff'><u><a href='http://www.macromedia.com/support/documentation/en/flashplayer/help/settings_manager04.html'>Global Security Settings panel</a></u></font>.")
					  ) );
			Log.getInstance().addEventListener( LogEvent.LOG_ADD, _logView.logAdded );

			switch( dock )
			{
				case CardinalPoints.NORTH :
					_resizer = new ComponentResizer( this, ComponentResizer.BOTTOM_RESIZE_POLICY );
					StageUtils.lockToStage( this,StageUtils.Y_ALIGN_TOP + StageUtils.WIDTH );
					break;
				case CardinalPoints.SOUTH :
				default :
					_resizer = new ComponentResizer( this, ComponentResizer.TOP_RESIZE_POLICY );
					StageUtils.lockToStage( this,StageUtils.Y_ALIGN_BOTTOM + StageUtils.WIDTH );
					break;
			}
			_resizer.addEventListener(Event.RESIZE, resize );

			invalidate(true );
		}
		public function get monitorsPanel () : Panel { return _monitorsPanel; }
		public function get monitor1 () : GraphMonitor { return _monitor1; }
		public function get monitor2 () : GraphMonitor { return _monitor2; }
		public function get logView () : LogView { return _logView; }
		public function get resizer () : ComponentResizer { return _resizer; }
		public function get monitorsToolbar () : ToolBar { return _monitorsToolbar; }
		public function get logsToolbar () : ToolBar { return _logsToolbar; }
		
		public function get commandsList () : Object { return _commandsList; }
		public function set commandsList (commandsList : Object) : void
		{
			_commandsList = commandsList;
		}
		protected function resize ( event : Event ) : void
		{
			StageUtils.stageResize(null);
		}

		protected function buildDefaultTools () : void
		{
			var css : StyleSheet = new StyleSheet();
			css.parseCSS("p { color:#000000; font-family:Monospace; font-size:10px; } " +
						 "h1 { font-weight:bold; font-style:italic; } " +						 "h2 { font-weight:bold; text-decoration:underline; } " +						 "code { color:#660066; display:inline; } " +						 ".str { color:#008800; } " +
						 ".kwd { color:#000088; } " +
						 ".com { color:#880000; } " +
						 ".typ { color:#660066; } " +
						 ".lit { color:#006666; } " +
						 ".pun { color:#666600; } " +
						 ".pln { color:#000000; } " +
						 ".tag { color:#000088; } " +
						 ".atn { color:#660066; } " +
						 ".atv { color:#008800; } " +
						 ".dec { color:#660066; }" );
			
			var p0 : Panel = new Panel();
			var l0 : BorderLayout = new BorderLayout();
			p0.childrenLayout = l0;
			_logView = new LogView();
			_logView.logsLimit = 500;
			(_logView.textfield as TextFieldImpl).styleSheet = css;
			_logView.addEventListener(DebugEvent.NOTIFY_WARNING, notifyWarning );
			_logView.addEventListener(DebugEvent.NOTIFY_ERROR, notifyError );			_logsToolbar = new ToolBar( ButtonDisplayModes.ICON_ONLY, false, 1, false );
			_notifier = new Notifier ( new ProxyAction ( notifierClick, _( "Error" ), magicIconBuild ( Notifier.errorIcon ) ) );
						
			_commandInput = new TextInput( 0, false, "commandInput", false );
			_commandInput.preferredWidth = 250;
			_commandInput.addEventListener(ComponentEvent.DATA_CHANGE, commandInputDataChange );
			_logsToolbar.addComponents( new Label(_("Input :" ), _commandInput ), _commandInput );
			_logsToolbar.addSeparator();
			
			ActionManagerInstance.registerAction(new ProxyAction( _logView.clear, _("Clear Logs"), null,null, KeyStroke.getKeyStroke( Keys.L, KeyStroke.getModifiers(true) ) ), 
												 BuiltInActionsList.CLEAR_LOGS );
			ActionManagerInstance.registerAction(new SaveLogs( _logView, "logs.txt", null, _("Save logs"), magicIconBuild(saveLogsIcon),_("Save the logs in a file.")), 
												 BuiltInActionsList.SAVE_LOGS );
			ActionManagerInstance.registerAction(new LocateWithMouse(_("Inspect"), magicIconBuild(inspectIcon), _("Move the mouse above the scene and click to print in the logs the path to the object under the mouse.")), 
												 BuiltInActionsList.LOCATE_WITH_MOUSE);			ActionManagerInstance.registerAction(new ForceGC(_("GC"),null,_("Force the garbage collector\nto perform a memory check.\n<b>Debug Player only</b>.")), 
												 BuiltInActionsList.FORCE_GC );
			
			_logsToolbar.addAction( ActionManagerInstance.getAction( BuiltInActionsList.SAVE_LOGS ) );			_logsToolbar.addAction( ActionManagerInstance.getAction( BuiltInActionsList.LOCATE_WITH_MOUSE ) );
			
			/*FDT_IGNORE*/ FEATURES::SETTINGS_MEMORY { /*FDT_IGNORE*/
			if( SettingsManagerInstance.backend )
			{
				ActionManagerInstance.registerAction( new ShowSettingsBackendAction(_("Show Settings") ), 
													  BuiltInActionsList.SHOW_SETTINGS );				ActionManagerInstance.registerAction( new ClearSettingsBackendAction(_("Clear Settings"), magicIconBuild( clearSettingsIcon ), _( "Delete all the data recorded by the settings backend of this application.\nSettings includes datas such as the textinputs history or the layout settings of many components.") ), 
													  BuiltInActionsList.CLEAR_SETTINGS );
			
				_logsToolbar.addAction( ActionManagerInstance.getAction( BuiltInActionsList.CLEAR_SETTINGS ) );				_logsToolbar.addAction( ActionManagerInstance.getAction( BuiltInActionsList.SHOW_SETTINGS ) );
			}
			/*FDT_IGNORE*/ } /*FDT_IGNORE*/
			
			
			l0.center = _logView;
			l0.south = _logsToolbar;
			
			p0.addComponents( _logView, _logsToolbar );
			
			var p1 : Panel = new Panel();
			var l1 : BorderLayout = new BorderLayout();
			p1.childrenLayout = l1;
			_monitor1 = new GraphMonitor();
			_monitor1.addRecorder( new MemRecorder( new Range( 0,60 ) ) );
			
			/*FDT_IGNORE*/ TARGET::FLASH_10_1 { /*FDT_IGNORE*/				
			_monitor1.addRecorder( new MemRecorder( new Range( 0,60 ), null, 1 ) );			_monitor1.addRecorder( new MemRecorder( new Range( 0,60 ), null, 0 ) );			/*FDT_IGNORE*/ } /*FDT_IGNORE*/

			var r1 : GraphMonitorRuler = new GraphMonitorRuler( _monitor1, _monitor1.recorders[0] );
			var c1 : GraphMonitorCaption = new GraphMonitorCaption(_monitor1);
			c1.captionMode = GraphMonitorCaption.SHORT_LABEL_MODE;
			c1.layoutMode = GraphMonitorCaption.COLUMN_3_LAYOUT_MODE;

			_monitorsToolbar = new ToolBar( ButtonDisplayModes.TEXT_ONLY, false, 1, false );

			var lfps : Label = new Label( _("FPS :") );

			var fps : Spinner = new Spinner(new SpinnerNumberModel(StageUtils.stage.frameRate, 12, 120, 1, true));
			fps.addEventListener(ComponentEvent.DATA_CHANGE, changeFramerate );
			fps.preferredWidth = 60;

			lfps.tooltip = _("Change the current framerate\nof this animation.");

			_monitorsToolbar.addComponent( lfps );
			_monitorsToolbar.addComponent( fps );

			_monitorsToolbar.addSeparator();
			_monitorsToolbar.addAction( ActionManagerInstance.getAction( BuiltInActionsList.FORCE_GC ) );
			
			l1.west = r1;
			l1.center = _monitor1;
			l1.south = c1;

			p1.addComponent(r1);
			p1.addComponent(_monitor1);
			p1.addComponent(c1);
			
			_monitor2 = new GraphMonitor();
			_monitor2.addRecorder( new FPSRecorder() );
			_monitor2.addRecorder( new ImpulseListenerRecorder( Impulse ) );
			
			var p2 : Panel = new Panel();
			var l2 : BorderLayout = new BorderLayout();
			p2.childrenLayout = l2;
			var r2 : GraphMonitorRuler = new GraphMonitorRuler( _monitor2, _monitor2.recorders[0] );
			var c2 : GraphMonitorCaption = new GraphMonitorCaption(_monitor2);
			c2.captionMode = GraphMonitorCaption.SHORT_LABEL_MODE;
			c2.layoutMode = GraphMonitorCaption.COLUMN_3_LAYOUT_MODE;
			l2.west = r2;
			l2.center = _monitor2;
			l2.south = c2;
			
			p2.addComponent(r2);
			p2.addComponent(_monitor2);
			p2.addComponent(c2);

			var pmon : Panel = new Panel();
			var lmon : BorderLayout = new BorderLayout(pmon, true);
			pmon.childrenLayout = lmon;
			
			_monitorsPanel = new Panel();
			_monitorsPanel.childrenLayout = new GridLayout(_monitorsPanel, 1 );
			_monitorsPanel.style.setForAllStates("insets", new Insets(0, 0, 4, 0));
			_monitorsPanel.addComponent(p1);
			_monitorsPanel.addComponent(p2);
			
			p0.name = "logsPanel";
			p1.name = "memoryMonitorsPanel";
			p2.name = "fpsMonitorsPanel";
			pmon.name = "monitorsPanel";
			_commandInput.name = "commandInput";
			_logView.name = "logView";
			_logsToolbar.name = "logsToolBar";
			_monitorsToolbar.name = "monitorsToolBar";
			_monitor1.name = "memoryMonitor";
			_monitor2.name = "fpsMonitor";			_monitorsPanel.name = "monitorsGrid";
			
			c1.name = c1.id = "monitor1Caption";
			c2.name = c2.id = "monitor2Caption";

			lmon.north = _monitorsToolbar;
			lmon.center = _monitorsPanel;

			pmon.addComponent(_monitorsToolbar);
			pmon.addComponent(_monitorsPanel);
			pmon.styleKey = "DefaultComponent";

			//var split : SplitPane = new SplitPane( SplitPane.HORIZONTAL_SPLIT, _logView, pmon );
			//split.styleKey = "DefaultComponent";			//split.dividerLocation = 200;
			styleKey = "DefaultComponent";

			//addTab( new SimpleTab( _("Misc"), split ) );			addTab( new SimpleTab( _("Logs"), p0, magicIconBuild( logsIcon ) ) );			addTab( new SimpleTab( _("Monitoring"), pmon, magicIconBuild( monitorIcon ) ) );
		}

		protected function commandInputDataChange (event : ComponentEvent) : void 
		{
			var s : String = StringUtils.trim(_commandInput.value ).replace(/[\t\n\r\s]+/g, " ");
			if( s != "" )
			{
				var key : String = s.split(/\s+/g)[0];
				if( _commandsList.hasOwnProperty(key) )
				{
					var a : DebugCommandDescriptor = _commandsList[key] as DebugCommandDescriptor;
					var res : Array = s.split(/\s+/g);
					res.unshift( s );
					a.fn(res); 
				}
				else
					Log.warn(_$(_("Unknown command '$0'"), StringUtils.escape(s) ) );
				
				_commandInput.value = "";
				setTimeout(_commandInput.grabFocus,50);
			}
		}
		protected function notifierClick () : void
		{
			visible = true;
		}
		protected function notifyError ( event : DebugEvent ) : void
		{
			_notifier.errors++;
			_notifier.show();
		}
		protected function notifyWarning ( event : DebugEvent ) : void
		{
			_notifier.warnings++;
			_notifier.show();
		}
		protected function changeFramerate (event : ComponentEvent) : void
		{
			StageUtils.stage.frameRate = (event.target as Spinner).value;
		}
		protected function swapVisibility () : void
		{
			this.visible = !this.visible;
			if( visible && _notifier.visible )
				_notifier.hide( );
		}
	}
}

import aesia.com.motion.SingleTween;
import aesia.com.patibility.lang._;
import aesia.com.patibility.lang._$;
import aesia.com.ponents.buttons.Button;
import aesia.com.ponents.layouts.display.DOInlineLayout;
import aesia.com.ponents.skinning.icons.Icon;
import aesia.com.ponents.utils.ToolKit;

import flash.events.Event;

[Skinable(skin="ErrorNotifier")]
[Skin(define="ErrorNotifier",
 	  inherit="DefaultComponent",
	  state__all__background="new aesia.com.ponents.skinning.decorations::SimpleFill(color(Gold))",	  state__all__foreground="new aesia.com.ponents.skinning.decorations::SimpleBorders(color(Orange))",
	  state__all__insets="new aesia.com.ponents.utils::Insets(2)",
	  state__all__corners="new aesia.com.ponents.utils::Corners(2)"
)]
internal class Notifier extends Button
{
	[Embed(source="../skinning/icons/error.png")]
	static public var errorIcon : Class;

	public var errors : uint;	public var warnings : uint;

	public function Notifier ( actionOrLabel : * = null, icon : Icon = null )
	{
		super( actionOrLabel, icon );
		_allowOver = false;		_allowPressed = false;		_allowFocus = false;		_allowSelected = false;
		errors = 0;		warnings = 0;
		visible = false;
		(_childrenLayout as DOInlineLayout).direction = "rightToLeft";
		x = 5;		y = 5;
	}

	public function blink() : void
	{

	}
	public function stopBlink() : void
	{

	}

	public function show () : void
	{
		var s : String = "";
		if( warnings > 0 )
			s += _$(_("$0 Warnings"), warnings );
		if( warnings > 0 &&  errors > 0 )
			s += ", ";
		if( errors > 0 )
			s += _$(_("$0 Errors"), errors );
		label = s;

		if(!visible)
		{
			visible = true;
			ToolKit.popupLevel.addChild( this );
			SingleTween.add( this, { setter:"alpha",
									 duration:500,
									 end:1,
									 start:0
								   });
			blink();
		}
	}
	public function hide () : void
	{
		errors = 0;
		warnings = 0;
		visible = false;
		parent.removeChild( this );
		stopBlink();
		SingleTween.add( this, { setter:"alpha",
								 duration:500,
								 end:0,
								 start:1
							   });
	}
	override public function click ( e : Event = null ) : void
	{
		super.click ( e );
		hide();
	}
}