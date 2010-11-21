/**
 * @license
 */
package aesia.com.patibility.codecs
{
	import aesia.com.edia.bitmaps.MultiSideBitmapSprite;
	import aesia.com.mon.geom.pt;
	import aesia.com.patibility.lang._;

	import flash.display.BitmapData;
	import flash.utils.ByteArray;

	/**
	 * La classe <code>SPZCodec</code> permet d'encoder et de décoder
	 * des objets de types <code>MultiSideBitmapSprite</code> sauvegardés
	 * dans des fichiers de type <code>SPZ</code>.
	 * <p>
	 * La classe <code>SPZCodec</code> ne gère que des objets <code>MultiSideBitmapSprite</code>
	 * ne contenant qu'un seul <code>BitmapData</code> commun à tout les états.
	 * </p>
	 *
	 * @author Cédric Néhémie
	 * @see	aesia.com.edia.bitmaps.MultiSideBitmapSprite
	 */
	public class SPZCodec implements Codec
	{
		/**
		 * @inheritDoc
		 */
		public function encode (o : *) : *
		{
			if( o is MultiSideBitmapSprite )
			{
				var bs : MultiSideBitmapSprite = o as MultiSideBitmapSprite;
				var ba : ByteArray = new ByteArray();

				var l : int = bs.sidesCount;
				var s : Object = bs.sides;

				ba.writeUnsignedInt(l);
				for( var i:String in s )
				{
					var side : Object = s[i];
					ba.writeUTF(i);
					ba.writeDouble( side.center.x );
					ba.writeDouble( side.center.y );
					ba.writeBoolean(side.reversed );
				}

				ba.writeUnsignedInt( bs.data.width );
				ba.writeUnsignedInt( bs.data.height );
				ba.writeBytes( bs.data.getPixels(bs.data.rect) );

				ba.position = 0;
				ba.compress();

				return ba;
			}
			else throw new Error(_("The method SPZCodec.encode accept only an argument of type MultiBitmapSprite."));
		}
		/**
		 * @inheritDoc
		 */
		public function decode (o : *) : *
		{
			if( o is ByteArray )
			{
				var ba : ByteArray = o as ByteArray;
				ba.uncompress();
				ba.position = 0;

				var l : uint = ba.readUnsignedInt();
				var sides : Object = {};
				for(var i:int=0;i<l;i++)
				{
					var sideName : String = ba.readUTF();

					var centerx : Number = ba.readDouble();
					var centery : Number = ba.readDouble();

					var reversed : Boolean = ba.readBoolean();

					sides[sideName] = {
										center:pt(centerx,centery),
										reversed:reversed
									  };

				}

				var w : uint = ba.readUnsignedInt();
				var h : uint = ba.readUnsignedInt();

				var bmp : BitmapData = new BitmapData(w, h, true, 0);
				bmp.setPixels(bmp.rect, ba );

				for (var j : String in sides )
					sides[j].bitmap = bmp;

				var sprite : MultiSideBitmapSprite = new MultiSideBitmapSprite( bmp );
				sprite.sides = sides;

				return sprite;
			}
			else throw new Error(_("The method SPZCodec.decode accept only an argument of type ByteArray."));
		}
		/**
		 * @inheritDoc
		 */
		public function get encodedType () : Class { return ByteArray; }
		/**
		 * @inheritDoc
		 */
		public function get decodedType () : Class { return MultiSideBitmapSprite; }
	}
}
