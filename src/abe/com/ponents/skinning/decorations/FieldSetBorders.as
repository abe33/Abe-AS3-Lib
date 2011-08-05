package abe.com.ponents.skinning.decorations 
{
	import abe.com.mon.colors.Color;
	import abe.com.mon.geom.Dimension;
	import abe.com.ponents.containers.FieldSet;
	import abe.com.ponents.core.Component;
	import abe.com.ponents.utils.Borders;
	import abe.com.ponents.utils.Corners;

	import flash.display.Graphics;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	/**
	 * @author Cédric Néhémie
	 */
	public class FieldSetBorders extends SimpleBorders 
	{
		public function FieldSetBorders ( color : Color = null ) 
		{
			super( color );
		}
		
		override public function clone () : * 
		{
			return new FieldSetBorders( color );	
		}
		override public function equals (o : *) : Boolean 
		{
			if( o is FieldSetBorders )
			{
				return (o as FieldSetBorders).color.equals(color);
			}
			return false;
		}
		override public function draw (r : Rectangle, g : Graphics, c : Component, borders : Borders = null, corners : Corners = null, smoothing : Boolean = false) : void
		{
			var fs : FieldSet;
			if( c is FieldSet && (fs = c as FieldSet).label )
			{
				var p : Point = fs.label.position;
				var d : Dimension = new Dimension( fs.label.width, fs.label.height );
				var bb : Rectangle = new Rectangle( p.x, p.y, d.width, d.height );
				r.y = Math.floor( r.y + bb.height / 2 );
				r.height = Math.floor( r.height - bb.height / 2 );
				
				corners = corners ? corners : new Corners();
				g.beginFill( color.hexa, color.alpha/255 );
				g.drawRoundRectComplex(	r.x, 
										r.y, 
										r.width, 
										r.height, 
										corners.topLeft, 
										corners.topRight, 
										corners.bottomLeft, 
										corners.bottomRight );
										
				g.drawRoundRectComplex(	r.x + borders.left, 
										r.y + borders.top, 
										r.width-(borders.left+borders.right), 
										r.height-(borders.top+borders.bottom), 
										Math.max( 0, corners.topLeft - borders.left ), 
										Math.max( 0, corners.topRight - borders.right ), 
										Math.max( 0, corners.bottomLeft - borders.top ), 
										Math.max( 0, corners.bottomRight - borders.bottom ) );
				
				g.drawRect( bb.x, r.y, bb.width, borders.top );
				
				g.endFill();				
			}
			else
				super.draw(r, g, c, borders, corners, smoothing );
		}
	}
}
