package abe.com.ponents.skinning.decorations 
{
    import abe.com.mon.colors.Color;
    import abe.com.mon.geom.pt;
    import abe.com.mon.utils.GeometryUtils;
    import abe.com.mon.utils.PointUtils;
    import abe.com.patibility.lang._$;
    import abe.com.ponents.core.Component;
    import abe.com.ponents.utils.Borders;
    import abe.com.ponents.utils.CardinalPoints;
    import abe.com.ponents.utils.Corners;

    import flash.display.Graphics;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import flash.utils.getQualifiedClassName;
	/**
	 * @author cedric
	 */
	public class BubbleBorders implements ComponentDecoration 
	{
		public var color : Color;
		public var tailPlacement : String;
		public var tailSize : Number;
		public var tailWidth : Number;
		public var tailPosition : Number;
		public var tailOrientation : Number;

		public function BubbleBorders ( color : Color, 
										tailPlacement : String = "north", 
										tailSize : Number = 15, 
										tailWidth : Number = 5,
										tailPosition : Number = 0.25,
										tailOrientation : Number = -2 ) 
		{
			this.color = color;
			this.tailPlacement = tailPlacement;			this.tailSize = tailSize;			this.tailWidth = tailWidth;
			this.tailPosition = tailPosition;
			this.tailOrientation = tailOrientation;
		}
		public function draw (r : Rectangle, g : Graphics, c : Component, borders : Borders = null, corners : Corners = null, smoothing : Boolean = false) : void
		{
			corners = corners ? corners : new Corners();			
			var points : Array = getTriplets(r, borders, corners);
			drawOutter(points[0], points[1], points[2], r, g, borders, corners);			drawInner(points[3], points[4], points[5], r, g, borders, corners);
			
			g.endFill();				
		}
		protected function getTriplets( r : Rectangle, borders : Borders, corners : Corners ): Array
		{
			var po : Point;			var p1 : Point;			var p2 : Point;			var p3 : Point;			var p4 : Point;			var p5 : Point;			var p6 : Point;			var p1p : Point;			var p2p : Point;
			var ratio : Number;
			
			switch( tailPlacement )
			{
				//east case
				case CardinalPoints.EAST : 
					po = pt( r.x + r.width, r.y + r.height * tailPosition );
					// first triplet
					p1 = pt( po.x, po.y - borders.right - tailWidth / 2 );
					p2 = pt( po.x, po.y + borders.right + tailWidth / 2 );
					p3 = po.add( PointUtils.getProjection( tailOrientation, tailSize ) );
					
					// thales
					ratio = ( borders.top * 2 ) / ( tailWidth + borders.right * 2 ); 	
					p1p = p3.add( PointUtils.scaleNew( p1.subtract(p3), ratio ) );
					p2p = p3.add( PointUtils.scaleNew( p2.subtract(p3), ratio ) );
							
					// second triplet
					p6 = pt( ( p1p.x + p2p.x ) / 2, ( p1p.y + p2p.y ) / 2 );
					p4 = GeometryUtils.perCrossing( pt(r.x + r.width - borders.right, r.y ), pt( 0, r.height ), p6, p1.subtract(p3) );
					p5 = GeometryUtils.perCrossing( pt(r.x + r.width - borders.right, r.y ), pt( 0, r.height ), p6, p2.subtract(p3) );
					break;
				//west case
				case CardinalPoints.WEST : 
					po = pt( r.x, r.y + r.height * tailPosition );
					// first triplet
					p1 = pt( po.x, po.y - borders.left - tailWidth / 2 );
					p2 = pt( po.x, po.y + borders.left + tailWidth / 2 );
					p3 = po.add( PointUtils.getProjection( tailOrientation, tailSize ) );
					
					// thales
					ratio = ( borders.top * 2 ) / ( tailWidth + borders.left * 2 ); 	
					p1p = p3.add( PointUtils.scaleNew( p1.subtract(p3), ratio ) );
					p2p = p3.add( PointUtils.scaleNew( p2.subtract(p3), ratio ) );
							
					// second triplet
					p6 = pt( ( p1p.x + p2p.x ) / 2, ( p1p.y + p2p.y ) / 2 );
					p4 = GeometryUtils.perCrossing( pt(r.x + borders.left, r.y ), pt( 0, r.height ), p6, p1.subtract(p3) );
					p5 = GeometryUtils.perCrossing( pt(r.x + borders.left, r.y ), pt( 0, r.height ), p6, p2.subtract(p3) );
					break;
				// south case
				case CardinalPoints.SOUTH : 
					po = pt( r.x + r.width * tailPosition, r.y + r.height );
					// first triplet
					p1 = pt( po.x - borders.bottom - tailWidth / 2, po.y );
					p2 = pt( po.x + borders.bottom + tailWidth / 2 , po.y );
					p3 = po.add( PointUtils.getProjection( tailOrientation, tailSize ) );
					
					// thales
					ratio = ( borders.top * 2 ) / ( tailWidth + borders.bottom * 2 ); 	
					p1p = p3.add( PointUtils.scaleNew( p1.subtract(p3), ratio ) );
					p2p = p3.add( PointUtils.scaleNew( p2.subtract(p3), ratio ) );
							
					// second triplet
					p6 = pt( ( p1p.x + p2p.x ) / 2, ( p1p.y + p2p.y ) / 2 );
					p4 = GeometryUtils.perCrossing( pt(r.x, r.y + r.height - borders.bottom ), pt( r.width, 0 ), p6, p1.subtract(p3) );
					p5 = GeometryUtils.perCrossing( pt(r.x, r.y + r.height - borders.bottom ), pt( r.width, 0 ), p6, p2.subtract(p3) );
					break;
				// north case
				case CardinalPoints.NORTH : 
				default : 
					po = pt( r.x + r.width * tailPosition, r.y );
					// first triplet
					p1 = pt( po.x - borders.top - tailWidth / 2, po.y );
					p2 = pt( po.x + borders.top + tailWidth / 2 , po.y );
					p3 = po.add( PointUtils.getProjection( tailOrientation, tailSize ) );
					
					// thales
					ratio = ( borders.top * 2 ) / ( tailWidth + borders.top * 2 ); 	
					p1p = p3.add( PointUtils.scaleNew( p1.subtract(p3), ratio ) );
					p2p = p3.add( PointUtils.scaleNew( p2.subtract(p3), ratio ) );
							
					// second triplet
					p6 = pt( ( p1p.x + p2p.x ) / 2, ( p1p.y + p2p.y ) / 2 );
					p4 = GeometryUtils.perCrossing( pt(r.x,r.y + borders.top ), pt( r.width, 0 ), p6, p1.subtract(p3) );
					p5 = GeometryUtils.perCrossing( pt(r.x,r.y + borders.top ), pt( r.width, 0 ), p6, p2.subtract(p3) );
					break;
			}
			
			return [p1,p2,p3,p4,p5,p6];
		}
		protected function drawInner( p1 : Point, p2 : Point, p3 : Point, r : Rectangle, g : Graphics, borders : Borders, corners : Corners ) : void
		{
			g.drawRoundRectComplex(	r.x + borders.left, 
									r.y + borders.top, 
									r.width-(borders.left+borders.right), 
									r.height-(borders.top+borders.bottom), 
									Math.max( 0, corners.topLeft - borders.left ), 
									Math.max( 0, corners.topRight - borders.right ), 
									Math.max( 0, corners.bottomLeft - borders.top ), 
									Math.max( 0, corners.bottomRight - borders.bottom ) );
			
			g.moveTo(p1.x, p1.y);
			g.lineTo(p3.x, p3.y);
			g.lineTo(p2.x, p2.y);
			g.lineTo(p1.x, p1.y);		}
		protected function drawOutter( p1 : Point, p2 : Point, p3 : Point, r : Rectangle, g : Graphics, borders : Borders, corners : Corners ) : void
		{
			g.beginFill( color.hexa, color.alpha/255 );
			g.drawRoundRectComplex(	r.x, 
									r.y, 
									r.width, 
									r.height, 
									corners.topLeft, 
									corners.topRight, 
									corners.bottomLeft, 
									corners.bottomRight );
									
			g.moveTo(p1.x, p1.y);
			g.lineTo(p3.x, p3.y);
			g.lineTo(p2.x, p2.y);
			g.lineTo(p1.x, p1.y);
		}
		
		public function equals (o : *) : Boolean
		{
			if( o is BubbleBorders )
				return false;
			else 
				return false;
		}
		public function clone () : *
		{
			return new BubbleBorders(color);
		}
		public function toSource () : String
		{
			return _$("new $0($1)", getQualifiedClassName(this).replace("::", "."), color.toSource() );
		}
		public function toReflectionSource () : String
		{
			return _$("new $0($1)", getQualifiedClassName(this), color.toReflectionSource() );
		}
	}
}
