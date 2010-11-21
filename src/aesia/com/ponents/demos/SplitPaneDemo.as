package aesia.com.ponents.demos 
{
	import aesia.com.mon.utils.RandomUtils;
	import aesia.com.mon.geom.Dimension;
	import aesia.com.mon.utils.StageUtils;
	import aesia.com.ponents.buttons.Button;
	import aesia.com.ponents.containers.SplitPane;
	import aesia.com.ponents.text.TextArea;
	import aesia.com.ponents.utils.KeyboardControllerInstance;
	import aesia.com.ponents.utils.ToolKit;

	import flash.display.Sprite;

	[SWF(width="700", height="500")]
	public class SplitPaneDemo extends Sprite 
	{
		public function SplitPaneDemo ()
		{
			StageUtils.setup( this );
			ToolKit.initializeToolKit();

			KeyboardControllerInstance.eventProvider = stage;
			
			ToolKit.mainLevel.addChild( createSplitPane(0, 10, 10 ) ); 			ToolKit.mainLevel.addChild( createSplitPane(1, 190, 10, .5, null, NaN, true, false ) ); 
						ToolKit.mainLevel.addChild( createSplitPane(0, 10, 150, .5, new Dimension ( 200, 150 ) ) ); 			ToolKit.mainLevel.addChild( createSplitPane(1, 220, 150, .75, new Dimension ( 200, 150 ), NaN, true, false ) ); 			ToolKit.mainLevel.addChild( createSplitPane(1, 430, 150, .25, new Dimension ( 200, 150 ) , NaN , false) ); 
			
			var nest : SplitPane = new SplitPane( 0, 
												  createSplitPane(1, 0, 0, .6, new Dimension ( 200, 150 ), 75 ),
												  createSplitPane(1, 0, 0, .6, new Dimension ( 200, 150 ), 50 ) );
			
			nest.x = 10;
			nest.y = 310;
			nest.size = new Dimension( 410, 150 );
			
			ToolKit.mainLevel.addChild( nest ); 			ToolKit.mainLevel.addChild( createSplitPane(1, 430, 310, .6, new Dimension ( 200, 150 ), 0, false ) ); 
		}
		protected function createSplitPane ( dir : uint, 
											 x : Number, 
											 y : Number, 
											 weight : Number = .5, 
											 size : Dimension = null,
											 dividerLoc : Number = NaN,  
											 enabled : Boolean = true,
											 oneTE : Boolean = true ) : SplitPane
		{
			var bt : Button = new Button();
			var txt : TextArea = new TextArea();
			
			var splitPane : SplitPane = new SplitPane( dir, bt, txt );
			
			splitPane.x = x;
			splitPane.y = y;
			splitPane.resizeWeight = weight;
			splitPane.enabled = enabled;
			
			if( size )
				splitPane.size = size;
				
			if( !isNaN( dividerLoc ) )
				splitPane.dividerLocation = dividerLoc;
			
			splitPane.oneTouchExpandable = oneTE;
			splitPane.oneTouchExpandFirstComponent = RandomUtils.boolean(.5);
			
			return splitPane;
		}
	}
}
