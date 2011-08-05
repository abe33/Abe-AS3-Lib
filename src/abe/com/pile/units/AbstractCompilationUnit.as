package abe.com.pile.units
{
    import abe.com.mon.core.FormMetaProvider;

    import org.osflash.signals.Signal;

    /**
     * @author cedric
     */
    public class AbstractCompilationUnit implements CompilationUnit, FormMetaProvider
    {
        protected var _unitCompiled : Signal;
        protected var _extraImports : String;
        protected var _unit : *;
        protected var _key : String;

        public function AbstractCompilationUnit ( extraImports : String = "" )
        {
            _unitCompiled = new Signal();
            _extraImports = extraImports;
        }
        public function get unit () : * { return _unit; }
        
        [Form(type="string")]
        public function get key () : String { return _key; }
        public function set key ( key : String ) : void { _key = key; }
        
        [Form(type="text")]
        public function get extraImports () : String { return _extraImports; }
        public function set extraImports ( extraImports : String ) : void { _extraImports = extraImports; }
        
        public function get source () : String { return ""; }
        public function get outputSource () : String { return ""; }


        public function get unitCompiled () : Signal { return _unitCompiled; }

        public function unitBytesLoaded ( u : *, k : String ) : void
        {
            _unit = u;
            _key = k;
            _unitCompiled.dispatch ( this );
        }
        public function clone () : * { return false; }
    }
}
