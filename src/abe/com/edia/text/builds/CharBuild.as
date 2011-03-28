/**
 * @license
 */
package abe.com.edia.text.builds 
{
	import abe.com.edia.text.AdvancedTextField;
	import abe.com.edia.text.core.Char;
	import abe.com.mon.core.Clearable;

	import flash.events.IEventDispatcher;
	import flash.text.TextFormat;

	/**
	 * @author Cédric Néhémie
	 */
	[Event(name="charsCreated", type="text.CharEvent")]
	[Event(name="charsRemoved", type="text.CharEvent")]	[Event(name="buildComplete", type="text.CharEvent")]
	[Event(name="init", type="flash.events.Event")]
	public interface CharBuild extends IEventDispatcher, Clearable
	{
		function get chars () : Vector.<Char>;		function get effects () : Object;
		
		function get embedFonts () : Boolean;
		function set embedFonts ( b : Boolean ) : void;
		
		function buildChars ( text : String ) : void;
		
		function fireCharsCreated ( chars : Object ) : void;
		function fireCharsRemoved ( chars : Object ) : void;		function fireBuildComplete  () : void;		function fireInit () : void;
		
		function get defaultTextFormat () : TextFormat;
		function set defaultTextFormat (tf : TextFormat) : void;
		
		function set owner ( o : AdvancedTextField ) : void;
		function get owner (): AdvancedTextField;
	}
}
