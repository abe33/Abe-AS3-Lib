package aesia.com.ponents.demos 
{
	import aesia.com.mon.geom.Dimension;
	import aesia.com.mon.logs.Log;
	import aesia.com.mon.utils.StageUtils;
	import aesia.com.motion.Impulse;
	import aesia.com.patibility.lang._;
	import aesia.com.ponents.actions.builtin.ForceGC;
	import aesia.com.ponents.buttons.Button;
	import aesia.com.ponents.containers.MultiSplitPane;
	import aesia.com.ponents.containers.Panel;
	import aesia.com.ponents.containers.ToolBar;
	import aesia.com.ponents.layouts.components.BorderLayout;
	import aesia.com.ponents.layouts.components.splits.Leaf;
	import aesia.com.ponents.layouts.components.splits.Split;
	import aesia.com.ponents.monitors.GraphMonitor;
	import aesia.com.ponents.monitors.GraphMonitorCaption;
	import aesia.com.ponents.monitors.GraphMonitorRuler;
	import aesia.com.ponents.monitors.LogView;
	import aesia.com.ponents.monitors.recorders.FPSRecorder;
	import aesia.com.ponents.monitors.recorders.MemRecorder;
	import aesia.com.ponents.utils.KeyboardControllerInstance;
	import aesia.com.ponents.utils.ToolKit;

	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.system.System;

	[SWF(frameRate="40")]
	public class MonitorDemo extends Sprite 
	{
		private var monitor : GraphMonitor;
		public function MonitorDemo ()
		{
			MemRecorder.registerMem();
			StageUtils.setup( this );
			StageUtils.flexibleStage();
			ToolKit.initializeToolKit();

			KeyboardControllerInstance.eventProvider = stage;
			Impulse.smoothFactor = 4;
			
			var p : MultiSplitPane = new MultiSplitPane();
			var p2 : Panel = new Panel();
			var l : BorderLayout = new BorderLayout();
			p2.childrenLayout = l;
			var model : Split = new Split(false);
			var lv : LogView = new LogView();
			
			var t : ToolBar = new ToolBar();
			t.addComponent(new Button( new ForceGC( _("Force GC") ) ));
			monitor = new GraphMonitor();
			monitor.addRecorder( new MemRecorder() );			monitor.addRecorder( new MemRecorder( null, null, 2 ) );			monitor.addRecorder( new FPSRecorder() );
			var caption : GraphMonitorCaption = new GraphMonitorCaption( monitor, 1 );
			var ruler1 : GraphMonitorRuler = new GraphMonitorRuler( monitor, monitor.recorders[0] );			var ruler2 : GraphMonitorRuler = new GraphMonitorRuler( monitor, monitor.recorders[0], "left" );
			
			l.center = monitor;
			l.south = caption;			l.west = ruler1;			l.east = ruler2;
			l.north = t;
			p2.addComponent( t );
			p2.addComponent( monitor );
			p2.addComponent( caption );			p2.addComponent( ruler1 );			p2.addComponent( ruler2 );
			
			p.multiSplitLayout.modelRoot = model;
						p.multiSplitLayout.addSplitChild(model, new Leaf( p2 ));
			p.multiSplitLayout.addSplitChild(model, new Leaf( lv ) );
						p.addComponent( p2 );			p.addComponent( lv );
			
			p.preferredSize = new Dimension( 550, 200 );
			
			ToolKit.mainLevel.addChild( p );
			StageUtils.lockToStage(p);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, click);
		}
		
		private function click (event : Event) : void
		{
			for(var i : uint=0;i<10;i++)
			{
				var e : BitmapData = new BitmapData(4000,4000,true);
			}
			Log.debug( "10 bitmap objets created : " + System.totalMemory );
		}
	}
}