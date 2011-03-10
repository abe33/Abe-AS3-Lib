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
			Assert.assertEquals( Reflection.get("10"), 10 );   
		[Test]  
		public function getClassName() : void
		{ 
			Assert.assertEquals( Reflection.getClassName( Point 	), "Point" );   
		}
		
	}
}