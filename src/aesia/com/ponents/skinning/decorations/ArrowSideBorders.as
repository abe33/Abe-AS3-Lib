package aesia.com.ponents.skinning.decorations 
{
	import aesia.com.mon.utils.Color;
	import aesia.com.ponents.utils.Borders;
	import aesia.com.ponents.utils.CardinalPoints;
	import aesia.com.ponents.utils.Corners;

	import flash.display.Graphics;
	import flash.geom.Rectangle;

	/**
	 * @author Cédric Néhémie
	 */
	public class ArrowSideBorders extends ArrowSideFill implements ComponentDecoration 
	{
		public function ArrowSideBorders ( color : Color = null, arrowPlacement : String = "north", arrowSize : Number = 5)
		{
			super( color ? color : Color.Black, arrowPlacement, arrowSize );
		}
		override public function clone () : *
		{
			return new ArrowSideBorders( color, arrowPlacement, arrowSize );
		}
		override public function equals (o : *) : Boolean
		{
			if( o is ArrowSideBorders )
			{
				var g : ArrowSideBorders = o as ArrowSideBorders;
				return g.color.equals( color ) && 
					   g.arrowPlacement == arrowPlacement &&
					   g.arrowSize == arrowSize;
			}
			return false;
		}
		
		override protected function drawArrow (r : Rectangle, g : Graphics, corners : Corners, borders : Borders) : void
		{
			switch( arrowPlacement )
			{
				case CardinalPoints.WEST : 
					drawWestArrow( r, g, corners );
					drawWestArrow( r, g, corners, borders );
					break;
				case CardinalPoints.SOUTH : 
					drawSouthArrow( r, g, corners );
					drawSouthArrow( r, g, corners, borders );
					break;
				case CardinalPoints.EAST : 
					drawEastArrow( r, g, corners );
					drawEastArrow( r, g, corners, borders );
					break;
				case CardinalPoints.NORTH : 
				default : 
					drawNorthArrow( r, g, corners );
					drawNorthArrow( r, g, corners, borders );
					break;
			}
		}
	}
}
