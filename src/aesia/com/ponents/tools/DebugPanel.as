package aesia.com.ponents.tools
{
	import aesia.com.mands.ProxyCommand;
	import aesia.com.mon.geom.Range;
	import aesia.com.mon.geom.dm;
	import aesia.com.mon.logs.Log;
	import aesia.com.mon.utils.KeyStroke;
	import aesia.com.mon.utils.Keys;
	import aesia.com.mon.utils.StageUtils;
	import aesia.com.motion.Impulse;
	import aesia.com.patibility.lang._;
	import aesia.com.patibility.lang._$;
	import aesia.com.ponents.actions.ProxyAction;
	import aesia.com.ponents.actions.builtin.ForceGC;
	import aesia.com.ponents.buttons.Button;
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
	import aesia.com.ponents.utils.CardinalPoints;
	import aesia.com.ponents.utils.ComponentResizer;
	import aesia.com.ponents.utils.Insets;
	import aesia.com.ponents.utils.KeyboardControllerInstance;

	import flash.events.Event;
	import flash.system.Capabilities;

	/**
	 * @author cedric
	 */
	public class DebugPanel extends TabbedPane
	{
		[Embed(source="../skinning/icons/chart_curve.png")]
		static private var monitorIcon : Class;

		[Embed(source="../skinning/icons/application.png")]
		static private var logsIcon : Class;

		protected var _resizer : ComponentResizer;
		protected var _monitor1 : GraphMonitor;
		protected var _monitor2 : GraphMonitor;
		protected var _logView : LogView;
		protected var _toolbar : ToolBar;
		protected var _monitorsPanel : Panel;
		protected var _notifier : Notifier;

		public function DebugPanel ( dock : String = "south" )
		{
			super( dock == "south" ? CardinalPoints.NORTH : CardinalPoints.SOUTH );
			_preferredSize = dm(150,150);
			buildDefaultTools();

			KeyboardControllerInstance.addGlobalKeyStroke(KeyStroke.getKeyStroke( Keys.F4 ), new ProxyCommand(swapVisibility));
			Log.info( _$(_("Press the F4 key to show/hide the debug tools.\n<b>Player Version :</b> $0 $1$2\n<b>Operating System :</b> $3\n<b>Sandbox type :</b> $4\n$5"),
						Capabilities.version,
						Capabilities.playerType,						Capabilities.isDebugger ? _(" Debug") : "",
						Capabilities.os,
						Capabilities.localFileReadDisable ? _("Local with file access") : _("Network only"),
						Capabilities.localFileReadDisable ? "" : _("If you experience errors such as <b>SecurityError</b> while loading a file, it's probably due to the sandbox restrictions, please allow the directory where this file is stored in the <font color='#0000ff'><u><a href='http://www.macromedia.com/support/documentation/en/flashplayer/help/settings_manager04.html'>Global Security Settings panel</a></u></font>.")
						 ), true );

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

			invalidate(true);
		}
		public function get monitorsPanel () : Panel { return _monitorsPanel; }
		public function get monitor1 () : GraphMonitor { return _monitor1; }
		public function get monitor2 () : GraphMonitor { return _monitor2; }
		public function get logView () : LogView { return _logView; }
		public function get resizer () : ComponentResizer { return _resizer; }
		public function get toolbar () : ToolBar { return _toolbar; }

		protected function resize ( event : Event ) : void
		{
			StageUtils.stageResize(null);
		}

		protected function buildDefaultTools () : void
		{
			_logView = new LogView();
			_logView.logsLimit = 1000;
			_logView.addEventListener(DebugEvent.NOTIFY_WARNING, notifyWarning );			_logView.addEventListener(DebugEvent.NOTIFY_ERROR, notifyError );

			_notifier = new Notifier ( new ProxyAction ( notifierClick, _( "Error" ), magicIconBuild ( Notifier.errorIcon ) ) );

			var p1 : Panel = new Panel();
			var l1 : BorderLayout = new BorderLayout();
			p1.childrenLayout = l1;
			_monitor1 = new GraphMonitor();
			_monitor1.addRecorder( new MemRecorder( new Range( 0,60 ) ) );			_monitor1.addRecorder( new MemRecorder( new Range( 0,60 ), null, 1 ) );			_monitor1.addRecorder( new MemRecorder( new Range( 0,60 ), null, 0 ) );


			var r1 : GraphMonitorRuler = new GraphMonitorRuler( _monitor1, _monitor1.recorders[0] );
			var c1 : GraphMonitorCaption = new GraphMonitorCaption(_monitor1);
			c1.captionMode = GraphMonitorCaption.SHORT_LABEL_MODE;
			c1.layoutMode = GraphMonitorCaption.COLUMN_3_LAYOUT_MODE;

			_toolbar = new ToolBar( ButtonDisplayModes.TEXT_ONLY, false, 1, false );

			var gc : Button = new Button(new ForceGC(_("GC"),null,_("Force the garbage collector\nto perform a memory check.\n<b>Debug Player only</b>.")));

			var lfps : Label = new Label(_("FPS :") );

			var fps : Spinner = new Spinner(new SpinnerNumberModel(StageUtils.stage.frameRate, 12, 120, 1, true));
			fps.addEventListener(ComponentEvent.DATA_CHANGE, changeFramerate );
			fps.preferredWidth = 60;

			lfps.tooltip = _("Change the current framerate\nof this animation.");

			_toolbar.addComponent( lfps );
			_toolbar.addComponent( fps );

			_toolbar.addSeparator();
			_toolbar.addComponent(gc );


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

			lmon.north = _toolbar;
			lmon.center = _monitorsPanel;

			pmon.addComponent(_toolbar);
			pmon.addComponent(_monitorsPanel);
			pmon.styleKey = "DefaultComponent";

			//var split : SplitPane = new SplitPane( SplitPane.HORIZONTAL_SPLIT, _logView, pmon );
			//split.styleKey = "DefaultComponent";			//split.dividerLocation = 200;
			styleKey = "DefaultComponent";

			//addTab( new SimpleTab( _("Misc"), split ) );			addTab( new SimpleTab( _("Logs"), _logView, magicIconBuild( logsIcon ) ) );			addTab( new SimpleTab( _("Monitoring"), pmon, magicIconBuild( monitorIcon ) ) );
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
				_notifier.hide();
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