package abe.com.patibility.serialize
{
    /**
     * @author cedric
     */
    public interface Serializer
    {
        function serialize( o : * ) : String;
        
        function addTypeHandler( type : *, handler : Function ):void;
    }
}
