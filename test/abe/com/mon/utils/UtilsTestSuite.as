package abe.com.mon.utils 
{
	import abe.com.mon.utils.arrays.ArrayTest;

	[Suite(description="abe.com.mon.utils TestSuite",order=2)]
	[RunWith("org.flexunit.runners.Suite")]	
	public class UtilsTestSuite 
	{
		public var arrays : ArrayTest;
		public var colors : ColorTest;		public var reflection : ReflectionTest;
		public var strings : StringUtilsTest;
	}
}
