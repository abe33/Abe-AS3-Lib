package abe.com.ponents.builder.codecs 
{
	import abe.com.mon.utils.magicEquals;
	import abe.com.mon.utils.magicToReflectionSource;
	import abe.com.patibility.codecs.Codec;
	import abe.com.patibility.lang._;
	import abe.com.ponents.skinning.ComponentStyle;

	import flash.utils.Dictionary;
	/**
	 * @author cedric
	 */
	public class StyleMetaCodec implements Codec 
	{
		public function encode (o : *) : *
		{
			if( o is ComponentStyle )
			{
				var cs : ComponentStyle = o as ComponentStyle;
				var a : Array = cs.getPropertiesTable();
				var i:int;
				var s : String = '[Skin(\tdefine="'+ cs.styleName + 
									( cs.defaultStyleKey != "" ? '",\n\t\tinherit="'+cs.defaultStyleKey : '",\n\t\tinherit="' ) +
								  '",';
				
				for( i=0;i<a.length;i++)
				{
					var d : Dictionary = getSimilarInstanceByStates(a[i], cs );
					for( var j:* in d )
					{
						if( j != "null" )
						{
							var ast : Array = d[j] as Array;
							s+= '\n\t\tstate__'+( ast.length == 16 ? "all" : ast.join("_") )+'__'+a[i]+'="' + magicToReflectionSource( j )+ '",';
						}
					}
				}
				a = cs.getCustomPropertiesTable();
				for( i=0; i <a.length ; i++)
				{
					s+= '\n\t\tcustom_'+a[i]+'="'+ magicToReflectionSource( cs[a[i]] ) +'",';
				}
				s = s.substr(0, s.length-1);
				s+= "\n)]";
				return s;
			}
			else throw new TypeError( _("The SkinMetaCodec.encode() method only support arguments of type ComponentStyle.") );
		}
		
		public function decode (o : *) : *
		{
			if( o is String )
			{
				
			}
			else throw new TypeError( _("The SkinMetaCodec.decode() method only support arguments of type String.") );
		}
		
		public function getSimilarInstanceByStates ( property : String, style : ComponentStyle ) : Dictionary
		{
			var d : Dictionary = new Dictionary();
			
			for( var i:int=0;i<16;i++)
			{
				var v : *;
				if( style.states[i] )
					v = style.states[i][property];
				else
					v = null;
				
				var hasEquality:Boolean = false;
				search:for(var j:* in d )
				{
					if( magicEquals( v, j ) )
					{
						d[j].push( i );
						hasEquality = true;
						break search;
					}
				}
				if( !hasEquality )
					d[v] = [i];
			}
			
			return d; 
		}
		
		public function get encodedType () : Class { return String; }
		public function get decodedType () : Class { return ComponentStyle; }
	}
}
