package abe.com.pile.units
{
    import abe.com.mon.core.FormMetaProvider;
    import abe.com.patibility.lang._$;

    /**
     * @author cedric
     */
    public class FunctionCompilationUnit extends AbstractCompilationUnit implements FormMetaProvider
    {
        protected var _signature : String;
        protected var _content : String;
        
        public function FunctionCompilationUnit ( name : String = "funcName",
        										  signature : String = "function ${functionName}():void", 
                                                  content : String = "",
                								  extraImports : String = "" )
        {
            super ( extraImports );
            _key = name;
            _signature = signature;
            _content = content;
        }
        [Form(type="string")]
        public function get signature () : String { return _signature; }
        public function set signature ( signature : String ) : void { _signature = signature; }

        [Form(type="text")]
        public function get content () : String { return _content; }
        public function set content ( content : String ) : void { _content = content; }

        override public function get source () : String 
       	{
            var src : String = outputSource;
            return  _$( "import abe.com.pile.*;\n\
${imports}\n\
${source}\n\
CompilationManagerInstance.registerCompiledContent( ${name}, '${name}' );",
					{
                        'source':src,
                        'name':_key,
                        'imports':_extraImports
                    } );
        }
        override public function get outputSource () : String {
            return _$( "$0\n{\n\t$1\n}",
                        _$( _signature, {'functionName':_key}),
                        _content.replace(/\n/g, "\n\t") );
        }
		override public function clone () : * { return new  FunctionCompilationUnit(_key, _signature, _content, _extraImports ); }
        
        public function asAnonymFunction() : String
        {
            return outputSource.replace ( _key, "" );
        }
    }
}
