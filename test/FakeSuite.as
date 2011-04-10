package  
{
	/**
	 * @author cedric
	 */
	[Suite(description="This Suite is here only to demonstrate how the runner handle failed and ignored tests.")]
	[RunWith("org.flexunit.runners.Suite")]
	public class FakeSuite 
	{
		public var test1 : FakeTest1;		public var test2 : FakeTest2;
	}
}
