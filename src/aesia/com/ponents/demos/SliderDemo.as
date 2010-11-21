package aesia.com.ponents.demos 
{
	import aesia.com.mon.geom.Dimension;
	import aesia.com.mon.logs.Log;
	import aesia.com.mon.utils.StageUtils;
	import aesia.com.ponents.models.DefaultBoundedRangeModel;
	import aesia.com.ponents.monitors.LogView;
	import aesia.com.ponents.sliders.HSlider;
	import aesia.com.ponents.sliders.VSlider;
	import aesia.com.ponents.text.Label;
	import aesia.com.ponents.utils.KeyboardControllerInstance;
	import aesia.com.ponents.utils.ToolKit;

	import flash.display.Sprite;

	/**
	 * @author Cédric Néhémie
	 */
	public class SliderDemo extends Sprite 
	{
		public function SliderDemo ()
		{
			StageUtils.setup( this );
			ToolKit.initializeToolKit();
			
			var lv : LogView = new LogView();
			lv.y = 150;
			lv.x = 150;
			lv.size = new Dimension( 400, 250 );
			ToolKit.mainLevel.addChild( lv );
			
			KeyboardControllerInstance.eventProvider = stage;
			try
			{
				
				var slider1 : HSlider = new HSlider( new DefaultBoundedRangeModel( 10 ) );
				slider1.x = 20;							slider1.y = 20;	
				
				var slider2 : HSlider = new HSlider( new DefaultBoundedRangeModel( 20 ) );
				slider2.snapToTicks = true;
				slider2.x = 20;			
				slider2.y = 70;		
				
				var slider3 : HSlider = new HSlider( new DefaultBoundedRangeModel( 30, 0, 50 ), 10, 1 );
				slider3.displayTicks = true;
				slider3.x = 20;			
				slider3.y = 120;
				slider3.preferredWidth = 300;
				slider3.displayInput = false;				
				var slider4 : HSlider = new HSlider( new DefaultBoundedRangeModel( 40 ) );
				slider4.displayTicks = true;
				slider4.snapToTicks = true;
				slider4.preComponent = new Label( "min" );
				slider4.postComponent = new Label( "max" );
				slider4.x = 20;			
				slider4.y = 170;			
				slider4.preferredWidth = 300;
				
				var slider5 : HSlider = new HSlider( new DefaultBoundedRangeModel( 50 ) );
				slider5.preComponent = new Label( "min" );				slider5.postComponent = new Label( "max" );
				slider5.displayInput = false;
				slider5.x = 20;			
				slider5.y = 220;
				slider5.enabled = false;	
				
				var slider6 : VSlider = new VSlider( new DefaultBoundedRangeModel( 20 ) );
				slider6.y = 10;			
				slider6.x = 340;
				
				var slider7 : VSlider = new VSlider( new DefaultBoundedRangeModel( 30, 0, 50 ), 10, 2 );
				slider7.y = 10;			
				slider7.x = 400;
				slider7.displayTicks = true;				slider7.snapToTicks = true;
				slider7.preComponent = new Label( "min" );
				slider7.postComponent = new Label( "max" );
				
				var slider8 : VSlider = new VSlider( new DefaultBoundedRangeModel( 50 ) );
				slider8.y = 10;			
				slider8.x = 460;
				slider8.displayTicks = true;
				slider8.displayInput = false;
				slider8.snapToTicks = true;
				slider8.preComponent = new Label( "min" );
				slider8.postComponent = new Label( "max" );
				
				ToolKit.mainLevel.addChild( slider1 );				ToolKit.mainLevel.addChild( slider2 );				ToolKit.mainLevel.addChild( slider3 );				ToolKit.mainLevel.addChild( slider4 );				ToolKit.mainLevel.addChild( slider5 );				ToolKit.mainLevel.addChild( slider6 );				ToolKit.mainLevel.addChild( slider7 );				ToolKit.mainLevel.addChild( slider8 );
			}
			catch(e : Error )
			{
				Log.error( e.message + "\n" + e.getStackTrace() );
			}
		}
	}
}
