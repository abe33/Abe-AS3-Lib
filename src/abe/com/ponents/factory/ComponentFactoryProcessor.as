package abe.com.ponents.factory 
{
    import abe.com.mon.logs.Log;
    import abe.com.mon.utils.Reflection;
    import abe.com.motion.Impulse;
    import abe.com.patibility.lang._;
    import abe.com.patibility.lang._$;
    import abe.com.ponents.core.Component;
    import abe.com.ponents.utils.Inspect;

    import org.osflash.signals.Signal;
    /**
     * La classe <code>ComponentFactoryProcessor</code> est utilisé afin de rendre asynchrone
     * le processus de construction des composants.
     * 
     * @author Cédric Néhémie
     */
    public class ComponentFactoryProcessor implements ComponentFactory
    {
        protected var _buildStack : Array;
        protected var _processStack : Array;
        protected var _currentStack : Array;
        protected var _processingContext : Object;
        protected var _groups : Object;
        protected var _currentTotal : uint;
        protected var _currentProcessed : uint;
        
        protected var _buildStarted : Signal;
        protected var _buildCompleted : Signal;
        protected var _buildProgressed : Signal;
        
        public function ComponentFactoryProcessor() 
        {
            _buildStarted = new Signal();
            _buildCompleted = new Signal();
            _buildProgressed = new Signal();
        
            _buildStack = [];
            _processStack = [];
            _processingContext = {};
            _groups = {root:this};
        }
        
        public function get buildStarted () : Signal { return _buildStarted; }
        public function get buildCompleted () : Signal { return _buildCompleted; }
        public function get buildProgressed () : Signal { return _buildProgressed; }
        
        /**
         * @inheritDoc
         */
        public function get componentsToBuild () : uint 
        { 
            var l : uint = _buildStack.length;
            var n : uint = 0;
            for( var i : uint = 0;i < l;i++ )
            {
                if( _buildStack[i] is ComponentFactoryProcessGroup )
                    n += (_buildStack[i] as ComponentFactoryProcessGroup).componentsToBuild;
                else
                    n++;
            }
            return n; 
        }
        /**
         * @inheritDoc
         */
        public function group ( id : String = null, callback : Function = null ) : ComponentFactory
        {
            if( id && hasGroup(id) )
                return _groups[id];
            
            var g : ComponentFactoryProcessGroup = new ComponentFactoryProcessGroup( this, id, callback );
            
            _buildStack.push( g );
            
            if( id )
                registerGroup( id, g );
            
            return g;
        }
        /**
         * @inheritDoc
         */
        public function build( c : Class, 
                               id : String = null,
                               args : * = null, 
                               kwargs : * = null, 
                               callback : Function = null, 
                               kwargsOrder : Array = null ) : ComponentFactory
        {
            _buildStack.push( new ComponentFactoryProcessEntry(c, id, args, kwargs, callback, kwargsOrder) );
            
            return this;
        }
        public function hasGroup( id : String ) : Boolean
        {
            return _groups.hasOwnProperty(id);
        }
        public function registerGroup( id : String, g : ComponentFactoryProcessGroup ) : void
        {
            _groups[id] = g;
        }
        public function process() : void 
        {
            _currentProcessed = 0;
            _currentTotal = componentsToBuild;
            _processStack.push( _buildStack );
            _currentStack = _buildStack;
            
            Impulse.register(tick);
            fireBuildStartSignal();
        }
        protected function processStack( stack : Array ):void
        {
            _processStack.push( stack );
            _currentStack = stack;
        }
        protected function processKeywordArgs ( o : *, k : String, kwargs : Object ):void
        {
            try
            {
                if( o.hasOwnProperty( k ) && kwargs.hasOwnProperty( k ) )
                {
                    var kwarg : * = kwargs[k];
                    var val : * = kwarg is Function ? kwarg( o, k, _processingContext) : kwarg;
                    
                    if ( o[k] is Function )
                       ( o[k] as Function ).apply( null, val );
                    else
                        o[k] = val;
                }
                else
                {
                    /*FDT_IGNORE*/ CONFIG::DEBUG { /*FDT_IGNORE*/
                        Log.warn(_$(_("Both the target object $0 and the kwargs object must have a property named '$1'"), o, k ) );
                    /*FDT_IGNORE*/ } /*FDT_IGNORE*/
                }
            }
            catch( e : Error )
            {
                /*FDT_IGNORE*/ CONFIG::DEBUG { /*FDT_IGNORE*/
                    Log.error(_$(_("An unexpected error occured while processing the keyword argument $0 for $1 with kwargs:\n$2\n$3"),k,o,Inspect.inspect(kwargs),e.getStackTrace()),true);
                /*FDT_IGNORE*/ } /*FDT_IGNORE*/
            }
            delete kwargs[k];
        }
        protected function processEntry ( entry : ComponentFactoryProcessEntry ) : void 
        {
            try
            {
                var id : String = entry.id;
                var clazz : Class = entry.clazz;
                var args : * = entry.args is Function ? entry.args( _processingContext ) : entry.args;
                var kwargs : *;
                var kwargsOrder : Array = entry.kwargsOrder;
                var callback : Function = entry.callback;
                
                if( !clazz )
                    throw new ArgumentError( _("The clazz argument must be a valid Class.") );
                
                if( args && !(args is Array) )
                    throw new ArgumentError( _("The args argument should be either an Array, a function which return an Array or null.") );

                var o : * = Reflection.buildInstance( clazz, args );
                
                kwargs = entry.kwargs is Function ? entry.kwargs( o, _processingContext ) : entry.kwargs;
                
                if( kwargs && typeof kwargs != "object" )
                    throw new ArgumentError( _("The kwargs argument should be either an Object, a function which return an Object or null.") );
                
                if( id )
                {
                    if( !exist( id ) )
                    {
                        _processingContext[ id ] = o;
                        if( o is Component )
                        {
                          ( o as Component ).id = id;
                          ( o as Component ).name = id;
                        }
                    }
                    else
                    {
                        /*FDT_IGNORE*/ CONFIG::DEBUG { /*FDT_IGNORE*/
                            Log.warn( _$(_("The id '$0' is already defined in the current context. The corresponding component will not receive any id"), id ) );
                        /*FDT_IGNORE*/ } /*FDT_IGNORE*/
                    }
                }
                if( kwargs )
                {
                    if( kwargs["id"] )
                    {
                        /*FDT_IGNORE*/ CONFIG::DEBUG { /*FDT_IGNORE*/
                            Log.warn( _("The 'id' keyword is reserved by the factory, it will be ignored."));
                        /*FDT_IGNORE*/ } /*FDT_IGNORE*/
                        delete kwargs["id"];
                    }
                    var k : String;
                    if( kwargsOrder )
                    {
                        for( var i : uint = 0; i < kwargsOrder.length; i++ )
                        {
                            k = kwargsOrder[i];
                            processKeywordArgs(o, k, kwargs);
                        }
                    }
                    for( k in kwargs )
                        processKeywordArgs(o, k, kwargs);
                }
                if( callback != null )
                    callback( o, _processingContext );
                
                _currentProcessed++;
                fireBuildProgressSignal();
                
                /*FDT_IGNORE*/ CONFIG::DEBUG { /*FDT_IGNORE*/
                    Log.info( _$( _( "Build complete for $0" ), entry ), true );
                /*FDT_IGNORE*/ } /*FDT_IGNORE*/
            }
            catch( e : Error )
            {
                /*FDT_IGNORE*/ CONFIG::DEBUG { /*FDT_IGNORE*/
                    Log.error( _$( _("Unable to build the following entry : \n$0\n\n\n$1\n$2"), 
                                     entry, 
                                     e.getStackTrace(), 
                                     Inspect.inspect( _processingContext ) ), true );
                /*FDT_IGNORE*/ } /*FDT_IGNORE*/
            }
        }
        protected function exist ( id : String ) : Boolean 
        {
            return _processingContext.hasOwnProperty(id);
        }
        protected function tick ( bias : Number, biasInSeconds : Number, currentTime : Number ) : void
        {
            if( _currentStack.length == 0 )
            {
                if( _processStack.length > 1 )
                {
                    if( _currentStack is ComponentFactoryProcessGroup )
                    {
                          var g : ComponentFactoryProcessGroup = _currentStack as ComponentFactoryProcessGroup;
                          if( g.callback != null )
                              g.callback( _processingContext );
                    }
                    _processStack.pop();
                    _currentStack = _processStack[_processStack.length-1];
                }
                else
                {
                    fireBuildCompleteSignal();
                    Impulse.unregister(tick);
                    return;
                }
            }
            
            var build : * = _currentStack.shift();
            
            if( build is ComponentFactoryProcessEntry )
                processEntry ( build as ComponentFactoryProcessEntry );
            else if( build is Array )
                processStack( build as Array );
        }
        public function fireBuildStartSignal():void
        {
            _buildStarted.dispatch( this, 0, _currentTotal );
        }
        public function fireBuildCompleteSignal():void
        {
            _buildCompleted.dispatch( this, _currentTotal, _currentTotal );
        }
        public function fireBuildProgressSignal():void
        {
            _buildProgressed.dispatch( this, _currentProcessed, _currentTotal );
        }
    }
}
