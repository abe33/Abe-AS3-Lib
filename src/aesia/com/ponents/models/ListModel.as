package aesia.com.ponents.models 
{
	import flash.events.IEventDispatcher;

	/**
	 * @author Cédric Néhémie
	 */
	public interface ListModel extends IEventDispatcher
	{
		function sort (... args):Array;
		function sortOn(fieldName:Object, options:Object = null):Array
		
		function getElementAt ( id : uint ) : *;		function setElementAt ( id : uint, el : * ) : void;		function addElement ( el : * ) : void;		function addElementAt ( el : *, id : uint ) : void;
		function removeElement ( el : * ) : void;		function removeElementAt ( id : uint ) : void;
		function setElementIndex ( el : *, id : uint ) : void;
		function contains ( el : * ) : Boolean;		function indexOf ( el : * ) : int;		function lastIndexOf ( el : * ) : int;		function toArray() : Array;
		
		function get size () : uint;
		function get contentType () : Class;
		function set contentType (contentType : Class) : void;
	}
}
