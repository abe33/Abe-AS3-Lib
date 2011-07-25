package abe.com.ponents.factory 
{
    import org.osflash.signals.Signal;
    /**
     * @author cedric
     */
    public interface EntryPoint
    {
        function init( preload : ComponentFactoryPreload ) : void;
        function get buildSetted () : Signal;
    }
}
