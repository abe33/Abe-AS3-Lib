package aesia.com.ponents.demos 
{
	import aesia.com.mon.geom.Dimension;
	import aesia.com.mon.logs.Log;
	import aesia.com.mon.logs.LogEvent;
	import aesia.com.mon.utils.KeyStroke;
	import aesia.com.mon.utils.Keys;
	import aesia.com.mon.utils.StageUtils;
	import aesia.com.ponents.actions.AbstractAction;
	import aesia.com.ponents.dnd.DnDEvent;
	import aesia.com.ponents.dnd.DnDManagerInstance;
	import aesia.com.ponents.menus.Menu;
	import aesia.com.ponents.menus.MenuItem;
	import aesia.com.ponents.menus.PopupMenu;
	import aesia.com.ponents.monitors.LogView;
	import aesia.com.ponents.skinning.icons.magicIconBuild;
	import aesia.com.ponents.utils.KeyboardControllerInstance;
	import aesia.com.ponents.utils.ToolKit;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;

	/**
	 * @author Cédric Néhémie
	 */
	public class PopupMenuDemo extends Sprite 
	{
		[Embed(source="add.png")]
		private var add : Class;
		
		private var dndBitmapData : BitmapData;
		private var dndBitmap : Bitmap;
		public function PopupMenuDemo ()
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
			lv.size = new Dimension(200,400);
			lv.x = 350;
			ToolKit.mainLevel.addChild(lv);
			
			KeyboardControllerInstance.eventProvider = stage;
			try
			{
				/*
				var popupmenu1 : PopupMenu = new PopupMenu();
				popupmenu1.addMenuItem( new MenuItem() );				popupmenu1.addMenuItem( new MenuItem() );				popupmenu1.addMenuItem( new MenuItem() );				popupmenu1.addMenuItem( new MenuItem() );				popupmenu1.addSeparator();				popupmenu1.addMenuItem( new MenuItem() );				popupmenu1.addMenuItem( new MenuItem() );				popupmenu1.addMenuItem( new MenuItem() );
				
				popupmenu1.x = 10;
				popupmenu1.y = 350;
				ToolKit.mainLevel.addChild( popupmenu1 );
				
				Log.info( popupmenu1.preferredSize );				*/
				var popupmenu2 : PopupMenu = new PopupMenu( );				popupmenu2.scrollLayout = 0;
	
				popupmenu2.x = 0;
				popupmenu2.y = 0;
				
				var menu1 : Menu = new Menu( "A Menu" );
				menu1.mnemonic = KeyStroke.getKeyStroke( Keys.A );				var menu2 : Menu = new Menu( "Another Menu" );				menu2.mnemonic = KeyStroke.getKeyStroke( Keys.A );
				menu1.addMenuItem( new MenuItem( new AbstractAction( "A long menu label" ) ) );
				menu1.addMenuItem( new MenuItem() );
				menu1.addMenuItem( new MenuItem() );
				menu1.addMenuItem( new MenuItem() );
								menu1.addMenuItem( menu2 );
				
				menu2.addMenuItem( new MenuItem( new AbstractAction( "A long menu label" ) ) );
				menu2.addMenuItem( new MenuItem() );
				menu2.addMenuItem( new MenuItem() );
				menu2.addMenuItem( new MenuItem() );
				
				popupmenu2.addMenuItem( menu1 );
				
				for(var i:Number = 0;i<25;i++)
				{
					var item : MenuItem;
					item = new MenuItem();
					
					if( i == 0 )
						item.mnemonic = KeyStroke.getKeyStroke( Keys.M );					if( i == 1 )
						item.mnemonic = KeyStroke.getKeyStroke( Keys.E );
					if( i == 8 )
						item.action = new AbstractAction( "Menu Item " + i, magicIconBuild(add), "",  KeyStroke.getKeyStroke( Keys.W, 3 ) );
					if( i % 4 == 0 )
						item.icon = magicIconBuild(add);
					if( i % 3 == 0 )
					{
						item.label = "Disabled Item " + i;
						item.enabled = false;
					}
					else if( i % 3 == 1 )
					{
						item.allowDrag = true;
						item.label = "Draggable Item " + i;
					}
					else						item.label = "Menu Item " + i;
						
					if( i == 2 ) 
						popupmenu2.addSeparator();
					else 
						popupmenu2.addMenuItem( item );
				}
				
				Log.info( popupmenu2.preferredSize );				ToolKit.mainLevel.addChild( popupmenu2 );	
				
				DnDManagerInstance.addEventListener( DnDEvent.DRAG, drag );
				DnDManagerInstance.addEventListener( DnDEvent.DRAG_START, dragStarted );
				DnDManagerInstance.addEventListener( DnDEvent.DRAG_STOP, dragStopped );
				DnDManagerInstance.addEventListener( DnDEvent.DRAG_ABORT, dragAborted );
				DnDManagerInstance.addEventListener( DnDEvent.DRAG_ACCEPT, dragAccepted );
				DnDManagerInstance.addEventListener( DnDEvent.DRAG_EXIT, dragExited );
				DnDManagerInstance.addEventListener( DnDEvent.DRAG_ENTER, dragEntered );
				DnDManagerInstance.addEventListener( DnDEvent.DRAG_REJECT, dragRejected );
				DnDManagerInstance.addEventListener( DnDEvent.DROP, drop );
				
				dndBitmap = new Bitmap( );
				dndBitmap.alpha = .5;
			}
			catch( e : Error )
			{
				Log.error( e.message + "\n" + e.getStackTrace() );
			}
		}
		public function dragEntered ( e : DnDEvent ) : void
		{
			//Log.info ( "dragEntered" );
		}
		public function dragExited ( e : DnDEvent ) : void
		{
			//Log.info ( "dragExited" );
		}
		public function dragAborted( e : DnDEvent ) : void
		{
			//Log.info ( "dragAborted" );
		}
		public function dragAccepted( e : DnDEvent ) : void
		{
			//Log.info ( "dragAccepted" );
		}
		public function dragRejected( e : DnDEvent ) : void
		{
			//Log.info ( "dragRejected" );
		}
		public function drag ( e : DnDEvent ) : void
		{
			//var pv : PageView = e.dragSource as PageView;
			dndBitmap.x = mouseX - dndBitmap.width / 2;
			dndBitmap.y = mouseY - dndBitmap.height / 2;
		}

		public function dragStarted ( e : DnDEvent ) : void
		{
			var g : DisplayObject = e.dragSource.dragGeometry;
			dndBitmapData = new BitmapData( g.width, g.height );
			dndBitmapData.draw( g );
			dndBitmap.bitmapData = dndBitmapData;
			ToolKit.popupLevel.addChild( dndBitmap );
			//Log.info ( "dragStarted" );
			//ToolKit.popupLevel.addChild( pv.dragGeometry );
		}

		public function dragStopped ( e : DnDEvent ) : void
		{
			ToolKit.popupLevel.removeChild( dndBitmap );
			dndBitmapData.dispose();
			dndBitmapData = null;
			//Log.info ( "dragStopped" );
			//ToolKit.popupLevel.removeChild( pv.dragGeometry ); 
		}
		public function drop ( e : DnDEvent ) : void
		{
			//Log.info ( "drop" );
		}
	}
}
