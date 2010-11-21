package aesia.com.ponents.monitors 
{
	import aesia.com.mon.geom.Dimension;
	import aesia.com.mon.utils.AllocatorInstance;
	import aesia.com.mon.utils.Color;
	import aesia.com.ponents.core.Component;
	import aesia.com.ponents.utils.Orientations;

	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.text.TextField;
	import flash.text.TextFormat;

	/**
	 * @author Cédric Néhémie
	 */
	public class PixelRuler extends AbstractRuler 
	{
		protected var _minorTickSpacing : Number;
		protected var _majorTickSpacing : Number;
		protected var _snapToTicks : Boolean;
		protected var _ticksShape : Shape;
		protected var _textFields : Vector.<TextField>;
		
		public function PixelRuler ( target : Component, 
									 direction : uint = 0, 
									 majorTickSpacing : Number = 100, 
									 minorTickSpacing : Number = 10, 
								 	 snapToTicks : Boolean = false )
		{
			super( target, direction );
			_minorTickSpacing = minorTickSpacing;
			_majorTickSpacing = majorTickSpacing;
			_snapToTicks = snapToTicks;
			_ticksShape = new Shape();
			_textFields = new Vector.<TextField>();
			addChild( _ticksShape );
		}

		override public function repaint () : void
		{
			super.repaint();
			_ticksShape.graphics.clear();
			if( direction == Orientations.HORIZONTAL )
				paintHorizontalTicks();
			else
				paintVerticalTicks();
		}
		override public function invalidatePreferredSizeCache () : void
		{
			if( _target )
			{
				switch ( _direction ) 
				{
					case Orientations.HORIZONTAL : 
						_preferredSizeCache = new Dimension( _target.width, rulerSize );
						break;
					case Orientations.VERTICAL : 
						_preferredSizeCache = new Dimension( rulerSize, _target.height );
						break;
				}
			}
			else 
				_preferredSizeCache = new Dimension(  rulerSize, rulerSize );
		}
		protected function paintVerticalTicks () : void
		{
			var x : Number;
			var y : Number;
			var i : Number;
			var j : Number;
			var c : Color = _style.textColor;
			var f : TextFormat = _style.format;
			var g : Graphics = _ticksShape.graphics;
			var txt : TextField;
			var txtLength : Number = _textFields.length;
			var numStep : Number = Math.floor( height / _majorTickSpacing );
			var l : Number = Math.max( numStep, txtLength );
			x = width-10;
			
			for( i = 0, j = 0; j <= l; i += _majorTickSpacing, j++ )
			{
				if( j > numStep )
				{
					if( j < txtLength )
					{
						txt = _textFields[ j ];
						removeChild( txt );
						AllocatorInstance.release( txt );
					}
				}
				else
				{ 
					if( j >= txtLength )
					{
						txt = AllocatorInstance.get(TextField) as TextField;
						addChild( txt );
						_textFields.push( txt ); 
					}
					else
					{
						txt = _textFields[ j ];
					}
					
					if( i == 0 )
						y = 0;
					else
						y = i - txt.height;
				
					txt.autoSize = "left";
					txt.selectable = false;
					txt.defaultTextFormat = f;
					txt.text = String(i);
					txt.x = 0;
					txt.y = y;
					
					g.lineStyle( 0, c.hexa, c.alpha / 400 );
					g.moveTo( x, i );
					g.lineTo( width, i );
				}
			}
			_textFields.length = numStep+1;
			
			g.lineStyle( 0, c.hexa, c.alpha / 255 );
			for( i = _minorTickSpacing; i <= height ; i += _minorTickSpacing )
			{
				g.moveTo( width - 5, i );
				g.lineTo( width, i );
			}
		}
		protected function paintHorizontalTicks () : void
		{
			var x : Number;
			var i : Number;			var j : Number;
			var c : Color = _style.textColor;
			var h : Number = rulerSize;
			var y : Number;
			var f : TextFormat = _style.format;
			var g : Graphics = _ticksShape.graphics;
			var txt : TextField;
			var txtLength : Number = _textFields.length;
			var numStep : Number = Math.floor( width / _majorTickSpacing );
			var l : Number = Math.max( numStep, txtLength );
			
			for( i = 0, j = 0; j <= l; i += _majorTickSpacing, j++ )
			{
				if( j > numStep )
				{
					if( j < txtLength )
					{
						txt = _textFields[ j ];
						removeChild( txt );
						AllocatorInstance.release( txt );
					}
				}
				else
				{ 
					if( j >= txtLength )
					{
						txt = AllocatorInstance.get(TextField) as TextField;
						addChild( txt );
						_textFields.push( txt ); 
					}
					else
					{
						txt = _textFields[ j ];
					}
					
					if( i == 0 )
						x = 0;	
					else if( i == width )
						x = width - txt.width;
					else
						x = i - txt.width/2;
				
					txt.autoSize = "left";
					txt.selectable = false;
					txt.defaultTextFormat = f;
					txt.text = String( i );
					txt.x = x;
					txt.y = -2;
					
					y = txt.y + txt.height;
					
					g.lineStyle( 0, c.hexa, c.alpha / 400 );
					g.moveTo( i, y );
					g.lineTo( i, h );
				}
			}
			_textFields.length = numStep + 1;
			 
			g.lineStyle( 0, c.hexa, c.alpha / 255 );
			for( i = _minorTickSpacing; i <= width ; i += _minorTickSpacing )
			{
				g.moveTo( i, ( y + h ) / 2 );
				g.lineTo( i, h );
			}
		}
	}
}
