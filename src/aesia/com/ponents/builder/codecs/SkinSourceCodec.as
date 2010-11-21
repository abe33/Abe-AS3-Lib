package aesia.com.ponents.builder.codecs 
{
	import aesia.com.patibility.lang._;
	import aesia.com.patibility.lang._$;
	import aesia.com.ponents.skinning.ComponentStyle;
	import aesia.com.ponents.skinning.SkinManagerInstance;

	/**
	 * @author cedric
	 */
	public class SkinSourceCodec extends StyleSourceCodec 
	{
		protected var _output : String;
		protected var _processedStyles : Object;
		protected var _currentSkin : Object;

		public function SkinSourceCodec ()
		{
		}

		override public function encode (o : *) : *
		{
			if( o is Object )
			{
				_output = _$("var skin:Object={name:'$0'};\n\n", o.name );
				_currentSkin = o;
				//super.encode( o );	
				_processedStyles = {};
				
				for( var i : String in _currentSkin )
				{
					if( i != "name" )
					{
						var style : ComponentStyle = _currentSkin[i] as ComponentStyle;
						if( !_processedStyles.hasOwnProperty(style.styleName) )
						{
							processStyle( style );
						}
					}
				}
				_output += _$("SkinManagerInstance.addSkin( '$0', skin );", o.name );
				_processedStyles = null;
				return _output;		
			}
			else throw new Error(_("The SkinSourceCodec.encode method only take an Object as argument." ) );
		}
		
		protected function processStyle (style : ComponentStyle) : void
		{
			if( style.defaultStyleKey != "" && !_processedStyles.hasOwnProperty( style.defaultStyle.styleName ) )
				processStyle( SkinManagerInstance.getStyle( style.defaultStyleKey ) );
				
			_output += _$("skin['$0'] = $1\n\n", style.styleName , super.encode( style ));
			_processedStyles[ style.styleName ] = true;
		}

		override public function get decodedType () : Class {
			return Object;
		}
	}
}
