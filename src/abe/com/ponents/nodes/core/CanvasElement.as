package abe.com.ponents.nodes.core 
{
    import flash.display.DisplayObject;
	/**
	 * @author cedric
	 */
	public interface CanvasElement 
	{
		function get isMovable() : Boolean;
        function get isSelectable():Boolean;
        
        function get hasSubObjects ():Boolean;
        function isSubObject( o : DisplayObject ) : Boolean;
        
        function remove():void;
	}
}
