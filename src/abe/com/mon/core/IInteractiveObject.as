/**
 * @license
 */
package abe.com.mon.core 
{

	/**
	 * Interface mimant la structure de la classe <code>InteractiveObject</code> afin 
	 * de permettre l'accès aux méthodes de cette dernière depuis des interfaces
	 * dont les classes concrètes étendront forcement une classe graphique de Flash.
	 * 
	 * @author Cédric Néhémie
	 */
	public interface IInteractiveObject extends IDisplayObject
	{/*
		function get contextMenu(): NativeMenu;
		function set contextMenu(o:NativeMenu): void;
*/
		function get doubleClickEnabled(): Boolean;
		function set doubleClickEnabled(b:Boolean): void;

		function get mouseEnabled(): Boolean;
		function set mouseEnabled(b:Boolean): void;

		function get tabEnabled(): Boolean;
		function set tabEnabled(b:Boolean): void;
	}
}
