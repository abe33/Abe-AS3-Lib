package aesia.com.ponents.core 
{
	import aesia.com.mon.core.Identifiable;
	import aesia.com.ponents.skinning.icons.Icon;
	/**
	 * @author cedric
	 */
	public interface Dockable extends Identifiable
	{
		function get label () : *;
		
		function get icon () : Icon;
		function set icon ( icon : Icon ) : void;
		
		function get content () : Component;
	}
}