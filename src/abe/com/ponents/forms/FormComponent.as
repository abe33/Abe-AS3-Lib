package abe.com.ponents.forms 
{
	import abe.com.ponents.core.Component;

	/**
	 * @author cedric
	 */
	public interface FormComponent extends Component
	{
		function get disabledMode () : uint;
		
		function get disabledValue () : *;
		function set disabledValue ( v : * ) : void;
		
		function get value () : *;
	}
}