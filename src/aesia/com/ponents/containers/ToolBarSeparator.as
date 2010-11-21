package aesia.com.ponents.containers 
{
	import flash.ui.ContextMenuItem;

	import aesia.com.mon.geom.Dimension;
	import aesia.com.ponents.core.AbstractComponent;
	import aesia.com.ponents.skinning.decorations.SeparatorDecoration;
	import aesia.com.ponents.transfer.ComponentTransferable;
	import aesia.com.ponents.transfer.Transferable;
	import aesia.com.ponents.utils.Directions;

	import flash.display.DisplayObject;
	import flash.events.FocusEvent;

	/**
	 * @author Cédric Néhémie
	 */
	[Skinable(skin="ToolBarSeparatorV")]
	[Skin(define="ToolBarSeparatorV",
		  inherit="EmptyComponent",
		  state__all__insets="new aesia.com.ponents.utils::Insets(3)",
		  state__all__background="new aesia.com.ponents.skinning.decorations::SeparatorDecoration(color(White),color(Gray),1)"
	)]
	[Skin(define="ToolBarSeparatorH",
		  inherit="EmptyComponent",
		  state__all__insets="new aesia.com.ponents.utils::Insets(3)",
		  state__all__background="new aesia.com.ponents.skinning.decorations::SeparatorDecoration(color(White),color(Gray),0)"
	)]
	public class ToolBarSeparator extends AbstractComponent 
	{
		static private const SKIN_DEPENDENCIES : Array = [SeparatorDecoration];
		
		protected var _icon : DisplayObject;
		protected var _toolbar : ToolBar;
		
		public function ToolBarSeparator ( c : ToolBar )
		{
			super();
			toolbar = c;			
		}
		public function get toolbar () : ToolBar { return _toolbar; }
		public function set toolbar (toolbar : ToolBar) : void
		{
			_toolbar = toolbar;
			
			if( _toolbar.direction == Directions.TOP_TO_BOTTOM || _toolbar.direction == Directions.BOTTOM_TO_TOP )
			{
				styleKey = "ToolBarSeparatorH";
			}
			else
			{
				styleKey = "ToolBarSeparatorV";
			}
			
			invalidatePreferredSizeCache();
		}
		override public function invalidatePreferredSizeCache () : void
		{
			if( _toolbar.direction == Directions.TOP_TO_BOTTOM || _toolbar.direction == Directions.BOTTOM_TO_TOP )
				_preferredSizeCache = new Dimension(24,12);
			else
				_preferredSizeCache = new Dimension(12,24);
			super.invalidatePreferredSizeCache();
		}

		override public function repaint () : void
		{
			var size : Dimension = calculateComponentSize();
			
			_repaint( size );			
		}

		override public function focusIn (e : FocusEvent) : void
		{
			if( e.shiftKey )
				focusPrevious();
			else
				focusNext();
		}
		/*FDT_IGNORE*/ FEATURES::DND { /*FDT_IGNORE*/
		override public function get transferData () : Transferable
		{
			return new ComponentTransferable( this );
		}
		/*FDT_IGNORE*/ } /*FDT_IGNORE*/

		/*FDT_IGNORE*/ FEATURES::MENU_CONTEXT { /*FDT_IGNORE*/
		override public function get menuContext () : Vector.<ContextMenuItem> { return _toolbar.menuContext; }
		/*FDT_IGNORE*/ } /*FDT_IGNORE*/
	}
}
