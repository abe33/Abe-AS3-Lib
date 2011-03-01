package abe.com.ponents.models 
{
	import flash.events.IEventDispatcher;

	/**
	 * @author Cédric Néhémie
	 */
	public interface ListModel extends IEventDispatcher
	{
		function sort (... args):Array;
		function sortOn(fieldName:Object, options:Object = null):Array
		
		function getElementAt ( id : uint ) : *;
		function removeElement ( el : * ) : void;
		function setElementIndex ( el : *, id : uint ) : void;
		function contains ( el : * ) : Boolean;
		
		function get size () : uint;
		function get contentType () : Class;
		function set contentType (contentType : Class) : void;
	}
}