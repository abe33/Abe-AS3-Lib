package aesia.com.ponents.demos
{
	import aesia.com.ponents.skinning.icons.magicIconBuild;
	import aesia.com.ponents.containers.ScrollPane;
	import aesia.com.mon.geom.dm;
	import aesia.com.mon.logs.Log;
	import aesia.com.mon.utils.StageUtils;
	import aesia.com.ponents.buttons.Button;
	import aesia.com.ponents.containers.Accordion;
	import aesia.com.ponents.containers.AccordionTab;
	import aesia.com.ponents.spinners.Spinner;
	import aesia.com.ponents.text.TextArea;
	import aesia.com.ponents.tools.DebugPanel;
	import aesia.com.ponents.utils.KeyboardControllerInstance;
	import aesia.com.ponents.utils.ToolKit;

	import flash.display.Sprite;

	/**
	 * @author cedric
	 */
	public class AccordionDemo extends Sprite
	{
		[Embed(source="add.png")]
		private var add : Class;

		public function AccordionDemo ()
		{
			StageUtils.setup(this);
			StageUtils.flexibleStage();
			ToolKit.initializeToolKit();

			var p : DebugPanel = new DebugPanel();
			ToolKit.popupLevel.addChild(p);

			KeyboardControllerInstance.eventProvider = stage;

			try
			{
				var accordion1 : Accordion = new Accordion(
															new AccordionTab( "Tab #1" , new Button().setPreferredSize(dm(100,50) ), magicIconBuild(add) ),
															new AccordionTab( "Tab #2" , new TextArea().setPreferredSize(dm(150,150) ) ),
															new AccordionTab( "Tab #3" , new Spinner() )
														 );
				accordion1.x = 10;
				accordion1.y = 10;

				var accordion2 : Accordion = new Accordion(
															new AccordionTab( "Tab #1" , new Button().setPreferredSize(dm(100,50) ), magicIconBuild(add) ),
															new AccordionTab( "Tab #2" , new TextArea().setPreferredSize(dm(150,150) ) ),
															new AccordionTab( "Tab #3" , new Spinner() )
														 );
				var scp : ScrollPane = new ScrollPane ();
				scp.preferredSize = dm( 200, 300 );
				scp.view = accordion2;
				scp.x = 250;				scp.y = 10;

				ToolKit.mainLevel.addChild( accordion1 );				ToolKit.mainLevel.addChild( scp );
			}
			catch( e : Error )
			{
				Log.error( e.message + "\n" + e.getStackTrace() );
			}
		}
	}
}
