/**
 * @license
 */
package abe.com.edia.text.core
{
	import flash.text.TextFormat;

	/**
	 * @author Cédric Néhémie
	 */
	public interface Char 
	{	
		function get x () : Number;
		function set x ( n : Number ) : void;

		function get y () : Number;
		function set y ( n : Number ) : void;
		
		function get alpha () : Number;
		function set alpha ( n : Number ) : void;

		function get text () : String;
		function set text ( s : String ) : void;

		function get format () : TextFormat;
		function set format ( tf : TextFormat ) : void;

		function get visible () : Boolean;
		function set visible ( b : Boolean ) : void;
		
		function get filters () : Array;
		function set filters ( b : Array ) : void;

		function get charWidth () : Number;
		
		function get width () : Number;
		function get height () : Number;
		
		function get scaleX () : Number;
		
		function get scaleY () : Number;
		function set scaleY ( n : Number ) : void;

		function get background () : Boolean;
		function set background ( b : Boolean ) : void;
		
		function get backgroundColor () : uint;
		function set backgroundColor ( b : uint ) : void;		
	}
}