
package abe.com.mon.utils
{
    /**
     * @author cedric
     */
    public class ObjectPool
    {
        private var instances : Array;
        private var count : int;
        private var counter : int;
        public function ObjectPool ( type : Class, count : int = 20 )
        {
            instances = new Array( count );
            for( var i : int = 0; i < count; i++ )
            	instances[i] = new type();
            this.count = count;
            this.counter = -1;
        }
        public function get():*
        {
            if( counter+1 >= count )	
            	counter = -1;
            
            return instances[++counter];
        }
    }
}
