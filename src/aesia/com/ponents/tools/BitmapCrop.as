package aesia.com.ponents.tools
{
	import aesia.com.mands.ProxyCommand;
	import aesia.com.mon.geom.Dimension;
	import aesia.com.mon.geom.Rectangle2;
	import aesia.com.mon.geom.dm;
	import aesia.com.mon.geom.pt;
	import aesia.com.mon.utils.Color;
	import aesia.com.mon.utils.KeyStroke;
	import aesia.com.mon.utils.Keys;
	import aesia.com.mon.utils.PointUtils;
	import aesia.com.patibility.lang._;
	import aesia.com.ponents.core.SimpleDOContainer;
	import aesia.com.ponents.layouts.display.DOStretchLayout;
	import aesia.com.ponents.skinning.cursors.Cursor;
	import aesia.com.ponents.utils.Insets;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.GraphicsPathCommand;
	import flash.display.Shape;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.ui.MouseCursor;

	[Skinable(skin="BitmapCrop")]
	[Skin(define="BitmapCrop",
			  inherit="DefaultComponent",
			  state__all__background="new deco::SimpleFill(color(0xff333333))",
			  state__all__foreground="new deco::SimpleBorders(color(0xff000000))"
			  
	)]
	/**
	 * @author Cédric Néhémie
	 */
	public class BitmapCrop extends SimpleDOContainer
	{
		static protected const CONTROL_POINTS_SIZE : uint = 6;
		public var keyboardIncrement : uint = 1;

		protected var _bitmap : BitmapData;
		protected var _bitmapContainer : Bitmap;
		protected var _outputSize : Dimension;
		protected var _sourceRect : Rectangle2;
		protected var _output : BitmapData;
		protected var _pressedX : Number;
		protected var _pressedY : Number;
		protected var _pressedAngle : Number;
		protected var _cropPreview : Shape;
		protected var _controlPoints : Object;
		protected var _currentTransformMode : String;		protected var _allowRotation : Boolean;
		protected var _constraintsRatio : Boolean;

		public function BitmapCrop ( bitmap : BitmapData = null, outputSize : Dimension = null )
		{
			super ();
			_controlPoints = {};
			_cropPreview = new Shape ();
			_allowRotation = true;
			_constraintsRatio = true;
			_allowOver = false;
			_allowPressed = false;

			childrenLayout = new DOStretchLayout ( _childrenContainer, true );
			this.outputSize = outputSize;
			this.bitmap = bitmap;
			addChild ( _cropPreview );
			_sourceRect = new Rectangle2 ( 0, 0, _outputSize.width, _outputSize.height );

			/*FDT_IGNORE*/ FEATURES::KEYBOARD_CONTEXT { /*FDT_IGNORE*/
				_keyboardContext[ KeyStroke.getKeyStroke(Keys.UP) ] = new ProxyCommand(up);				_keyboardContext[ KeyStroke.getKeyStroke(Keys.DOWN) ] = new ProxyCommand(down);				_keyboardContext[ KeyStroke.getKeyStroke(Keys.LEFT) ] = new ProxyCommand(left);				_keyboardContext[ KeyStroke.getKeyStroke(Keys.RIGHT) ] = new ProxyCommand(right);
			/*FDT_IGNORE*/ } /*FDT_IGNORE*/
			/*FDT_IGNORE*/ FEATURES::MENU_CONTEXT { /*FDT_IGNORE*/
				addNewContextMenuItemForGroup( _("Reset transformations"), "reset", reset, "transformations", -1, true );
			/*FDT_IGNORE*/ } /*FDT_IGNORE*/
		}
		public function get bitmap () : BitmapData { return _bitmap; }
		public function set bitmap ( bitmap : BitmapData ) : void
		{
			if( _bitmap )
			{
				removeComponentChild( _bitmapContainer );
			}
			_bitmap = bitmap;

			if( _bitmap )
			{
				_bitmapContainer = new Bitmap ( _bitmap, "auto", true );
				addComponentChild ( _bitmapContainer );

			}
			/*FDT_IGNORE*/ FEATURES::MENU_CONTEXT { /*FDT_IGNORE*/
				setContextMenuItemEnabled( "reset", _bitmap != null );
			/*FDT_IGNORE*/ } /*FDT_IGNORE*/
			updateOutputBitmap();
			invalidatePreferredSizeCache();
		}
		public function get outputSize () : Dimension { return _outputSize;	}
		public function set outputSize ( outputSize : Dimension ) : void
		{
			_outputSize = outputSize ? outputSize : dm ( 640, 480 );
			if( _sourceRect )
			{
				_sourceRect.width = _outputSize.width;				_sourceRect.height = _outputSize.height;
			}
			updateOutputBitmap ();
		}
		public function get sourceRect () : Rectangle2 { return _sourceRect; }
		public function get output() : BitmapData { return _output;}

		public function get allowRotation () : Boolean { return _allowRotation; }
		public function set allowRotation ( allowRotation : Boolean ) : void
		{
			_allowRotation = allowRotation;
		}
		public function get constraintsRatio () : Boolean { return _constraintsRatio; }
		public function set constraintsRatio ( constraintsRatio : Boolean ) : void
		{
			_constraintsRatio = constraintsRatio;
		}
		public function up() : void
		{
			_sourceRect.y -= keyboardIncrement;
			updateOutput();
		}
		public function down() : void
		{
			_sourceRect.y += keyboardIncrement;
			updateOutput();
		}
		public function left() : void
		{
			_sourceRect.x -= keyboardIncrement;
			updateOutput();
		}
		public function right() : void
		{
			_sourceRect.x += keyboardIncrement;
			updateOutput();
		}
		public function reset(... args) : void
		{
			_sourceRect = new Rectangle2 ( 0, 0, _outputSize.width, _outputSize.height );
			updateOutput();
			invalidate(true);
		}
		public function updateOutput():void
		{
			if( _bitmap )
			{
				var m : Matrix = new Matrix ();
				var rx : Number = _outputSize.width / _sourceRect.width;
				var ry : Number = _outputSize.height / _sourceRect.height;

				m.scale ( rx, ry );
				m.translate ( -_sourceRect.x*rx, -_sourceRect.y*ry );
				m.rotate ( -_sourceRect.rotation );

				_output.lock ();
				_output.fillRect ( _output.rect, 0x00000000 );
				_output.draw ( _bitmap, m, null, null, null, true );
				_output.unlock();
			}
		}
		protected function updateOutputBitmap () : void
		{
			if( _output )
			{
				_output.dispose();
				_output = null;
			}
			_output = new BitmapData(_outputSize.width, _outputSize.height, true, 0);
			updateOutput();
		}
		protected function updateControlPoints():void
		{
			if( _bitmap )
			{
				var w : Number = CONTROL_POINTS_SIZE / _bitmapContainer.scaleX;
				var h : Number = CONTROL_POINTS_SIZE / _bitmapContainer.scaleY;

				_controlPoints[ Cursor.RESIZE_NW ] = new Rectangle ( _sourceRect.topLeft.x - w/2, _sourceRect.topLeft.y - h/2, w, h );
				_controlPoints[ Cursor.RESIZE_NE ] = new Rectangle ( _sourceRect.topRight.x - w/2, _sourceRect.topRight.y - h/2, w, h );
				_controlPoints[ Cursor.RESIZE_SW ] = new Rectangle ( _sourceRect.bottomLeft.x - w/2, _sourceRect.bottomLeft.y - h/2, w, h );
				_controlPoints[ Cursor.RESIZE_SE ] = new Rectangle ( _sourceRect.bottomRight.x - w/2, _sourceRect.bottomRight.y - h/2, w, h );

				_controlPoints[ Cursor.RESIZE_N ] = new Rectangle ( _sourceRect.topEdgeCenter.x - w/2, _sourceRect.topEdgeCenter.y - h/2, w, h );				_controlPoints[ Cursor.RESIZE_S ] = new Rectangle ( _sourceRect.bottomEdgeCenter.x - w/2, _sourceRect.bottomEdgeCenter.y - h/2, w, h );				_controlPoints[ Cursor.RESIZE_E ] = new Rectangle ( _sourceRect.rightEdgeCenter.x - w/2, _sourceRect.rightEdgeCenter.y - h/2, w, h );				_controlPoints[ Cursor.RESIZE_W ] = new Rectangle ( _sourceRect.leftEdgeCenter.x - w/2, _sourceRect.leftEdgeCenter.y - h/2, w, h );
			}
		}
		override public function repaint () : void
		{
			super.repaint ();
			updateControlPoints();
			drawSourceRect();
		}
		protected function drawSourceRect () : void
		{
			var g : Graphics = _cropPreview.graphics;
			g.clear();
			if( _bitmap )
			{
				var r : Rectangle;
				var rx : Number = _bitmapContainer.scaleX;
				var ry : Number = _bitmapContainer.scaleY;
				var insets : Insets = style.insets;

				r = new Rectangle ( (insets.left - _bitmapContainer.x) / rx,
									( insets.top - _bitmapContainer.y ) / ry,
									( width - insets.horizontal ) / rx,
									( height - insets.vertical ) / ry
								  );
				_cropPreview.scrollRect = r;

				_cropPreview.scaleX = _cropPreview.scaleY = _bitmapContainer.scaleX;
				//_cropPreview.x = _bitmapContainer.x;				//_cropPreview.y = _bitmapContainer.y;

				g.beginFill( 0, .5 );

				var p1 : Point = _sourceRect.topLeft;
				var p2 : Point = _sourceRect.topRight;
				var p3 : Point = _sourceRect.bottomRight;
				var p4 : Point = _sourceRect.bottomLeft;
				
				/*FDT_IGNORE*/
				TARGET::FLASH_9 { var commands : Array = new Array(10); }
				TARGET::FLASH_10 { var commands : Vector.<int> = new Vector.<int>(10, true); }
				TARGET::FLASH_10_1 { /*FDT_IGNORE*/
				var commands : Vector.<int> = new Vector.<int>(10, true); /*FDT_IGNORE*/ } /*FDT_IGNORE*/
				
				commands[0] = GraphicsPathCommand.MOVE_TO;
				commands[1] = GraphicsPathCommand.LINE_TO;
				commands[2] = GraphicsPathCommand.LINE_TO;
				commands[3] = GraphicsPathCommand.LINE_TO;
				commands[4] = GraphicsPathCommand.LINE_TO;
				commands[5] = GraphicsPathCommand.MOVE_TO;
				commands[6] = GraphicsPathCommand.LINE_TO;
				commands[7] = GraphicsPathCommand.LINE_TO;
				commands[8] = GraphicsPathCommand.LINE_TO;
				commands[9] = GraphicsPathCommand.LINE_TO;
				
				/*FDT_IGNORE*/
				TARGET::FLASH_9 { var data : Array = new Array(20); }
				TARGET::FLASH_10 { var data : Vector.<Number> = new Vector.<Number>(20, true); }
				TARGET::FLASH_10_1 { /*FDT_IGNORE*/
				var data : Vector.<Number> = new Vector.<Number>(20, true); /*FDT_IGNORE*/ } /*FDT_IGNORE*/
				
				data[0] = 0; // x
				data[1] = 0; // y
				data[2] = _bitmap.width;
				data[3] = 0;
				data[4] = _bitmap.width;
				data[5] = _bitmap.height;
				data[6] = 0;
				data[7] = _bitmap.height;
				data[8] = 0;
				data[9] = 0;

				data[10] = p1.x; // x
				data[11] = p1.y; // y
				data[12] = p4.x;
				data[13] = p4.y;
				data[14] = p3.x;
				data[15] = p3.y;
				data[16] = p2.x;
				data[17] = p2.y;
				data[18] = p1.x;
				data[19] = p1.y;

				g.drawPath(commands, data );
				g.endFill();

				_sourceRect.draw(g, Color.Black);

				for(var i : String in _controlPoints)
				{
					r = _controlPoints[i];
					g.beginFill( 0xffffff, 1 );
					g.lineStyle(0, 0);
					g.drawRect(r.x, r.y, r.width, r.height);
					g.endFill();
				}
			}
		}
		override public function mouseDown(e : MouseEvent) : void
		{
			super.mouseDown(e);
			_pressedX = mouseX;
			_pressedY = mouseY;
			if( _bitmap )
				_pressedAngle = Math.atan2 ( _bitmapContainer.mouseY - _sourceRect.center.y,
											 _bitmapContainer.mouseX - _sourceRect.center.x ) - _sourceRect.rotation;
		}
		override public function mouseMove(e : MouseEvent) : void
		{
			super.mouseMove(e);

			if( _pressed )
			{
				var dx : Number = mouseX - _pressedX ;
				var dy : Number = mouseY - _pressedY;

				var pt1 : Point;				var pt2 : Point;
				var ratio : Number = _outputSize.width / _outputSize.height;
				var dif : Number;				var difx : Number;				var dify : Number;
				switch( _currentTransformMode )
				{
					case Cursor.DRAG :
						_sourceRect.offset ( dx / _bitmapContainer.scaleX, dy / _bitmapContainer.scaleY );
						break;
					case Cursor.ROTATE :
						var a : Number = Math.atan2 ( _bitmapContainer.mouseY - _sourceRect.center.y, _bitmapContainer.mouseX - _sourceRect.center.x );
						_sourceRect.rotateAroundCenter ( ( a - _pressedAngle ) - _sourceRect.rotation );
						break;
					case Cursor.RESIZE_W :
						pt1 = _sourceRect.leftEdgeCenter;
						pt2 = pt( _bitmapContainer.mouseX, _bitmapContainer.mouseY );

						pt1 = PointUtils.rotateAround(pt1, _sourceRect.center, -_sourceRect.rotation);
						pt2 = PointUtils.rotateAround(pt2, _sourceRect.center, -_sourceRect.rotation);

						dif = pt1.subtract ( pt2 ).x;
						_sourceRect.inflateLeft ( dif );
						if( _constraintsRatio )
							_sourceRect.inflateBottom( dif / ratio );
						break;
					case Cursor.RESIZE_E :
						pt1 = _sourceRect.rightEdgeCenter;
						pt2 = pt( _bitmapContainer.mouseX, _bitmapContainer.mouseY );

						pt1 = PointUtils.rotateAround(pt1, _sourceRect.center, -_sourceRect.rotation);
						pt2 = PointUtils.rotateAround(pt2, _sourceRect.center, -_sourceRect.rotation);

						dif = pt2.subtract ( pt1 ).x;
						_sourceRect.inflateRight ( dif );
						if( _constraintsRatio )
							_sourceRect.inflateBottom( dif / ratio );
						break;
					case Cursor.RESIZE_N :
						pt1 = _sourceRect.topEdgeCenter;
						pt2 = pt( _bitmapContainer.mouseX, _bitmapContainer.mouseY );

						pt1 = PointUtils.rotateAround(pt1, _sourceRect.center, -_sourceRect.rotation);
						pt2 = PointUtils.rotateAround(pt2, _sourceRect.center, -_sourceRect.rotation);

						dif = pt1.subtract(pt2).y;
						_sourceRect.inflateTop(dif);
						if( _constraintsRatio )
							_sourceRect.inflateRight( dif * ratio );
						break;
					case Cursor.RESIZE_S :
						pt1 = _sourceRect.bottomEdgeCenter;
						pt2 = pt( _bitmapContainer.mouseX, _bitmapContainer.mouseY );

						pt1 = PointUtils.rotateAround(pt1, _sourceRect.center, -_sourceRect.rotation);
						pt2 = PointUtils.rotateAround(pt2, _sourceRect.center, -_sourceRect.rotation);

						dif = pt2.subtract(pt1).y;
						_sourceRect.inflateBottom( dif );
						if( _constraintsRatio )
							_sourceRect.inflateRight( dif * ratio );
						break;
					case Cursor.RESIZE_NW :
						pt1 = _sourceRect.topLeft;
						pt2 = pt( _bitmapContainer.mouseX, _bitmapContainer.mouseY );

						pt1 = PointUtils.rotateAround(pt1, _sourceRect.center, -_sourceRect.rotation);
						pt2 = PointUtils.rotateAround(pt2, _sourceRect.center, -_sourceRect.rotation);

						difx = pt1.subtract(pt2).x;						dify = pt1.subtract(pt2).y;

						if( _constraintsRatio )
							_sourceRect.inflateTopLeft( difx, difx / ratio );						else
							_sourceRect.inflateTopLeft( difx, dify );
						break;
					case Cursor.RESIZE_NE :
						pt1 = _sourceRect.topRight;
						pt2 = pt( _bitmapContainer.mouseX, _bitmapContainer.mouseY );

						pt1 = PointUtils.rotateAround(pt1, _sourceRect.center, -_sourceRect.rotation);
						pt2 = PointUtils.rotateAround(pt2, _sourceRect.center, -_sourceRect.rotation);

						difx = pt2.subtract(pt1).x;
						dify = pt1.subtract(pt2).y;

						if( _constraintsRatio )
							_sourceRect.inflateTopRight( difx, difx / ratio );
						else
							_sourceRect.inflateTopRight( difx, dify );
						break;
					case Cursor.RESIZE_SW :
						pt1 = _sourceRect.bottomLeft;
						pt2 = pt( _bitmapContainer.mouseX, _bitmapContainer.mouseY );

						pt1 = PointUtils.rotateAround(pt1, _sourceRect.center, -_sourceRect.rotation);
						pt2 = PointUtils.rotateAround(pt2, _sourceRect.center, -_sourceRect.rotation);

						difx = pt1.subtract(pt2).x;
						dify = pt2.subtract(pt1).y;

						if( _constraintsRatio )
							_sourceRect.inflateBottomLeft( difx, difx / ratio );
						else
							_sourceRect.inflateBottomLeft( difx, dify );
						break;
					case Cursor.RESIZE_SE :
						pt1 = _sourceRect.bottomRight;
						pt2 = pt( _bitmapContainer.mouseX, _bitmapContainer.mouseY );

						pt1 = PointUtils.rotateAround(pt1, _sourceRect.center, -_sourceRect.rotation);
						pt2 = PointUtils.rotateAround(pt2, _sourceRect.center, -_sourceRect.rotation);

						difx = pt2.subtract(pt1).x;
						dify = pt2.subtract(pt1).y;

						if( _constraintsRatio )
							_sourceRect.inflateBottomRight( difx, difx / ratio );
						else
							_sourceRect.inflateBottomRight( difx, dify );
						break;
					case MouseCursor.ARROW :
					default :
						break;
				}
				updateOutput();

				_pressedX = mouseX;
				_pressedY = mouseY;
				invalidate(true);
			}
			else if( _bitmap )
			{
				var overControls : Boolean = false;
				var mx : Number = _bitmapContainer.mouseX;				var my : Number = _bitmapContainer.mouseY;

				for( var i : String in _controlPoints )
				{
					var r : Rectangle = _controlPoints[i];
					if( r.contains(mx, my) )
					{
						_currentTransformMode = i;
						overControls = true;
					}
				}
				if( !overControls )
				{
					if( _sourceRect.contains ( mx, my ) )
						_currentTransformMode = Cursor.DRAG;
					else if( _allowRotation )
						_currentTransformMode = Cursor.ROTATE;
					else
						_currentTransformMode = MouseCursor.ARROW;
				}
				cursor = Cursor.get ( _currentTransformMode );
			}
		}
		protected function mouseWheel ( event : MouseEvent ) : void
		{
			var r : Number = _sourceRect.width / _sourceRect.height;
			_sourceRect.inflateAroundCenter( event.delta, event.delta / r );

			updateOutput();
			invalidate(true);
		}
		override protected function registerToOnStageEvents () : void
		{
			super.registerToOnStageEvents ();
			//addEventListener(MouseEvent.MOUSE_WHEEL, mouseWheel );
		}
		override protected function unregisterFromOnStageEvents () : void
		{
			super.unregisterFromOnStageEvents ();
			//removeEventListener(MouseEvent.MOUSE_WHEEL, mouseWheel );
		}
	}
}
