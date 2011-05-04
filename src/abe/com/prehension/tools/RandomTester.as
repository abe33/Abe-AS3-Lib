package abe.com.prehension.tools{
	import abe.com.ponents.utils.Insets;
	import abe.com.mon.logs.Log;
	import abe.com.mon.randoms.BaileyCrandallRandom;
	import abe.com.mon.randoms.LaggedFibonnacciRandom;
	import abe.com.mon.randoms.LinearCongruentialRandom;
	import abe.com.mon.randoms.MathRandom;
	import abe.com.mon.randoms.MersenneTwisterRandom;
	import abe.com.mon.randoms.NoiseRandom;
	import abe.com.mon.randoms.PerlinRandom;
	import abe.com.mon.utils.StageUtils;
	import abe.com.ponents.containers.Panel;
	import abe.com.ponents.layouts.components.GridLayout;
	import abe.com.ponents.monitors.RandomMonitor;
	import abe.com.ponents.tools.DebugPanel;
	import abe.com.ponents.utils.KeyboardControllerInstance;
	import abe.com.ponents.utils.ToolKit;

	import flash.display.Sprite;

	[SWF(width="800",height="500")]
	public class RandomTester extends Sprite 
	{
		public function RandomTester ()
		{
			StageUtils.setup(this);
			StageUtils.flexibleStage();
			ToolKit.initializeToolKit();
			
			var p : DebugPanel = new DebugPanel();
			ToolKit.popupLevel.addChild(p);
			p.visible = false;
			KeyboardControllerInstance.eventProvider = stage;
			
			try
			{
				var grid : Panel= new Panel();
				grid.childrenLayout = new GridLayout( grid, 2, 4, 4, 4);
				grid.style.insets = new Insets(4);
				grid.height = 500;
				
				var generators : Array = [ MathRandom, 		LinearCongruentialRandom, 	LaggedFibonnacciRandom, 	MersenneTwisterRandom, 
										   PerlinRandom, 	NoiseRandom, 				BaileyCrandallRandom ];
				for each ( var g : Class in generators )
				{
					var tester : RandomMonitor = new RandomMonitor( new g() );
					grid.addComponent( tester );
					tester.start();
				}
				ToolKit.mainLevel.addChild( grid );
				StageUtils.lockToStage( grid, StageUtils.WIDTH );
				
			}
			catch( e : Error ) 
			{
				Log.error( e.message + "\n" + e.getStackTrace() );
			}
		}
	}
}
