package abe.com.mon.core
{
    /**
     * @author cedric
     */
    public interface Debuggable
    {
        /*FDT_IGNORE*/CONFIG::DEBUG {/*FDT_IGNORE*/
	        function optionsChanged( options : Object ):void;
	        function optionChanged( option : String, value : * ):void;
	        
	        function set debugActivated ( b : Boolean ) : void;
            
        /*FDT_IGNORE*/}/*FDT_IGNORE*/
    }
}
