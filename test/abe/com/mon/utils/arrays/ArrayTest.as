package abe.com.mon.utils.arrays 
{
	import org.hamcrest.assertThat;
	import org.hamcrest.object.equalTo;
	import org.hamcrest.object.nullValue;

	/**
	 * @author cedric
	 */
	[TestCase(description="Verify that all the array closures works as expected.", order=2)]
	public class ArrayTest 
	{
		
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
