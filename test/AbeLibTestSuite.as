package  
{
	import abe.com.patibility.humanize.HumanizeTest;
	import abe.com.mon.geom.GeomTestSuite;
	import abe.com.mon.utils.UtilsTestSuite;

	[Suite(description="Reference all the test suites and solitary test cases of the library.")]
	[RunWith("org.flexunit.runners.Suite")]
	public class AbeLibTestSuite 
	{
		public var commonGeom : GeomTestSuite;		public var commonUtils : UtilsTestSuite;
				public var humanize : HumanizeTest;
	}
}
