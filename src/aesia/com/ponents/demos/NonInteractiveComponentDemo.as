package aesia.com.ponents.demos 
{
	import aesia.com.mon.logs.Log;
	import aesia.com.mon.utils.StageUtils;
	import aesia.com.ponents.buttons.Button;
	import aesia.com.ponents.containers.ToolBar;
	import aesia.com.ponents.models.SpinnerNumberModel;
	import aesia.com.ponents.monitors.LogView;
	import aesia.com.ponents.spinners.Spinner;
	import aesia.com.ponents.utils.KeyboardControllerInstance;
	import aesia.com.ponents.utils.ToolKit;
	import aesia.com.ponents.utils.firstIndependentComponent;

	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	/**
	 * @author cedric
	 */
	public class NonInteractiveComponentDemo extends Sprite 
	{
		public function NonInteractiveComponentDemo ()
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
				var bt1 : Button = new Button( "Interactive Button" );				var bt2 : Button = new Button( "Non-Interactive Button" );				var bt3 : Spinner = new Spinner( new SpinnerNumberModel(0, 0, 10, 1));
				
				//bt2.interactive = false;
				//bt3.interactive = false;
				
				var p: ToolBar = new ToolBar();
				p.interactive = false;
				
				p.addComponent( bt1 );				p.addComponent( bt2 );				p.addComponent( bt3 );
				
				p.x = 10;
				p.y = 10;
				
				ToolKit.mainLevel.addChild(p);
				
				p.addEventListener(MouseEvent.MOUSE_UP, click );
			}
			catch( e : Error ) 
			{
				Log.error( e.message + "\n" + e.getStackTrace() );
			}
		}
		
		protected function click (event : MouseEvent) : void
		{
			var a : Array = getObjectsUnderPoint( new Point( stage.mouseX, stage.mouseY ) );
			if( a.length > 0 )
				Log.debug( firstIndependentComponent( a[a.length-1]) );
		}
	}
}
