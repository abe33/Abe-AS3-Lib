package abe.com.ponents.ressources.handlers 
{
    import abe.com.ponents.core.Component;
	/**
	 * @author cedric
	 */
	public interface TypeHandler 
	{
		function get title():String;
		function getPreview ( o : * ) : Component;
		function getDescription ( o : * ) : String;
		function getIconHandler () : Function;
	}
}
