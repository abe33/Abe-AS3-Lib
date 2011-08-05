package abe.com.mon.geom 
{
	import abe.com.mon.utils.MathUtils;
	import abe.com.mon.utils.RandomUtils;
	import abe.com.patibility.hamcrest.equalToObject;

	import org.flexunit.experimental.theories.Theories;
	import org.hamcrest.assertThat;
	import org.hamcrest.core.allOf;
	import org.hamcrest.object.notNullValue;

	import flash.geom.Point;

	[TestCase(description="Circle theories", order=3)]
	[RunWith("org.flexunit.experimental.theories.Theories")]
	public class CircleTheories 
	{
		private var theory : Theories;
		public static var circle : Circle;

		public function CircleTheories(circleConstruc:Circle):void 
		{
          circle = circleConstruc;
     	}
		[DataPoints]
		[ArrayElementType("abe.com.mon.geom.Circle")]
		public static var circles : Array = [ new Circle( 1, -1, 10 ),
	        			  					  new Circle( 10, -10, 40 ),
					  						  new Circle( -5, 3, 11 ),
	         			   					  new Circle( 4, 4, 6 ) ];

		[DataPoints]
		[ArrayElementType("Number")]
		public static var angles : Array = RandomUtils.floatArray(20,0,180);

		[Theory(description="This theory verify that the getPointAtAngle of the Circle class returns the valid coordinates for a wide range of values.",
				details="There's 4 circles with different settings and they are tested over 20 different random angles.")]
		public function testGetPointAtAngle ( angle : Number) : void 
		{
			var centerXY : Point = circle.center;
			var radius : Number = circle.radius;
			var a : Number = MathUtils.deg2rad( angle );
	 
			var newPoint : Point = circle.getPointAtAngle( a );
			var testPoint : Point = new Point( centerXY.x + radius * Math.cos( a ), 
											   centerXY.y + radius * Math.sin( a ) );
			
			assertThat(newPoint, allOf( notNullValue(), equalToObject( testPoint ) ) );
		}
	}
}
