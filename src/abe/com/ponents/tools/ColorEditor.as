package abe.com.ponents.tools 
{
	import abe.com.mon.geom.Dimension;
	import abe.com.mon.utils.Color;
	import abe.com.patibility.lang._;
	import abe.com.ponents.buttons.ButtonDisplayModes;
	import abe.com.ponents.events.ComponentEvent;
	import abe.com.ponents.skinning.icons.magicIconBuild;
	import abe.com.ponents.tabs.SimpleTab;
	import abe.com.ponents.tabs.TabbedPane;

	/**
	 * @author cedric
	 */
	[Event(name="dataChange",type="abe.com.ponents.events.ComponentEvent")]
	public class ColorEditor extends TabbedPane 
	{
		[Embed(source="../skinning/icons/palette.png")]
		static public var RGB_ICON : Class;
		
		[Embed(source="../skinning/icons/color_swatch.png")]
		static public var PALETTE_ICON : Class;
		
		protected var _target : Color;
		protected var _rgbEditor : RGBColorEditor;
		protected var _paletteEditor : PaletteColorEditor;

		public function ColorEditor (tabsPosition : String = "north")
		{
			super( tabsPosition );
			preferredSize = new Dimension(290, 300);
			
			_tabBar.buttonDisplayMode = ButtonDisplayModes.ICON_ONLY;
			
			
			_rgbEditor = new RGBColorEditor();
			addTab( new SimpleTab( _("RGB"), _rgbEditor, magicIconBuild(RGB_ICON) ) );			
			_paletteEditor = new PaletteColorEditor();
			addTab( new SimpleTab( _("Palettes"), _paletteEditor, magicIconBuild(PALETTE_ICON) ) );
			
			this.target = new Color();
		}

		protected function colorDataChange (event : ComponentEvent) : void 
		{
			if( event.target != _rgbEditor )
				_rgbEditor.target = _target;
			if( event.target != _paletteEditor )
				_paletteEditor.target = _target;
				
			fireDataChange();
		}

		public function get target () : Color { return _target; }	
		public function set target (target : Color) : void
		{
			_target = target.clone();
			
			_rgbEditor.target = _target;			_rgbEditor.safeTarget = _target;
			_paletteEditor.target = _target;
		}
		protected function fireDataChange () : void 
		{
			dispatchEvent(new ComponentEvent(ComponentEvent.DATA_CHANGE));
		}

		override protected function registerToOnStageEvents () : void 
		{
			super.registerToOnStageEvents( );
			_rgbEditor.addEventListener(ComponentEvent.DATA_CHANGE, colorDataChange );
			_paletteEditor.addEventListener(ComponentEvent.DATA_CHANGE, colorDataChange );
		}

		override protected function unregisterFromOnStageEvents () : void 
		{
			super.unregisterFromOnStageEvents( );
			_rgbEditor.removeEventListener(ComponentEvent.DATA_CHANGE, colorDataChange );
			_paletteEditor.removeEventListener(ComponentEvent.DATA_CHANGE, colorDataChange );
		}
	}
}
