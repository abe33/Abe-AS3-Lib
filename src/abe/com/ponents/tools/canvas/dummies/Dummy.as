package abe.com.ponents.tools.canvas.dummies
{
    import abe.com.mon.core.Allocable;
    import abe.com.mon.core.IInteractiveObject;
    /**
     * @author cedric
     */
    public interface Dummy extends IInteractiveObject, Allocable
    {
        function get selected():Boolean;
        function set selected (b:Boolean):void
    }
}
