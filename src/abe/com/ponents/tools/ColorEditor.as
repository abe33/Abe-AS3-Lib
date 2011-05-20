package abe.com.ponents.tools 
{
	import abe.com.mon.colors.Color;
	import abe.com.mon.geom.Dimension;
	import abe.com.patibility.lang._;
	import abe.com.ponents.core.Component;
	import abe.com.ponents.buttons.ButtonDisplayModes;
	import abe.com.ponents.events.ComponentEvent;
	import abe.com.ponents.skinning.icons.magicIconBuild;
	import abe.com.ponents.tabs.SimpleTab;
	import abe.com.ponents.tabs.TabbedPane;

    import org.osflash.signals.Signal;    
    
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
		
		[Embed(source="../skinning/icons/color_wheel.png")]
		static public var COLOR_WHEEL_ICON : Class;
		
		protected var _target : Color;
		protected var _rgbEditor : RGBColorEditor;
		protected var _paletteEditor : PaletteColorEditor;
		protected var _colorWheelEditor : ColorWheelEditor;
		
        protected var _dataChanged : Signal;
        public function get dataChanged () : Signal { return _dataChanged; }
        
		public function ColorEditor (tabsPosition : String = "north")
		{
			super( tabsPosition );
			_dataChanged = new Signal();
			preferredSize = new Dimension(290, 350);
			
			_tabBar.buttonDisplayMode = ButtonDisplayModes.ICON_ONLY;
			
			_rgbEditor = new RGBColorEditor();
			addTab( new SimpleTab( _("RGB"), _rgbEditor, magicIconBuild(RGB_ICON) ) );
			
			_colorWheelEditor = new ColorWheelEditor();
			addTab( new SimpleTab( _("Color Wheel"), _colorWheelEditor, magicIconBuild(COLOR_WHEEL_ICON) ) );

			_paletteEditor = new PaletteColorEditor();
			addTab( new SimpleTab( _("Palettes"), _paletteEditor, magicIconBuild(PALETTE_ICON) ) );
			
			this.target = new Color();
		}
		protected function colorDataChanged ( c : Component, cl : Color ) : void 
		{
			if( c == _paletteEditor )
			{
				_rgbEditor.target = _target;
				_colorWheelEditor.target = _target;
			}
			else if( c == _rgbEditor )
		    {
		        _paletteEditor.target = _target;
		        _colorWheelEditor.target = _target;
		    }				
			else if( c == _colorWheelEditor )
			{
				_paletteEditor.target = _target;
				_rgbEditor.target = _target;
			}
				
			fireDataChangedSignal();
		}
		public function get target () : Color { return _target; }	
		public function set target (target : Color) : void
		{
			_target = target.clone();
			
			_rgbEditor.target = _target;
			_rgbEditor.safeTarget = _target;
			_paletteEditor.target = _target;
			_colorWheelEditor.target = _target;
		}
		protected function fireDataChangedSignal () : void 
		{
			_dataChanged.dispatch( this, _target );
		}
		override protected function registerToOnStageEvents () : void 
		{
			super.registerToOnStageEvents( );
			_rgbEditor.dataChanged.add ( colorDataChanged );
			_paletteEditor.dataChanged.add( colorDataChanged );
			_colorWheelEditor.dataChanged.add( colorDataChanged );
		}

		override protected function unregisterFromOnStageEvents () : void 
		{
			super.unregisterFromOnStageEvents( );
			_rgbEditor.dataChanged.remove ( colorDataChanged );
			_paletteEditor.dataChanged.remove( colorDataChanged );
			_colorWheelEditor.dataChanged.remove( colorDataChanged );
		}
	}
}
