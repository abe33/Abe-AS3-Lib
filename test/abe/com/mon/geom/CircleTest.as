package abe.com.mon.geom 
{
	import abe.com.mon.utils.MathUtils;

	import org.hamcrest.assertThat;
	import org.hamcrest.core.allOf;
	import org.hamcrest.core.not;
	import org.hamcrest.object.equalTo;
	import org.hamcrest.object.hasProperties;
	import org.hamcrest.object.hasProperty;
	import org.hamcrest.object.notNullValue;

	import flash.geom.Point;
	/**
	 * @author cedric
	 */
	[TestCase(description="Test the Circle class.")]
	public class CircleTest 
	{
		[Test(order=1, description="This test verify that all the properties and derived properties of a circle are initialized and valid.")]
		public function instanciation() : void
		{
			var c : Circle = new Circle(10,10,10);
			
			assertThat( c, notNullValue() );
			assertThat( c, hasProperties({	'x':10, 'y':10,
											'radius':10 }) );
			assertThat( c.center, allOf( notNullValue(), hasProperties({'x':10,'y':10}) ) );
		}
		[Test] 
		public function equality () : void
		{
			var c1 : Circle = new Circle( 10, 10, 10 );			var c2 : Circle = new Circle( 10, 10, 10 );			var c3 : Circle = new Circle( 10, 10, 12 );
			
			assertThat( c1.equals( c2 ) );			assertThat( not( c2.equals( c3 ) ) );			assertThat( not( c1.equals( c3 ) ) );
			
			c2.rotation = 2;
			
			assertThat( not( c2.equals( c1 ) ) );
			assertThat( not( c2.equals( c3 ) ) );
			
			c3.radius = 10;
			
			assertThat( c1.equals( c3 ) );
		}
		
		[Test(description="This test verify that the serialization methods return the expected results.")] 
		public function serialization () : void		{
			var c : Circle = new Circle( 10, 10, 10 );			
			var s1 : String = "new abe.com.mon.geom.Circle(10,10,10)";
			var s2 : String = "new abe.com.mon.geom::Circle(10,10,10)";
			var s3 : String = "[object Circle(radius=10)]";
						assertThat( c.toSource(), 			allOf( notNullValue(), equalTo( s1 ) ) );			assertThat( c.toReflectionSource(), allOf( notNullValue(), equalTo( s2 ) ) );
			assertThat( c.toString(), 			allOf( notNullValue(), equalTo( s3 ) ) );
		}

		[Test(description="This test verify the ability of a Circle to clone itself.")] 
		public function cloning () : void
		{
			var c1 : Circle = new Circle( 10, 10, 10 );			var c2 : Circle = c1.clone();
			
			assertThat( c1.equals( c2 ) );
			assertThat( not( c1 == c2 ) );		}
		[Test(description="This test verify the ability of a Circle to copy data from or to another object.")] 
		public function copy () : void
		{
			var c1 : Circle = new Circle( 10, 10, 10 );			var c2 : Circle = new Circle();			var c3 : Circle = new Circle();
			
			assertThat( not( c1.equals( c2 ) ) );
			
			c2.copyFrom( c1 );
			
			assertThat( c1.equals( c2 ) );			assertThat( not( c3.equals( c2 ) ) );
			
			c3.copyTo( c2 );
			
			assertThat( not( c1.equals( c2 ) ) );			assertThat( c3.equals( c2 ) );
			
			var o : Object = {};
			c1.copyTo( o );
			assertThat( o, hasProperties({	'x':equalTo(c1.x),											'y':equalTo(c1.y),											'radius':equalTo(c1.radius),											'rotation':equalTo(c1.rotation)
										}) );
			c2.copyFrom(o);
			assertThat( c2, hasProperties({	'x':equalTo(o.x),
											'y':equalTo(o.y),
											'radius':equalTo(o.radius),
											'rotation':equalTo(o.rotation)
										}) );
			assertThat( c1.equals( c2 ) );
						
		}
		[Test(description="This test verify the accurrany of the acreage derived property.")]
		public function acreage () : void
		{
			var a : Number = 10 * 10 * Math.PI;
			var c : Circle = new Circle( 10, 10, 10 );			
			assertThat( c.acreage, a );
		}
		[Test(description="This test verify that the coordinates returned by the getPointAtAngle method are valid with any values.")]
		public function getPointAtAngle () : void
		{
			var c1 : Circle = new Circle( 1, -1, 10 );			var c2 : Circle = new Circle( -10, 10, 8 );			var c3 : Circle = new Circle( 4, 3, 12 );
			
			testGetPointAtAngle(c1, 0);			testGetPointAtAngle(c1, 13);			testGetPointAtAngle(c1, 90);			testGetPointAtAngle(c1, 180);
			
			testGetPointAtAngle(c2, 0);
			testGetPointAtAngle(c2, -46);
			testGetPointAtAngle(c2, 120);
			testGetPointAtAngle(c2, 18.5);
			
			testGetPointAtAngle(c3, 6);
			testGetPointAtAngle(c3, 45);
			testGetPointAtAngle(c3, -80);
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
			
			assertThat( testPoint, allOf( notNullValue(), hasProperty("x"), hasProperty("y") ) );
			assertThat( newPoint.equals( testPoint ) );
		}
	}
}
