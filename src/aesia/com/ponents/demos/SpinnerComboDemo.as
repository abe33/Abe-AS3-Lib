package aesia.com.ponents.demos 
{
	import aesia.com.ponents.spinners.QuadSpinner;
	import aesia.com.ponents.utils.Insets;
	import aesia.com.mon.geom.Dimension;
	import aesia.com.mon.logs.Log;
	import aesia.com.mon.utils.StageUtils;
	import aesia.com.ponents.monitors.LogView;
	import aesia.com.ponents.spinners.DoubleSpinner;
	import aesia.com.ponents.utils.KeyboardControllerInstance;
	import aesia.com.ponents.utils.ToolKit;

	import flash.display.Sprite;

	/**
	 * @author cedric
	 */
	public class SpinnerComboDemo extends Sprite 
	{
		public function SpinnerComboDemo ()
		{
			StageUtils.setup(this);
			StageUtils.flexibleStage();
			ToolKit.initializeToolKit();
			
			var lv : LogView;			
			lv = new LogView();
			ToolKit.mainLevel.addChild(lv);
			StageUtils.lockToStage(lv,257);
			
			KeyboardControllerInstance.eventProvider = stage;
			
			try
			{
				var d : Dimension = new Dimension(100, 150);
				var ds : DoubleSpinner = new DoubleSpinner(d, "width", "height");
				
				var i : Insets = new Insets(1, 2, 3, 4);
				var qs : QuadSpinner = new QuadSpinner( i, "top", "bottom", "left", "right", 0, 10, 1 );
				
				ds.x = 10;				ds.y = 10;
				qs.x = 10;
				qs.y = 50;
				
				ds.preferredWidth = 400;				qs.preferredWidth = 400;
				
				ToolKit.mainLevel.addChild( ds );				ToolKit.mainLevel.addChild( qs );
			}
			catch( e : Error ) 
			{
				Log.error( e.message + "\n" + e.getStackTrace() );
			}
		}
	}
}
