/**
 * @license
 */
package abe.com.patibility.codecs
{
	import abe.com.mon.logs.Log;
	import abe.com.patibility.codecs.Codec;
	import abe.com.mon.colors.Color;
	import abe.com.mon.colors.Palette;

	import flash.utils.ByteArray;

	/**
	 * La classe <code>ACOCodec</code> permet d'encoder et de décoder
	 * des objets <code>Palette</code> au format <code>ACO</code>.
	 * <p>
	 * Le format <code>ACO</code> est le format de palette utilisé
	 * par le logiciel Photoshop®.
	 * </p>
	 *
	 * @author Cédric Néhémie
	 * @see	http://www.nomodes.com/aco.html Format ACO
	 */
	public class ACOCodec implements Codec
	{
		/**
		 * @inheritDoc
		 */
		public function encode (o : *) : *
		{
			if( o is Palette )
			{
				var palette : Palette = o as Palette;
				var ba : ByteArray = new ByteArray();
				var n : Number = 0;
				var c : Color;
				var l : Number = palette.colors.length;

				// Version 1
				ba.writeShort( 1 );				ba.writeShort( l );
				for ( n = 0; n < l; n++ )
				{
					c = palette.colors[n];
					ba.writeShort( 0 );					ba.writeShort( c.red + ( c.red << 8 ) );
					ba.writeShort( c.green + ( c.green << 8 )  );					ba.writeShort( c.blue + ( c.blue << 8 )  );					ba.writeShort( 0 );
				}
				// version 2
				ba.writeShort( 2 );
				ba.writeShort( l );
				for ( n = 0; n < l; n++ )
				{
					c = palette.colors[n];
					ba.writeShort( 0 );
					ba.writeShort( c.red + ( c.red << 8 ) );
					ba.writeShort( c.green + ( c.green << 8 ) );
					ba.writeShort( c.blue + ( c.blue << 8 ) );
					ba.writeShort( 0 );					ba.writeShort( 0 );
					if( c.name.length > 0 )						ba.writeUTF( c.name );					ba.writeShort( 0 );
				}
				ba.position = 0;
				return ba;
			}
			else
				throw new Error("La méthode ACOCodec.encode n'accepte que des objets de type Palette en argument");

			return null;
		}
		/**
		 * @inheritDoc
		 */
		public function decode (o : *) : *
		{
			if( o is ByteArray )
			{
				var ba : ByteArray = o as ByteArray;
				var n : Number;
				var r : int;				var g : int;				var b : int;
				var s : String;
				var version : int;
				var numColor : int;
				var sl : int;
				var av1 : Array = [];
				var av2 : Array = [];
				var palette : Palette = new Palette("Photoshop sucks");

				// version 1
				version = ba.readShort();
				numColor = ba.readShort();
				for(n=0;n<numColor;n++)
				{
					ba.readShort();
					r = ba.readShort() & 0xff;
					g = ba.readShort() & 0xff;
					b = ba.readShort() & 0xff;
					av1.push( new Color( r, g, b ) );
					ba.readShort();
				}

				if( ba.bytesAvailable == 0 )
				{
					/*FDT_IGNORE*/ CONFIG::DEBUG { /*FDT_IGNORE*/
					Log.info( "ACOCodec: get palette content from section 1 (version 1)" );
					/*FDT_IGNORE*/ } /*FDT_IGNORE*/

					palette.addColors.apply( null, av1 );
					return palette;
				}

				// version 2
				// si une erreur est levée on stop et on renvoie la version 1
				try
				{
					version = ba.readShort();
					numColor = ba.readShort();

					for(n=0;n<numColor;n++)
					{
						ba.readShort();
						r = ba.readShort() & 0xffff;
						g = ba.readShort() & 0xffff;
						b = ba.readShort() & 0xffff;
						ba.readShort();
						ba.readShort();
						sl = ba.readShort();
						if( sl > 1 )
						{
							s = ba.readUTFBytes( sl );
							ba.readShort();
							av2.push( new Color( r & 0xff, g & 0xff, b & 0xff, 0xff, s ) );						}
						else
							av2.push( new Color( r & 0xff, g & 0xff, b & 0xff ) );
					}
					/*FDT_IGNORE*/ CONFIG::DEBUG { /*FDT_IGNORE*/
					Log.info( "ACOCodec: get palette content from section 2 (version 2)" );
					/*FDT_IGNORE*/ } /*FDT_IGNORE*/

					palette.addColors.apply( null, av2 );
					return palette;
				}
				catch ( e : Error )
				{
					/*FDT_IGNORE*/ CONFIG::DEBUG { /*FDT_IGNORE*/
					Log.info( "ACOCodec: get palette content from section 1 (version 1) cause section 2 is invalid" );
					/*FDT_IGNORE*/ } /*FDT_IGNORE*/

					palette.addColors.apply( null, av1 );
					return palette;
				}
			}
			else
				throw new Error("La méthode ACOCodec.decode n'accepte que des objets de type ByteArray en argument");
		}
		/**
		 * @inheritDoc
		 */
		public function get encodedType () : Class { return ByteArray; }
		/**
		 * @inheritDoc
		 */
		public function get decodedType () : Class { return Palette; }
	}
}
