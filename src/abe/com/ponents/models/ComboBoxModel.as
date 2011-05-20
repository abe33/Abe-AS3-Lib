package abe.com.ponents.models 
{
    import org.osflash.signals.Signal;
	/**
	 * @author Cédric Néhémie
	 */
	public interface ComboBoxModel extends ListModel
	{
		function get selectedElement () : *;
		function set selectedElement ( el : * ) : void;
		
		function get selectionChanged () : Signal;
	}
}
