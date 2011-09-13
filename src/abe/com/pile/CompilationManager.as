package abe.com.pile
{
    import abe.com.pile.units.CompilationUnit;

    import org.osflash.signals.Signal;

    import flash.utils.ByteArray;
    import flash.utils.Dictionary;
    /**
     * @author cedric
     */
    public class CompilationManager
    {
        static public const EVAL : Evaluator = new Evaluator();
        
        public var bytesLoaded : Signal;
        
        protected var _inCompilation : Boolean;
        protected var _compilationStack : Array;
        protected var _compiledUnits : Dictionary;
        
        protected var _currentUnit : CompilationUnit;

        public function CompilationManager ()
        {
            bytesLoaded = new Signal();
            _compilationStack = [];
            _compiledUnits = new Dictionary(true);
        }
        
        public function compile ( unit : CompilationUnit,
                              	  inplace : Boolean = false ) : void
	    {
            if( !_inCompilation )
            {
	            _inCompilation = true;
                _currentUnit = unit;
                
		        bytesLoaded.addOnce( unit.unitBytesLoaded );
	            
		        var bytes : ByteArray = EVAL.eval( unit.source );
		        
                ByteLoader.loadBytes( bytes, inplace );
            }
            else
            {
                _compilationStack.push( [ unit, inplace ] );
            }
	    }
        public function registerCompiledContent( o : *, k : String ) : void
        {
            _compiledUnits[ o ] = _currentUnit;
            _inCompilation = false;
        	bytesLoaded.dispatch( o, k );
            
            if( _compilationStack.length > 0 )
            {
                var args : Array = _compilationStack.shift();
                _currentUnit = args[0];
                
                compile.apply( this, args );
            }
        }
        public function wasCompiled ( o : * ) : Boolean {
            return _compiledUnits[ o ] != null;
        }

        public function get compiledUnits () : Dictionary {
            return _compiledUnits;
        }
    }
}
