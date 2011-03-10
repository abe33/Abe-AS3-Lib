package abe.com.mon.utils 
{
	import abe.com.mon.geom.dm;

	import org.flexunit.Assert;

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
			Assert.assertEquals( Reflection.get("10"), 10 );   			Assert.assertEquals( Reflection.get("-10"), -10 );   			Assert.assertEquals( Reflection.get("0.57"), 0.57 );   			Assert.assertEquals( Reflection.get("'foo'"), "foo" );   			Assert.assertEquals( Reflection.get("true"), true );   			Assert.assertEquals( Reflection.get("false"), false );   			Assert.assertEquals( Reflection.get("null"), null );   		}
		[Test]  
		public function getClassName() : void
		{ 
			Assert.assertEquals( Reflection.getClassName( Point 	), "Point" );   			Assert.assertEquals( Reflection.getClassName( Array 	), "Array" );   			Assert.assertEquals( Reflection.getClassName( 10 		), "int" );   			Assert.assertEquals( Reflection.getClassName( 10.5 		), "Number" );   			Assert.assertEquals( Reflection.getClassName( "foo" 	), "String" );   			Assert.assertEquals( Reflection.getClassName( dm(5, 5) 	), "Dimension" );   			Assert.assertEquals( Reflection.getClassName( null	 	), "null" );   
		}
		
	}
}
