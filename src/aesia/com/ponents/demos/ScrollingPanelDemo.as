package aesia.com.ponents.demos 
{
	import aesia.com.mon.geom.Dimension;
	import aesia.com.mon.utils.StageUtils;
	import aesia.com.ponents.actions.AbstractAction;
	import aesia.com.ponents.buttons.Button;
	import aesia.com.ponents.containers.SlidePane;
	import aesia.com.ponents.utils.KeyboardControllerInstance;
	import aesia.com.ponents.utils.ToolKit;

	import flash.display.Sprite;

	/**
	 * @author Cédric Néhémie
	 */
	public class ScrollingPanelDemo extends Sprite 
	{
		public function ScrollingPanelDemo ()
		{
			StageUtils.setup( this );
			ToolKit.initializeToolKit();
						
			KeyboardControllerInstance.eventProvider = stage;
			
			var bt : Button = new Button( new AbstractAction("A super long text to force the horizontal scroll"));
			
			var scp : SlidePane = new SlidePane();
			scp.preferredSize = new Dimension( 200, 200 );
			scp.view = bt;

			scp.x = 10;
			scp.y = 10;
			
			ToolKit.mainLevel.addChild( scp );
		}
	}
}
