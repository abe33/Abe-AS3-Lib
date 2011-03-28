package abe.com.mon.utils.arrays 
{
	import org.hamcrest.core.describedAs;
	import abe.com.mon.geom.Rectangle2;

	import org.hamcrest.assertThat;
	import org.hamcrest.collection.array;
	import org.hamcrest.object.*;

	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * @author cedric
	 */
	[TestCase(description="Verify that all the array filters function works as expected.", order=2)]
	public class ArrayTest 
	{
		[Test]
		public function contains () : void
		{}
		
		[Test(description="This test verify that the matchCycle function perform as expected with various array structure.")]
		public function matchCycle() : void
		{
			var a : Array;
			
			// value cycle
			a = ["foo",10,true,"foo",10,true];
			assertThat( a.every( abe.com.mon.utils.arrays.matchCycle( "foo", 10, true ) ), 
					    describedAs("matchCycle with %0 as arguments on %1 should return true", 
					    			org.hamcrest.object.equalTo( true ), 
					    			["foo", 10, true], 
					    			a ) );
			
			// invalid value cycle
			a = ["foo",10,true,"bar",10,true];
			assertThat( a.every( abe.com.mon.utils.arrays.matchCycle( "foo", 10, true ) ), 
					    describedAs("matchCycle with %0 as arguments on %1 should return false", 
					    			org.hamcrest.object.equalTo( false ), 
					    			["foo", 10, true], 
					    			a ) );
				    
			// single cycle
			a = ["foo",10,true];
			assertThat( a.every( abe.com.mon.utils.arrays.matchCycle( 
											 abe.com.mon.utils.arrays.isA(String),
											 abe.com.mon.utils.arrays.isA(Number),
											 abe.com.mon.utils.arrays.isA(Boolean) ) ), 
					    describedAs("matchCycle(isA(String),isA(Number),isA(Boolean)) on %0 should return true", 
					    			org.hamcrest.object.equalTo( true ), 
					    			a ) );
			
			// several cycle
			a = ["foo",10,true, "bar",5,false, "oof",12,true ];
			assertThat( a.every( abe.com.mon.utils.arrays.matchCycle( 
											 abe.com.mon.utils.arrays.isA(String),
											 abe.com.mon.utils.arrays.isA(Number),
											 abe.com.mon.utils.arrays.isA(Boolean) ) ), 
					   describedAs("matchCycle(isA(String),isA(Number),isA(Boolean)) on %0 should return true", 
					    			org.hamcrest.object.equalTo( true ), 
					    			a ) );
			
			// incomplete cycle
			a = ["foo",10,true,"bar"];
			assertThat( a.every( abe.com.mon.utils.arrays.matchCycle( 
											 abe.com.mon.utils.arrays.isA(String),
											 abe.com.mon.utils.arrays.isA(Number),
											 abe.com.mon.utils.arrays.isA(Boolean) ) ), 
					    describedAs("matchCycle(isA(String),isA(Number),isA(Boolean)) on %0 should return false", 
					    			org.hamcrest.object.equalTo( false ), 
					    			a ) );
			
			// invalid cycle
			a = ["foo",10,true,"bar","foo",10];
			assertThat( a.every( abe.com.mon.utils.arrays.matchCycle( 
											 abe.com.mon.utils.arrays.isA(String),
											 abe.com.mon.utils.arrays.isA(Number),
											 abe.com.mon.utils.arrays.isA(Boolean) ) ), 
					    describedAs("matchCycle(isA(String),isA(Number),isA(Boolean)) on %0 should return false", 
					    			org.hamcrest.object.equalTo( false ), 
					    			a ) );
		}
		[Test(description="This test verify that the matchFixed function perform as expected with various array structure.")]
		public function matchFixed() : void
		{
			var a : Array;
			
			// fingle fixed
			a = ["foo",10,true];
			assertThat( a.every( abe.com.mon.utils.arrays.matchFixed( "foo", 10, true ) ), 
					    describedAs("matchFixed with %0 as arguments on %1 should return true", 
					    			org.hamcrest.object.equalTo( true ), 
					    			["foo", 10, true], 
					    			a ) );
			
			// invalid fixed
			a = ["foo",10,true,"bar"];
			assertThat( a.every( abe.com.mon.utils.arrays.matchFixed( "foo", 10, true ) ), 
					    describedAs("matchFixed with %0 as arguments on %1 should return false", 
					    			org.hamcrest.object.equalTo( false ), 
					    			["foo", 10, true], 
					    			a ) );
			
			// invalid fixed
			a = ["bar",10,true];
			assertThat( a.every( abe.com.mon.utils.arrays.matchFixed( "foo", 10, true ) ), 
					    describedAs("matchFixed with %0 as arguments on %1 should return false", 
					    			org.hamcrest.object.equalTo( false ), 
					    			["foo", 10, true], 
					    			a ) );
			// with submatcher
			a = ["foo",10,true];
			assertThat( a.every( abe.com.mon.utils.arrays.matchFixed( 
											 abe.com.mon.utils.arrays.isA(String),
											 abe.com.mon.utils.arrays.isA(Number),
											 abe.com.mon.utils.arrays.isA(Boolean) ) ), 
					    describedAs("matchCycle(isA(String),isA(Number),isA(Boolean)) on %0 should return true", 
					    			org.hamcrest.object.equalTo( true ), 
					    			a ) );
			// with invalid data
			a = [10,10,true];
			assertThat( a.every( abe.com.mon.utils.arrays.matchFixed( 
											 abe.com.mon.utils.arrays.isA(String),
											 abe.com.mon.utils.arrays.isA(Number),
											 abe.com.mon.utils.arrays.isA(Boolean) ) ), 
					    describedAs("matchCycle(isA(String),isA(Number),isA(Boolean)) on %0 should return false", 
					    			org.hamcrest.object.equalTo( false ), 
					    			a ) );
		}
		[Test(description="This test verify that the matchRest function perform as expected with various array structure.")]
		public function matchRest() : void
		{
			var a : Array;
			
			a = ["foo",10,true];
			assertThat( a.every( abe.com.mon.utils.arrays.matchRest( "foo", 10, true ) ), 
					    describedAs("matchFixed with %0 as arguments on %1 should return true", 
					    			org.hamcrest.object.equalTo( true ), 
					    			["foo", 10, true], 
					    			a ) );
					    			
			a = ["bar",10,true];
			assertThat( a.every( abe.com.mon.utils.arrays.matchRest( "foo", 10, true ) ), 
					    describedAs("matchFixed with %0 as arguments on %1 should return false", 
					    			org.hamcrest.object.equalTo( false ), 
					    			["foo", 10, true], 
					    			a ) );
					    			
			a = ["foo",10,true,true,true];
			assertThat( a.every( abe.com.mon.utils.arrays.matchRest( "foo", 10, true ) ), 
					    describedAs("matchFixed with %0 as arguments on %1 should return true", 
					    			org.hamcrest.object.equalTo( true ), 
					    			["foo", 10, true], 
					    			a ) );
			
			a = ["foo",10,true,true,false];
			assertThat( a.every( abe.com.mon.utils.arrays.matchRest( "foo", 10, true ) ), 
					    describedAs("matchFixed with %0 as arguments on %1 should return false", 
					    			org.hamcrest.object.equalTo( false ), 
					    			["foo", 10, true], 
					    			a ) );
			
			a = ["foo",10,true, {}, null, "foo", true];
			assertThat( a.every( abe.com.mon.utils.arrays.matchRest( "foo", 10, true, anything() ) ), 
					    describedAs("matchFixed('foo', 10, true, anything()) on %0 should return true", 
					    			org.hamcrest.object.equalTo( true ), 
					    			a ) );
			
			a = ["foo",10,true, {}, {}, {} ];
			assertThat( a.every( abe.com.mon.utils.arrays.matchRest( 
											 abe.com.mon.utils.arrays.isA(String),
											 abe.com.mon.utils.arrays.isA(Number),
											 abe.com.mon.utils.arrays.isA(Boolean),											 abe.com.mon.utils.arrays.instanceOf(Object)  ) ), 
					    describedAs("matchFixed('foo', 10, true, anything()) on %0 should return true", 
					    			org.hamcrest.object.equalTo( true ), 
					    			a ) );
			
			a = ["foo",10,true, {}, false, {} ];
			assertThat( a.every( abe.com.mon.utils.arrays.matchRest( 
											 abe.com.mon.utils.arrays.isA(String),
											 abe.com.mon.utils.arrays.isA(Number),
											 abe.com.mon.utils.arrays.isA(Boolean),
											 abe.com.mon.utils.arrays.instanceOf(Object)  ) ), 
					    describedAs("matchFixed('foo', 10, true, anything()) on %0 should return false", 
					    			org.hamcrest.object.equalTo( false ), 
					    			a ) );
		}
		[Test(description="This test verify that the equalTo filter works as expected.")]
		public function equalTo() : void
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
			
			a = [ 5, "5" ];
			assertThat( a.every( abe.com.mon.utils.arrays.equalTo( "5" ) ), 
						org.hamcrest.object.equalTo( true ) );
			
			a = [ 1, true ];
			assertThat( a.every( abe.com.mon.utils.arrays.equalTo( true ) ), 
						org.hamcrest.object.equalTo( true ) );
			
			a = [ null, undefined ];
			assertThat( a.every( abe.com.mon.utils.arrays.equalTo( null ) ), 
						org.hamcrest.object.equalTo( true ) );
		}
		[Test(description="This test verify that the strictlyEqualTo filter works as expected.")]
		public function strictlyEqualTo() : void
		{
			var a : Array;
			
			a = [ null, false, false, false ];
			assertThat( a.every( abe.com.mon.utils.arrays.strictlyEqualTo( false ) ), 
						org.hamcrest.object.equalTo( false ) );
			
			a = [ 5, "5" ];
			assertThat( a.every( abe.com.mon.utils.arrays.strictlyEqualTo( "5" ) ), 
						org.hamcrest.object.equalTo( false ) );
			
			a = [ null, undefined ];
			assertThat( a.every( abe.com.mon.utils.arrays.strictlyEqualTo( null ) ), 
						org.hamcrest.object.equalTo( false ) );
		}
		
		[Test(description="This test verify that the hasProperty filter works as expected.")]
		public function hasProperty() : void
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
		public function hasProperties() : void
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
		public function instanceOf() : void
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
		public function isA() : void
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
		
		public function not () : void
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
		public function anyOf() : void
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
		public function allOf() : void
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
		[Test(description="This test verify the nullValue function.")]
		public function nullValue () : void
		{
			var a : Array;
			
			a = [null, undefined, false, "null"];
			assertThat( a.every( abe.com.mon.utils.arrays.nullValue), 
						org.hamcrest.object.equalTo( false ) );
			
			assertThat( a.some( abe.com.mon.utils.arrays.nullValue), 
						org.hamcrest.object.equalTo( true ) );
		
			assertThat( a.filter( abe.com.mon.utils.arrays.nullValue).length, 
						org.hamcrest.object.equalTo( 2 ) );
		}
		[Test(description="This test verify the closeTo filter.")]
		public function closeTo() : void
		{
			var a : Array;
			
			a = [ 0, 4.5, 5, 6.7, 6.2, 6, 8 ];
			assertThat( a.every( abe.com.mon.utils.arrays.closeTo(5)), 
						org.hamcrest.object.equalTo( false ) );
			
			assertThat( a.every( abe.com.mon.utils.arrays.closeTo(5,6)), 
						org.hamcrest.object.equalTo( true ) );
			
			assertThat( a.some( abe.com.mon.utils.arrays.closeTo(5)), 
						org.hamcrest.object.equalTo( true ) );
			
			assertThat( a.filter( abe.com.mon.utils.arrays.closeTo(5)), 
						array( 4.5, 5, 6 ) );
			
			assertThat( a.filter( abe.com.mon.utils.arrays.closeTo(5,2)), 
						array( 4.5, 5, 6.7, 6.2, 6 ) );
		
			assertThat( a.filter( abe.com.mon.utils.arrays.closeTo(5,6)), 
						array( 0, 4.5, 5, 6.7, 6.2, 6, 8 ) );
		}
		[Test(description="This test verify the between filter.")]
		public function between () : void
		{
			var a : Array;
			
			a = [ 0, 4.5, 5, 6.7, 6.2, 6, 8 ];
			
			assertThat( a.every(abe.com.mon.utils.arrays.between(4,6) ),
						org.hamcrest.object.equalTo( false ) );
			
			assertThat( a.every(abe.com.mon.utils.arrays.between(0,8) ),
						org.hamcrest.object.equalTo( true ) );
			
			assertThat( a.filter( abe.com.mon.utils.arrays.between(4,6)), 
						array( 4.5, 5, 6 ) );
			
			assertThat( a.filter( abe.com.mon.utils.arrays.between(4,7)), 
						array( 4.5, 5, 6.7, 6.2, 6 ) );
			
			assertThat( a.filter( abe.com.mon.utils.arrays.between(0,8)), 
						array( 0, 4.5, 5, 6.7, 6.2, 6, 8 ) );
		}
		[Test(description="This test verify the greaterThan filter.")]
		public function greaterThan () : void
		{
			var a : Array;
			
			a = [ 0, 4.5, 5, 6.7, 6.2, 6, 8 ];
			
			// greaterThan
			assertThat( a.every(abe.com.mon.utils.arrays.greaterThan(4)),
						org.hamcrest.object.equalTo( false ) );
			
			assertThat( a.every(abe.com.mon.utils.arrays.greaterThan(0)),
						org.hamcrest.object.equalTo( false ) );
			
			assertThat( a.some(abe.com.mon.utils.arrays.greaterThan(0)),
						org.hamcrest.object.equalTo( true ) );
			
			assertThat( a.some(abe.com.mon.utils.arrays.greaterThan(8)),
						org.hamcrest.object.equalTo( false ) );
		}	
		[Test(description="This test verify the greaterThanOrEqualTo filter.")]
		public function greaterThanOrEqualTo () : void
		{
			var a : Array;
			
			a = [ 0, 4.5, 5, 6.7, 6.2, 6, 8 ];
					
			// greaterThanOrEqualTo
			assertThat( a.every(abe.com.mon.utils.arrays.greaterThanOrEqualTo(4)),
						org.hamcrest.object.equalTo( false ) );
			
			assertThat( a.every(abe.com.mon.utils.arrays.greaterThanOrEqualTo(0)),
						org.hamcrest.object.equalTo( true ) );
			
			assertThat( a.some(abe.com.mon.utils.arrays.greaterThanOrEqualTo(0)),
						org.hamcrest.object.equalTo( true ) );
			
			assertThat( a.some(abe.com.mon.utils.arrays.greaterThanOrEqualTo(8)),
						org.hamcrest.object.equalTo( true ) );
		}
		[Test(description="This test verify the lowerThan filter.")]
		public function lowerThan () : void
		{
			var a : Array;
			
			a = [ 0, 4.5, 5, 6.7, 6.2, 6, 8 ];
			// lowerThan
			assertThat( a.every(abe.com.mon.utils.arrays.lowerThan(6)),
						org.hamcrest.object.equalTo( false ) );
			
			assertThat( a.every(abe.com.mon.utils.arrays.lowerThan(8)),
						org.hamcrest.object.equalTo( false ) );
			
			assertThat( a.some(abe.com.mon.utils.arrays.lowerThan(6)),
						org.hamcrest.object.equalTo( true ) );
			
			assertThat( a.some(abe.com.mon.utils.arrays.lowerThan(0)),
						org.hamcrest.object.equalTo( false ) );
		}
		[Test(description="This test verify the lowerThanOrEqualTo filter.")]
		public function lowerThanOrEqualTo () : void
		{
			var a : Array;
			
			a = [ 0, 4.5, 5, 6.7, 6.2, 6, 8 ];
			// lowerThan
			assertThat( a.every(abe.com.mon.utils.arrays.lowerThanOrEqualTo(6)),
						org.hamcrest.object.equalTo( false ) );
			
			assertThat( a.every(abe.com.mon.utils.arrays.lowerThanOrEqualTo(8)),
						org.hamcrest.object.equalTo( true ) );
			
			assertThat( a.some(abe.com.mon.utils.arrays.lowerThanOrEqualTo(6)),
						org.hamcrest.object.equalTo( true ) );
			
			assertThat( a.some(abe.com.mon.utils.arrays.lowerThanOrEqualTo(0)),
						org.hamcrest.object.equalTo( true ) );
		}
		
		[Test(description="This test verify the lastIn function.")]
		public function lastIn () : void
		{
			var a : Array;
			
			a = [];
			assertThat( abe.com.mon.utils.arrays.lastIn(a), org.hamcrest.object.nullValue() );
			
			a = ["foo"];
			assertThat( abe.com.mon.utils.arrays.lastIn(a), org.hamcrest.object.equalTo( "foo" ) );
			
			a = [1,true,{},"bar",null,"foo"];
			assertThat( abe.com.mon.utils.arrays.lastIn(a), org.hamcrest.object.equalTo( "foo" ) );
		}
		[Test(description="This test verify the lastIn function.")]
		public function firstIn () : void
		{
			var a : Array;
			
			a = [];
			assertThat( abe.com.mon.utils.arrays.firstIn(a), org.hamcrest.object.nullValue() );
			
			a = ["foo"];
			assertThat( abe.com.mon.utils.arrays.firstIn(a), org.hamcrest.object.equalTo( "foo" ) );
			
			a = [1,true,{},"bar",null,"foo"];
			assertThat( abe.com.mon.utils.arrays.firstIn(a), org.hamcrest.object.equalTo( 1 ) );
		}
	}
}
