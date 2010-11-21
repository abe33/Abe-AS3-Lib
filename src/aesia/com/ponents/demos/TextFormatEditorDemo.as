package aesia.com.ponents.demos 
{
	import aesia.com.mon.logs.Log;
	import aesia.com.mon.utils.StageUtils;
	import aesia.com.ponents.monitors.LogView;
	import aesia.com.ponents.text.TextFormatEditor;
	import aesia.com.ponents.utils.KeyboardControllerInstance;
	import aesia.com.ponents.utils.ToolKit;

	import flash.display.Sprite;
	import flash.text.TextFormat;

	/**
	 * @author cedric
	 */
	public class TextFormatEditorDemo extends Sprite 
	{
		public function TextFormatEditorDemo ()
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
				var tfe : TextFormatEditor = new TextFormatEditor();
				
				tfe.x = 10;
				tfe.y = 10;
				
				ToolKit.mainLevel.addChild( tfe );
				
				tfe.initEditState( null, new TextFormat( "MonoSpace", 16, 0, true, false, true ) );
			}
			catch( e : Error ) 
			{
				Log.error( e.message + "\n" + e.getStackTrace() );
			}
		}
	}
}
