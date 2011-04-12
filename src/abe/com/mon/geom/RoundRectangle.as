package abe.com.mon.geom 
{
	import abe.com.mon.colors.Color;
	import abe.com.mon.core.Copyable;
	import abe.com.mon.core.Randomizable;
	import abe.com.mon.core.Serializable;
	import abe.com.mon.utils.MathUtils;
	import abe.com.mon.utils.PointUtils;
	import abe.com.mon.utils.StringUtils;

	import avmplus.getQualifiedClassName;

	import flash.display.Graphics;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	/**
	 * 
	 * 
	 * @author Cédric Néhémie
	 */
	public class RoundRectangle extends Rectangle2 implements Geometry, 
															 Path, 
															 ClosedGeometry, 
															 Copyable, 
															 Serializable, 
															 Surface,
															 Randomizable
	{
		public var cornerRadius : Number;
		public var drawBias : Number = 30;
		
		public function RoundRectangle ( xOrRect : * = 0,
										 yOrRotation : Number = 0,
										 widthOrCornerRadius : Number = 0,
										 height : Number = 0,
										 rotation : Number = 0,
										 cornerRadius : Number = 10,
										 pathBasedOnLength : Boolean = true  ) 
		{
			super( xOrRect, yOrRotation, widthOrCornerRadius, height, rotation, pathBasedOnLength );
			
			if( xOrRect is Rectangle )
				this.cornerRadius = widthOrCornerRadius;
			else
				this.cornerRadius = cornerRadius;
		}
/*----------------------------------------------------------------------*
 *  GETTERS/SETTERS OVERRIDES
 *----------------------------------------------------------------------*/
		/**
		 * @inheritDoc
		 */
		override public function get bottomRight () : Point 
		{ 
			var pt1 : Point = topEdge;
			pt1.normalize( cornerRadius * 2 );
			var pt2 : Point = leftEdge;
			pt2.normalize( cornerRadius * 2 );
			
			return super.bottomRight.add( pt1 ).add( pt2 );	
		}
		/**
		 * @inheritDoc
		 */
		override public function get topRight () : Point 
		{ 
			var pt1 : Point = topEdge;
			pt1.normalize( cornerRadius * 2 );
			return super.topRight.add( pt1 ); 
		}
		/**
		 * @inheritDoc
		 */		override public function get bottomLeft () : Point 
		{ 
			var pt1 : Point = leftEdge;
			pt1.normalize( cornerRadius * 2 );
			return super.bottomLeft.add( pt1 ); 
		}
		/**
		 * @inheritDoc
		 */
		override public function get topEdge () : Point { return pt( Math.cos( rotation ) * ( width - cornerRadius * 2 ), 
					 												 Math.sin( rotation ) * ( width - cornerRadius * 2 ) ); }
		/**
		 * @inheritDoc
		 */			 												 
		override public function get leftEdge () : Point { return pt( Math.cos( rotation + Math.PI / 2 ) * ( height - cornerRadius * 2 ),
																	  Math.sin( rotation + Math.PI / 2 ) * ( height - cornerRadius * 2 ) ); }
		/**
		 * @inheritDoc
		 */
		override public function get topEdgeCenter () : Point 
		{
			var pt1 : Point = topEdge;
			pt1.normalize( cornerRadius );
			return super.topEdgeCenter.add( pt1 );
		}
		/**
		 * @inheritDoc
		 */
		override public function get bottomEdgeCenter () : Point 
		{
			var pt1 : Point = topEdge;
			pt1.normalize( cornerRadius );
			return super.bottomEdgeCenter.add( pt1 );
		}
		/**
		 * @inheritDoc
		 */
		override public function get leftEdgeCenter () : Point 
		{
			var pt1 : Point = leftEdge;
			pt1.normalize( cornerRadius );
			return super.leftEdgeCenter.add( pt1 );
		}
		/**
		 * @inheritDoc
		 */
		override public function get rightEdgeCenter () : Point 
		{
			var pt1 : Point = leftEdge;
			pt1.normalize( cornerRadius );
			return super.rightEdgeCenter.add( pt1 );
		}
		/**
		 * @inheritDoc
		 */
		override public function get acreage () : Number 
		{
			var n : Number = 0;
			n += Math.PI * cornerRadius * cornerRadius;
			n += ( width - cornerRadius * 2 ) * cornerRadius * 2;			n += ( height - cornerRadius * 2 ) * cornerRadius * 2;			n += ( height - cornerRadius * 2 ) * ( width - cornerRadius * 2 );
			return n;
		}
		/**
		 * @inheritDoc
		 */
		override public function get length () : Number 
		{
			return topEdge.length * 2 + leftEdge.length * 2 + cornerLength * 4;
		}
		/**
		 * @inheritDoc
		 */
		override public function get points () : Array 
		{
			var a : Array = [];
			for( var i : int = 0; i <= drawBias;i++)
				a.push ( getPathPoint( ( i / drawBias ) ) );
			return a;
		}
/*----------------------------------------------------------------------*
 *  ROUND RECTANGLE CUSTOM METHODS
 *----------------------------------------------------------------------*/
		protected function get cornerLength() : Number { return .5 * Math.PI * cornerRadius; }	
		
		protected function getEdgeRef ( edge : uint ) : Point
		{
			var pt1 : Point;
			switch( edge )
			{
				// right edge
				case 1 :
					pt1 = rightEdge;
					pt1.normalize( cornerRadius );
					return topRight.add( pt1 );
				// bottomEdge
				case 2 :
					pt1 = topEdge;
					pt1.normalize( cornerRadius );
					return bottomRight.subtract( pt1 );
				// left edge
				case 3 :
					pt1 = rightEdge;
					pt1.normalize( cornerRadius );
					return bottomLeft.subtract( pt1 );
				// top edge
				case 0 :
				default : 
					pt1 = topEdge;
					pt1.normalize( cornerRadius );
					return topLeft.add( pt1 );
			}
		}
		protected function getCornerRef ( corner : uint ) : Point
		{
			var pt1 : Point;
			var hedge : Point = topEdge;			var vedge : Point = leftEdge;
			hedge.normalize( cornerRadius );			vedge.normalize( cornerRadius );
			switch( corner )
			{
				case 3 : 
					pt1 = bottomLeft;
					return pt1.add( hedge ).subtract( vedge );
				case 2 : 
					pt1 = bottomRight;
					return pt1.subtract( hedge ).subtract( vedge );
				case 1 : 
					pt1 = topRight;
					return pt1.subtract( hedge ).add( vedge );
				case 0 : 
				default :
					pt1 = topLeft;
					return pt1.add( hedge ).add( vedge );
			}
		}
		protected function getPointOnCorner( p : Number, corner : uint, lengthRand : Number = 1 ) : Point
		{
			// p is relative to the corner
			// 0 = topleft, 1 = topright, 2 = bottomright, 3 = bottomleft
			
			var a : Number = rotation + p * Math.PI/2;
			var pref : Point = getCornerRef ( corner );
			switch( corner )
			{
				case 2 : 					return pref.add( pt( Math.cos( a ) * cornerRadius * lengthRand, 
										 Math.sin( a ) * cornerRadius * lengthRand ) );
				case 1 : 					return pref.add( pt( Math.cos( -Math.PI/2 + a ) * cornerRadius * lengthRand, 
										 Math.sin( -Math.PI/2 + a ) * cornerRadius * lengthRand ) );
				case 0 : 
					return pref.add( pt( Math.cos( -Math.PI + a ) * cornerRadius * lengthRand, 
										 Math.sin( -Math.PI + a ) * cornerRadius * lengthRand ) ); 				case 3 : 
				default :
					return pref.add( pt( Math.cos( Math.PI/2 + a ) * cornerRadius * lengthRand, 
									 	 Math.sin( Math.PI/2 + a ) * cornerRadius * lengthRand ) );
			}
			return null;
		}
/*----------------------------------------------------------------------*
 *  OTHERS OVERRIDES
 *----------------------------------------------------------------------*/		
		/**
		 * @inheritDoc
		 */
		override public function getRandomPointInSurface () : Point
		{
			var slots : Array = [0,1,2,3,4,5,6,7,8];
			var cornSurface : Number = Math.PI * cornerRadius * cornerRadius / 4;
			var hFillerSurface : Number = ( width - cornerRadius * 2 ) * cornerRadius;			var vFillerSurface : Number = ( height - cornerRadius * 2 ) * cornerRadius;
			var centerSurface : Number = ( width - cornerRadius * 2 ) * ( height - cornerRadius * 2 );
			var weights : Array = [ cornSurface, 	hFillerSurface, 	cornSurface, 
									vFillerSurface, centerSurface, 		vFillerSurface, 
									cornSurface, 	hFillerSurface, 	cornSurface ];
			var slot : uint = _randomSource.inArrayWithRatios( slots , weights, false, acreage );
			var pt1 : Point;
			switch( slot )
			{
				// corners
				case 0 : 
					return getPointOnCorner( _randomSource.random(), 0, Math.sqrt( _randomSource.random() ) );				case 2 : 
					return getPointOnCorner( _randomSource.random(), 1, Math.sqrt( _randomSource.random() ) );				case 6 : 
					return getPointOnCorner( _randomSource.random(), 3, Math.sqrt( _randomSource.random() ) );				case 8 :
					return getPointOnCorner( _randomSource.random(), 2, Math.sqrt( _randomSource.random() ) );
				
				// edges
				case 1 : 
					pt1 = leftEdge;
					pt1.normalize( cornerRadius );
					return getCornerRef(0).add( PointUtils.scaleNew( topEdge, _randomSource.random() ) )
						  				  .subtract( PointUtils.scaleNew( pt1, _randomSource.random() ) );
				case 3 : 
					pt1 = topEdge;
					pt1.normalize( cornerRadius );
					return getCornerRef(0).add( PointUtils.scaleNew( leftEdge, _randomSource.random() ) )
						  				  .subtract( PointUtils.scaleNew( pt1, _randomSource.random() ) );
				case 5 : 
					pt1 = topEdge;
					pt1.normalize( cornerRadius );
					return getCornerRef(1).add( PointUtils.scaleNew( leftEdge, _randomSource.random() ) )
						  				  .add( PointUtils.scaleNew( pt1, _randomSource.random() ) );
				case 7 : 
					pt1 = leftEdge;
					pt1.normalize( cornerRadius );
					return getCornerRef(3).add( PointUtils.scaleNew( topEdge, _randomSource.random() ) )
						  				  .add( PointUtils.scaleNew( pt1, _randomSource.random() ) );
				// center
				case 4 : 
				default :
					return getCornerRef(0).add( PointUtils.scaleNew( topEdge, _randomSource.random() ) )
						  				  .add( PointUtils.scaleNew( leftEdge, _randomSource.random() ) );
			}
			return null;
		}
		/**
		 * @inheritDoc
		 */
		override public function getPathOrientation (path : Number) : Number
		{
			var p : Point = getTangentAt ( path );
			return Math.atan2( p.y, p.x );
		}
		/**
		 * @inheritDoc
		 */
		override public function getPathPoint (path : Number) : Point 
		{
			var p1 : Number;
			var p2 : Number;
			var p3 : Number;			var p4 : Number;			var p5 : Number;			var p6 : Number;			var p7 : Number;
			var hedgeLength : Number = topEdge.length;			var vedgeLength : Number = leftEdge.length;
			if( pathBasedOnLength )
			{
				var l : Number = length;
				p1 = hedgeLength / l;
				p2 = p1 + cornerLength / l;
				p3 = p2 + vedgeLength / l;
				p4 = p3 + cornerLength / l;
				p5 = p4 + hedgeLength / l;
				p6 = p5 + cornerLength / l;
				p7 = p6 + vedgeLength / l;
			}
			else
			{
				p1 = 1/8;				p2 = 2/8;				p3 = 3/8;				p4 = 4/8;				p5 = 5/8;				p6 = 6/8;				p7 = 7/8;
			}
			// on top edge
			if( path < p1 )
				return getEdgeRef(0).add( PointUtils.scaleNew( topEdge, MathUtils.map( path, 0, p1, 0, 1 ) ) );
			// top right corner
			else if( path < p2 )
				return getPointOnCorner( (path-p1) / (p2-p1), 1 );
			// right edge
			else if( path < p3 ) 
				return getEdgeRef(1).add( PointUtils.scaleNew( leftEdge, MathUtils.map( path, p2, p3, 0, 1 ) ) );			// bottom right corner
			else if( path < p4 )
				return getPointOnCorner( (path-p3) / (p4-p3) , 2 );
			// bottom edge
			else if( path < p5 )
				return getEdgeRef(2).add( PointUtils.scaleNew( topEdge, MathUtils.map( path, p4, p5, 0, 1 ) * -1 ) );
			// bottom left corner
			else if( path < p6 )
				return getPointOnCorner( (path-p5) / (p6-p5) , 3 );
			// left edge
			else if( path < p7 )
				return getEdgeRef(3).add( PointUtils.scaleNew( leftEdge, MathUtils.map( path, p6, p7, 0, 1 ) * -1 ) );
			// top left corner
			else
				return getPointOnCorner( (path-p7) / (1-p7), 0 );
		}
		/**
		 * @inheritDoc
		 */
		override public function getPointAtAngle (a : Number) : Point 
		{
			return super.getPointAtAngle( a );
		}
		/**
		 * @inheritDoc
		 */
		override public function draw (g : Graphics, c : Color) : void 
		{
			var a : Array = points;
			var s : Point = a[0];
			var l : uint = a.length;
			
			g.lineStyle(0, c.hexa, c.alpha/255 );
			g.moveTo( s.x, s.y );

			for(var i:int=1;i<l;i++ )
			{
				var p : Point = a[i];
				g.lineTo( p.x, p.y );
			}
			g.lineTo( s.x, s.y );
			g.lineStyle();
		}
		/**
		 * @inheritDoc
		 */
		override public function fill (g : Graphics, c : Color) : void 
		{
			var a : Array = points;
			var s : Point = a[0];
			var l : uint = a.length;
			
			g.beginFill( c.hexa, c.alpha/255 );
			g.moveTo( s.x, s.y );

			for(var i:int=1;i<l;i++ )
			{
				var p : Point = a[i];
				g.lineTo( p.x, p.y );
			}
			g.lineTo( s.x, s.y );
			g.endFill();
		}
		/**
		 * @inheritDoc
		 */
		override public function clone () : Rectangle
		{
			return new RoundRectangle(x, y, width, height, rotation, cornerRadius, pathBasedOnLength);
		}
		/**
		 * @inheritDoc
		 */
		override public function copyTo (o : Object) : void
		{
			super.copyTo(o);
			o["cornerRadius"] = cornerRadius;
		}
		/**
		 * @inheritDoc
		 */
		override public function copyFrom (o : Object) : void
		{
			super.copyFrom( o );
			cornerRadius = o["cornreRadius"];
		}
		/**
		 * @inheritDoc
		 */
		override public function equals ( toCompare : Rectangle ) : Boolean
		{
			if( toCompare is RoundRectangle )
				return super.equals ( toCompare ) && ( toCompare as RoundRectangle ).cornerRadius == cornerRadius;
			else
				return super.equals ( toCompare ) && cornerRadius == 0;
		}
		/**
		 * @inheritDoc
		 */
		override public function toSource () : String
		{
			return toReflectionSource().replace("::", ".");
		}
		/**
		 * @inheritDoc
		 */
		override public function toReflectionSource () : String
		{
			return StringUtils.tokenReplace("new $0($1,$2,$3,$4,$5,$6,$7)",
					   getQualifiedClassName(this),
					   x,
					   y,
					   width,
					   height, 
					   rotation, 
					   cornerRadius,
					   pathBasedOnLength );
		}
		/**
		 * @copy Dimension#toString()
		 */
		override public function toString () : String 
		{
			return StringUtils.stringify(this,{ x:x, y:y, width:width, height:height, rotation:rotation, cornerRadius:cornerRadius } );
		}
	}
}
