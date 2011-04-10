package abe.com.ponents.skinning.decorations 
{
	import abe.com.mon.colors.Color;
	import abe.com.mon.core.FormMetaProvider;
	import abe.com.mon.core.Serializable;
	import abe.com.mon.colors.Gradient;
	import abe.com.mon.utils.MathUtils;
	import abe.com.patibility.lang._$;
	import abe.com.ponents.core.Component;
	import abe.com.ponents.utils.Borders;
	import abe.com.ponents.utils.Corners;

	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.display.SpreadMethod;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.utils.getQualifiedClassName;
	/**
	 * @author cedric
	 */
	public class StripFill implements ComponentDecoration, FormMetaProvider
	{
		protected var _colors : Array;		protected var _stripSizes : Array;
		protected var _orientation : Number;
		
		protected var _gradient : Gradient;
		protected var _matrixSize : Number;

		public function StripFill ( colors : Array = null, stripSizes : Array = null, orientation : Number = 0 )
		{
			_colors = colors ? colors : [ Color.Black, Color.White ];
			_stripSizes = stripSizes ? stripSizes : [5,5];
			_orientation = orientation;
			
			updateGradient();
		}
		[Form(type="array", contentType="abe.com.mon.colors::Color", listCell="abe.com.ponents.lists::ColorListCell")]
		public function get colors () : Array { return _colors; }		
		public function set colors (colors : Array) : void
		{
			_colors = colors;
			updateGradient();
		}
		[Form(type="array", contentType="Number")]
		public function get stripSizes () : Array { return _stripSizes; }		
		public function set stripSizes (stripSizes : Array) : void
		{
			_stripSizes = stripSizes;
			updateGradient();
		}
		[Form]
		public function get orientation () : Number { return _orientation; }		
		public function set orientation (orientation : Number) : void
		{
			_orientation = orientation;
			updateGradient();
		}
		
		public function clone () : *
		{
			return new StripFill( _colors.concat(), _stripSizes.concat(), _orientation );
		}
		public function draw (r : Rectangle, g : Graphics, c : Component, borders : Borders = null, corners : Corners = null, smoothing : Boolean = false) : void
		{
			if( _gradient )
			{
				var m : Matrix = new Matrix();
				
				m.createGradientBox( _matrixSize, _matrixSize, MathUtils.deg2rad( _orientation ), 0, 0 );
				
				g.beginGradientFill( GradientType.LINEAR, 
									_gradient.toGradientFillColorsArray(), 
									_gradient.toGradientFillAlphasArray(), 
									_gradient.toGradientFillPositionsArray(), 
									m, 
									SpreadMethod.REPEAT );			
				g.drawRoundRectComplex(r.x, 
									   r.y, 
									   r.width, 
									   r.height, 
									   corners.topLeft, 
									   corners.topRight, 
									   corners.bottomLeft, 
									   corners.bottomRight );
				g.endFill();
			}
		}
		protected function updateGradient () : void
		{
			if(_colors && _stripSizes)
			{
				_matrixSize = 0;
				_stripSizes.forEach(function(n:Number, ... args):void { _matrixSize += n; });
				
				var l : uint = _colors.length;
				var c : Array = [];
				var p : Array = [];
				var n : Number = 0;
				
				for(var i:uint=0;i<l;i++)
				{
					c.push( _colors[i] );
					c.push( _colors[i] );
					
					p.push( n / _matrixSize + 0.01 );
					p.push( ( n + _stripSizes[i] ) / _matrixSize );
					
					n += _stripSizes[i];
				}
				
				_gradient = new Gradient( c, p );
			}
		}
		public function toSource () : String
		{
			return _$("new $0([$1],[$2],$3)",
						getQualifiedClassName(this).replace("::", "."),
						_colors.map(function(o:Serializable, ...arfs):String{ return o.toSource();}).join(","), 
						_stripSizes.join(","), 
						_orientation );
		}
		public function equals (o : *) : Boolean
		{
			if( o is StripFill )
			{
				var b : Boolean = true;
					
				b &&= _colors.every( function( c : Color, i : uint, ... args ):Boolean { return c.equals( o.colors[i] ); } );				b &&= _stripSizes.every( function( c : Number, i : uint, ... args ):Boolean { return c == o.stripSizes[i]; } );
				b &&= _orientation == o.orientation;
				
				return b;
			}
			else return false;
		}
		public function toReflectionSource () : String
		{
			return _$("new $0([$1],[$2],$3)",
						getQualifiedClassName(this),
						_colors.map(function(o:Serializable, ...arfs):String{ return o.toReflectionSource();}).join(","), 
						_stripSizes.join(","), 
						_orientation );
		}
	}
}
