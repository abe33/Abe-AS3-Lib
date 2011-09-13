package abe.com.ponents.monitors.recorders 
{
    import abe.com.mon.geom.Range;
    import abe.com.ponents.monitors.GraphCurveSettings;
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
