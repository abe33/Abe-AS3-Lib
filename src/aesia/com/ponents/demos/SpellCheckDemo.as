package aesia.com.ponents.demos 
{
	import aesia.com.mon.geom.Dimension;
	import aesia.com.mon.utils.StageUtils;
	import aesia.com.ponents.text.TextArea;
	import aesia.com.ponents.utils.KeyboardControllerInstance;
	import aesia.com.ponents.utils.ToolKit;

	import flash.display.Sprite;

	/**
	 * @author Cédric Néhémie
	 */
	public class SpellCheckDemo extends Sprite 
	{
		public function SpellCheckDemo ()
		{
			StageUtils.setup( this );
			ToolKit.initializeToolKit();

			KeyboardControllerInstance.eventProvider = stage;
			
			var t : TextArea = new TextArea();
			t.x = 10;			t.y = 10;
			t.size = new Dimension( 300,200 );
			t.value = "thiis is a wrongly spelled word in TextArea, use context menu to see suggestions.\n\n\n\n<font size='20'>A big text</font>\n<u>miiispelled</u> waurd.";
			/*FDT_IGNORE*/ FEATURES::SPELLING { /*FDT_IGNORE*/
				t.spellCheckerId = "usa.zwl";
				t.spellCheckEnabled = true;
			/*FDT_IGNORE*/ } /*FDT_IGNORE*/
			ToolKit.mainLevel.addChild( t );
		}
	}
}
