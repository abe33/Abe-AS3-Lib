package aesia.com.ponents.demos 
{
	import aesia.com.mon.logs.Log;
	import aesia.com.mon.utils.Color;
	import aesia.com.mon.utils.Gradient;
	import aesia.com.mon.utils.StageUtils;
	import aesia.com.ponents.actions.builtin.ColorPickerAction;
	import aesia.com.ponents.actions.builtin.GradientPickerAction;
	import aesia.com.ponents.buttons.Button;
	import aesia.com.ponents.monitors.LogView;
	import aesia.com.ponents.utils.KeyboardControllerInstance;
	import aesia.com.ponents.utils.ToolKit;

	import flash.display.Sprite;

	/**
	 * @author Cédric Néhémie
	 */
	public class ColorPickerActionDemo extends Sprite 
	{
		public function ColorPickerActionDemo ()
		{
			StageUtils.setup(this);
			StageUtils.flexibleStage();
			ToolKit.initializeToolKit();
			
			var lv : LogView;			
			lv = new LogView();
			ToolKit.mainLevel.addChild(lv);
			StageUtils.lockToStage(lv, StageUtils.WIDTH + StageUtils.Y_ALIGN_BOTTOM);
			
			KeyboardControllerInstance.eventProvider = stage;
			
			try
			{
				var a : ColorPickerAction = new ColorPickerAction( Color.YellowGreen.clone() );				var b : GradientPickerAction = new GradientPickerAction(new Gradient([Color.CornflowerBlue, Color.Navy, Color.LightCyan.alphaClone(0x66)],[0,.25,1]));
				var bt : Button = new Button(b);
				
				ToolKit.mainLevel.addChild(bt);
			}
			catch( e : Error ) 
			{
				Log.error( e.message + "\n" + e.getStackTrace() );
			}
		}
	}
}
