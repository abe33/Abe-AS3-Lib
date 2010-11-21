package aesia.com.ponents.demos
{
	import aesia.com.mon.utils.StageUtils;
	import aesia.com.ponents.builder.styles.StyleEditorPane;
	import aesia.com.ponents.builder.styles.initializePrototypeSerializableSupport;
	import aesia.com.ponents.forms.FormUtils;
	import aesia.com.ponents.skinning.decorations.ComponentDecoration;
	import aesia.com.ponents.skinning.decorations.NoDecoration;
	import aesia.com.ponents.utils.KeyboardControllerInstance;
	import aesia.com.ponents.utils.ToolKit;

	import flash.display.Sprite;

	[SWF(width="1152",height="768",backgroundColor="#D3D3D3")]
	/**
	 * @author cedric
	 */
	public class StyleStateGridDemo extends Sprite
	{
		public function StyleStateGridDemo ()
		{
			initializePrototypeSerializableSupport();

			StageUtils.setup(this);
			StageUtils.flexibleStage();
			StageUtils.noMenu();
			ToolKit.initializeToolKit();

			FormUtils.addNewValueFunction(ComponentDecoration, function( t : Class) : * { return new NoDecoration(); } );
			/*
			var lv : LogView;
			lv = new LogView();
			ToolKit.mainLevel.addChild( lv );
			StageUtils.lockToStage( lv );
			*/
			KeyboardControllerInstance.eventProvider = stage;

			/*try
			{*/
				var splitPane : StyleEditorPane = new StyleEditorPane();
				ToolKit.mainLevel.addChild( splitPane );
				StageUtils.lockToStage(splitPane);
			/*}
			catch( e : Error )
			{
				Log.error( e.message + "\n" + e.getStackTrace() );
			}*/
		}
	}
}
