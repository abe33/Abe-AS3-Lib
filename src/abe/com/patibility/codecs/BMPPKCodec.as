/**
 * @license
 */
package abe.com.patibility.codecs
{
	import abe.com.patibility.lang._;

	import flash.display.BitmapData;

	/**
	 * La classe <code>BMPPKCodec</code> permet d'encoder et de décoder des
	 * chaîne de caractère sous forme d'image.
	 *
	 * @author Cédric Néhémie
	 */
	public class BMPPKCodec implements Codec
	{
		/**
		 * @inheritDoc
		 */
		public function encode ( o : * ) : *
		{
			if( o is String )
			{
				var s : String = o as String;
				var l : uint = s.length;

				var bmpSize : uint = 1 + Math.ceil ( l / 3 );
				var bmp : BitmapData = new BitmapData ( bmpSize, 1, false, 0 );

				bmp.setPixel(0, 0, l);
				for( var i :int = 0; i<l; i += 3)
				{
					var r : uint = i < l ? ( uint(s.charCodeAt(i)) & 0xff ) << 16 : 0;					var g : uint = i+1 < l ? ( uint(s.charCodeAt(i+1)) & 0xff ) << 8 : 0;					var b : uint = i+2 < l ? ( uint(s.charCodeAt(i+2)) & 0xff ) : 0;
					bmp.setPixel(1+i / 3, 0, r+g+b );
				}
				return bmp;
			}
			else throw new Error (_("La méthode BMPPKCodec.encode n'accepte que les arguments de type String"));
		}
		/**
		 * @inheritDoc
		 */
		public function decode ( o : * ) : *
		{
			if( o is BitmapData )
			{
				var bmp : BitmapData = o as BitmapData;
				var l : uint = bmp.getPixel(0,0);
				var s : String = "";

				for(var i : uint = 0; i < l; i+=3 )
				{
					var px : uint = bmp.getPixel(1 + i/3, 0 );
					var r : uint = px >> 16 & 0xff;
					var g : uint = px >> 8 & 0xff;					var b : uint = px  & 0xff;
					if( i<l ) s += String.fromCharCode( r );					if( i+1<l ) s += String.fromCharCode( g );					if( i+2<l ) s += String.fromCharCode( b );				}
				return s;
			}
			else throw new Error (_("La méthode BMPPKCodec.decode n'accepte que les arguments de type BitmapData"));
		}
		/**
		 * @inheritDoc
		 */
		public function get encodedType () : Class { return BitmapData; }
		/**
		 * @inheritDoc
		 */
		public function get decodedType () : Class { return String; }
	}
}
