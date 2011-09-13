/**
 * @license
 */
package abe.com.edia.text.layouts 
{
    import abe.com.edia.text.AdvancedTextField;
    import abe.com.edia.text.core.Char;
    import abe.com.mon.core.Clearable;
    import abe.com.mon.geom.Dimension;
    import abe.com.mon.geom.Range;

    import flash.text.TextLineMetrics;
	/**
	 * @author Cédric Néhémie
	 */
	public interface CharLayout extends Clearable
	{
		function layout( letters : Vector.<Char> ) : void;
		
		function get numLines() : uint;
		
		function get chars () : Vector.<Char>;
		
		function get wordWrap () : Boolean;		function set wordWrap ( b : Boolean ) : void;
		
		function get multiline () : Boolean;
		function set multiline ( b : Boolean ) : void;
		
		function get autoSize () : String;		function set autoSize ( s : String ) : void;
		
		function get textSize () : Dimension;
		
		function set owner ( o : AdvancedTextField ) : void;		function get owner (): AdvancedTextField;

		function getMetrics (r : Range) : TextLineMetrics;
		function getLineAt( i : uint ) : Array;		function getLineIndexAt( y : Number ) : int;
	}
}
