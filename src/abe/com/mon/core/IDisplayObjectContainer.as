/**
 * @license
 */
package abe.com.mon.core 
{
	import flash.display.DisplayObject;

	/**
	 * Interface mimant la structure de la classe <code>DisplayObjectContainer</code> afin 
	 * de permettre l'accès aux méthodes de cette dernière depuis des interfaces
	 * dont les classes concrètes étendront forcement une classe graphique de Flash.
	 * 
	 * @author Cédric Néhémie
	 */
	public interface IDisplayObjectContainer extends IInteractiveObject
	{
		function get mouseChildren(): Boolean;
		function set mouseChildren(b:Boolean): void;

		function get tabChildren(): Boolean;
		function set tabChildren(b:Boolean): void;
		
		function get numChildren(): int;

		function addChild(o:DisplayObject): DisplayObject;
		function addChildAt(o:DisplayObject, i:int): DisplayObject;
		function contains(o:DisplayObject): Boolean;
		function getChildAt(i:int): DisplayObject;
		function getChildByName(n:String): DisplayObject;
		function getChildIndex(o:DisplayObject): int;
		function removeChild(o:DisplayObject): DisplayObject;
		function removeChildAt(i:int): DisplayObject;
		function setChildIndex(o:DisplayObject, i:int): void;
		function swapChildren(a:DisplayObject, b:DisplayObject): void;
		function swapChildrenAt(a:int, b:int): void;
	}
}
