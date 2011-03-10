package  
{
	import abe.com.mon.geom.GeomTestSuite;
	import abe.com.mon.utils.UtilsTestSuite;

	[Suite(description="Global TestSuite")]
	[RunWith("org.flexunit.runners.Suite")]
	public class AbeLibTestSuite 
	{
		public var commonGeom : GeomTestSuite;		public var commonUtils : UtilsTestSuite;
	}
}
