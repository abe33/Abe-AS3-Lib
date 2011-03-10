package abe.com.mon.geom 
{
	import abe.com.mon.utils.MathUtils;

	import flexunit.framework.Assert;

	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertTrue;

	import flash.geom.Point;
	/**
	 * @author cedric
	 */
	public class CircleTest 
	{

		[Test] 
		public function serialization () : void
		{
			var c : Circle = new Circle( 10, 10, 10 );
						var s1 : String = "new abe.com.mon.geom.Circle(10,10,10)";
			var s2 : String = "new abe.com.mon.geom::Circle(10,10,10)";
			var s3 : String = "[object Circle(radius=10)]";
			
			Assert.assertEquals( c.toSource( ), s1 );			Assert.assertEquals( c.toReflectionSource( ), s2 );			Assert.assertEquals( c.toString( ), s3 );
		}

		[Test] 
		public function equality () : void
		{
			var c1 : Circle = new Circle( 10, 10, 10 );			var c2 : Circle = new Circle( 10, 10, 10 );			var c3 : Circle = new Circle( 10, 10, 12 );
			
			Assert.assertTrue( c1.equals( c2 ) );			Assert.assertFalse( c2.equals( c3 ) );			Assert.assertFalse( c1.equals( c3 ) );
		}

		[Test] 
		public function cloning () : void
		{
			var c1 : Circle = new Circle( 10, 10, 10 );			var c2 : Circle = c1.clone( );
			
			Assert.assertTrue( c1.equals( c2 ) );
			Assert.assertFalse( c1 == c2 );		}

		[Test]
		public function acreage () : void
		{
			var a : Number = 10 * 10 * Math.PI;
			var c : Circle = new Circle( 10, 10, 10 );			
			assertEquals( c.acreage, a );
		}
		[Test]
		public function getPointAtAngle () : void
		{
			var c1 : Circle = new Circle( 1, -1, 10 );			var c2 : Circle = new Circle( -10, 10, 8 );			var c3 : Circle = new Circle( 4, 3, 12 );
			
			testGetPointAtAngle(c1, 0);			testGetPointAtAngle(c1, 13);			testGetPointAtAngle(c1, 90);			testGetPointAtAngle(c1, 180);
			
			testGetPointAtAngle(c2, 0);
			testGetPointAtAngle(c2, 46);
			testGetPointAtAngle(c2, 120);
			testGetPointAtAngle(c2, 18.5);
			
			testGetPointAtAngle(c3, 6);
			testGetPointAtAngle(c3, 45);
			testGetPointAtAngle(c3, 80);
			testGetPointAtAngle(c3, 99);
		}
		
		public function testGetPointAtAngle ( circle : Circle, angle : Number) : void 
		{
			var centerXY : Point = circle.center;
			var radius : Number = circle.radius;
			var a : Number = MathUtils.deg2rad( angle );
	 
			var newPoint : Point = circle.getPointAtAngle( a );
			var testPoint : Point = new Point( centerXY.x + radius * Math.cos( a ), 
											   centerXY.y + radius * Math.sin( a ) );
			
			assertTrue( newPoint.equals( testPoint ) );
		}
	}
}
