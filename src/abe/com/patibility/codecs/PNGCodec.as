/**
 * @license
 */
package abe.com.patibility.codecs
{
    import abe.com.mon.geom.Dimension;
    import abe.com.mon.geom.dm;
    import abe.com.patibility.lang._;

    import flash.display.BitmapData;
    import flash.geom.Matrix;
    import flash.geom.Rectangle;
    import flash.utils.ByteArray;
	/**
	 * La classe <code>PNGCodec</code> permet d'encoder et de décoder des images
	 * au format <code>PNG</code>.
	 *
	 * @author Cédric Néhémie
	 * @see	http://fr.wikipedia.org/wiki/Portable_Network_Graphics Format PNG
	 */
	public class PNGCodec implements Codec
	{
		/**
		 * @inheritDoc
		 */
		public function get encodedType () : Class { return ByteArray; }
		/**
		 * @inheritDoc
		 */
		public function get decodedType () : Class { return BitmapData; }
		/**
		 * @inheritDoc
		 */
		public function encode ( o : * ) : *
		{
			if( o is BitmapData )
			{
				var img : BitmapData = o as BitmapData;
				var j : int;

				// Create output byte array
				var png : ByteArray = new ByteArray ();
				// Write PNG signature
				png.writeUnsignedInt ( 0x89504e47 );
				png.writeUnsignedInt ( 0x0D0A1A0A );
				// Build IHDR chunk
				var IHDR : ByteArray = new ByteArray ();
				IHDR.writeInt ( img.width );
				IHDR.writeInt ( img.height );
				IHDR.writeUnsignedInt ( 0x08060000 );
				// 32bit RGBA
				IHDR.writeByte ( 0 );
				writeChunk ( png, 0x49484452, IHDR );
				// Build IDAT chunk
				var IDAT : ByteArray = new ByteArray ();
				for(var i : int = 0;i < img.height;i++)
				{
					// no filter
					IDAT.writeByte ( 0 );
					var p : uint;
					if ( !img.transparent )
					{
						for(j = 0;j < img.width;j++)
						{
							p = img.getPixel ( j, i );
							IDAT.writeUnsignedInt ( uint ( ((p & 0xFFFFFF) << 8) | 0xFF ) );
						}
					}
					else
					{
						for(j = 0;j < img.width;j++)
						{
							p = img.getPixel32 ( j, i );
							IDAT.writeUnsignedInt ( uint ( ((p & 0xFFFFFF) << 8) | ( p >> 24 ) ) );
						}
					}
				}
				IDAT.compress ();
				writeChunk ( png, 0x49444154, IDAT );
				// Build IEND chunk
				writeChunk ( png, 0x49454E44, null );
				// return PNG
				return png;
			}
			else
				throw new Error ( _ ( "PNGCodec.encode method accepts only items of type BitmapData as argument" ) );
		}

		private static var crcTable : Array;
		private static var crcTableComputed : Boolean = false;

		private static function writeChunk ( png : ByteArray, type : uint, data : ByteArray ) : void
		{
			var c : uint;
			if (!crcTableComputed)
			{
				crcTableComputed = true;
				crcTable = [];
				for (var n : uint = 0; n < 256; n++)
				{
					c = n;
					for (var k : uint = 0; k < 8; k++)
					{
						if (c & 1)
						{
							c = uint ( uint ( 0xedb88320 ) ^ uint ( c >>> 1 ) );
						}
						else
						{
							c = uint ( c >>> 1 );
						}
					}
					crcTable[n] = c;
				}
			}
			var len : uint = 0;
			if (data != null)
			{
				len = data.length;
			}
			png.writeUnsignedInt ( len );
			var p : uint = png.position;
			png.writeUnsignedInt ( type );
			if ( data != null )
			{
				png.writeBytes ( data );
			}
			var e : uint = png.position;
			png.position = p;
			c = 0xffffffff;
			for (var i : int = 0; i < (e - p); i++)
			{
				c = uint ( crcTable[
				(c ^ png.readUnsignedByte ()) & uint ( 0xff )] ^ uint ( c >>> 8 ) );
			}
			c = uint ( c ^ uint ( 0xffffffff ) );
			png.position = e;
			png.writeUnsignedInt ( c );
		}

		/**
		 * @inheritDoc
		 */
		public function decode ( o : * ) : *
		{
			if( o is ByteArray )
			{
				var png : ByteArray = o as ByteArray;

				var IHDR:uint = 0x49484452;
				var PLTE:uint = 0x504c5445;
				var IDAT:uint = 0x49444154;
				var IEND:uint = 0x49454e44;
				var chunks : Array = new Array ();
				var input : ByteArray = new ByteArray ();
				var output : ByteArray = new ByteArray ();

				input = png;

				input.position = 0;

				if (!readSignature ( input ))
					throw new Error ( "wrong signature" );

				getChunks ( input, chunks );

				var dim : Dimension;


				for (var i : int = 0; i < chunks.length; ++i)
				{
					switch(chunks[i].type)
					{
						case IHDR:
							dim = processIHDR ( i, input, chunks );
							break;
						// case PLTE: processPLTE(i); break;
						case IDAT:
							processIDAT ( i, input, chunks, output, dim );
							break;
						// case IEND: processIEND(i); break;
					}
				}

				// Since the image is inverted in x and y, I have to flip it using a Matrix object. There should be a better solution for this..
				var bd0 : BitmapData = new BitmapData ( dim.width, dim.height );
				var bd1 : BitmapData = new BitmapData ( dim.width, dim.height, true, 0xffffff );

				if (output.length > 0 && (dim.width * dim.height * 4) == output.length)
				{
					output.position = 0;
					bd0.setPixels ( new Rectangle ( 0, 0, dim.width, dim.height ), output );

					var mat : Matrix = new Matrix ();
					mat.scale ( -1, -1 );
					mat.translate ( dim.width, dim.height );

					bd1.draw ( bd0, mat );
				}

				return bd1;
			}
			else
				throw new Error ( _ ( "PNGCodec.decode method only accepts objects of type ByteArray as argument" ) );
		}

		private function processIHDR ( index : uint, input : ByteArray, chunks : Array ) : Dimension
		{
			input.position = chunks[index].position;

			var width : uint = input.readUnsignedInt ();
			var height : uint = input.readUnsignedInt ();

			// file info, but is not used yet
			var bitDepth : uint = input.readUnsignedByte ();
			var colourType : uint = input.readUnsignedByte ();
			var compressionMethod : uint = input.readUnsignedByte ();
			var filterMethod : uint = input.readUnsignedByte ();
			var interlaceMethod : uint = input.readUnsignedByte ();

			return dm( width, height );
		}

		// This can't handle multiple IDATs yet, and it can only decode filter 0 scanlines.
		private function processIDAT ( index : uint, input : ByteArray, chunks : Array, output : ByteArray, dim : Dimension ):void
		{
			var tmp : ByteArray = new ByteArray ();

			var pixw : uint = dim.width * 4;

			tmp.writeBytes ( input, chunks[index].position, chunks[index].length );
			tmp.uncompress ();

			for (var i : int = tmp.length - 1; i > 0; --i)
			{
				if (i % (pixw + 1) != 0)
				{
					var a : uint = tmp[i];
					var b : uint = tmp[i - 1];
					var g : uint = tmp[i - 2];
					var r : uint = tmp[i - 3];

					output.writeByte ( a );
					output.writeByte ( r );
					output.writeByte ( g );
					output.writeByte ( b );

					i -= 3;
				}
			}
		}

		private function getChunks ( input : ByteArray, chunks : Array ):void
		{
			var pos : uint = 0;
			var len : uint = 0;
			var type : uint = 0;

			var loopEnd : int = input.length;

			while (input.position < loopEnd)
			{
				len = input.readUnsignedInt ();
				type = input.readUnsignedInt ();
				pos = input.position;

				input.position += len;
				input.position += 4;
				// crc block. It is ignored right now, but if you want to retrieve it, replace this line with "input.readUnsignedInt()"

				chunks.push ( { position:pos, length:len, type:type } );
			}
		}

		private function readSignature ( input : ByteArray ):Boolean
		{
			return ( input.readUnsignedInt () == 0x89504e47 &&
					 input.readUnsignedInt () == 0x0D0A1A0A );
		}

		// transform the chunk type to a string representation
		private function fixType ( num : uint ):String
		{
			var ret : String = "";
			var str : String = num.toString ( 16 );

			while (str.length < 8)
				str = "0" + str;

			ret += String.fromCharCode ( parseInt ( str.substr ( 0, 2 ), 16 ) );
			ret += String.fromCharCode ( parseInt ( str.substr ( 2, 2 ), 16 ) );
			ret += String.fromCharCode ( parseInt ( str.substr ( 4, 2 ), 16 ) );
			ret += String.fromCharCode ( parseInt ( str.substr ( 6, 2 ), 16 ) );

			return ret;
		}
	}
}
