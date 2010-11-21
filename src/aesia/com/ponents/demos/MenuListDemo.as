package aesia.com.ponents.demos 
{
	import aesia.com.mon.geom.Dimension;
	import aesia.com.mon.logs.Log;
	import aesia.com.mon.logs.LogEvent;
	import aesia.com.mon.utils.KeyStroke;
	import aesia.com.mon.utils.Keys;
	import aesia.com.mon.utils.StageUtils;
	import aesia.com.ponents.actions.AbstractAction;
	import aesia.com.ponents.menus.MenuItem;
	import aesia.com.ponents.menus.MenuList;
	import aesia.com.ponents.models.DefaultListModel;
	import aesia.com.ponents.monitors.LogView;
	import aesia.com.ponents.skinning.icons.magicIconBuild;
	import aesia.com.ponents.utils.ToolKit;

	import flash.display.Sprite;

	/**
	 * @author Cédric Néhémie
	 */
	public class MenuListDemo extends Sprite 
	{
		[Embed(source="add.png")]
		private var add : Class;
		public function MenuListDemo ()
		{
			var lv : LogView;
			var a : Array =[];
			var f : Function = function ( e : LogEvent):void
			{
				a.push( e.msg );	
			};
			Log.getInstance().addEventListener( LogEvent.LOG_ADD, f );
			StageUtils.setup(this);
			StageUtils.flexibleStage();
			ToolKit.initializeToolKit();
			
			lv = new LogView();
			lv.size = new Dimension(300,400);
			lv.x = 250;
			ToolKit.mainLevel.addChild(lv);
			
			try
			{
				var lm : DefaultListModel=  new DefaultListModel();
				/*
				var cmenu : CheckBoxMenuItem = new CheckBoxMenuItem( "CheckBox Menu" );
				cmenu.mnemonic = KeyStroke.getKeyStroke( Keys.C );
				lm.addElement( cmenu );
				lm.addElement( new MenuSeparator() );
				
				var bg : ButtonGroup = new ButtonGroup();
				var rmenu1 : RadioMenuItem = new RadioMenuItem( "Radio Menu 1" );
				var rmenu2 : RadioMenuItem = new RadioMenuItem( "Radio Menu 2" );
				var rmenu3 : RadioMenuItem = new RadioMenuItem( "Radio Menu 3" );
				
				bg.add( rmenu1 );
				bg.add( rmenu2 );
				bg.add( rmenu3 );
				rmenu1.selected = true;
				
				lm.addElement(rmenu1 );
				lm.addElement(rmenu2 );
				lm.addElement(rmenu3 );
				*/
				//lm.addElement( new MenuSeparator() );
				
				lm.addElement( new MenuItem( new AbstractAction( "A long menu label", 
																 magicIconBuild(add), 
																 "A long description",
																 KeyStroke.getKeyStroke( Keys.A, KeyStroke.getModifiers(true) ) ) ) );
				lm.addElement( new MenuItem( ) );
				lm.addElement( new MenuItem( ) );
				lm.addElement( new MenuItem( ) );
				
				var ml : MenuList = new MenuList( lm );
				ml.x = 10;				ml.y = 10;
				//ml.size = new Dimension(180,380);
				ToolKit.mainLevel.addChild( ml );
				
			}
			catch( e : Error )
			{
				Log.error( e.message + "\n" + e.getStackTrace() );
			}
		}
	}
}
