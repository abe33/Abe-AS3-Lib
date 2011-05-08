package abe.com.edia.keyboard
{
	import abe.com.mon.logs.Log;
	import abe.com.mon.utils.StageUtils;
	import abe.com.ponents.monitors.LogView;
	import abe.com.ponents.utils.KeyboardControllerInstance;
	import abe.com.ponents.utils.ToolKit;

	import flash.display.Sprite;
	import flash.events.KeyboardEvent;

	/**
	 * @author cedric
	 */
	[SWF(frameRate="60")]
	public class KeyboardCombination extends Sprite 
	{
		private var controller : KeyCombinator;
		
		public function KeyboardCombination ()
		{
			StageUtils.setup(this);
			StageUtils.flexibleStage();
			ToolKit.initializeToolKit();
			
			var lv : LogView;			
			lv = new LogView();
			ToolKit.mainLevel.addChild(lv);
			StageUtils.lockToStage(lv);
			
			KeyboardControllerInstance.eventProvider = stage;
			
			try
			{
				controller = new KeyCombinator( /*new KeyCombinatorFilter({ "38":"U",
																		  "40":"D",
																		  "37":"L",
																		  "39":"R" 
																		 } )*/ );
				stage.addEventListener(KeyboardEvent.KEY_DOWN, controller.keyDown);				stage.addEventListener(KeyboardEvent.KEY_UP, controller.keyUp);
				
				controller.addEventListener(KeyCombinatorEvent.NEW_KEYS_SEQUENCE,newKeySequence);				controller.addEventListener(KeyCombinatorEvent.KEY_RELEASE, keyRelease );
			}
			catch( e : Error ) 
			{
				Log.error( e.message + "\n" + e.getStackTrace() );
			}
		}
		
		protected function keyRelease (event : KeyCombinatorEvent) : void
		{
			Log.debug( event.sequence );
		}

		protected function newKeySequence (event : KeyCombinatorEvent) : void
		{
			Log.info( event.sequence );
		}
	}
}
