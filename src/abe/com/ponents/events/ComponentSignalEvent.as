package abe.com.ponents.events
{
    import abe.com.mon.utils.StringUtils;

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
        
        public function toString() : String {
            return StringUtils.stringify( this, {'signalName':signalName} );
        }
    }
}
