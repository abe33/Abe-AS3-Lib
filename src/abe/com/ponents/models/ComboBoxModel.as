package abe.com.ponents.models 
{

	/**
	 * @author Cédric Néhémie
	 */
	public interface ComboBoxModel extends ListModel
	{
		function get selectedElement () : *;		function set selectedElement ( el : * ) : void;
	}
}
