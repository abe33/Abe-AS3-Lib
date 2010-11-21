package aesia.com.ponents.tabs 
{
	import aesia.com.ponents.core.Component;

	/**
	 * @author Cédric Néhémie
	 */
	public interface Tab extends Component 
	{
		function get content () : Component ;	
		function set content (content : Component) : void;
		
		function get parentTabbedPane () : TabbedPane;	
		function set parentTabbedPane (parentTabbedPane : TabbedPane) : void;

		function get placement () : String;		
		function set placement (placement : String) : void;
		
		function get selected () : Boolean;		function set selected ( b : Boolean ) : void;
		
		function get buttonDisplayMode () : uint;		function set buttonDisplayMode ( m : uint ) : void;
	}
}
