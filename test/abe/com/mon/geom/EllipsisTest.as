package abe.com.mon.geom 
{
	import abe.com.mon.utils.MathUtils;
	import abe.com.mon.utils.PointUtils;

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
	[TestCase(description="Test the Ellipsis class.")]
	public class EllipsisTest 
	{

		[Test(order=1, description="This test verify that all the properties and derived properties of a ellipse are initialized and valid.")]
		public function instanciation() : void
		{
			var e : Ellipsis = new Ellipsis(2,5,7,12);
			
			assertThat( e, notNullValue() );
			assertThat( e, hasProperties({	'x':2, 
											'y':5,
											'radius1':7, 
											'radius2':12,											'rotation':0,											'pathOffset':0,
											'clockWisePath':true
										 }) );
			assertThat( e.center, allOf( notNullValue(), hasProperties({'x':2,'y':5}) ) );
		}
		[Test(description="This test verify that two equal Ellipsis can compare themselves.")] 
		public function equality () : void
		{
			var e1 : Ellipsis = new Ellipsis( 2, 5, 7, 12 );
			var e2 : Ellipsis = new Ellipsis( 2, 5, 7, 12 );
			var e3 : Ellipsis = new Ellipsis( 2, 5, 12, 12 );
			
			assertThat( e1.equals( e2 ) );
			assertThat( not( e2.equals( e3 ) ) );
			assertThat( not( e1.equals( e3 ) ) );
			
			e2.rotation = 2;
			
			assertThat( not( e2.equals( e1 ) ) );
			assertThat( not( e2.equals( e3 ) ) );
			
			e3.radius1 = 7;
			
			assertThat( e1.equals( e3 ) );
		}
		
		[Test(description="This test verify that the serialization methods return the expected results.")] 
		public function serialization () : void
		{
			var e : Ellipsis = new Ellipsis( 2, 5, 7, 12 );
			
			var s1 : String = "new abe.com.mon.geom.Ellipsis(2,5,7,12,0,30)";
			var s2 : String = "new abe.com.mon.geom::Ellipsis(2,5,7,12,0,30)";
			var s3 : String = "[object Ellipsis(radius1=7, radius2=12)]";
			
			assertThat( e.toSource(), 			allOf( notNullValue(), equalTo( s1 ) ) );
			assertThat( e.toReflectionSource(), allOf( notNullValue(), equalTo( s2 ) ) );
			assertThat( e.toString(), 			allOf( notNullValue(), equalTo( s3 ) ) );
		}

		[Test(description="This test verify the ability of a Ellipsis to clone itself.")] 
		public function cloning () : void
		{
			var e1 : Ellipsis = new Ellipsis( 2, 5, 7 );
			var e2 : Ellipsis = e1.clone();
			
			assertThat( e1.equals( e2 ) );
			assertThat( not( e1 == e2 ) );
		}
		[Test(description="This test verify the ability of a Ellipsis to copy data from or to another object.")] 
		public function copy () : void
		{
			var e1 : Ellipsis = new Ellipsis( 2, 5, 7 );
			var e2 : Ellipsis = new Ellipsis();
			var e3 : Ellipsis = new Ellipsis();
			
			assertThat( not( e1.equals( e2 ) ) );
			
			e2.copyFrom( e1 );
			
			assertThat( e1.equals( e2 ) );
			assertThat( not( e3.equals( e2 ) ) );
			
			e3.copyTo( e2 );
			
			assertThat( not( e1.equals( e2 ) ) );
			assertThat( e3.equals( e2 ) );
			
			var o : Object = {};
			e1.copyTo( o );
			assertThat( o, hasProperties({	'x':equalTo(e1.x),
											'y':equalTo(e1.y),
											'radius1':equalTo(e1.radius1),											'radius2':equalTo(e1.radius2),
											'rotation':equalTo(e1.rotation)
										}) );
			e2.copyFrom(o);
			assertThat( e2, hasProperties({	'x':equalTo(o.x),
											'y':equalTo(o.y),
											'radius1':equalTo(o.radius1),											'radius2':equalTo(o.radius2),
											'rotation':equalTo(o.rotation)
										}) );
			assertThat( e1.equals( e2 ) );
						
		}
		[Test(description="This test verify the accurrany of the acreage derived property.")]
		public function acreage () : void
		{
			var a : Number = 7 * 12 * Math.PI;
			var e : Ellipsis = new Ellipsis( 2, 5, 7, 12 );
			
			assertThat( e.acreage, a );
		}
		[Test(description="This test verify that the coordinates returned by the getPointAtAngle method are valid with any values.")]
		public function getPointAtAngle () : void
		{
			var e1 : Ellipsis = new Ellipsis( 1, -1, 10 );
			var e2 : Ellipsis = new Ellipsis( -10, 10, 8 );
			var e3 : Ellipsis = new Ellipsis( 4, 3, 12 );
			
			testGetPointAtAngle(e1, 0);
			testGetPointAtAngle(e1, 13);
			testGetPointAtAngle(e1, 90);
			testGetPointAtAngle(e1, 180);
			
			testGetPointAtAngle(e2, 0);
			testGetPointAtAngle(e2, -46);
			testGetPointAtAngle(e2, 120);
			testGetPointAtAngle(e2, 18.5);
			
			testGetPointAtAngle(e3, 6);
			testGetPointAtAngle(e3, 45);
			testGetPointAtAngle(e3, -80);
			testGetPointAtAngle(e3, 99);
		}
		public function testGetPointAtAngle ( ellipse : Ellipsis, angle : Number) : void 
		{
			var centerXY : Point = ellipse.center;
			var radius1 : Number = ellipse.radius1;			var radius2 : Number = ellipse.radius2;
			var a : Number = MathUtils.deg2rad( angle );
	 
			var newPoint : Point = ellipse.getPointAtAngle( a );
			var testPoint : Point = new Point ( radius1 * Math.cos( a ),
												radius2 * Math.sin( a ) );

			testPoint = PointUtils.rotate( testPoint, ellipse.rotation ).add(centerXY);
			
			assertThat( testPoint, notNullValue() );
			assertThat( newPoint.equals( testPoint ) );
		}
	}
}
