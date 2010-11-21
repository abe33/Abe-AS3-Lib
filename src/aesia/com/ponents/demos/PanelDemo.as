package aesia.com.ponents.demos 
{
	import aesia.com.mon.geom.Dimension;
	import aesia.com.mon.utils.StageUtils;
	import aesia.com.ponents.buttons.ButtonGroup;
	import aesia.com.ponents.buttons.ToggleButton;
	import aesia.com.ponents.containers.Panel;
	import aesia.com.ponents.containers.ScrollPane;
	import aesia.com.ponents.layouts.components.BorderLayout;
	import aesia.com.ponents.layouts.components.GridLayout;
	import aesia.com.ponents.text.TextArea;
	import aesia.com.ponents.text.TextInput;
	import aesia.com.ponents.utils.KeyboardControllerInstance;
	import aesia.com.ponents.utils.ToolKit;

	import flash.display.Sprite;

	/**
	 * @author Cédric Néhémie
	 */
	[SWF( width="640", height="430")]
	public class PanelDemo extends Sprite 
	{
		[Embed(source="add.png")]
		private var add : Class;
		
		public function PanelDemo ()
		{
			StageUtils.setup( this );
			ToolKit.initializeToolKit();
			//aesia.com.ponents.tools.ToolKit.initializeToolKit();
			//Tools.logWindow(200,200,440,230);

			KeyboardControllerInstance.eventProvider = stage;
			
			enabled();
			disabled();
		}
		
		public function enabled () :void
		{
			var t2 : TextInput = new TextInput();
			var t3 : TextArea = new TextArea();
			var bt2 : ToggleButton = new ToggleButton();
			var bt3 : ToggleButton = new ToggleButton();
			var bt4 : ToggleButton = new ToggleButton();
			var bt5 : ToggleButton = new ToggleButton();
			var btg : ButtonGroup = new ButtonGroup();
			
			btg.add( bt2 );
			btg.add( bt3 );
			btg.add( bt4 );
			btg.add( bt5 );
			
			var bt6 : TextInput = new TextInput();
			var bt7 : ToggleButton = new ToggleButton();
			var bt8 : ToggleButton = new ToggleButton();
			var bt9 : ToggleButton = new ToggleButton();
			var bt10 : TextArea = new TextArea();
			
			var panel2 : Panel = new Panel();
			panel2.childrenLayout = new GridLayout( panel2, 2, 2 );
			//panel2.allowMask = false;
			panel2.addComponent( t2 );
			panel2.addComponent( t3 );
			panel2.addComponent( bt2 );
			panel2.addComponent( bt3 );
			panel2.addComponent( bt4 );
			panel2.addComponent( bt5 );
			panel2.preferredSize = new Dimension ( 200,200 );
			panel2.x = 10;
			panel2.y = 10;
			
			var panel3 : Panel = new Panel();
			var bl : BorderLayout = new BorderLayout( panel3 );
			panel3.childrenLayout = bl;
			panel3.addComponent( bt6 );
			panel3.addComponent( bt9 );
			panel3.addComponent( bt10 );
			panel3.addComponent( bt8 );
			panel3.addComponent( bt7 );
			panel3.preferredSize = new Dimension ( 200,200 );
			panel3.x = 220;
			panel3.y = 10;
			
			bl.addComponent( bt6, "north" );
			bl.addComponent( bt8, "east" );
			bl.addComponent( bt10 );
			bl.addComponent( bt9, "west" );
			bl.addComponent( bt7, "south" );
			
			var scp : ScrollPane = new ScrollPane();
			scp.x = 430;
			scp.y = 10;
			scp.preferredSize = new Dimension ( 200,200 );
			
			scp.rowHead = new ToggleButton();
			(scp.rowHead as ToggleButton).preferredSize = new Dimension( 20,20 );
			scp.colHead = new ToggleButton();
			(scp.colHead as ToggleButton).preferredSize = new Dimension( 20,20 );
			
			scp.upperLeft = new ToggleButton();
			scp.upperRight = new ToggleButton();
			scp.lowerLeft = new ToggleButton();
			scp.lowerRight = new ToggleButton();
			
			scp.viewport.view = new ToggleButton();
			(scp.viewport.view as ToggleButton ).preferredSize = new Dimension( 300,300 );
			
			ToolKit.mainLevel.addChild( panel2 );
			ToolKit.mainLevel.addChild( panel3 );
			ToolKit.mainLevel.addChild( scp );
		}
		public function disabled () :void
		{
			var t2 : TextInput = new TextInput();
			var t3 : TextArea = new TextArea();
			var bt2 : ToggleButton = new ToggleButton();
			var bt3 : ToggleButton = new ToggleButton();
			var bt4 : ToggleButton = new ToggleButton();
			var bt5 : ToggleButton = new ToggleButton();
			var btg : ButtonGroup = new ButtonGroup();
			
			btg.add( bt2 );
			btg.add( bt3 );
			btg.add( bt4 );
			btg.add( bt5 );
			
			var bt6 : TextInput = new TextInput();
			var bt7 : ToggleButton = new ToggleButton();
			var bt8 : ToggleButton = new ToggleButton();
			var bt9 : ToggleButton = new ToggleButton();
			var bt10 : TextArea = new TextArea();
			
			var panel2 : Panel = new Panel();
			panel2.childrenLayout = new GridLayout( panel2, 2, 2 );
			//panel2.allowMask = false;
			panel2.addComponent( t2 );
			panel2.addComponent( t3 );
			panel2.addComponent( bt2 );
			panel2.addComponent( bt3 );
			panel2.addComponent( bt4 );
			panel2.addComponent( bt5 );
			panel2.preferredSize = new Dimension ( 200,200 );
			panel2.x = 10;
			panel2.y = 220;
			panel2.enabled = false;
			
			var panel3 : Panel = new Panel();
			var bl : BorderLayout = new BorderLayout( panel3 );
			panel3.childrenLayout = bl;
			panel3.addComponent( bt6 );
			panel3.addComponent( bt8 );
			panel3.addComponent( bt10 );
			panel3.addComponent( bt9 );
			panel3.addComponent( bt7 );
			panel3.preferredSize = new Dimension ( 200,200 );
			panel3.x = 220;
			panel3.y = 220;
			panel3.enabled = false;
			
			bl.addComponent( bt6, "north" );
			bl.addComponent( bt8, "east" );
			bl.addComponent( bt10 );
			bl.addComponent( bt9, "west" );
			bl.addComponent( bt7, "south" );
			
			var scp : ScrollPane = new ScrollPane();
			scp.x = 430;
			scp.y = 220;
			scp.preferredSize = new Dimension ( 200,200 );
			scp.enabled = false;
			
			scp.rowHead = new ToggleButton();
			(scp.rowHead as ToggleButton).preferredSize = new Dimension( 20,20 );
			scp.colHead = new ToggleButton();
			(scp.colHead as ToggleButton).preferredSize = new Dimension( 20,20 );
			
			scp.upperLeft = new ToggleButton();
			scp.upperRight = new ToggleButton();
			scp.lowerLeft = new ToggleButton();
			scp.lowerRight = new ToggleButton();
			
			scp.viewport.view = new ToggleButton();
			(scp.viewport.view as ToggleButton ).preferredSize = new Dimension( 300,300 );
			
			ToolKit.mainLevel.addChild( panel2 );
			ToolKit.mainLevel.addChild( panel3 );
			ToolKit.mainLevel.addChild( scp );
		}
	}
}
