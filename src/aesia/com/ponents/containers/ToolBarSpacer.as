package aesia.com.ponents.containers 
{
	import aesia.com.mon.geom.Dimension;
	import aesia.com.mon.geom.dm;
	import aesia.com.ponents.core.AbstractComponent;
	import aesia.com.ponents.core.Component;

	import flash.ui.ContextMenuItem;

	/**
	 * @author cedric
	 */
	[Skinable(skin="NoDecorationComponent")]
	public class ToolBarSpacer extends AbstractComponent 
	{
		static public const PIXEL : String = "px";
		static public const PERCENT : String = "%";
		protected var _mode : String;
		protected var _value : uint;
		protected var _toolBar : ToolBar;

		public function ToolBarSpacer ( toolBar : ToolBar, value : uint = 100, mode : String = "%" )
		{
			super();
			_toolBar = toolBar;
			_mode = mode;
			_value = value;
			invalidatePreferredSizeCache ();
		}
		
		public function get mode () : String { return _mode; }		
		public function set mode (mode : String) : void
		{
			_mode = mode;
			invalidatePreferredSizeCache ();
		}
		
		public function get value () : uint { return _value; }		
		public function set value (value : uint) : void
		{
			_value = value;
			invalidatePreferredSizeCache ();
		}
		/*FDT_IGNORE*/ FEATURES::MENU_CONTEXT { /*FDT_IGNORE*/
		override public function get menuContext () : Vector.<ContextMenuItem> { return _toolBar.menuContext; }
		/*FDT_IGNORE*/ } /*FDT_IGNORE*/
		override public function invalidatePreferredSizeCache () : void
		{
			switch(_mode)
			{
				case PIXEL :
					_preferredSizeCache = dm(_value, 10);
					break;
				case PERCENT : 
				default : 
					var w : uint = _toolBar.width - _toolBar.style.insets.horizontal;
					var l : uint = _toolBar.childrenCount;
					for( var i:uint = 0;i<l;i++)
					{
						var c : Component = _toolBar.children[i];
						if( !(c is ToolBarSpacer) )
							w -= c.width;
					}
					
					_preferredSizeCache = dm( w * _value / 100, 10 );
					break;
			}
			super.invalidatePreferredSizeCache();
		}

		override public function get preferredSize () : Dimension 
		{
			_size = null;
			invalidatePreferredSizeCache();	
			return super.preferredSize;		
		}
	}
}
