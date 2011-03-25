package abe.com.mon.utils.arrays 
{
	import abe.com.mon.geom.Rectangle2;

	import org.hamcrest.assertThat;	import org.hamcrest.object.*;
	import org.hamcrest.collection.array;

	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * @author cedric
	 */
	[TestCase(description="Verify that all the array filters function works as expected.", order=2)]
	public class ArrayTest 
	{
		[Test(description="This test verify that the equalTo filter works as expected.")]
		public function testEqualTo() : void
		{
			var a : Array;
			
			a = [ true, false, false, false ];
			assertThat( a.every( abe.com.mon.utils.arrays.equalTo( false ) ), 
						org.hamcrest.object.equalTo( false ) );
			
			a = [ "foo", "foo", "foo", "foo" ];
			assertThat( a.every( abe.com.mon.utils.arrays.equalTo( "foo" ) ), 
						org.hamcrest.object.equalTo( true ) );
			
			a = [ "foo", "foo", true, true ];
			assertThat( a.every( abe.com.mon.utils.arrays.equalTo( true ) ), 
						org.hamcrest.object.equalTo( false ) );
		}
		
		[Test(description="This test verify that the hasProperty filter works as expected.")]
		public function testHasProperty() : void
		{
			var a : Array;
			
			a = [ true, false, "foo", {'foo':"bar"}, {'foo':50} ];
			
			assertThat( a.every( abe.com.mon.utils.arrays.hasProperty( "foo" ) ), 
						org.hamcrest.object.equalTo( false ) );
			
			assertThat( a.some( abe.com.mon.utils.arrays.hasProperty( "foo" ) ), 
						org.hamcrest.object.equalTo( true ) );
			
			assertThat( a.filter( abe.com.mon.utils.arrays.hasProperty( "foo" ) ).length, 
						org.hamcrest.object.equalTo( 2 ) );
			
			assertThat( a.filter( abe.com.mon.utils.arrays.hasProperty( "foo", "bar" ) ).length, 
						org.hamcrest.object.equalTo( 1 ) );
			
			assertThat( a.filter( abe.com.mon.utils.arrays.hasProperty( "foo", abe.com.mon.utils.arrays.isA( String ) ) ).length, 
						org.hamcrest.object.equalTo( 1 ) );
			
			assertThat( a.filter( abe.com.mon.utils.arrays.hasProperty( "foo", abe.com.mon.utils.arrays.isA( Number ) ) ).length, 
						org.hamcrest.object.equalTo( 1 ) );
		}
		
		[Test(description="This test verify that the hasProperties filter works as expected.")]
		public function testHasProperties() : void
		{
			var a : Array;
			
			a = [ true, false, "foo", {'foo':"bar", 'bar':456}, {'foo':50,'bar':50} ];
			
			assertThat( a.every( abe.com.mon.utils.arrays.hasProperties( {'foo':"bar" } ) ), 
						org.hamcrest.object.equalTo( false ) );
			
			assertThat( a.some( abe.com.mon.utils.arrays.hasProperties( {'foo':"bar" } ) ), 
						org.hamcrest.object.equalTo( true ) );
			
			assertThat( a.filter( abe.com.mon.utils.arrays.hasProperties( {'foo':"bar" } ) ).length, 
						org.hamcrest.object.equalTo( 1 ) );
			
			assertThat( a.filter( abe.com.mon.utils.arrays.hasProperties( {'bar':abe.com.mon.utils.arrays.isA( Number ) } ) ).length, 
						org.hamcrest.object.equalTo( 2 ) );
			
			assertThat( a.filter( abe.com.mon.utils.arrays.hasProperties( {	'foo':50,
																			'bar':50 } ) ).length, 
						org.hamcrest.object.equalTo( 1 ) );			
		}
		
		[Test(description="This test verify that the instanceOf filters correctly discern types.")]
		public function testInstanceOf() : void
		{
			var a : Array;
			
			a = [ {'x':1,'y':2}, new Point(1,2), new Rectangle(), new Rectangle2() ];
			
			assertThat( a.every( abe.com.mon.utils.arrays.instanceOf( Point ) ), 
						org.hamcrest.object.equalTo( false ) );
			
			assertThat( a.some( abe.com.mon.utils.arrays.instanceOf( Point ) ), 
						org.hamcrest.object.equalTo( true ) );
			
			assertThat( a.filter( abe.com.mon.utils.arrays.instanceOf( Object ) ).length, 
						org.hamcrest.object.equalTo( 1 ) );
			
			assertThat( a.filter( abe.com.mon.utils.arrays.instanceOf( Point ) ).length, 
						org.hamcrest.object.equalTo( 1 ) );
			
			assertThat( a.filter( abe.com.mon.utils.arrays.instanceOf( Rectangle ) ).length, 
						org.hamcrest.object.equalTo( 1 ) );
			
			assertThat( a.filter( abe.com.mon.utils.arrays.instanceOf( Rectangle2 ) ).length, 
						org.hamcrest.object.equalTo( 1 ) );
		}
		
		[Test(description="This test verify that the isA filters correctly discern types.")]
		public function testIsA() : void
		{
			var a : Array;
			
			a = [ {'x':1,'y':2}, new Point(1,2), new Rectangle(), new Rectangle2() ];
			
			assertThat( a.every( abe.com.mon.utils.arrays.isA( Object ) ), 
						org.hamcrest.object.equalTo( true ) );
			
			assertThat( a.some( abe.com.mon.utils.arrays.isA( Point ) ), 
						org.hamcrest.object.equalTo( true ) );
			
			assertThat( a.some( abe.com.mon.utils.arrays.isA( String ) ), 
						org.hamcrest.object.equalTo( false ) );
			
			assertThat( a.filter( abe.com.mon.utils.arrays.isA( Object ) ).length, 
						org.hamcrest.object.equalTo( 4 ) );
			
			assertThat( a.filter( abe.com.mon.utils.arrays.isA( Rectangle ) ).length, 
						org.hamcrest.object.equalTo( 2 ) );
				
			assertThat( a.filter( abe.com.mon.utils.arrays.isA( Rectangle2 ) ).length, 
						org.hamcrest.object.equalTo( 1 ) );
		}
		
		public function testNot () : void
		{
			var a : Array;
			
			a = [ true, true, "foo", "bar", 15, {} ];
			
			assertThat( a.every( abe.com.mon.utils.arrays.not( false ) ), 
						org.hamcrest.object.equalTo( true ) );
			
			assertThat( a.some( abe.com.mon.utils.arrays.not( abe.com.mon.utils.arrays.instanceOf( Object )  ) ), 
						org.hamcrest.object.equalTo( true ) );
			
			assertThat( a.filter( abe.com.mon.utils.arrays.not( false ) ).length, 
						org.hamcrest.object.equalTo( 6 ) );
			
		}
		
		[Test(description="This test verify the anyOf filter in various situation.")]
		public function testAnyOf() : void
		{
			var a : Array;
			
			a = [ true, false, false, false ];
			assertThat( a.every( abe.com.mon.utils.arrays.anyOf( true, false ) ) );
			
			a = [ true, "foo", 12, false ];
			assertThat( a.every( abe.com.mon.utils.arrays.anyOf( true, 
																 false, 
																 abe.com.mon.utils.arrays.isA( String ),
																 abe.com.mon.utils.arrays.equalTo( 12 ) ) ) );
			
			a = [ true, "foo", 12, false, {}, "bar" ];
			assertThat( a.filter( abe.com.mon.utils.arrays.anyOf( abe.com.mon.utils.arrays.isA(String), 
																  true,
																  false ) ),
						array( true,"foo",false,"bar" ) );
			
			
			a = [ true, "foo", false, "bar" ];
			assertThat( a.filter( abe.com.mon.utils.arrays.anyOf( abe.com.mon.utils.arrays.instanceOf(Object),
																  abe.com.mon.utils.arrays.instanceOf(Point) ) ),
						array() );
			
			assertThat( a.filter( abe.com.mon.utils.arrays.anyOf( true ) ),
						array(true) );
		}
		[Test(description="This test verify the allOf filter in various situation.")]
		public function testAllOf() : void
		{
			var a : Array;
			
			a = [ true, false, false, false ];
			assertThat( a.every( abe.com.mon.utils.arrays.allOf( abe.com.mon.utils.arrays.isA(Boolean), false ) ), 
						org.hamcrest.object.equalTo( false ) );
			
			a = [ "foo", "bar" ];
			assertThat( a.every( abe.com.mon.utils.arrays.allOf( abe.com.mon.utils.arrays.isA(String) ) ), 
						org.hamcrest.object.equalTo( true ) );
			
			a = [ true, "foo", false, "bar", {}, 15 ];
			assertThat( a.filter( abe.com.mon.utils.arrays.allOf( abe.com.mon.utils.arrays.isA(String), 
																  abe.com.mon.utils.arrays.equalTo( "foo" ) ) ),
						array("foo") );
			
			a = [ "foo", "bar", {"foo":true}, true ];
			assertThat( a.some( abe.com.mon.utils.arrays.allOf( abe.com.mon.utils.arrays.instanceOf(Object), 
																abe.com.mon.utils.arrays.hasProperty("foo") ) ), 
						org.hamcrest.object.equalTo( true ) );
		}
	}
}
