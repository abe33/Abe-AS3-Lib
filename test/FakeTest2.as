package  
{
	import org.hamcrest.assertThat;
	import org.hamcrest.object.equalTo;

	/**
	 * @author cedric
	 */
	[TestCase(description="This TestCase is here only to demonstrate how the runner handle failed and ignored tests.")]
	public class FakeTest2
	{
		[Test(description="This test is a failure !")]
		public function failure1 () : void { assertThat( "foo", equalTo("bar") ); }
		[Test(description="This test is a failure !")]
		public function failure2 () : void { assertThat( "foo", equalTo("bar") ); }
		
		[Ignore]
		[Test(description="This test was ignored.")]
		public function ignored1 () : void { assertThat( "foo", equalTo("bar") ); }
		[Ignore]
		[Test(description="This test was ignored.")]
		public function ignored2 () : void { assertThat( "foo", equalTo("bar") ); }
		
		[Test(description="This is a success !")]
		public function success1 () : void { assertThat( "foo", equalTo("foo") ); }
		[Test(description="This is a success !")]
		public function success2 () : void { assertThat( "foo", equalTo("foo") ); }
		[Test(description="This is a success !")]
		public function success3 () : void { assertThat( "foo", equalTo("foo") ); }
	}
}
