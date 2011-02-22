package abe.com.ponents.menus 
{
	import abe.com.ponents.core.Component;

	import flash.geom.Point;

	/**
	 * @author Cédric Néhémie
	 */
	public interface MenuContainer
	{
		function done () : void;
		function navigateToLeft () : void;		function navigateToRight () : void;
		function getPopupCoordinates ( menu : Menu ) : Point;
		function addMenuItem ( m : MenuItem ) : void;		function removeMenuItem ( m : MenuItem ) : void;
		
		function isMenuDescendant ( c : Component ) : Boolean;
		function itemContentChange( item : MenuItem ) : void;
	}
}
