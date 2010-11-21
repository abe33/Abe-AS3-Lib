package aesia.com.ponents.demos 
{
	import aesia.com.mon.utils.StageUtils;
	import aesia.com.ponents.containers.Panel;
	import aesia.com.ponents.layouts.components.InlineLayout;
	import aesia.com.ponents.text.Label;
	import aesia.com.ponents.text.TextInput;
	import aesia.com.ponents.utils.KeyboardControllerInstance;
	import aesia.com.ponents.utils.ToolKit;

	import flash.display.Sprite;

	/**
	 * @author Cédric Néhémie
	 */
	public class LabelDemo extends Sprite 
	{
		public function LabelDemo ()
		{
			StageUtils.setup( this );
			ToolKit.initializeToolKit();

			KeyboardControllerInstance.eventProvider = stage;
			
			var panel1 : Panel = new Panel();
			panel1.childrenLayout = new InlineLayout( panel1, 4 );
			
			var ti1 : TextInput = new TextInput();
			ti1.value = "login";
			var l1 : Label = new Label( "Login :", ti1 );
			
			panel1.addComponent( l1 );
			panel1.addComponent( ti1 );
			panel1.x = 10;			panel1.y = 10;
			
			var panel2 : Panel = new Panel();
			panel2.childrenLayout = new InlineLayout( panel2, 4 );
			
			var ti2 : TextInput = new TextInput( 8, true );
			ti2.value = "pass";
			var l2 : Label = new Label( "Password : ", ti2 );
			
			panel2.addComponent( l2 );
			panel2.addComponent( ti2 );
			panel2.x = 10;
			panel2.y = 40;
			panel2.enabled = false;
			
			ToolKit.mainLevel.addChild( panel1 );
			ToolKit.mainLevel.addChild( panel2 );
		}
	}
}
