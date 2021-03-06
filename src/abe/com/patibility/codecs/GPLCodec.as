/**
 * @license
 */
package abe.com.patibility.codecs
{
	import abe.com.mon.colors.Color;
	import abe.com.mon.colors.Palette;
	import abe.com.mon.utils.StringUtils;
	import abe.com.patibility.lang._;

	import flash.utils.ByteArray;
	/**
	 * La classe <code>GPLCodec</code> permet d'encoder et de décoder
	 * des objets <code>Palette</code> au format <code>GPL</code> de GIMP.
	 *
	 * @author Cédric Néhémie
	 * @see	http://docs.gimp.org/fr/gimp-concepts-palettes.html Palette GIMP
	 */
	public class GPLCodec implements Codec
	{
		/*
		 GIMP Palette
		Name: flesh
		Columns: 0
		#
		238 212 192	flesh light
		 */
		/**
		 * @inheritDoc
		 */
		public function encode (o : *) : *
		{
			if( o is Palette )
			{
				var p : Palette = o as Palette;
				var s : String = "GIMP Palette\n";
				s+= "Name: " + p.name + "\n";
				s+= "Columns: 0\n#\n";
				var l : int = p.colors.length;
				for(var i:int;i<l;i++)
				{
					var c : Color = p.colors[i];
					s += c.red + " " + c.green + " " + c.blue + " " + ( c.name != "" ? c.name : _("Unnamed Color") ) + "\n";
				}
				return s;
			}
			else throw new Error(_("GPLCodec.encode method only accepts type Palette as argument :" + o));
		}
		/**
		 * @inheritDoc
		 */
		public function decode (o : *) : *
		{
			if( o is ByteArray )
			{
				var ba : ByteArray = o as ByteArray;

				o = ba.readMultiByte(ba.length, "iso-8859-01");
			}
			if( o is String )
			{
				var a : Array = (o as String).split("\n");
				a.shift();
				var name : String = StringUtils.trim( a.shift().replace("Name:","") );
				a.shift();
				a.shift();
				var l : int = a.length;
				var cols : Array = [];
				for(var i:int=0;i<l;i++ )
				{
					var c : Array = StringUtils.trim( a[i] ).split(/\s+/g);
					if( c.length == 1 )
						continue;

					var r : int = parseInt(c.shift());
					var g : int = parseInt(c.shift());
					var b : int = parseInt(c.shift());
					var cname : String = c.join(" ");
					cols.push( new Color(r, g, b, 255, cname))
				}
				return new Palette( name, cols );
			}
			else throw new Error(_("GPLCodec.decode method only accepts arguments of type String : " + o));
		}
		/**
		 * @inheritDoc
		 */
		public function get encodedType () : Class { return String; }
		/**
		 * @inheritDoc
		 */
		public function get decodedType () : Class { return Palette; }
	}
}
