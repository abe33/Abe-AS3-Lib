package abe.com.pile
{
    /**
     * @author cedric
     */
    public class CompiledEntity
    {
        public var entity : *;
        public var key : String;
        public var source : String;
        public var type : String;
        public var compiledSource : String;

        public function CompiledEntity ( entity : *, 
        								 key : String, 
                                         type : String,
                                         source : String, 
                                         compiledSource : String )
        {
            this.entity = entity;
            this.key = key;
            this.source = source;
            this.type = type;
            this.compiledSource = compiledSource;
        }
    }
}
