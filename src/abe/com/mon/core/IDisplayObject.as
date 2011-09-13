/**
 * @license
 */
package abe.com.mon.core 
{
    import flash.display.DisplayObject;
    import flash.display.DisplayObjectContainer;
    import flash.display.Stage;
    import flash.events.IEventDispatcher;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import flash.geom.Transform;
	/**
	 * An interface that mimic the structure of the <code>DisplayObject</code>
	 * class in order to allow an access to its members from an interface which
	 * concret classes will extends a display class from Flash.
	 * 
	 * <fr>
	 * Interface mimant la structure de la classe <code>DisplayObject</code> afin 
	 * de permettre l'accès aux méthodes de cette dernière depuis des interfaces
	 * dont les classes concrètes étendront forcement une classe graphique de Flash.
	 * </fr>
	 * @author Cédric Néhémie
	 */
	public interface IDisplayObject extends IEventDispatcher
	{
		function get name() : String;
		function set name( b : String ) : void;
		
		function get alpha(): Number;
		function set alpha(n:Number): void;
		
		function get cacheAsBitmap(): Boolean;
		function set cacheAsBitmap(b:Boolean): void;

		function get filters(): Array;
		function set filters(a:Array): void;

		function get height(): Number;
		function set height(n:Number): void;
		
		function get mask(): DisplayObject;
		function set mask(o:DisplayObject): void;

		function get mouseX(): Number;
		function get mouseY(): Number;
		
		function get opaqueBackground(): Object;
		function set opaqueBackground(o:Object): void;
		
		function get rotation(): Number;
		function set rotation(n:Number): void;
		
		function get scaleX(): Number;
		function set scaleX(n:Number): void;
		
		function get scaleY(): Number;
		function set scaleY(n:Number): void;

		function get scrollRect(): Rectangle;
		function set scrollRect(r:Rectangle): void;

		function get transform(): Transform;
		function set transform(t:Transform): void;

		function get visible(): Boolean;
		function set visible(b:Boolean): void;

		function get width(): Number;
		function set width(n:Number): void;

		function get x(): Number;
		function set x(n:Number): void;

		function get y(): Number;
		function set y(n:Number): void;
		
		function get parent(): DisplayObjectContainer;
		function get root(): DisplayObject;
		function get stage(): Stage;
		
		function getBounds(targetCoordinateSpace:DisplayObject): Rectangle;
		function getRect(targetCoordinateSpace:DisplayObject): Rectangle;
		function globalToLocal(p:Point): Point;
		function hitTestObject(o:DisplayObject): Boolean;
		function hitTestPoint(x:Number, y:Number, shapeFlag:Boolean = false): Boolean;
		function localToGlobal(p:Point): Point;
	}
}
