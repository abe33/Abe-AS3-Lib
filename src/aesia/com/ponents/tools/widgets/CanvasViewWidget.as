package aesia.com.ponents.tools.widgets 
{
	import flash.events.ContextMenuEvent;
	import aesia.com.edia.camera.CameraEvent;
	import aesia.com.edia.camera.CameraLayer;
	import aesia.com.patibility.lang._;
	import aesia.com.ponents.core.AbstractContainer;
	import aesia.com.ponents.core.SimpleDOContainer;
	import aesia.com.ponents.events.ComponentEvent;
	import aesia.com.ponents.layouts.components.BorderLayout;
	import aesia.com.ponents.layouts.display.DOCanvasViewLayout;
	import aesia.com.ponents.models.DefaultBoundedRangeModel;
	import aesia.com.ponents.skinning.cursors.Cursor;
	import aesia.com.ponents.sliders.HSlider;
	import aesia.com.ponents.text.Label;
	import aesia.com.ponents.tools.CameraCanvas;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.ui.MouseCursor;

	[Skinable(skin="CanvasViewWidget")]
	[Skin(define="CanvasViewWidget",
		  inherit="EmptyComponent",
		  state__all__insets="new cutils::Insets(3,3,3,0)"
	)]
	[Skin(define="CanvasViewWidget_SnapShot",
		  inherit="EmptyComponent",
	      state__all__background="new deco::SimpleFill(skin.rulerBackgroundColor)"
	)]
	/**
	 * @author cedric
	 */
	public class CanvasViewWidget extends AbstractContainer 
	{
		static public const MINI_VIEW_RATIO : uint = 4;
		static public const MINI_VIEW_MARGIN : uint = 4;
		
		protected var _canvas : CameraCanvas;
		protected var _zoomSlider : HSlider;
		protected var _zoomSetProgramatically : Boolean;
		protected var _canvasSnapshot : BitmapData;		protected var _canvasMiniView : SimpleDOContainer;
		protected var _canvasBitmap : Bitmap; 
		protected var _canvasCameraScreen : Shape;
		protected var _dragging : Boolean;
		protected var _pressedX : Number;
		protected var _pressedY : Number;

		public function CanvasViewWidget ( canvas : CameraCanvas = null )
		{
			super( );
			setup();
			
			if( canvas )
				this.canvas = canvas;
		}
		public function get canvas () : CameraCanvas { return _canvas; }
		public function set canvas (canvas : CameraCanvas) : void 
		{
			if( _canvas )
				unregisterFromCanvasEvent( _canvas );
				
			_canvas = canvas;
			
			if( _canvas )
			{
				registerToCanvasEvent( _canvas );
				
				_zoomSlider.model.removeEventListener( ComponentEvent.DATA_CHANGE , zoomSliderDataChange );				
				_zoomSlider.model.minimum = Math.floor(_canvas.camera.zoomRange.min * 100 );				_zoomSlider.model.maximum = Math.floor(_canvas.camera.zoomRange.max * 100 );
				_zoomSlider.model.value = Math.floor(_canvas.camera.zoom * 100 );				( _zoomSlider.preComponent as Label ).value = _zoomSlider.model.minimum + "%";
				( _zoomSlider.postComponent as Label ).value = _zoomSlider.model.maximum + "%";
				_zoomSlider.invalidatePreferredSizeCache();
				updateMiniView();				
				_zoomSlider.model.addEventListener( ComponentEvent.DATA_CHANGE , zoomSliderDataChange );
			}
		}
		protected function setup() : void
		{
			var l : BorderLayout = new BorderLayout( this, true, 3 );
			_childrenLayout = l;
			
			var m : DefaultBoundedRangeModel = new DefaultBoundedRangeModel(0, 0, 100, 1);
			m.formatFunction = function( v : *) : String { return String( int( v ) ) + "%"; };
			_zoomSlider = new HSlider( m,
									   10,
									   1,
									   false,
									   true,
									   true, 
									   new Label("0%"),									   new Label("100%") );
			_zoomSlider.input.preferredWidth = 40;
			addComponent( _zoomSlider );
			l.south = _zoomSlider;
			
			_canvasMiniView = new SimpleDOContainer();
			_canvasBitmap = new Bitmap();
			_canvasCameraScreen = new Shape();
			_canvasMiniView.styleKey = "CanvasViewWidget_SnapShot";
			var cl : DOCanvasViewLayout = new DOCanvasViewLayout(null);
			_canvasMiniView.childrenLayout = cl;
			
			setupMiniView( _canvasMiniView );
			
			_canvasMiniView.addComponentChild( _canvasBitmap );			_canvasMiniView.addComponentChild( _canvasCameraScreen );
			
			cl.snapshot = _canvasBitmap;
			cl.screen = _canvasCameraScreen;
			
			addComponent( _canvasMiniView );
			l.center = _canvasMiniView;
			
			invalidatePreferredSizeCache();
		}
		protected function setupMiniView ( o : SimpleDOContainer) : void 
		{
			o.cursor = Cursor.get( MouseCursor.HAND );
			o.addEventListener( MouseEvent.MOUSE_DOWN, mvMouseDown );			o.addEventListener( MouseEvent.MOUSE_UP, mvMouseUp );			o.addEventListener( ComponentEvent.RELEASE_OUTSIDE, mvMouseUp );			o.addEventListener( MouseEvent.MOUSE_MOVE, mvMouseMove );
			
			o.addNewContextMenuItemForGroup( _("Zoom 1:1"), "realSize", realSizeCallback, "zoom", 0 );
		}
		protected function realSizeCallback ( e : ContextMenuEvent ) : void 
		{
			_canvas.camera.zoom = 1;
		}
		protected function mvMouseMove (event : MouseEvent) : void 
		{
			if( _dragging )
			{
				var x : Number = _canvasMiniView.mouseX;				var y : Number = _canvasMiniView.mouseY;
				
				var difx : Number = x - _pressedX;				var dify : Number = y - _pressedY;

				_pressedX = x;
				_pressedY = y;
				
				_canvas.camera.translateXY( difx / _canvasBitmap.scaleX * MINI_VIEW_RATIO, 
											dify / _canvasBitmap.scaleY * MINI_VIEW_RATIO );
			}
		}
		protected function mvMouseUp (event : Event) : void 
		{
			_dragging = false;
		}
		protected function mvMouseDown (event : MouseEvent) : void 
		{
			_dragging = true;
			_pressedX = _canvasMiniView.mouseX;			_pressedY = _canvasMiniView.mouseY;
		}
		public function updateMiniView ( e : Event = null ) : void
		{
			if( _canvasSnapshot )
				_canvasSnapshot.dispose();
			
			if( _canvas )
			{
				var bb : Rectangle = new Rectangle();				var r : Rectangle = new Rectangle();				var l : uint = _canvas.layers.length;
				var i:uint;
				var c : CameraLayer;
				var m : Matrix;
				for(i=0;i<l;i++)
				{
					c = _canvas.getLayerAt(i);
					bb = bb.union( c.getBounds( c ) );
					r = r.union( c.getBounds( _canvas ) );
				}	
				if( bb.width > 0 && bb.height > 0 )
				{
					_canvasSnapshot = new BitmapData( bb.width/MINI_VIEW_RATIO + MINI_VIEW_MARGIN, bb.height/MINI_VIEW_RATIO + MINI_VIEW_MARGIN, false, 0xffffff );
					
					var marg : Number = MINI_VIEW_MARGIN * MINI_VIEW_RATIO / 2;
					for(i=0;i<l;i++)
					{
						c = _canvas.getLayerAt(i);
						m = new Matrix();
						m.translate( -bb.x + marg, -bb.y + marg );
						m.scale(1/MINI_VIEW_RATIO, 1/MINI_VIEW_RATIO);
						_canvasSnapshot.draw(c,m);
					}
					var w : Number = _canvas.camera.safeWidth / _canvas.camera.zoom;					var h : Number = _canvas.camera.safeHeight / _canvas.camera.zoom;

					r.x -= marg;					r.y -= marg;
					r.x /= _canvas.camera.zoom;					r.y /= _canvas.camera.zoom;
					_canvasCameraScreen.graphics.clear();
					_canvasCameraScreen.graphics.lineStyle(0, 0xff0000);
					_canvasCameraScreen.graphics.drawRect( -r.x / MINI_VIEW_RATIO, 
														   -r.y / MINI_VIEW_RATIO, 
														   w / MINI_VIEW_RATIO, 
														   h / MINI_VIEW_RATIO);
					_canvasCameraScreen.graphics.endFill();
					
					_canvasBitmap.bitmapData = _canvasSnapshot;
					_canvasMiniView.invalidatePreferredSizeCache();
				}
			}
			repaint();
		}
		protected function registerToCanvasEvent( c : CameraCanvas ) : void
		{
			c.camera.addEventListener(CameraEvent.CAMERA_CHANGE, cameraChange );
			c.addEventListener(ComponentEvent.REPAINT, canvasRepaint );		}
		protected function unregisterFromCanvasEvent( c : CameraCanvas ) : void		{
			c.camera.removeEventListener(CameraEvent.CAMERA_CHANGE, cameraChange );
			c.removeEventListener(ComponentEvent.REPAINT, canvasRepaint );
		}
		protected function canvasRepaint (event : ComponentEvent) : void 
		{
			updateMiniView();
		}
		protected function zoomSliderDataChange (event : ComponentEvent) : void 
		{
			if( _canvas )
			{
				_zoomSetProgramatically = true;
				_canvas.camera.zoom = _zoomSlider.model.value / 100;
				_zoomSetProgramatically = false;
			}
		}
		protected function cameraChange (event : CameraEvent) : void 
		{
			if( !_zoomSetProgramatically )
				_zoomSlider.model.value = Math.floor( _canvas.camera.zoom * 100 );
				
			updateMiniView();
		}
	}
}
