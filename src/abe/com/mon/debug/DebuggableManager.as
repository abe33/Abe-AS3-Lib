package abe.com.mon.debug
{
	import abe.com.mon.core.Debuggable;
	import org.osflash.signals.Signal;
	import flash.utils.Dictionary;
    /**
     * @author cedric
     */
    public class DebuggableManager
    {
        protected var _classes : Array;
        protected var _options : Dictionary;
        protected var _activeClasses : Dictionary;
        protected var _instances : Dictionary;
        
        public var classDebugActivated : Signal;
        public var classDebugDeactivated : Signal;
        
        public var classAdded : Signal;
        public var classRemoved : Signal;
        
        public var instanceAdded : Signal;
        public var instanceRemoved : Signal;
        
        public function DebuggableManager ()
        {
            _classes = [];
            _activeClasses = new Dictionary(true);
            _options = new Dictionary(true);
            _instances = new Dictionary(true);
            
            classDebugActivated = new Signal();
            classDebugDeactivated = new Signal();
            instanceAdded = new Signal();
            instanceRemoved = new Signal();
            classAdded = new Signal();
            classRemoved = new Signal();
        }
        public function get classes () : Array { return _classes.concat(); }
        public function get activeClasses () : Array 
        { 
            var a : Array = [];
            for each( var cl : Class in _classes)
            	if( isClassDebugActive( cl ) )
                	a.push( cl );
            return a; 
        }
        public function getClassOptions ( cl : Class ) : Object
        {
            if( containsClass(cl) )
            	return _options[ cl ];
            else
            	return null;
        }
		public function registerClass( cl : Class, options : Object = null ):void
        {
            if( !containsClass(cl) )
            {
                _classes.push( cl );
                _activeClasses[ cl ] = false;
                _options[ cl ] = options ? options : {};
                _instances[ cl ] = [];
                
                classAdded.dispatch( this, cl );
            }
        }
        public function removeClass ( cl : Class ) : void
        {
            if( containsClass( cl ) )
            {
                var index : int = findClass(cl);
                _classes.splice(index,1);
                delete _activeClasses[cl];
                delete _options[cl];
                delete _instances[cl];
                
                classRemoved.dispatch( this, cl );
            }
        }
        public function containsClass( cl : Class ) : Boolean
        {
            return findClass( cl ) != -1;
        }
        public function findClass( cl : Class ):int
        {
            return _classes.indexOf( cl );
        }
        public function activateClassDebug( cl : Class ) : void
        {
            if( containsClass( cl ) )
            {
	            _activeClasses[ cl ] = true;
	            classDebugActivated.dispatch( this, cl );
                for each( var d : Debuggable in _instances[ cl ] )
                	d.debugActivated = true;
            }
        }
        public function deactivateClassDebug( cl : Class ) : void
        {
            if( containsClass( cl ) )
            {
	            _activeClasses[ cl ] = false;
	            classDebugDeactivated.dispatch( this, cl );
                for each( var d : Debuggable in _instances[ cl ] )
                	d.debugActivated = false;
            }
        }
        public function isClassDebugActive( cl : Class ) : Boolean
        {
            if( containsClass( cl ) )
            	return _activeClasses[ cl ];
            else
            	return false;
        }
        
        public function getInstancesFor( cl : Class ):Array
        {
            if( containsClass(cl) )
            	return _instances[ cl ] as Array; 
            else 
            	return null;
        }
        public function registerInstance( cl : Class, instance : * ) : void
        {
            if(!containsInstance(cl, instance))
            {
            	_instances[ cl ].push( instance );
            
	            if( instance is Debuggable )
	              ( instance as Debuggable ).debugActivated = isClassDebugActive(cl);
	            
	            instanceAdded.dispatch( this, cl, instance );
            }
        }
        public function findInstance( cl : Class, instance : * ) : int
        {
            return _instances[ cl ].indexOf( instance );
        }
        public function containsInstance( cl : Class, instance : * ) : Boolean
        {
            return findInstance( cl, instance ) != -1;
        }
        public function removeInstance( cl : Class, instance : * ):void
        {
            if( containsInstance(cl, instance) )
            {
            	_instances[cl].splice( findInstance(cl, instance), 1 );

            	instanceRemoved.dispatch ( this, cl, instance );
            }
        }
    }
}
