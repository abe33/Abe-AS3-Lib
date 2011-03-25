package abe.com.patibility.hamcrest 
{
	import org.hamcrest.number.closeTo;
	import abe.com.mon.utils.Reflection;

	import org.hamcrest.assertThat;
	import org.hamcrest.object.equalTo;

	/**
	 * @author cedric
	 */
	[TestCase(description="These tests first verify that the custom hamcrest matchers works as expected",order=1)]
	public class HamcrestTest 
	{
		[Ignore]
		[Test(description="Dead end")]
		public function ignored () : void {}
		
		[Test(description="This test must fail, for the moment")]
		public function propertiesCount1():void
		{
			assertThat( Reflection.get("{foo}"), propertiesCount(equalTo(2)) ); 
		}
		[Test(description="This test must fail, for the moment")]
		public function propertiesCount2():void
		{
			assertThat( Reflection.get("{foo}"), propertiesCount(2)); 
		}
		[Test(description="This test must fail, for the moment")]
		public function propertiesCount3():void
		{
			assertThat( Reflection.get("{foo}"), propertiesCount(closeTo(4, 1))); 
		}
	}
}
