package abe.com.ponents.events
{
    import org.osflash.signals.events.GenericEvent;
    
    public class ComponentSignalEvent extends GenericEvent
    {
        public var signalName : String;
        public var args : Array;
        
        public function ComponentSignalEvent( s : String, b : Boolean = true, ... args )
        {
            super( b );
            signalName = s;
            this.args = args;
        }
    }
}
