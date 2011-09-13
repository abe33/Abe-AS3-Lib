/**
 * @license
 */
package abe.com.patibility.codecs
{
    import abe.com.edia.bitmaps.BitmapSprite;
    import abe.com.patibility.lang._;

    import flash.display.BitmapData;
    import flash.geom.Point;
    import flash.utils.ByteArray;
	/**
	 * La classe <code>SPRCodec</code> permet d'encoder et de décoder des objets
	 * de type <code>BitmapSprite</code> sauvegardé dans des fichiers de type
	 * <code>SPR</code>.
	 *
	 * @author Cédric Néhémie
	 * @see	abe.com.edia.bitmaps.BitmapSprite
	 */
	public class SPRCodec implements Codec
	{
		/**
		 * @inheritDoc
		 */
		public function encode (o : *) : *
		{
			if( o is BitmapSprite )
			{
				var bs : BitmapSprite = o as BitmapSprite;
				var ba : ByteArray = new ByteArray();

				ba.writeDouble( bs.center.x );				ba.writeDouble( bs.center.y );
				ba.writeUnsignedInt( bs.data.width );				ba.writeUnsignedInt( bs.data.height );				ba.writeBytes( bs.data.getPixels(bs.data.rect) );
				ba.position = 0;
				ba.compress();
				return ba;
			}
			else throw new Error(_("SPRCodec.encode method accepts only objects of type BitmapSprite as argument"));
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
				var centerx : Number = ba.readDouble();				var centery : Number = ba.readDouble();
				var w : uint = ba.readUnsignedInt();
				var h : uint = ba.readUnsignedInt();

				var bmp : BitmapData = new BitmapData(w, h, true, 0);
				bmp.setPixels(bmp.rect, ba );

				var sprite : BitmapSprite = new BitmapSprite(bmp);
				sprite.center = new Point(centerx,centery);

				return sprite;
			}
			else throw new Error(_("SPRCodec.decode method accepts only objects of type ByteArray as argument"));
		}
		/**
		 * @inheritDoc
		 */
		public function get encodedType () : Class { return ByteArray; }
		/**
		 * @inheritDoc
		 */
		public function get decodedType () : Class { return BitmapSprite; }
	}
}
