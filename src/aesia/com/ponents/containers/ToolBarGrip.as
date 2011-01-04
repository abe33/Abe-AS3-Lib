package aesia.com.ponents.containers 
{
	import aesia.com.mon.geom.dm;
	import aesia.com.patibility.lang._;
	import aesia.com.ponents.allocators.EmbeddedBitmapAllocatorInstance;
	import aesia.com.ponents.core.AbstractComponent;
	import aesia.com.ponents.dnd.gestures.DragGesture;
	import aesia.com.ponents.skinning.cursors.Cursor;
	import aesia.com.ponents.utils.Directions;

	import flash.display.BitmapData;
	import flash.ui.MouseCursor;

	[Skinable(skin="ToolBarGripV")]
	[Skin(define="ToolBarGripV",
		  inherit="EmptyComponent",
		  state__all__background="new deco::BitmapDecoration( new aesia.com.ponents.containers::ToolBarGrip.getVGrip(), 'center', 'center' )"
	)]
	[Skin(define="ToolBarGripH",
		  inherit="EmptyComponent",
		  state__all__background="new deco::BitmapDecoration( new aesia.com.ponents.containers::ToolBarGrip.getHGrip(), 'center', 'center' )"
	)]
	/**
	 * @author cedric
	 */
	public class ToolBarGrip extends AbstractComponent 
	{
		static public function getVGrip() : BitmapData
		{
			return EmbeddedBitmapAllocatorInstance.get( vgrip ).bitmapData;
		}
		static public function getHGrip() : BitmapData
		{
			return EmbeddedBitmapAllocatorInstance.get( hgrip ).bitmapData;
		}
		
		[Embed(source="../skinning/icons/toolbargripH.png")]
		static public const hgrip : Class;
		
		[Embed(source="../skinning/icons/toolbargripV.png")]
		static public const vgrip : Class;
		
		public function ToolBarGrip ()
		{
			super( );
			invalidatePreferredSizeCache();
			
			/*FDT_IGNORE*/ FEATURES::CURSOR { /*FDT_IGNORE*/
			cursor = Cursor.get( MouseCursor.HAND );
			/*FDT_IGNORE*/ } /*FDT_IGNORE*/
			
			/*FDT_IGNORE*/ FEATURES::TOOLTIP { /*FDT_IGNORE*/
			_userTooltip = _("Drag the toolbar");
			/*FDT_IGNORE*/ } /*FDT_IGNORE*/
		}
		override public function invalidatePreferredSizeCache () : void 
		{
			_size = null;
			_preferredSizeCache = dm(10,10);
			super.invalidatePreferredSizeCache();
		}
		
		override public function set allowDrag (b : Boolean) : void {}
		override public function set gesture (gesture : DragGesture) : void {}
		
		public function set direction( d : String ) : void
		{
			if( d == Directions.TOP_TO_BOTTOM || d == Directions.BOTTOM_TO_TOP )
			{
				styleKey = "ToolBarGripH";
			}
			else
			{
				styleKey = "ToolBarGripV";
			}
		}
	}
}
