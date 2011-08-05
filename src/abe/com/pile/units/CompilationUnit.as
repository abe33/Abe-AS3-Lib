package abe.com.pile.units
{
    import abe.com.mon.core.Cloneable;
    import org.osflash.signals.Signal;
    /**
     * @author cedric
     */
    public interface CompilationUnit extends Cloneable
    {
        function get source() : String;
        function get outputSource() : String;
        
        function get unit():*;
        function get key():String;
        
        function get unitCompiled():Signal;
        
        function unitBytesLoaded( u : *, k : String ):void;
    }
}
