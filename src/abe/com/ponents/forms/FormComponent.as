package abe.com.ponents.forms 
{
	import abe.com.ponents.core.Component;
	
	import org.osflash.signals.Signal;
	/**
	 * @author cedric
	 */
	public interface FormComponent extends Component
	{
		function get disabledMode () : uint;
		function set disabledMode ( b : uint ) : void;
		
		function get disabledValue () : *;
		function set disabledValue ( v : * ) : void;
		
		function get value () : *;
		function set value ( v : * ) : void;
		
		function get dataChanged () : Signal;
	}
}
