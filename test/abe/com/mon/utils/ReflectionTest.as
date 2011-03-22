package abe.com.mon.utils 
{
	import abe.com.patibility.hamcrest.equalToObject;
	import abe.com.mon.geom.dm;

	import org.hamcrest.assertThat;
	import org.hamcrest.collection.array;
	import org.hamcrest.core.allOf;
	import org.hamcrest.core.describedAs;
	import org.hamcrest.core.not;
	import org.hamcrest.object.equalTo;
	import org.hamcrest.object.hasProperties;
	import org.hamcrest.object.instanceOf;
	import org.hamcrest.object.notNullValue;
	import org.hamcrest.object.nullValue;

	import flash.geom.Point;
	/**
	 * @author cedric
	 */
	public class ReflectionTest 
	{
		static public function testFunction( ...args ) : uint 
		{
			return args.length;
		}
		
		[Test(description="This test verify that all the code parsing of the Reflection.get() method works as expected")]  
		public function get() : void
		{ 
			Reflection.debug = true;			
			// test primitives
			assertThat( Reflection.get("10"), 		equalTo(10) );   
			assertThat( Reflection.get("0xff"), 	equalTo(255) );   			assertThat( Reflection.get("-10"), 		equalTo(-10) );   			assertThat( Reflection.get("0.57"), 	equalTo(0.57) );   			assertThat( Reflection.get("'foo'"),	equalTo("foo") );   			assertThat( Reflection.get("\"foo\""),	equalTo("foo") );   			assertThat( Reflection.get("true"), 	equalTo(true) );   			assertThat( Reflection.get("false"),	equalTo(false) );   			assertThat( Reflection.get("null"), 	nullValue() );			
			// cases that we must assert that they return strings due to missing definition or invalid syntax
			assertThat( Reflection.get("new some.unknown::Class()"), allOf( instanceOf( String ), equalTo("new some.unknown::Class()") ) );
			assertThat( Reflection.get("Array..prototype"), allOf( instanceOf( String ), equalTo("Array..prototype") ) );						// arrays
			//FIXME: Find a way to deal with function args in a way that doesn't imply that single array become a double array 
			assertThat( Reflection.get("[1,2,3,4]"), describedAs( "Reflection.get(%0) should return [<1>,<2>,<3>,<4>]", 
													 array(1,2,3,4), 
													 "[1,2,3,4]" ) ); 
			assertThat( Reflection.get("(1,2,3,4)"), describedAs( "Reflection.get(%0) should return [<1>,<2>,<3>,<4>]", 
													 array(1,2,3,4), 
													 "(1,2,3,4)" ) ); 
			assertThat( Reflection.get("1,2,3,4"), 	 describedAs( "Reflection.get(%0) should return [<1>,<2>,<3>,<4>]", 
													 array(1,2,3,4), 
													 "1,2,3,4" ) ); 			
			assertThat( Reflection.get("[1,2,3,4],true"), 	 describedAs( "Reflection.get(%0) should return [[<1>,<2>,<3>,<4>],<true>]", 
													 array(array(1,2,3,4),true), 
													 "[1,2,3,4],true" ) ); 

			assertThat( Reflection.get("[]"),	 	 describedAs( "Reflection.get(%0) should return []", array(), "[]" ) ); 
			assertThat( Reflection.get("()"),	 	 describedAs( "Reflection.get(%0) should return []", array(), "()" ) ); 
						// function calls
			assertThat( Reflection.get("abe.com.mon.utils::ReflectionTest.testFunction(0)"), equalTo( 1 ) ); 
			assertThat( Reflection.get("abe.com.mon.utils::ReflectionTest.testFunction(1)"), equalTo( 1 ) ); 			assertThat( Reflection.get("abe.com.mon.utils::ReflectionTest.testFunction([0,1,2])"), equalTo( 1 ) ); 			assertThat( Reflection.get("abe.com.mon.utils::ReflectionTest.testFunction(0,1,2)"), equalTo( 3 ) ); 					// dot syntax and native shortcuts			assertThat( Reflection.get("color(Red)"), Color.Red );
			assertThat( Reflection.get("abe.com.mon.utils::Color.Red"), Color.Red );
			assertThat( Reflection.get("abe.com.mon.utils::Color.Red.alphaClone(0x55)"), equalToObject( Color.Red.alphaClone(0x55)) );
			assertThat( Reflection.get("Array.inexistantProperty"), nullValue() );			
			// objects			assertThat( Reflection.get("{'foo':15,'bar':'foobar'}"), describedAs( "Reflection.get(%0) should return an object", 
																	 allOf( notNullValue(), 
																	 		not( instanceOf( String ) ), 
																	 		hasProperties({'foo':15,'bar':'foobar'}) ), 
																	 "{'foo':15,'bar':'foobar'}" ) ); 
			
			assertThat( Reflection.get("{}"),	 	 not( instanceOf(String ) ) ); 

			Reflection.debug = false;
		}

		[Test]  
		public function getClassName() : void
		{ 
			assertThat( Reflection.getClassName( Point ), 		equalTo("Point") );   			assertThat( Reflection.getClassName( Array ), 		equalTo("Array") );   			assertThat( Reflection.getClassName( 10 ), 			equalTo("int") );   			assertThat( Reflection.getClassName( 10.5 ), 		equalTo("Number") );   			assertThat( Reflection.getClassName( "foo" ), 		equalTo("String") );   			assertThat( Reflection.getClassName( dm(5, 5) ),	equalTo("Dimension") );   			assertThat( Reflection.getClassName( null ), 		equalTo("null") );   
		}
		
	}
}
