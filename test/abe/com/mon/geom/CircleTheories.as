package abe.com.mon.geom 
{
	import abe.com.mon.utils.MathUtils;

	import org.flexunit.asserts.assertTrue;
	import org.flexunit.experimental.theories.Theories;

	import flash.geom.Point;

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
		public static var angles : Array = [ 0,10,20,5,33,44.5,60,90,180 ];

		[Theory]
		public function testGetPointAtAngle ( angle : Number) : void 
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
