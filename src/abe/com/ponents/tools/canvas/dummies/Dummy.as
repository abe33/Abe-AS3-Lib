package abe.com.ponents.tools.canvas.dummies
{
    import abe.com.mon.core.Allocable;
    import abe.com.mon.core.IInteractiveObject;
    import abe.com.ponents.nodes.core.CanvasElement;
    /**
     * @author cedric
     */
    public interface Dummy extends IInteractiveObject, Allocable, CanvasElement
    {
        function get selected():Boolean;
        function set selected (b:Boolean):void
    }
}
