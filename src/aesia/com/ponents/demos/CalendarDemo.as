package aesia.com.ponents.demos 
{
	import aesia.com.mon.logs.Log;
	import aesia.com.mon.utils.StageUtils;
	import aesia.com.ponents.actions.builtin.CalendarAction;
	import aesia.com.ponents.buttons.Button;
	import aesia.com.ponents.monitors.LogView;
	import aesia.com.ponents.skinning.icons.magicIconBuild;
	import aesia.com.ponents.utils.KeyboardControllerInstance;
	import aesia.com.ponents.utils.ToolKit;

	import flash.display.Sprite;

	/**
	 * @author Cédric Néhémie
	 */
	public class CalendarDemo extends Sprite 
	{
		[Embed(source="../skinning/icons/calendar.png")]
		static public var CALENDAR : Class;		
		
		public function CalendarDemo ()
		{
			StageUtils.setup(this);
			StageUtils.flexibleStage();
			ToolKit.initializeToolKit();
			
			var lv : LogView;			
			lv = new LogView();
			ToolKit.mainLevel.addChild(lv);
			StageUtils.lockToStage(lv, StageUtils.WIDTH + StageUtils.Y_ALIGN_BOTTOM );
			
			KeyboardControllerInstance.eventProvider = stage;
			
			try
			{
				var a : CalendarAction = new CalendarAction(new Date(), "Y M D d", magicIconBuild(CALENDAR));
				var b : Button = new Button(a);
				//var c : Calendar = new Calendar();
				//c.addEventListener(CalendarEvent.DATE_CHANGE, function ( e: Event ) : void{Log.debug("date changed");});
				b.x = 10;
				b.y = 10;
				ToolKit.mainLevel.addChild( b );
			}
			catch( e : Error ) 
			{
				Log.error( e.message + "\n" + e.getStackTrace() );
			}
		}
	}
}
