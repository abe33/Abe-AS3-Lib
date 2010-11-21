package aesia.com.ponents.demos 
{
	import aesia.com.ponents.utils.ComponentResizer;
	import aesia.com.mon.geom.Dimension;
	import aesia.com.mon.logs.Log;
	import aesia.com.mon.utils.StageUtils;
	import aesia.com.ponents.buttons.Button;
	import aesia.com.ponents.buttons.CheckBox;
	import aesia.com.ponents.containers.Panel;
	import aesia.com.ponents.layouts.components.FlowLayout;
	import aesia.com.ponents.models.SpinnerNumberModel;
	import aesia.com.ponents.monitors.LogView;
	import aesia.com.ponents.spinners.Spinner;
	import aesia.com.ponents.utils.KeyboardControllerInstance;
	import aesia.com.ponents.utils.ToolKit;

	import flash.display.Sprite;

	/**
	 * @author cedric
	 */
	public class FlowLayoutDemo extends Sprite 
	{
		protected var resizer : ComponentResizer;

		public function FlowLayoutDemo ()
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
				var p : Panel = new Panel();
				p.styleKey = "DefaultComponent";
				p.childrenLayout = new FlowLayout( p, 3, 3, "right" );
				//p.preferredSize = new Dimension( 150, 100 );
				p.addComponent( new Button() );
				p.addComponent( new CheckBox() );				p.addComponent( new Spinner( new SpinnerNumberModel(0, 0, 10, 1, true) ) );				p.addComponent( new Button() );
				p.addComponent( new Button() );				p.addComponent( new CheckBox() );
				
				resizer = new ComponentResizer( p, ComponentResizer.BOTH_RESIZE_POLICY );
				
				p.x = 10;				p.y = 10;
				
				ToolKit.mainLevel.addChild( p );
			}
			catch( e : Error ) 
			{
				Log.error( e.message + "\n" + e.getStackTrace() );
			}
		}
	}
}
