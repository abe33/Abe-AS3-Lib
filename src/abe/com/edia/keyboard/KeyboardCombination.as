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
			ToolKit.initializeToolKit( this );
			
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
				
				controller.keySequenceFound.add(newKeySequence);				controller.keyReleased.add( keyRelease );
			}
			catch( e : Error ) 
			{
				Log.error( e.message + "\n" + e.getStackTrace() );
			}
		}
		
		protected function keyRelease ( controller : KeyCombinator, sequence : String, key : String ) : void
		{
			Log.debug( sequence );
		}

		protected function newKeySequence ( controller : KeyCombinator, sequence : String, key : String ) : void
		{
			Log.info( sequence );
		}
	}
}
