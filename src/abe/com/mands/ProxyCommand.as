package abe.com.mands 
{

    /**
     * @author Cédric Néhémie
     */
    public class ProxyCommand extends AbstractCommand 
    {
        private var fn : Function;
        private var args : Array;
        
        public var passArguments : Boolean;
        
        public function ProxyCommand ( fn : Function, passArgs : Boolean = false, ... args )
        {
            super();
            this.fn = fn;
            this.args = args;
            this.passArguments = passArgs;
        }

        override public function execute( ... a ) : void
        {
            if( passArguments )
                fn.apply( null, a.concat( args ) );
            else
                fn.apply( null, args );
            
            commandEnded.dispatch( this );
        }
    }
}
