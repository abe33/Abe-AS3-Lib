package aesia.com.ponents.demos 
{
	import aesia.com.mon.geom.Dimension;
	import aesia.com.mon.logs.Log;
	import aesia.com.mon.logs.LogEvent;
	import aesia.com.mon.utils.StageUtils;
	import aesia.com.ponents.actions.AbstractAction;
	import aesia.com.ponents.buttons.Button;
	import aesia.com.ponents.containers.ToolBar;
	import aesia.com.ponents.monitors.LogView;
	import aesia.com.ponents.skinning.icons.magicIconBuild;
	import aesia.com.ponents.utils.KeyboardControllerInstance;
	import aesia.com.ponents.utils.ToolKit;

	import flash.display.Sprite;

	/**
	 * @author Cédric Néhémie
	 */
	public class ToolBarDemo extends Sprite 
	{
		[Embed(source="add.png")]
		private var add : Class;
		
		public function ToolBarDemo ()
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
			lv.size = new Dimension(200,300);
			lv.x = 350;
			lv.y = 100;
			ToolKit.popupLevel.addChild(lv);
			
			try
			{
				KeyboardControllerInstance.eventProvider = stage;
				
				createToolBar( 0, 10, 10, true );				createToolBar( 0, 10, 40, false );
				
				createToolBar( 1, 10, 70, true );
				createToolBar( 1, 10, 100, false );
				
				createToolBar( 2, 10, 130, true, 'topToBottom' );
				createToolBar( 2, 60, 130, false, 'topToBottom' );
			}
			catch( e : Error )
			{
				Log.error( e.message + "\n" + e.getStackTrace() );
			}
		}
		
		public function createToolBar( displayMode : uint, x : Number, y : Number, enabled : Boolean = true, o : String = 'leftToRight' ):void
		{
			var toolbar : ToolBar = new ToolBar( displayMode );
			toolbar.direction = o;
			
			var button1 : Button = new Button( new AbstractAction( "Button", magicIconBuild(add) ) );			var button2 : Button = new Button( new AbstractAction( "Button" ) );			var button3 : Button = new Button( new AbstractAction( "", magicIconBuild(add) ) );
			
			toolbar.addComponent( button1 );			toolbar.addSeparator();
			toolbar.addComponent( button2 );			toolbar.addSeparator();			toolbar.addComponent( button3 );
			toolbar.y = y;			toolbar.x = x;
			
			toolbar.enabled = enabled;
			
			ToolKit.mainLevel.addChild( toolbar );		}
	}
}
