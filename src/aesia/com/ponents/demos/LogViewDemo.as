package aesia.com.ponents.demos 
{
	import aesia.com.mon.logs.Log;
	import aesia.com.mon.utils.StageUtils;
	import aesia.com.ponents.monitors.LogView;
	import aesia.com.ponents.utils.ToolKit;

	import flash.display.Sprite;

	/**
	 * @author Cédric Néhémie
	 */
	public class LogViewDemo extends Sprite 
	{
		public function LogViewDemo ()
		{
			StageUtils.setup(this);
			ToolKit.initializeToolKit();
			
			var l : LogView = new LogView();
			
			ToolKit.mainLevel.addChild( l );
			StageUtils.lockToStage( l );
			
			Log.debug( "A debug message" );			Log.info( "An info message" );			Log.warn( "A warning message" );			Log.error( "An error message" );			Log.fatal( "A fatal message" );
		}
	}
}
