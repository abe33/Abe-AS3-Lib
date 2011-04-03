package abe.com.ponents.factory.ressources.preview 
{
	import abe.com.mon.colors.Color;
	import abe.com.mon.geom.dm;
	import abe.com.patibility.lang._;
	import abe.com.ponents.actions.ProxyAction;
	import abe.com.ponents.buttons.Button;
	import abe.com.ponents.buttons.ButtonDisplayModes;
	import abe.com.ponents.buttons.ColorPicker;
	import abe.com.ponents.containers.Panel;
	import abe.com.ponents.containers.ToolBar;
	import abe.com.ponents.core.SimpleDOContainer;
	import abe.com.ponents.events.ComponentEvent;
	import abe.com.ponents.layouts.components.BorderLayout;
	import abe.com.ponents.layouts.components.InlineLayout;
	import abe.com.ponents.models.DefaultBoundedRangeModel;
	import abe.com.ponents.skinning.DefaultSkin;
	import abe.com.ponents.skinning.decorations.SimpleFill;
	import abe.com.ponents.skinning.icons.magicIconBuild;
	import abe.com.ponents.sliders.VSlider;

	import flash.display.DisplayObject;
	/**
	 * @author cedric
	 */
	public class DisplayObjectPreview extends Panel 
	{
		[Embed(source="../../../skinning/icons/tools/zoom.png")]
		static private var zoomIcon : Class;
		
		protected var _displayObject : DisplayObject;
		protected var _displayObjectPreview : SimpleDOContainer;
		protected var _zoomSlider : VSlider;
		protected var _toolBar : ToolBar;

		public function DisplayObjectPreview ()
		{
			super();
			buildChildren();
			styleKey = "DefaultComponent";
		}
		public function get displayObject () : DisplayObject { return _displayObject; }
		public function set displayObject (displayObject : DisplayObject) : void
		{
			_displayObjectPreview.removeAllComponentChildren();
			_displayObject = displayObject;
			if(_displayObject)
			{
				_displayObjectPreview.addComponentChild( _displayObject );
				_displayObject.scaleX = _displayObject.scaleY = _zoomSlider.value;
			}
		}
		protected function buildChildren () : void 
		{
			var bl : BorderLayout = new BorderLayout( this );
			_toolBar = new ToolBar(ButtonDisplayModes.ICON_ONLY, false, 3, false );
			( _toolBar.childrenLayout as InlineLayout ).horizontalAlign = "right";			( _toolBar.childrenLayout as InlineLayout ).spacingAtExtremity = false;
			_displayObjectPreview = new SimpleDOContainer();
			_displayObjectPreview.styleKey = "EmptyComponent";
			
			var cp : ColorPicker = new ColorPicker( DefaultSkin.backgroundColor.clone() );
			_zoomSlider = new VSlider( new DefaultBoundedRangeModel(1, 0.2, 100, 0.1), .1, .05, false, false, false );
			var zbt : Button = new Button(new ProxyAction(zoomReset, _("Zoom 1:1"), magicIconBuild(zoomIcon)));
			cp.addEventListener(ComponentEvent.DATA_CHANGE, backgroundColorChange );
			cp.preferredSize = dm(22,22);
			
			
			_zoomSlider.addEventListener(ComponentEvent.DATA_CHANGE, zoomChange );
			_toolBar.addComponents( cp, zbt );
			
			bl.center = _displayObjectPreview;
			bl.south = _toolBar;			bl.east = _zoomSlider;
			addComponents( _displayObjectPreview, _toolBar, _zoomSlider );
			childrenLayout = bl;
			
		}
		protected function zoomReset () : void 
		{
			_zoomSlider.value = 1;
		}
		protected function zoomChange (event : ComponentEvent) : void 
		{
			_displayObject.scaleX = _displayObject.scaleY = event.target.value;
			_displayObjectPreview.invalidatePreferredSizeCache();
		}
		protected function backgroundColorChange (event : ComponentEvent) : void 
		{
			_style.background = new SimpleFill( event.target.value as Color );
		}
	}
}
