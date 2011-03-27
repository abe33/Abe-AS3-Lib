package abe.com.ponents.skinning.decorations 
{
	import abe.com.mon.colors.Color;
	import abe.com.ponents.core.Component;
	import abe.com.ponents.utils.Borders;
	import abe.com.ponents.utils.CardinalPoints;
	import abe.com.ponents.utils.Corners;

	import flash.display.Graphics;
	import flash.geom.Rectangle;
	import flash.utils.getQualifiedClassName;

	/**
	 * @author Cédric Néhémie
	 */
	public class ArrowSideFill implements ComponentDecoration 
	{
		public var color : Color;
		public var arrowPlacement : String;
		public var arrowSize : Number;

		public function ArrowSideFill ( color : Color = null, arrowPlacement : String = "north", arrowSize : Number = 5 )
		{
			this.color = color ? color : Color.White;
			this.arrowPlacement = arrowPlacement;
			this.arrowSize = arrowSize;
		}
		public function clone () : *
		{
			return new ArrowSideFill( color, arrowPlacement, arrowSize );
		}
		public function toSource () : String
		{
			return "new "+ getQualifiedClassName(this).replace("::",".") + "(" + color.toSource() + ",'" + arrowPlacement + "', " + arrowSize + ")" ;
		}
		public function toReflectionSource () : String
		{
			return "new "+ getQualifiedClassName(this) + "(" + color.toReflectionSource() + ",'" + arrowPlacement + "', " + arrowSize + ")" ;
		}
		
		public function equals (o : *) : Boolean
		{
			if( o is ArrowSideFill )
			{
				var g : ArrowSideFill = o as ArrowSideFill;
				return g.color.equals( color ) && 
					   g.arrowPlacement == arrowPlacement &&
					   g.arrowSize == arrowSize;
			}
			return false;
		}
		
		public function draw ( r : Rectangle, g : Graphics, c : Component, borders : Borders = null, corners : Corners = null, smoothing : Boolean = false) : void
		{
			corners = corners ? corners : new Corners();
			g.beginFill( color.hexa, color.alpha/255 );
			
			drawArrow ( r, g, corners, borders );
			
			//g.drawRoundRectComplex(r.x, r.y, r.width, r.height, corners.topLeft, corners.topRight, corners.bottomLeft, corners.bottomRight );
			g.endFill( );
		}
		
		protected function drawArrow (r : Rectangle, g : Graphics, corners : Corners, borders : Borders) : void
		{	
			switch( arrowPlacement )
			{
				case CardinalPoints.SOUTH : 
					drawSouthArrow( r, g, corners );
					break;
				case CardinalPoints.EAST : 
					drawEastArrow( r, g, corners );
					break;
				case CardinalPoints.WEST : 
					drawWestArrow( r, g, corners );
					break;
				case CardinalPoints.NORTH : 
				default : 
					drawNorthArrow( r, g, corners );
					break;
			}
		}

		protected function drawNorthArrow (r : Rectangle, g : Graphics, corners : Corners = null, borders : Borders = null ) : void
		{
			borders = borders ? borders : new Borders(0,0,0,0);
			//top left corner
			g.moveTo( borders.left, 
					  arrowSize );
			
			//top edge : arrow
			g.lineTo( r.width / 2, 
					  borders.top );
					  
			g.lineTo( r.width - borders.right, 
					  arrowSize );
			
			// top right corner
			
			// right edge
			g.lineTo( r.width - borders.right, 
					  r.height - corners.bottomRight - borders.bottom );
			
			//bottom right corner
			g.curveTo( r.width - borders.right, 
					   r.height - borders.bottom, 
					   r.width - corners.bottomRight - borders.right,
					   r.height - borders.bottom );
			
			// bottom edge
			g.lineTo( corners.bottomLeft + borders.left,
					  r.height - borders.bottom );
			
			// bottom left corner
			g.curveTo( borders.left, 
					   r.height - borders.bottom, 
					   borders.left, 
					   r.height - corners.bottomLeft - borders.bottom );
			
			// left edge
			g.lineTo( borders.left, 
					  arrowSize );				
		}
		protected function drawSouthArrow (r : Rectangle, g : Graphics, corners : Corners = null, borders : Borders = null) : void
		{
			borders = borders ? borders : new Borders(0,0,0,0);
			//top left corner
			g.moveTo( borders.left, 
					  borders.top + corners.topLeft );
					  
			g.curveTo( borders.left, 
					   borders.top, 
					   borders.left + corners.topLeft, 
					   borders.top );
						
			//top edge
			g.lineTo( r.width - borders.right - corners.topRight, 
					  borders.top );
			
			// top right corner
			g.curveTo( r.width - borders.right, 
					   borders.top, 
					   r.width - borders.right, 
					   borders.top + corners.topRight );
			
			// right edge
			g.lineTo( r.width - borders.right, 
					  r.height - arrowSize );
			
			//bottom edge : arrow
			g.lineTo( r.width / 2, 
					  r.height - borders.bottom );

			g.lineTo( borders.left, 
					  r.height - arrowSize );
					  			
			// left edge
			g.lineTo( borders.left, 
					  corners.topLeft );		
		}
		protected function drawWestArrow (r : Rectangle, g : Graphics, corners : Corners = null, borders : Borders = null) : void
		{
			borders = borders ? borders : new Borders(0,0,0,0);
			//top left corner
			g.moveTo( borders.left, 
					  r.height/2 );
			
			//top edge : arrow
			g.lineTo( arrowSize, 
					  borders.top );
					  
			g.lineTo( r.width - borders.right - corners.topRight, 
					  borders.top );
			
			// top right corner
			g.curveTo( r.width - borders.right, 
					   borders.top, 
					   r.width - borders.right, 
					   borders.top + corners.topRight );	
			
			// right edge
			g.lineTo( r.width - borders.right, 
					  r.height - corners.bottomRight - borders.bottom );
			
			//bottom right corner
			g.curveTo( r.width - borders.right, 
					   r.height - borders.bottom, 
					   r.width - corners.bottomRight - borders.right,
					   r.height - borders.bottom );
			
			// bottom edge
			g.lineTo( arrowSize,
					  r.height - borders.bottom );
					  
			g.lineTo( borders.left, 
					  r.height / 2 );					
		}
		protected function drawEastArrow (r : Rectangle, g : Graphics, corners : Corners = null, borders : Borders = null) : void
		{
			borders = borders ? borders : new Borders(0,0,0,0);
			//top left corner
			g.moveTo( borders.left, 
					  borders.top + corners.topLeft );
					  
			g.curveTo( borders.left, 
					   borders.top, 
					   borders.left + corners.topLeft, 
					   borders.top );
						
			//top edge
			g.lineTo( r.width - arrowSize, 
					  borders.top );
			
			//right edge : arrow
			g.lineTo( r.width - borders.right, 
					  r.height / 2 );	
			
			g.lineTo( r.width - arrowSize, 
					  r.height - borders.bottom );	
					  
			// bottom edge
			g.lineTo( corners.bottomLeft + borders.left,
					  r.height - borders.bottom );
			
			// bottom left corner
			g.curveTo( borders.left, 
					   r.height - borders.bottom, 
					   borders.left, 
					   r.height - corners.bottomLeft - borders.bottom );
			
			// left edge
			g.lineTo( borders.left, 
					  borders.top + corners.topLeft );		
		}
	}
}
