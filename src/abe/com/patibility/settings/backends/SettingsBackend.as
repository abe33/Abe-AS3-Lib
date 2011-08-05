package abe.com.patibility.settings.backends 
{
    import org.osflash.signals.Signal;
    /**
     * @author cedric
     */
    public interface SettingsBackend
    {
        function init () : void;
        function clear () : void;
        function sync () : void;
        function reset () : void;
        
        function get ( o : *, p : String ) : *;
        function set ( o : *, p : String, v : * ) : Boolean;
        
        function getQuery( o : *, p : String ) : String;
        function setQuery( o : *, p : String, v : * ) : String;
        
        function get settingsList () : Array;
        
        function get initialized () : Signal;
        function get cleared () : Signal;
        function get synchronized () : Signal;
        function get resetted () : Signal;
        function get loadingProgressed (): Signal;
        
        function getWithQuery (s : String) : *;
        function setWithQuery (s : String, v : * ) : Boolean;
    }
}
