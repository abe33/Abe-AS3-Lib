package abe.com.ponents.factory
{
    import abe.com.patibility.lang._;
    /**
     * 
     *
     */
    public function contextMixedArgs ( ... args ) : Function 
    {
        var b : Array = args;
        if( b.length % 2 != 0 ) 
            throw new Error(_("contextMixedArgs arguments must be a pair list."))
        
        return function( context : Object ) : Array 
        {
            var a : Array = [];
            var l : uint = b.length;
            for( var i : uint = 0; i<l; i+=2 )
            {
                var k : * = b[i];
                var fromContext : Boolean = b[i+1];
                if( fromContext )
                    a.push( context[ k ] );
                else
                    a.push( k );
            }
            return a;
        };
    }
}
