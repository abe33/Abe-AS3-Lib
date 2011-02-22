/**
 * @license
 */
package abe.com.patibility.codecs
{
	import abe.com.edia.bitmaps.MultiSideBitmapSprite;
	import abe.com.mon.geom.pt;
	import abe.com.patibility.lang._;

	import flash.display.BitmapData;
	import flash.utils.ByteArray;

	/**
	 * La classe <code>SPZCodec2</code> permet d'encoder et de décoder
	 * des objets de types <code>MultiSideBitmapSprite</code> sauvegardés
	 * dans des fichiers de type <code>SPZ</code>.
	 * <p>
	 * La classe <code>SPZCodec2</code> supporte les objets <code>MultiSideBitmapSprite</code>
	 * contenant des images différentes par états du sprite.
	 * </p>
	 *
	 * @author Cédric Néhémie
	 * @see	abe.com.edia.bitmaps.MultiSideBitmapSprite
	 */
	public class SPZCodec2 extends SPZCodec
	{
		/**
		 * @inheritDoc
		 */
		override public function encode (o : *) : *
		{
			if( o is MultiSideBitmapSprite )
			{
				var bs : MultiSideBitmapSprite = o as MultiSideBitmapSprite;
				var ba : ByteArray = new ByteArray();
				var i:String;
				var side : Object;
				var l : int = bs.sidesCount;
				var s : Object = bs.sides;
				var map : Array = [];
				var bmp : BitmapData;
				for( i in s )
				{
					side = s[i];
					bmp = side.bitmap;

					if( map.indexOf( bmp ) == -1 )
						map.push(bmp);
				}

				var m : uint = map.length;
				ba.writeUnsignedInt(m);
				for(var j : uint = 0; j<m; j++)
				{
					bmp = map[j];
					ba.writeUnsignedInt( bmp.width );
					ba.writeUnsignedInt( bmp.height );
					ba.writeBytes( bmp.getPixels(bmp.rect) );
				}

				ba.writeUnsignedInt(l);
				for( i in s )
				{
					side = s[i];
					ba.writeUTF(i);
					ba.writeDouble( side.center.x );
					ba.writeDouble( side.center.y );
					ba.writeBoolean( side.reversed );					ba.writeUnsignedInt( map.indexOf(side.bitmap) );
				}

				ba.position = 0;
				ba.compress();

				return ba;
			}
			else throw new Error(_("The method SPZCodec2.encode accept only an argument of type MultiBitmapSprite."));
		}
		/**
		 * @inheritDoc
		 */
		override public function decode (o : *) : *
		{
			if( o is ByteArray )
			{
				try
				{
					var ba1 : ByteArray = new ByteArray();					var ba2b : ByteArray = o as ByteArray;
					ba2b.position = 0;
					ba2b.readBytes(ba1);
					var sp : MultiSideBitmapSprite = super.decode( ba1 );
					return sp;
				}
				catch( e : Error )
				{
					var ba : ByteArray = o as ByteArray;
					ba.position = 0;
					ba.uncompress();
					var map : Array = [];
					var m : uint = ba.readUnsignedInt();

					for(var j:uint = 0; j<m; j++)
					{
						var w : uint = ba.readUnsignedInt();
						var h : uint = ba.readUnsignedInt();

						var ba2 : ByteArray = new ByteArray();
						ba.readBytes( ba2, 0, w*h*4 );
						ba2.position = 0;

						var bmp : BitmapData = new BitmapData( w, h, true, 0);
						bmp.setPixels( bmp.rect, ba2 );
						map.push(bmp);
					}

					var l : uint = ba.readUnsignedInt();
					var sides : Object = {};
					for(var i:int=0;i<l;i++)
					{
						var sideName : String = ba.readUTF();

						var centerx : Number = ba.readDouble();
						var centery : Number = ba.readDouble();

						var reversed : Boolean = ba.readBoolean();
						var bmpIndex : uint = ba.readUnsignedInt();

						sides[sideName] = {
											center:pt(centerx,centery),
											reversed:reversed,
											bitmap:map[ bmpIndex ]
										  };
					}

					var sprite : MultiSideBitmapSprite = new MultiSideBitmapSprite( bmp );
					sprite.sides = sides;

					return sprite;
				}
			}
			else throw new Error(_("The method SPZCodec2.decode accept only an argument of type ByteArray."));
		}
	}
}
