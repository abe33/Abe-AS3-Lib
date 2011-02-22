package abe.com.ponents.swf.timeline.frames
{
	import abe.com.mon.utils.Color;
	import abe.com.ponents.core.SimpleDOContainer;

	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.text.TextField;

	[Skinable(skin="KeyFrame")]
	[Skin(define="KeyFrame",
			  inherit="DefaultComponent",
			  state__all__background="new abe.com.ponents.skinning.decorations::SimpleFill(color(0x88cccccc))",
			  state__all__borders="new abe.com.ponents.utils::Borders(0,0,1,1)",
			  state__all__format="new flash.text::TextFormat('Verdana',9)"
	)]
	/**
	 * @author Cédric Néhémie
	 */
	public class KeyFrame extends SimpleDOContainer
	{
		//static private var SKIN_DEPENDENCIES : Array = [LineBorders];

		static public const DOT_RADIUS : Number = 2.5;

		[Embed(source="../../../skinning/icons/frame_script.png")]
		static public var frame_script : Class;
		
		[Embed(source="../../../skinning/icons/frame_label.png")]
		static public var frame_label : Class;

		static public var frame_script_icon : BitmapData = new KeyFrame.frame_script().bitmapData;		static public var frame_label_icon : BitmapData = new KeyFrame.frame_label().bitmapData;

		public var frameName : String;
		public var frame : uint;
		public var script : String;

		public var frameWidth : uint;
		public var nextFrame : KeyFrame;
		public var previousFrame : KeyFrame;

		protected var _label : TextField;

		public function KeyFrame ( frame : uint, frameName : String = null, script : String = null )
		{
			super ();
			_allowOver = false;
			_allowPressed = false;
			_allowFocus = false;
			this.frame = frame;
			this.frameName = frameName;
			this.script = script;
		}

		public function get nextFrameIsEmpty () : Boolean { return !nextFrame || nextFrame is EmptyKeyFrame; }
		override public function repaint () : void
		{
			super.repaint ();
			paintFrameAttributes();
		}
		protected function paintFrameAttributes () : void
		{
			_childrenContainer.graphics.clear();			_childrenContainer.graphics.lineStyle();
			drawDot();
			drawFrameExtension();
			drawActionScript();
			drawLabel();
		}

		protected function drawLabel () : void
		{
			if( frameName )
			{
				var bmp : BitmapData = frame_label_icon;

				var m : Matrix = new Matrix();
				m.createBox( 1, 1, 0, 1, 1 );

				_childrenContainer.graphics.beginBitmapFill( bmp, m );
				_childrenContainer.graphics.drawRect( 1, 1, 5, 6 );
				_childrenContainer.graphics.endFill();

				if( width > frameWidth )
				{
					if(!_label)
					{
						_label = new TextField();
						addComponentChild( _label );
						_label.x = frameWidth-2;						_label.y = -2;
					}
					_label.width = width - frameWidth;
					_label.height = height;
					_label.defaultTextFormat = _style.format;
					_label.text = frameName;
				}
				else
				{
					if( _label )
					{
						removeComponentChild(_label);
						_label = null;
					}
				}
			}
			else
			{
				if( _label )
				{
					removeComponentChild(_label);
					_label = null;
				}
			}
		}
		protected function drawActionScript () : void
		{
			if( script )
			{
				var bmp : BitmapData = frame_script_icon;

				var m : Matrix = new Matrix();
				m.createBox( 1, 1, 0, 1, 7 );

				_childrenContainer.graphics.beginBitmapFill( bmp, m );
				_childrenContainer.graphics.drawRect( 1, 7, 5, 5 );
				_childrenContainer.graphics.endFill();
			}
		}
		protected function drawFrameExtension () : void
		{
			if( width > frameWidth )
			{
				_childrenContainer.graphics.lineStyle ( 0, Color.Black.hexa );
				_childrenContainer.graphics.beginFill ( Color.White.hexa );
				_childrenContainer.graphics.drawRect ( width-7, height-10,4,7 );
				_childrenContainer.graphics.endFill();
			}
		}
		protected function drawDot () : void
		{
			var x : Number = frameWidth / 2 - .5;
			var y : Number = height - DOT_RADIUS - 2;

			_childrenContainer.graphics.beginFill ( Color.Black.hexa );
			_childrenContainer.graphics.drawCircle ( x, y, DOT_RADIUS );
			_childrenContainer.graphics.endFill();
		}

		override public function showToolTip ( overlay : Boolean = false ) : void
		{
			_tooltip = frameName;
			super.showToolTip ( overlay );
		}

	}
}
