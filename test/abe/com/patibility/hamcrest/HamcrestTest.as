package abe.com.patibility.hamcrest 
{
	import abe.com.mon.geom.Dimension;

	import org.hamcrest.assertThat;
	import org.hamcrest.number.closeTo;
	import org.hamcrest.object.equalTo;

	import flash.geom.Point;

	/**
	 * @author cedric
	 */
	[TestCase(description="These tests verify that the custom hamcrest matchers works as expected",order=1)]
	public class HamcrestTest 
	{	
		[Test(description="This test verify that the propertiesCount matcher match the success when expected.")]
		public function propertiesCountSuccess():void
		{
			// empty object
			assertThat( {}, propertiesCount(0) ); 
			
			// objects with several properties			assertThat( {'foo':0}, propertiesCount(1) ); 			assertThat( {'foo':0,'bar':1}, propertiesCount(2) ); 			assertThat( {'foo':0,'bar':1,'toString':function():String{ return "foo"; } }, propertiesCount(3) ); 			
			// using a submatcher as argument 
			assertThat( {'foo':0,'bar':1}, propertiesCount(equalTo(2)) ); 			assertThat( {'foo':0,'bar':1}, propertiesCount(closeTo(2,1)) ); 
		}
		[Test(description="This test verify that the propertiesCount matcher fail as expected when the properties is lower than expected.", expects="Error")]
		public function propertiesCountFailure1 () : void
		{
			assertThat( {}, propertiesCount(1) );
		}
		[Test(description="This test verify that the propertiesCount matcher fail as expected when the properties is greater than expected.", expects="Error")]
		public function propertiesCountFailure2 () : void
		{
			assertThat( {'foo':'bar'}, propertiesCount(0) );
		}
		[Test(description="This test verify that the propertiesCount matcher fail as expected with a submatcher.", expects="Error")]
		public function propertiesCountFailure3 () : void
		{
			assertThat( {'foo':'bar'}, propertiesCount(closeTo(4,1)) );
		}
		[Test(description="This test verify that the equalToObject matcher match as expected.")]
		public function equalToObjectSuccess() : void
		{
			var d1 : Dimension = new Dimension(13,19);			var d2 : Dimension = new Dimension(13,19);
			var od1 : Object = {'width':13,'height':19};
			var od2 : Object = {'width':13,'height':19};
			var p1 : Point = new Point(13,19);			var p2 : Point = new Point(13,19);
			var op1 : Object = {'x':13,'y':19};			var op2 : Object = {'x':13,'y':19};
			
			// both objects are Equatable 
			assertThat( d1, equalToObject( d2 ) );
			
			// both objects have the same type and an equals method			assertThat( p1, equalToObject( p2 ) );
			
			// both objects don't have any equals method
			assertThat( op1, equalToObject( op2 ) );			assertThat( od1, equalToObject( od2 ) );
		}
		[Test(description="This test verify that anonymous object comparison fails as expected when the properties of both objects are different.", expects="Error")]
		public function equalToObjectFailure1 () : void
		{
			assertThat( {}, equalToObject({'foo':10}) );
		}
		[Test(description="This test verify that anonymous object comparison fails as expected when the one of the values is different.", expects="Error")]
		public function equalToObjectFailure2 () : void
		{
			assertThat( {'foo':0,'bar':"ooo"}, equalToObject({'foo':10,'bar':"ooo"}) );
		}
		[Test(description="This test verify that the comparison fails when two Equatable are different.", expects="Error")]
		public function equalToObjectFailure3 () : void
		{
			assertThat( new Dimension(13,19), equalToObject(new Dimension(0,19)) );		}
		[Test(description="This test verify that the comparison fails when two objects with an equals method are different.", expects="Error")]
		public function equalToObjectFailure4 () : void
		{
			assertThat( new Point(13,19), equalToObject(new Point(0,19)) );
		}
		[Test(description="This test verify that the comparison fails with Equatable and an anonymous object.", expects="Error")]
		public function equalToObjectFailure5 () : void
		{
			assertThat( new Dimension(13,19), equalToObject({'width':10,'height':19}) );
		}
		[Test(description="This test verify that the comparison fails with Equatable and an anonymous object with different properties.", expects="Error")]
		public function equalToObjectFailure6 () : void
		{
			assertThat( new Dimension(13,19), equalToObject({'x':10,'y':19}) );
		}
		[Test(description="This test verify that the comparison fails with an 'equals' owner and an anonymous object.", expects="Error")]
		public function equalToObjectFailure7 () : void
		{
			assertThat( new Point(13,19), equalToObject({'x':10,'y':19}) );
		}
		[Test(description="This test verify that the comparison fails with an 'equals' owner and an anonymous object  with different properties.", expects="Error")]
		public function equalToObjectFailure8 () : void
		{
			assertThat( new Point(13,19), equalToObject({'width':10,'height':19}) );
		}
	}
}
