package aesia.com.ponents.demos 
{
	import aesia.com.mon.geom.Dimension;
	import aesia.com.mon.utils.StageUtils;
	import aesia.com.ponents.text.TextArea;
	import aesia.com.ponents.text.TextInput;
	import aesia.com.ponents.utils.Corners;
	import aesia.com.ponents.utils.Insets;
	import aesia.com.ponents.utils.KeyboardControllerInstance;
	import aesia.com.ponents.utils.ToolKit;

	import flash.display.Sprite;

	/**
	 * @author Cédric Néhémie
	 */
	public class TextDemo extends Sprite 
	{
		[Embed(source="bgstretch.png")]
		private var bgClass : Class;
		
		public function TextDemo ()
		{
			StageUtils.setup( this );
			ToolKit.initializeToolKit();

			KeyboardControllerInstance.eventProvider = stage;
			
			var t1 : TextInput = new TextInput( 20 );			var t2 : TextInput = new TextInput( 10, true );			var t3 : TextInput = new TextInput( 20 );
						var t4 : TextArea = new TextArea();			var t5 : TextArea = new TextArea();
			
			ToolKit.mainLevel.addChild( t1 );			ToolKit.mainLevel.addChild( t2 );			ToolKit.mainLevel.addChild( t3 );			ToolKit.mainLevel.addChild( t4 );			ToolKit.mainLevel.addChild( t5 );
			
			t1.x = 50;
			t1.y = 20;
			t1.value = "enabled";
			
			t2.x = 160;
			t2.y = 20;
			t2.value = "enabled";
			
			t3.x = 270;
			t3.y = 20;
			t3.value = "disabled";
			t3.enabled = false;
			
			t4.x = 50;
			t4.y = 45;
			t4.value = "enabled";
			t4.preferredSize = new Dimension( 150, 70 );
			
			t5.x = 220;
			t5.y = 45;
			t5.enabled = false;
			t5.value = "disabled";
			t5.preferredSize = new Dimension( 150, 70 );
			
			t5.style.setForAllStates( "insets" , new Insets(5,5,5,5) )
					.setForAllStates( "cornerRadius", new Corners(5) );/*
					.setForAllStates( "fill" , new SlicedBitmapFill( new bgClass().bitmapData, new Rectangle( 8, 8, 24, 24 ) ) )
					.setForAllStates( "stroke", new NoStroke() );
		
			
			
			
			t4.style.states[ ComponentStates.FOCUS ].fill = new SimpleFill( Color.YellowGreen );			t4.style.states[ ComponentStates.FOCUS + ComponentStates.OVER ].fill = new SimpleFill( Color.Red );
			t4.allowOver = true;*/
		}
	}
}
