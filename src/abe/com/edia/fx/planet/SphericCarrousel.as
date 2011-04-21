package abe.com.edia.fx.planet 
{
	import abe.com.mon.utils.MathUtils;

	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Point;
	/**
	 * @author Cédric Néhémie
	 */
	public class SphericCarrousel 
	{
		public var background : Sprite;
		public var foreground : Sprite;
		public var rayon : Number;
		public var center : Point;
		
		static public function dosortFront ( o1 : DisplayObject, o2 : DisplayObject ) : Number
		{
			return o2.x*o2.x + o2.y*o2.y > o1.x*o1.x + o1.y*o1.y ? 1 : -1;
		}
		static public function dosortBack ( o1 : DisplayObject, o2 : DisplayObject ) : Number
		{
			return o2.x*o2.x + o2.y*o2.y < o1.x*o1.x + o1.y*o1.y ? 1 : -1;
		}
	
		public function SphericCarrousel()
		{
			center = new Point();
		}
		public function update() : void
		{
			updateFront();
			updateBack();
		}
		public function sortBackClouds () : void
		{
			var i : Number;
			var c : Vector.<DisplayObject> = new Vector.<DisplayObject> ();
			var l : Number = background.numChildren;
			for( i = 0; i < l; i++ )
			{
				c.push( background.getChildAt( i ) );
			}
			
			c.sort ( dosortBack );
					   
			i = c.length;
			while( i-- )
			{
				if ( background.getChildIndex( c[i] ) != i ) 
				{
					 background.setChildIndex( c[i], i );
				}
			}
		}
		public function sortFrontClouds () : void
		{
			var i : Number;
			var c : Vector.<DisplayObject> = new Vector.<DisplayObject> ();
			var l : Number = foreground.numChildren;
			for( i = 0; i < l; i++ )
			{
				c.push( foreground.getChildAt( i ) );
			}
			
			c.sort ( dosortFront );
					   
			i = c.length;
			while( i-- )
			{
				if ( foreground.getChildIndex( c[i] ) != i ) 
				{
					 foreground.setChildIndex( c[i], i );
				}
			}
		}
		public function updateFront () : void
		{
			var fl : Number = foreground.numChildren;
			var c : Cloud;
			var r : Number;
			var ry : Number;
			
			while ( --fl -(-1) )
			{
	
				c = foreground.getChildAt( fl ) as Cloud;
				r = rayon * Math.sin ( c.lat );
				ry = center.y + ( Math.cos ( c.lat ) * rayon );
				
				updateCloud(c, r, ry);
				
				if( c.y <= ry )
				{
					foreground.removeChild( c );
					background.addChild( c );
					c.isBack = true;
				}
			}
			sortFrontClouds();
		}
		public function updateBack () : void
		{
			var bl : Number = background.numChildren;
			var c : Cloud;
			var r : Number;
			var ry : Number;
	
			while ( --bl -(-1) )
			{
				c = background.getChildAt( bl ) as Cloud;
				r = rayon * Math.sin ( c.lat );
				ry = center.y + ( Math.cos ( c.lat ) * rayon );
				
				updateCloud(c, r, ry);
				
				if( c.y > ry )
				{
					background.removeChild( c );
					foreground.addChild( c );
					c.isBack = false;
				}
			}
			sortBackClouds();
		}
		public function updateCloud( c : Cloud, r : Number, ry : Number ) : void
		{
			var v : Point;
			
			c.rotation = 0;
			c.x = center.x + Math.sin( c.long ) * r;
			c.y = ry + Math.cos( c.long ) * r / 4;
			
			v = new Point( c.x, c.y ).subtract( center );
			c.scaleY = Math.max( .2, Math.sin( Math.PI/2 + ( v.length / rayon ) * Math.PI/2 ) );
			//c.alpha =  Math.max( .7, Math.sin( Math.PI/2 + ( v.length / rayon * v.length / rayon ) * Math.PI/2 ) );
			c.rotation = -MathUtils.rad2deg( Math.atan2( v.x, v.y ) );
				
		}
	}
}
