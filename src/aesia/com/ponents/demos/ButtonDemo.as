package aesia.com.ponents.demos 
{
	import aesia.com.mon.logs.Log;
	import aesia.com.mon.utils.StageUtils;
	import aesia.com.ponents.actions.AbstractAction;
	import aesia.com.ponents.buttons.Button;
	import aesia.com.ponents.buttons.ButtonDisplayModes;
	import aesia.com.ponents.buttons.ButtonGroup;
	import aesia.com.ponents.buttons.CheckBox;
	import aesia.com.ponents.buttons.RadioButton;
	import aesia.com.ponents.buttons.ToggleButton;
	import aesia.com.ponents.layouts.display.DOInlineLayout;
	import aesia.com.ponents.monitors.LogView;
	import aesia.com.ponents.skinning.icons.magicIconBuild;
	import aesia.com.ponents.utils.Directions;
	import aesia.com.ponents.utils.KeyboardControllerInstance;
	import aesia.com.ponents.utils.ToolKit;

	import flash.display.Sprite;

	/**
	 * @author Cédric Néhémie
	 */
	public class ButtonDemo extends Sprite 
	{
		[Embed(source="bgstretch.png")]
		private var bgClass : Class;
		
		[Embed(source="add.png")]
		private var add : Class;
		
		protected var btg1 : ButtonGroup;		protected var btg2 : ButtonGroup;
		
		public function ButtonDemo ()
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
				var bt1 : Button = new Button( new AbstractAction( "Button", magicIconBuild(add), "Some long description for the button." ) );
			
				var bt2 : Button = new Button( new AbstractAction( "<b>Button</b>", magicIconBuild(add), "Some long description for the disabled button." ) );
				bt2.buttonDisplayMode = ButtonDisplayModes.TEXT_ONLY;
				
				var bt2bis : Button = new Button( new AbstractAction( "", magicIconBuild(add), "Some long description for the icon button." ) );
				//bt2bis.displayMode = ButtonDisplayModes.ICON_ONLY;
				
				var bt3 : ToggleButton = new ToggleButton( new AbstractAction( "<i>Toggle Button</i>", null, "Some long description for the toggle button." ) );
				var bt4 : ToggleButton = new ToggleButton( new AbstractAction( "<u>Toggle Button</u>", null, "Some long description for the toggle button." ) );
				bt2.buttonDisplayMode = ButtonDisplayModes.TEXT_ONLY;
				var tbt1 : ToggleButton = new ToggleButton( new AbstractAction( "Button 1", null, "Short description") );
				var tbt2 : ToggleButton = new ToggleButton( new AbstractAction( "Button 2") );
				var tbt3 : ToggleButton = new ToggleButton( new AbstractAction( "Button 3") );
				
				var rbt1 : RadioButton = new RadioButton( new AbstractAction( "Radio 1", magicIconBuild( add )) );
				var rbt2 : RadioButton = new RadioButton( "", magicIconBuild( add ) );
				var rbt3 : RadioButton = new RadioButton( new AbstractAction( "Radio 3") );
				rbt3.enabled = false;
				
				var cbt1 : CheckBox = new CheckBox( "CheckBox 1", magicIconBuild( add ) );
				var cbt2 : CheckBox = new CheckBox( "", magicIconBuild( add ));
				var cbt3 : CheckBox = new CheckBox( "CheckBox 3" );
				
				btg1 = new ButtonGroup();
				btg1.add( tbt1 );
				btg1.add( tbt2 );
				btg1.add( tbt3 );
				
				btg2 = new ButtonGroup();
				btg2.add( rbt1 );
				btg2.add( rbt2 );
				btg2.add( rbt3 );
				rbt3.selected = true;
							
				bt1.x = 50;
				bt1.y = 20;
				
				bt2.x = 125;
				(bt2.childrenLayout as DOInlineLayout).direction = Directions.RIGHT_TO_LEFT;
				bt2.y = 20;
				bt2.enabled = false;
				
				bt2bis.x = 200;
				bt2bis.y = 20;
				
				bt3.x = 50;
				bt3.y = 50;
				bt3.selected = true;
				
				bt4.x = 150;
				bt4.y = 50;
				bt4.enabled = false;
				bt4.selected = true;
				
				tbt1.y = tbt2.y = tbt3.y = 80;
				tbt1.x = 50;
				tbt2.x = 120;
				tbt3.x = 190;
				
				rbt1.y = rbt2.y = rbt3.y = 110;
				rbt1.x = 50;
				rbt2.x = 140;
				rbt3.x = 210;
				
				cbt1.y = 130;
				cbt1.x = 50;
				
				cbt2.y = 130;
				cbt2.x = 170;
				
				cbt3.y = 130;
				cbt3.x = 250;
				cbt3.selected = false;
				cbt3.enabled = false;
	
				ToolKit.mainLevel.addChild( bt1 );
				ToolKit.mainLevel.addChild( bt2 );
				ToolKit.mainLevel.addChild( bt2bis );
				ToolKit.mainLevel.addChild( bt3 );
				ToolKit.mainLevel.addChild( bt4 );
				
				ToolKit.mainLevel.addChild( tbt1 );
				ToolKit.mainLevel.addChild( tbt2 );
				ToolKit.mainLevel.addChild( tbt3 );
				
				ToolKit.mainLevel.addChild( rbt1 );
				ToolKit.mainLevel.addChild( rbt2 );
				ToolKit.mainLevel.addChild( rbt3 );
				
				ToolKit.mainLevel.addChild( cbt1 );
				ToolKit.mainLevel.addChild( cbt2 );
				ToolKit.mainLevel.addChild( cbt3 );
			}
			catch( e : Error ) 
			{
				Log.error( e.message + "\n" + e.getStackTrace() );
			}
		}
	}
}
