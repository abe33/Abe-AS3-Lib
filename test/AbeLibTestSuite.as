package  
{
	import abe.com.mon.closures.ClosuresTest;
	import abe.com.mon.colors.ColorsTestSuite;
	import abe.com.mon.geom.GeomTestSuite;
	import abe.com.mon.utils.UtilsTestSuite;
	import abe.com.patibility.hamcrest.HamcrestTest;
	import abe.com.patibility.humanize.HumanizeTest;

	[Suite(description="Reference all the test suites and solitary test cases of the library.")]
	[RunWith("org.flexunit.runners.Suite")]
	public class AbeLibTestSuite 
	{
		public var commonColor : ColorsTestSuite;		public var commonGeom : GeomTestSuite;		public var commonUtils : UtilsTestSuite;
		public var commonClosures : ClosuresTest;				public var humanize : HumanizeTest;		public var hamcrest : HamcrestTest;
		
		//public var fake : FakeSuite;
	}
}
