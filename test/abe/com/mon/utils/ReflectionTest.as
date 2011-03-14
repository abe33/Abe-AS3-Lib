package abe.com.mon.utils 
{
	import org.hamcrest.object.nullValue;
	import abe.com.mon.geom.dm;

	import org.flexunit.Assert;
	import org.hamcrest.assertThat;
	import org.hamcrest.object.equalTo;

	import flash.geom.Point;
	/**
	 * @author cedric
	 */
	public class ReflectionTest 
	{
		[Test]  
		public function get() : void
		{ 
			// test primitives
			assertThat( Reflection.get("10"), 		equalTo(10) );   			assertThat( Reflection.get("-10"), 		equalTo(-10) );   			assertThat( Reflection.get("0.57"), 	equalTo(0.57) );   			assertThat( Reflection.get("'foo'"),	equalTo("foo") );   			assertThat( Reflection.get("true"), 	equalTo(true) );   			assertThat( Reflection.get("false"),	equalTo(false) );   			assertThat( Reflection.get("null"), 	nullValue() );   
					}
		[Test]  
		public function getClassName() : void
		{ 
			assertThat( Reflection.getClassName( Point ), 		equalTo("Point") );   			assertThat( Reflection.getClassName( Array ), 		equalTo("Array") );   			assertThat( Reflection.getClassName( 10 ), 			equalTo("int") );   			assertThat( Reflection.getClassName( 10.5 ), 		equalTo("Number") );   			assertThat( Reflection.getClassName( "foo" ), 		equalTo("String") );   			assertThat( Reflection.getClassName( dm(5, 5) ),	equalTo("Dimension") );   			assertThat( Reflection.getClassName( null ), 		equalTo("null") );   
		}
		
	}
}
