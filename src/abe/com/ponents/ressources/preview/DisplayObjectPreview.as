package abe.com.ponents.ressources.preview 
{
	import abe.com.mon.colors.Color;
	import abe.com.mon.geom.dm;
	import abe.com.mon.logs.Log;
	import abe.com.mon.utils.MatrixUtils;
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
	import abe.com.ponents.layouts.display.DONoLayout;
	import abe.com.ponents.models.DefaultBoundedRangeModel;
	import abe.com.ponents.skinning.DefaultSkin;
	import abe.com.ponents.skinning.cursors.Cursor;
	import abe.com.ponents.skinning.decorations.SimpleFill;
	import abe.com.ponents.skinning.icons.magicIconBuild;
	import abe.com.ponents.sliders.VLogarithmicSlider;
	import abe.com.ponents.sliders.VSlider;
	import abe.com.ponents.utils.Alignments;

	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.ui.MouseCursor;
	/**
	 * @author cedric
	 */
	public class DisplayObjectPreview extends Panel 
	{
		[Embed(source="../../skinning/icons/tools/zoom.png")]
		static private var zoomIcon : Class;
		
		protected var _displayObject : DisplayObject;
		protected var _displayObjectPreview : SimpleDOContainer;
		protected var _zoomSlider : VSlider;
		protected var _toolBar : ToolBar;
		protected var _allowPan : Boolean;
		protected var _pressedX : Number;
		protected var _pressedY : Number;

		public function DisplayObjectPreview ()
		{
			super();
			buildChildren();
			styleKey = "DefaultComponent";
			_allowPan = true;
		}
		public function get displayObject () : DisplayObject { return _displayObject; }
		public function set displayObject (displayObject : DisplayObject) : void
		{
			_displayObjectPreview.removeAllComponentChildren( );
			_displayObject = displayObject;
			if(_displayObject)
			{
				_displayObjectPreview.addComponentChild( _displayObject );
				_displayObject.scaleX = _displayObject.scaleY = _zoomSlider.value;
				
				center();
			}
		}
		public function center () : void 
		{
			_displayObject.x = 0;			_displayObject.y = 0;
			
			var bb : Rectangle = _displayObject.getBounds( _displayObjectPreview );
				
			_displayObject.x = Alignments.alignHorizontal( _displayObject.width, width, _displayObjectPreview.style.insets, "center" ) - bb.left;
			_displayObject.y = Alignments.alignVertical( _displayObject.height, height, _displayObjectPreview.style.insets, "center" ) - bb.top;
		}
		protected function buildChildren () : void 
		{
			var bl : BorderLayout = new BorderLayout( this );
			_toolBar = new ToolBar(ButtonDisplayModes.ICON_ONLY, false, 3, false );
			( _toolBar.childrenLayout as InlineLayout ).horizontalAlign = "right";
			( _toolBar.childrenLayout as InlineLayout ).spacingAtExtremity = false;			
			_displayObjectPreview = new SimpleDOContainer();			_displayObjectPreview.allowMask = false;
			_displayObjectPreview.childrenLayout = new DONoLayout();
			_displayObjectPreview.styleKey = "EmptyComponent";
			_displayObjectPreview.cursor = Cursor.get( MouseCursor.HAND );
			
			
			var cp : ColorPicker = new ColorPicker( DefaultSkin.backgroundColor.clone() );
			var zbt : Button = new Button(new ProxyAction(zoomReset, _("Zoom 1:1"), magicIconBuild(zoomIcon)));
			zbt.buttonDisplayMode = ButtonDisplayModes.ICON_ONLY;
			zbt.styleKey = "ToolBar_Button";
			_zoomSlider = new VLogarithmicSlider( new DefaultBoundedRangeModel(1, 0.2, 100, 1 ), 10, 5, true, false );
			_zoomSlider.preComponent = zbt;
			cp.addEventListener(ComponentEvent.DATA_CHANGE, backgroundColorChange );
			cp.preferredSize = dm(22,22);
			
			_zoomSlider.addEventListener(ComponentEvent.DATA_CHANGE, zoomChange );
			_displayObjectPreview.addEventListener(MouseEvent.MOUSE_WHEEL, _zoomSlider.mouseWheel );			_displayObjectPreview.addEventListener(MouseEvent.MOUSE_DOWN, previewMouseDown );			_toolBar.addComponents( cp, new Button(new ProxyAction(center, "C", null, "Center")) );
			
			bl.center = _displayObjectPreview;
			bl.south = _toolBar;			bl.east = _zoomSlider;
			addComponents( _displayObjectPreview, _toolBar, _zoomSlider );
			childrenLayout = bl;
		}
		protected function previewMouseUp (event : MouseEvent) : void 
		{
			stage.removeEventListener(MouseEvent.MOUSE_UP, previewMouseUp );
			if( _allowPan )
				stage.removeEventListener(MouseEvent.MOUSE_MOVE, panPreview );
		}
		protected function previewMouseDown (event : MouseEvent) : void 
		{
			if( _allowPan )
			{
				_pressedX = stage.mouseX;				_pressedY = stage.mouseY;				stage.addEventListener(MouseEvent.MOUSE_MOVE, panPreview );
				stage.addEventListener(MouseEvent.MOUSE_UP, previewMouseUp );
			}
		}
		protected function panPreview (event : MouseEvent) : void 
		{
			var mx : Number = stage.mouseX;			var my : Number = stage.mouseY;
			var doc : DisplayObject = _displayObjectPreview.getComponentChildAt(0);			
			doc.x += mx - _pressedX;
			doc.y += my - _pressedY;
			
			_pressedX = mx;
			_pressedY = my;		}
		protected function zoomReset () : void 
		{
			_zoomSlider.value = 1;
		}
		protected function zoomChange (event : ComponentEvent) : void 
		{
			var m : Matrix = _displayObject.transform.matrix;
			var s : Number = event.target.value / _displayObject.scaleX;
			MatrixUtils.scaleAroundExternalPoint(m, width / 2 , height / 2, s, s );
			//_displayObject.scaleX = _displayObject.scaleY = event.target.value;
			_displayObject.transform.matrix = m;
			_displayObjectPreview.invalidatePreferredSizeCache();
		}
		protected function backgroundColorChange (event : ComponentEvent) : void 
		{
			_style.background = new SimpleFill( event.target.value as Color );
		}
	}
}
