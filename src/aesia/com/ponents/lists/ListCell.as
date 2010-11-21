package aesia.com.ponents.lists 
{
	import aesia.com.mon.core.Allocable;
	import aesia.com.ponents.core.Component;
	import aesia.com.ponents.core.edit.Editable;

	/**
	 * @author Cédric Néhémie
	 */
	public interface ListCell extends Component, Editable, Allocable
	{
		function get selected () : Boolean;
		function set selected( b : Boolean ) : void;
 		
		function set owner ( l : List ) : void;
		function get owner () : List;
		
		function set value ( val : * ) : void;
		function get value () : *;
		
		function set index ( id : uint ) : void;
		function get index () : uint;
	}
}
