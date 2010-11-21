package aesia.com.ponents.monitors.recorders 
{
	import aesia.com.mon.geom.Range;
	import aesia.com.ponents.monitors.GraphCurveSettings;

	/**
	 * @author Cédric Néhémie
	 */
	public interface Recorder
	{
		function get valuesRange () : Range;
		function get curveSettings () : GraphCurveSettings;
		function get values () : Array;
		function get currentValue () : Number;
		function get unit() : String;
	}
}
