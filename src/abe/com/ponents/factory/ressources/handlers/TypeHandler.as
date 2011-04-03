package abe.com.ponents.factory.ressources.handlers 
{
	import abe.com.ponents.core.Component;
	/**
	 * @author cedric
	 */
	public interface TypeHandler 
	{
		function getPreview ( o : * ) : Component;
		function getDescription ( o : * ) : String;
		function getIconHandler () : Function;
	}
}
