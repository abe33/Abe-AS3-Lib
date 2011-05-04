/**
 * @license
 */
package abe.com.patibility.codecs
{
	import abe.com.mon.logs.Log;

	import flash.display.BitmapData;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	/**
	 * La classe <code>DIBCodec</code> permet d'encoder et de décoder
	 * des images au format <code>DIB</code>.
	 * <p>
	 * Le format <code>DIB</code> est le format utilisé pour encoder
	 * les images de type <code>BMP</code> ou encore les fichiers
	 * <code>&#42;.ico</code> ou <code>&#42;.cur</code> sous Windows®.
	 * </p>
	 *
	 * @author Cédric Néhémie
	 * @see	http://en.wikipedia.org/wiki/BMP_file_format Format BMP/DIB
	 */
	public class DIBCodec implements Codec
	{
		/**
		 * Constante indiquant la profondeur de bits par pixel.
		 */
		static public const BIT_DEPTH:uint = 24;
		/**
		 * @inheritDoc
		 */
		public function encode( o : * ) : *
		{
			if( o is BitmapData )
			{
				var image : BitmapData = o as BitmapData;
				var bmp:ByteArray = new ByteArray();
				bmp.endian = Endian.LITTLE_ENDIAN;

				writeHeader(bmp);
				writeInfoHeader(bmp, image);
				writeData(bmp, image);
				setFileSize(bmp);

				return bmp;
			}
			else
				throw new Error("DIBCodec.encode method accepts only objects of type BitmapData as argument");

			return null;
		}
		/**
		 * @inheritDoc
		 */
		public function decode ( o : * ) : *
		{
			if( o is ByteArray )
			{
				var bmp:ByteArray = o as ByteArray;
				bmp.endian = Endian.LITTLE_ENDIAN;

				readHeader(bmp);
				var img : BitmapData = readInfoHeader(bmp);
				readData( bmp, img );
			}
			else
				throw new Error("DIBCodec.decode method accepts only objects of type ByteArray as argument");

			return null;
		}
		/**
		 * @inheritDoc
		 */
		public function get encodedType () : Class { return ByteArray; }
		/**
		 * @inheritDoc
		 */
		public function get decodedType () : Class { return BitmapData; }

		/**
		 * Écrit les données de l'image dans le <code>ByteArray</code>.
		 *
		 * @param	bmp		l'objet dans lequel écrire les données
		 * @param	image	l'image à écrire
		 */
		protected function writeData(bmp:ByteArray, image:BitmapData):void
		{
			// Calculate row padding. Rows end on 4 byte (dword) boundaries.
			var padLength:int = image.width % 4;
			var padding:ByteArray = new ByteArray();

			for(var i:int = 0; i < padLength; i++)
			{
				padding.writeByte(0);
			}

			var rgb:uint = 0;

			for(var y:int = image.height - 1; y >= 0; y--)
			{
				for(var x:int = 0; x < image.width; x++)
				{
					rgb = image.getPixel(x, y);
					writePixel ( bmp, rgb );
				}

				// Align the rows.
				bmp.writeBytes(padding, 0, padLength);
			}
		}
		/**
		 * Lit les données depuis un objet <code>ByteArray</code> et remplit un
		 * <code>BitmapData</code>
		 *
		 * @param	bmp	le <code>ByteArray</code> à lire
		 * @param	img	le <code>BitmapData</code> à remplir
		 * @param	bpp	la profondeur de bits par pixel
		 */
		protected function readData ( bmp : ByteArray, img : BitmapData, bpp : int = 24 ) : void
		{
			var padLength:int = img.width % 4;
			var padding : ByteArray = new ByteArray();
			Log.debug("padLength = " + padLength );

			if( padLength != 0 )
				bmp.readBytes(padding, 0, padLength);
			for(var y:int = img.height - 1; y >= 0; y--)
			{
				for(var x:int = 0; x < img.width; x++)
				{
					img.setPixel32(x, y, readPixel( bmp, bpp ) );
				}
			}
		}
		/**
		 * Écrit un pixel dans le <code>ByteArray</code>.
		 *
		 * @param	bmp	le <code>ByteArray</code> cible
		 * @param	rgb	la couleur du pixel
		 * @param	bpp	la profondeur de bits par pixel
		 */
		protected function writePixel ( bmp : ByteArray, rgb:uint, bpp : int = 24 ):void
		{
			bmp.writeByte(0x000000ff & rgb);
			bmp.writeByte((0x0000ff00 & rgb) >> 8);
			bmp.writeByte((0x00ff0000 & rgb) >> 16 );
			if( bpp >= 32 )
				bmp.writeByte((0x00ff0000 & rgb) >> 24);
		}
		/**
		 * Lit un pixel dans le <code>ByteArray</code>.
		 *
		 * @param	bmp	le <code>ByteArray</code> source
		 * @param	bpp	la profondeur de bits par pixel
		 * @return	la couleur du pixel
		 */
		protected function readPixel ( bmp : ByteArray, bpp : int = 24 ) : uint
		{
			var r : uint = 0;			var g : uint = 0;			var b : uint = 0;
			var a : uint = 0;
			switch( bpp )
			{
				case 24 :
					r = bmp.readByte();
					g = bmp.readByte() << 8;					b = bmp.readByte() << 16;
					break;
				case 32 :
					r = bmp.readByte();
					g = bmp.readByte() << 8;
					b = bmp.readByte() << 16;
					a = bmp.readByte() << 24;
					break;
				case 8 :
					a = 255;
					b = bmp.readByte();
					r = b << 16;
					g = b << 8;
					break;
				case 16 :
					break;

			}
			return r + g + b + a;		}
		/**
		 * Créer le header du fichier <code>BMP</code>.
		 *
		 * @param	bmp	le <code>ByteArray</code> cible
		 */
		protected function writeHeader(bmp:ByteArray):void
		{
			// Bitmap header
			bmp.writeShort(0x4d42); // BMPs start with 'BM'
			bmp.writeUnsignedInt(0); // filesize in bytes, set after the data is populated.
			bmp.writeShort(0); // reserved.
			bmp.writeShort(0); // reserved.
			bmp.writeUnsignedInt(54); //data offset.
		}
		/**
		 * Lit le header du fichier.
		 *
		 * @param	bmp	le <code>ByteArray</code> source
		 */
		protected function readHeader ( bmp : ByteArray ) : void
		{
			bmp.readShort(); // BMPs start with 'BM'
			bmp.readUnsignedInt(); // filesize in bytes			bmp.readShort(); // reserved
			bmp.readShort(); // reserved			bmp.readUnsignedInt(); // data offset
		}
		/**
		 * Créer le header d'information du fichier.
		 *
		 * @param	bmp		le <code>ByteArray</code> cible
		 * @param	image	l'image à encoder
		 */
		protected function writeInfoHeader(bmp:ByteArray, image:BitmapData):void
		{
			// Bitmap Info header
			bmp.writeUnsignedInt(40); // Size of info header. V3
			bmp.writeInt(image.width); // signed int width of image.
			bmp.writeInt(image.height); // signed int height of image.
			bmp.writeShort(1); // # of color planes.
			bmp.writeShort(BIT_DEPTH); // # bits per pixel.
			bmp.writeUnsignedInt(0); // No compresion.
			bmp.writeUnsignedInt(0); // Size of the raw image data.	0 is valid for no compression.
			bmp.writeInt(0); // x resolution
			bmp.writeInt(0); // y resolution
			bmp.writeUnsignedInt(0); // # of colors in color pallete. 0 indicates default 2^n.
			bmp.writeUnsignedInt(0); // # of important colors. what?
		}
		/**
		 * Lit le header d'informations du fichier est renvoie un <code>BitmapData</code>
		 * prêt à être remplit avec les données.
		 *
		 * @param	bmp	le <code>ByteArray</code> source
		 * @return	un <code>BitmapData</code> à remplir
		 */
		protected function readInfoHeader ( bmp : ByteArray ) : BitmapData
		{
			Log.debug( "header size : " + bmp.readUnsignedInt() ); // info header size
			var width : Number = bmp.readInt();			var height : Number = bmp.readInt();
			Log.debug( "width : " + width );			Log.debug( "height : " + height );
			Log.debug( "color planes : " + bmp.readShort() );
			Log.debug( "bpp : " + bmp.readShort() );
			Log.debug( "compression : " + bmp.readUnsignedInt() );			Log.debug( "raw data size : " + bmp.readUnsignedInt() );			Log.debug( "x res : " + bmp.readInt() );			Log.debug( "y res : " + bmp.readInt() );
			Log.debug( "# colors : " +bmp.readUnsignedInt() );
			Log.debug( "# !colors : " +bmp.readUnsignedInt() );			Log.debug( "----------------------------------------------" );

			return new BitmapData(width, height, true, 0x00000000 );
		}
		/**
		 * Écrit la taille dans le fichier.
		 *
		 * @param	bmp	le <code>ByteArray</code> cible.
		 */
		protected function setFileSize(bmp:ByteArray):void
		{
			var prevPosition:uint = bmp.position;
			bmp.position = 2;
			bmp.writeUnsignedInt(bmp.length);
			bmp.position = prevPosition;
		}

	}
}
