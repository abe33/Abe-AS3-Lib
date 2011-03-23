package abe.com.mon.utils 
{
	import abe.com.mon.geom.dm;
	import abe.com.patibility.hamcrest.equalToObject;

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
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
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
			// primitives
			assertThat( Reflection.get("10"), 		equalTo(10) );   
			assertThat( Reflection.get("0xff"), 	equalTo(255) );   			assertThat( Reflection.get("-10"), 		equalTo(-10) );   			assertThat( Reflection.get("0.57"), 	equalTo(0.57) );   			assertThat( Reflection.get("'foo'"),	equalTo("foo") );   			assertThat( Reflection.get("\"foo\""),	equalTo("foo") );   			assertThat( Reflection.get("true"), 	equalTo(true) );   			assertThat( Reflection.get("false"),	equalTo(false) );   			assertThat( Reflection.get("null"), 	nullValue() );			
			// cases that we must assert that they return strings due to missing definition or invalid syntax
			assertThat( Reflection.get("new some.unknown::Class()"), allOf( instanceOf( String ), equalTo("new some.unknown::Class()") ) );
			assertThat( Reflection.get("Array..prototype"), allOf( instanceOf( String ), equalTo("Array..prototype") ) );						// arrays
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
						// function calls and arguments detection
			assertThat( Reflection.get("abe.com.mon.utils::ReflectionTest.testFunction()"), equalTo( 0 ) ); 
			assertThat( Reflection.get("abe.com.mon.utils::ReflectionTest.testFunction(1)"), equalTo( 1 ) ); 			assertThat( Reflection.get("abe.com.mon.utils::ReflectionTest.testFunction([0,1,2])"), equalTo( 1 ) ); 			assertThat( Reflection.get("abe.com.mon.utils::ReflectionTest.testFunction(0,1,2)"), equalTo( 3 ) ); 			assertThat( Reflection.get("abe.com.mon.utils::ReflectionTest.testFunction([0,1,2],true)"), equalTo( 2 ) ); 					// dot syntax			assertThat( Reflection.get("abe.com.mon.utils::Color.Red"), Color.Red );
			assertThat( Reflection.get("abe.com.mon.utils::Color.Red.alphaClone(0x55)"), equalToObject( Color.Red.alphaClone(0x55)) );
			assertThat( Reflection.get("Array.inexistantProperty"), nullValue() );
			
			// native shortcuts
			assertThat( Reflection.get("color(Red)"), Color.Red );			assertThat( Reflection.get("@'../some/file.png'"), 
										describedAs( "Reflection.get(%0) should return an URLRequest pointing to '../some/file.png'", 
													 allOf( notNullValue(),
															instanceOf( URLRequest ) ), 
													 "@'../some/file.png'" ) );
			assertThat( Reflection.get("/foo/gi"), 
									   describedAs( "Reflection.get(%0) should return a RegExp equivalent to /foo/gi", 
													allOf( notNullValue(),
														   instanceOf( RegExp ) ), 
													"/foo/gi" ) );			
			// objects			assertThat( Reflection.get("{'foo':15,bar:'foobar'}"), describedAs( "Reflection.get(%0) should return an object such as {'foo':15,'bar':'foobar'}", 
																	 allOf( notNullValue(), 
																	 		not( instanceOf( String ) ), 
																	 		hasProperties({'foo':15,'bar':'foobar'}) ), 
																	 "{'foo':15,bar:'foobar'}" ) ); 
			// empty properties are set to true
			assertThat( Reflection.get("{foo}"), describedAs( "Reflection.get(%0) should return an object", 
															  allOf( not( instanceOf(String ) ), 
															  	     notNullValue(),
															  	     hasProperties({'foo':true}) ),
															  "{foo}" ) );
			assertThat( Reflection.get("{}"),	 	 not( instanceOf(String ) ) ); 
			
			// non string keys gives a dictionary
			assertThat( Reflection.get("{new flash.geom::Point(4,4):'hello'}"), describedAs( "Reflection.get(%0) should return a dictionnary", 
															  allOf( notNullValue(),
															  	     instanceOf( Dictionary ) ),
															  "{new flash.geom::Point(4,4):'hello'}" ) );
															  	     
		}

		[Test]  
		public function getClassName() : void
		{ 
			assertThat( Reflection.getClassName( Point ), 		equalTo("Point") );   			assertThat( Reflection.getClassName( Array ), 		equalTo("Array") );   			assertThat( Reflection.getClassName( 10 ), 			equalTo("int") );   			assertThat( Reflection.getClassName( 10.5 ), 		equalTo("Number") );   			assertThat( Reflection.getClassName( "foo" ), 		equalTo("String") );   			assertThat( Reflection.getClassName( dm(5, 5) ),	equalTo("Dimension") );   			assertThat( Reflection.getClassName( null ), 		equalTo("null") );   
		}
		
	}
}
