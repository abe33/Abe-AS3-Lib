package abe.com.patibility.serialize
{
    import abe.com.mon.utils.Reflection;
    import abe.com.mon.utils.StringUtils;
    import abe.com.patibility.lang._$;

    import flash.utils.Dictionary;
    import flash.utils.getQualifiedClassName;

    /**
     * @author cedric
     */
    public class SourceSerializer implements Serializer
    {
        private var _typeMap : Dictionary;
        private var _constructorArgumentsMap : Object;
        private var _reflectionForm : Boolean;

        public function SourceSerializer ( reflectionForm : Boolean = false )
        {
            _typeMap = new Dictionary();
            _constructorArgumentsMap = {};
            _reflectionForm = reflectionForm;
            
            addTypeHandler( int, 		primiteHandler );
            addTypeHandler( uint, 		primiteHandler );
            addTypeHandler( Number, 	primiteHandler );
            addTypeHandler( Boolean, 	primiteHandler );
            addTypeHandler( String, 	stringHandler );
            addTypeHandler( Object, 	objectHandler );
            addTypeHandler( Array, 		arrayHandler );
            addTypeHandler( RegExp, 	regexpHandler );
            addTypeHandler( Class, 		classHandler );
            
            addTypeConstructorArgument( "flash.geom::Point", 			"x", "y" );
            addTypeConstructorArgument( "flash.geom::Rectangle", 		"x", "y", "width", "height" );
            addTypeConstructorArgument( "flash.net::URLRequest", 		"url" );
            addTypeConstructorArgument( "flash.text::TextFormat",		"font", "size", "color", "bold", 
            															"italic", "underline", "url", 
                                                                    	"target", "align", "leftMargin", 
                                                                    	"rightMargin", "indent", 
                                                                    	"leading" );        	
            addTypeConstructorArgument( "flash.geom::ColorTransform", 	"redMultiplier", "greenMultiplier", 
            															"blueMultiplier", "alphaMultiplier", 
                                                                        "redOffset", "greenOffset", "blueOffset", 
                                                                        "alphaOffset" );
            
            
//            addTypeConstructorArgument( "flash.net::URLRequest", 		"url" );
        }
        
        public function serialize ( o : * ) : String
        {
            var output : String;
            var c : Class = Reflection.getClass(o);
            var sc : String = getQualifiedClassName(o);
            
            if( o == null )
            	output = String(o);
            else if( sourcesDictionary[ o ] )
            	output = sourcesDictionary[ o ];
            else if( o is Class )
            	output = ( _typeMap[ Class ] as Function ).call( this, o, c );
            else if( _typeMap[ c ] != null  )
            	output = ( _typeMap[ c ] as Function ).call( this, o, c );
            else if( _typeMap[ sc ] != null  )
            	output = ( _typeMap[ sc ] as Function ).call( this, o, c );
            else
            {
                var constructArgs : Array;
                if( _constructorArgumentsMap[ c ] != null )
                	constructArgs = _constructorArgumentsMap[ c ];
                else if( _constructorArgumentsMap[ sc ] != null )
                	constructArgs = _constructorArgumentsMap[ sc ];
                else
                {
		            var m : XMLList = Reflection.getClassAndAncestorMeta( o, "Serialize" );
                    if( m.length() != 0)
			        	constructArgs = String( m[ m.length()-1].arg.( @key == 'constructorArgs' ).@value ).split(",");
                    else
                    	constructArgs = [];
                }
		        
		        output = _$("new $0($1)", sc, constructArgs.map(function(s:String,...args):String
		        {
                    if( StringUtils.trim(s).indexOf("...") == 0 )
                    {
                        s = StringUtils.trim(s.substr(3));
                        var a : Array = o[s];
                        var b : Array = [];
                        for each( var e:* in a )
                        	b.push( serialize( e ) );
                        
                        return b.join(",");
                    }
                    else
			        	return serialize( o[StringUtils.trim(s)] );
		        }) );
            }
	        if( _reflectionForm )
            	return output;
	        else
            	return output.replace(/::/g, "." );
        }

        public function addTypeHandler ( type : *, handler : Function ) : void
        {
            _typeMap[ type ] = handler;
        }
        public function addTypeConstructorArgument ( type : *, ... propertiesName ) : void
        {
            _constructorArgumentsMap[ type ] = propertiesName;
        }
        
        private function primiteHandler( o : *, c : Class ):String
        {
            return String(o);
        }
        private function stringHandler( o : *, c : Class ):String
        {
            return StringUtils.quote( o );
        }
        private function objectHandler( o : *, c : Class ):String
        {
            var a : Array = [];
            for ( var k : String in o )
            	a.push(k);
            a.sort();
            
            return _$("{$0}", a.map( function( k : String, ... args ) : String 
            {
                return _$(
                	"'${key}':${value}", 
                    { 
                        'key':k, 
                        'value':serialize(o[k]) 
                    }
                );
            }) );
        }
        private function arrayHandler( o : *, c : Class ):String
        {
            return _$("[$0]", (o as Array).map( function(o:*,... args):String
            {
                return serialize( o );
            }) );
        }
        private function regexpHandler( o : RegExp, c : Class ):String
        {
            var flags : String = "";
            
            if( o.global ) flags += "g";
            if( o.multiline ) flags += "m";
            if( o.ignoreCase ) flags += "i";
            if( o.dotall ) flags += "s";
            if( o.extended ) flags += "x";
               
            return _$(
            	"/${exp}/${flags}",
                {
                    'exp':o.source,
                    'flags':flags
                }
            );
        }
        private function classHandler( o : Class, c : Class ):String
        {
            return getQualifiedClassName( o );
        }
    }
}
