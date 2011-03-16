package abe.com.mon.utils 
{
	import org.hamcrest.object.instanceOf;
	import abe.com.mon.geom.dm;

	import org.hamcrest.assertThat;
	import org.hamcrest.collection.array;
	import org.hamcrest.core.describedAs;
	import org.hamcrest.core.isA;
	import org.hamcrest.core.not;
	import org.hamcrest.object.equalTo;
	import org.hamcrest.object.nullValue;

	import flash.geom.Point;
	/**
	 * @author cedric
	 */
	public class ReflectionTest 
	{
		[Test(description="This test verify that all the code parsing of the Reflection.get() method works as expected")]  
		public function get() : void
		{ 
			// test primitives
			assertThat( Reflection.get("10"), 		equalTo(10) );   			assertThat( Reflection.get("-10"), 		equalTo(-10) );   			assertThat( Reflection.get("0.57"), 	equalTo(0.57) );   			assertThat( Reflection.get("'foo'"),	equalTo("foo") );   			assertThat( Reflection.get("\"foo\""),	equalTo("foo") );   			assertThat( Reflection.get("true"), 	equalTo(true) );   			assertThat( Reflection.get("false"),	equalTo(false) );   			assertThat( Reflection.get("null"), 	nullValue() );
			
			// arrays 			assertThat( Reflection.get("[1,2,3,4]"), describedAs( "Reflection.get(%0) should return [[<1>,<2>,<3>,<4>]]", array(array(1,2,3,4)), "[1,2,3,4]" ) ); 			assertThat( Reflection.get("(1,2,3,4)"), describedAs( "Reflection.get(%0) should return [[<1>,<2>,<3>,<4>]]", array(array(1,2,3,4)), "(1,2,3,4)" ) ); 			assertThat( Reflection.get("1,2,3,4"), 	 describedAs( "Reflection.get(%0) should return [<1>,<2>,<3>,<4>]", array(1,2,3,4), "1,2,3,4" ) ); 			assertThat( Reflection.get("[]"),	 	 describedAs( "Reflection.get(%0) should return []", array(), "[]" ) ); 			assertThat( Reflection.get("()"),	 	 describedAs( "Reflection.get(%0) should return []", array(), "()" ) ); 		
			// objects
			assertThat( Reflection.get("{}"),	 	 not( instanceOf(String ) ) ); 
			
			// dot syntax and native shortcuts
			assertThat( Reflection.get("color(Red)"), Color.Red );			assertThat( Reflection.get("abe.com.mon.utils::Color.Red)"), Color.Red );
		}

		[Test]  
		public function getClassName() : void
		{ 
			assertThat( Reflection.getClassName( Point ), 		equalTo("Point") );   			assertThat( Reflection.getClassName( Array ), 		equalTo("Array") );   			assertThat( Reflection.getClassName( 10 ), 			equalTo("int") );   			assertThat( Reflection.getClassName( 10.5 ), 		equalTo("Number") );   			assertThat( Reflection.getClassName( "foo" ), 		equalTo("String") );   			assertThat( Reflection.getClassName( dm(5, 5) ),	equalTo("Dimension") );   			assertThat( Reflection.getClassName( null ), 		equalTo("null") );   
		}
		
	}
}
