package abe.com.ponents.factory 
{
    import org.osflash.signals.Signal;
    /**
     * @author cedric
     */
    public dynamic class ComponentFactoryProcessGroup extends Array implements ComponentFactory 
    {
        public var callback : Function;
        public var id : String;
        public var processor : ComponentFactoryProcessor;
        
        protected var _buildStarted : Signal;
        protected var _buildCompleted : Signal;
        protected var _buildProgressed : Signal;
        
        public function ComponentFactoryProcessGroup ( processor : ComponentFactoryProcessor, id : String = null, callback : Function = null ) 
        {
            _buildStarted = new Signal();
            _buildCompleted = new Signal();
            _buildProgressed = new Signal();
            
            super();
            this.processor = processor;
            this.id = id;
            this.callback = callback;
        }
        public function get buildStarted () : Signal { return _buildStarted; }
        public function get buildCompleted () : Signal { return _buildCompleted; }
        public function get buildProgressed () : Signal { return _buildProgressed; }
        /**
         * @inheritDoc
         */
        public function get componentsToBuild () : uint
        {
            var l : uint = length;
            var n : uint = 0;
            for( var i : uint = 0;i<l;i++ )
            {
                if( this[i] is ComponentFactoryProcessGroup )
                    n += (this[i] as ComponentFactoryProcessGroup).componentsToBuild;
                else
                    n++;
            }
            return n; 
        }
        /**
         * @inheritDoc
         */
        public function build (c : Class, 
                               id : String = null,
                               args : * = null, 
                               kwargs : * = null, 
                               callback : Function = null, 
                               kwargsOrder : Array = null ) : ComponentFactory
        {
            push( new ComponentFactoryProcessEntry(c, id, args, kwargs, callback, kwargsOrder) );
            return this;
        }
        /**
         * @inheritDoc
         */
        public function group ( id : String = null, callback : Function = null ) : ComponentFactory
        {
            if( id && processor.hasGroup(id) )
                return processor.group(id);
            
            var g : ComponentFactoryProcessGroup = new ComponentFactoryProcessGroup( processor, id, callback );
            
            push( g );
            
            if( id )
                processor.registerGroup(id, g);
            
            return g;
        }
    }
}
