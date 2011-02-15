package aesia.com.ponents.skinning.decorations 
{
	import aesia.com.mon.logs.Log;
	import aesia.com.mon.core.FormMetaProvider;
	import aesia.com.ponents.core.Component;
	import aesia.com.ponents.utils.Alignments;
	import aesia.com.ponents.utils.Borders;
	import aesia.com.ponents.utils.Corners;
	import aesia.com.ponents.utils.Insets;

	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.utils.getQualifiedClassName;
	/**
	 * @author cedric
	 */
	public class BitmapDecoration implements ComponentDecoration, FormMetaProvider
	{
		protected var _bitmap : BitmapData;
		protected var _halign : String;
		protected var _valign : String;
		protected var _margins : Insets;

		public function BitmapDecoration ( bitmap : BitmapData, halign : String = "left", valign : String="top", margins:Insets = null )
		{
			_bitmap = bitmap;
			_halign = halign;
			_valign = valign;
			_margins = margins ? margins : new Insets( );
		}
		public function clone () : * 
		{
			return new BitmapDecoration( bitmap.clone(), halign, valign, margins.clone() );	
		}
		
		[Form]
		public function get bitmap () : BitmapData { return _bitmap; }		
		public function set bitmap (bitmap : BitmapData) : void
		{
			_bitmap = bitmap;
		}
		[Form(type="string",enumeration="left,center,right")]
		public function get halign () : String { return _halign; }		
		public function set halign (halign : String) : void
		{
			_halign = halign;
		}
		[Form(type="string",enumeration="top,center,bottom")]
		public function get valign () : String { return _valign; }		
		public function set valign (valign : String) : void
		{
			_valign = valign;
		}
		[Form]
		public function get margins () : Insets { return _margins; }		
		public function set margins (margins : Insets) : void
		{
			_margins = margins;
		}
		
		public function draw ( r : Rectangle, 
							   g : Graphics, 
							   c : Component, 
							   borders : Borders = null, 
							   corners : Corners = null, 
							   smoothing : Boolean = false) : void
		{
			var x : Number;			var y : Number;
			
			switch( _halign )
			{
				case Alignments.RIGHT : 
					x = r.width - _bitmap.width - _margins.right;
					break;
				case Alignments.CENTER : 
					x = ( r.width - _bitmap.width ) / 2;
					break;
				case Alignments.LEFT : 
				default : 
					x = _margins.left;
					break;
			}
			
			switch( _valign )
			{
				case Alignments.BOTTOM : 
					y = r.height - _bitmap.height - _margins.bottom;
					break;
				case Alignments.CENTER : 
					y = ( r.height - _bitmap.height ) / 2;
					break;
				case Alignments.TOP : 
				default : 
					y = _margins.top;
					break;
			}
			
			var r2 : Rectangle = new Rectangle( x, y, _bitmap.width, _bitmap.height );
			var r3 : Rectangle = r.intersection(r2);
			var m : Matrix = new Matrix();
			m.createBox(1, 1, 0, r3.x, r3.y);
			
			g.beginBitmapFill( _bitmap, m, false, smoothing );
			g.drawRect(r3.x, r3.y, r3.width, r3.height );
			
			g.endFill();
		}

		public function equals (o : *) : Boolean
		{
			if( o is BitmapDecoration )
			{
				var bc : BitmapDecoration = o as BitmapDecoration;
				var b : Boolean = true;
				
				b &&= _bitmap == bc.bitmap;
				b &&= _halign == bc.halign;				b &&= _valign == bc.valign;				b &&= _margins.equals(bc.margins);
				
				return b;
			}
			else return false;
		}
		
		public function toSource () : String
		{
			return toReflectionSource().replace("::", ".");
		}
		
		public function toReflectionSource () : String
		{
			return "new " + getQualifiedClassName(this) +"()";
		}
	}
}
