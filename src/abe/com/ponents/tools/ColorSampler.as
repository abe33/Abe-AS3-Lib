package abe.com.ponents.tools 
{
	import abe.com.mon.colors.Color;
	import abe.com.ponents.buttons.AbstractButton;
	import abe.com.ponents.buttons.ButtonDisplayModes;
	import abe.com.ponents.events.ComponentEvent;
	import abe.com.ponents.events.PropertyEvent;
	import abe.com.ponents.layouts.display.DOStretchLayout;
	import abe.com.ponents.skinning.icons.BitmapIcon;

	import flash.display.BlendMode;
	import flash.display.Shape;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	/**
	 * @author Cédric Néhémie
	 */
	[Style(name="sampleIcon", type="abe.com.ponents.skinning.icons.Icon")]
	[Event(name="dataChange", type="abe.com.ponents.events.ComponentEvent")]
	[Skinable(skin="ColorSampler")]
	[Skin(define="ColorSampler",
			  inherit="DefaultComponent",
			  
			  custom_sampleIcon="icon(abe.com.ponents.tools::ColorSampler.DEFAULT_SAMPLE)"
	)]
	public class ColorSampler extends AbstractButton 
	{
		[Embed(source="../skinning/icons/colorpicker.png")]
		static public var DEFAULT_SAMPLE : Class;
		
		static public const X_AXIS : uint = 0;		static public const Y_AXIS : uint = 1;		static public const BOTH_AXIS : uint = 2;
		
		protected var _markerShape : Shape;
		protected var _markerAxis : uint;
		protected var _colorX : Number;		protected var _colorY : Number;
		protected var _value : Color;
		
		public function ColorSampler ()
		{
			super();
			_value = new Color();
			_markerAxis = BOTH_AXIS;
			_allowFocusTraversing = false;
			this.icon = _style.sampleIcon.clone();
			this.buttonDisplayMode = ButtonDisplayModes.ICON_ONLY;
			this.childrenLayout = new DOStretchLayout();
			_markerShape = new Shape();
			_markerShape.blendMode = BlendMode.INVERT;
			addChildAt( _markerShape, 2 );
		}
		
		public function get value () : Color { return _value; }		
		public function set value (value : Color) : void
		{
			_value = value; 
			var pt : Point = findColorPoint( _value );
			//_colorX = pt.x;			//_colorY = pt.y;
			paintMarkers( pt.x, pt.y );
			fireDataChange();
		}
		public function get markerAxis () : uint { return _markerAxis;}		
		public function set markerAxis (markerAxis : uint) : void
		{
			_markerAxis = markerAxis;
		}
		override public function mouseDown (e : MouseEvent) : void
		{
			super.mouseDown( e );
			checkCoord();
		}
		override public function mouseMove (e : MouseEvent) : void
		{
			super.mouseMove( e );
			if( _pressed )
				checkCoord();
		}
		protected function checkCoord () : void
		{
			var ic : BitmapIcon = _icon as BitmapIcon;
			
			_colorX = ic.bitmap.mouseX;			_colorY = ic.bitmap.mouseY;
			
			var col : uint = ic.bitmap.bitmapData.getPixel32(_colorX, _colorY);
			value = new Color( col );
			paintMarkers( _colorX, _colorY );
		}
		protected function getY ( c1 : uint, c2 : uint, c3 : uint, h : Number ) : Number
		{
			if( c1 == 255 )
				return h/2 - ( (c3/255) * h/2 );
			else
				return h - (c1/255) * h/2;
		}
		public function findColorPoint( color : Color ) : Point
		{
			var ic : BitmapIcon = _icon as BitmapIcon;
			
			var r : uint = color.red;			var g : uint = color.green;			var b : uint = color.blue;
			var w : Number = ic.bitmap.bitmapData.width;			var h : Number = ic.bitmap.bitmapData.height;
			var x : Number;					var y : Number;					
			var col : Number = w / 6;
			
			// cas du noir			if( r == g && r == b && r == 0 )
				return new Point( 0, h );
			// cas du blanc			
			else if( r == g && r == b && r == 0 )
				return new Point(0,0);
			// cas des colonnes de couleur dominante rouge
			else if( r > g && r > b )
			{
				// le vert est plus important que le bleu 
				if( g > b )
				{
					x = col * ( g / r );
					y = getY( r, g, b, h );
				}
				// le bleu est le plus important
				else if( b > g )
				{
					x = w - col * ( b / r );
					y = getY( r, b, g, h );
				}
				// les deux sont équivalents
				else
				{
					x = 0;
					y = getY( r, g, b, h );
				}
			}
			// cas des colonnes de couleur dominante verte
			else if( g > r && g > b )
			{
				// le rouge est plus important que le bleu 
				if( r > b )
				{
					x = col*2 - col * (r/g);
					y = getY( g, r, b, h );
				}
				// le bleu est le plus important
				else if( b > r )
				{
					x = col*2 + col * (b/g);
					y = getY( g, b, r, h );
				}
				// les deux sont équivalents
				else
				{
					x = col*2;
					y = getY( g, r, b, h );
					
				}
			}
			// cas des colonnes de couleur dominante bleu
			else if( b > r && b > g )
			{
				// le rouge est plus important que le bleu 
				if( r > g )
				{
					x = col*4 + col * (r/b);
					y = getY( b, r, g, h );
				}
				// le vert est le plus important
				else if( g > r )
				{
					x = col*4 - col * (g/b);
					y = getY( b, g, r, h );
				}
				// les deux sont équivalents
				else
				{
					x = col*4;
					y = getY( b, r, g, h );
				}
			}
			// rouge et vert sont égal
			else if( r == g && r > b )
			{
				x = col;
				y = getY( r, g, b, h );
			}
			// rouge et bleu sont égal
			else if( r == b && r > g )
			{
				x = col*5;
				y = getY( r, b, g, h );
			}
			// vert et bleu sont égal
			else if( b == g && g > r )
			{
				x = col*3;
				y = getY( b, g, r, h );
			}
			//_colorX = x;			//_colorY = y;
			return new Point(x,y);
		}
		public function clearMarkers () : void
		{
			_markerShape.graphics.clear();
		}
		protected function paintMarkers (x : Number, y : Number) : void
		{
			_markerShape.graphics.clear( );
			_markerShape.graphics.lineStyle( 0, 0 );
			
			var ic : BitmapIcon = _icon as BitmapIcon;
			var bsx : Number = ic.bitmap.scaleX;			var bsy : Number = ic.bitmap.scaleY;
			
			if( _markerAxis == X_AXIS || 
				_markerAxis == BOTH_AXIS )	
			{
				_markerShape.graphics.moveTo( _icon.x, _icon.y + y*bsy );					_markerShape.graphics.lineTo( _icon.x + _icon.width, _icon.y + y*bsy );	
			}
			
			if( _markerAxis == Y_AXIS || 
				_markerAxis == BOTH_AXIS )	
			{
				_markerShape.graphics.moveTo(  _icon.x + x*bsx, _icon.y );	
				_markerShape.graphics.lineTo(  _icon.x + x*bsx, _icon.y + _icon.height );	
			}
		}
		/*
		override public function repaint () : void 
		{
			super.repaint();
			//paintMarkers( _colorX, _colorY );
		}*/
		protected function fireDataChange () : void 
		{
			dispatchEvent( new ComponentEvent( ComponentEvent.DATA_CHANGE ) );
		}
		
		override protected function stylePropertyChanged ( event : PropertyEvent ) : void
		{
			switch( event.propertyName )
			{
				case "sampleIcon" : 
					icon = _style.sampleIcon.clone();
				default : 
					super.stylePropertyChanged( event );
					break;
			}
		}
	}
}
