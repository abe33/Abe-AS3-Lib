/**
 * @license
 */
package abe.com.patibility.codecs
{
	import flash.display.BitmapData;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	/**
	 * La classe <code>ICOCodec</code> permet d'encoder et de décoder
	 * des images au format <code>ICO</code>.
	 *
	 * @author Cédric Néhémie
	 * @see	http://en.wikipedia.org/wiki/ICO_%28file_format%29	Format ICO
	 */
	public class ICOCodec extends DIBCodec implements Codec
	{
		/**
		 * @inheritDoc
		 */
		override public function encode (o : *) : *
		{
			/*FDT_IGNORE*/
			TARGET::FLASH_9 { var res : Boolean = o is Array; }
			TARGET::FLASH_10 { var res : Boolean = o is Vector.<BitmapData>; }
			TARGET::FLASH_10_1 { /*FDT_IGNORE*/			var res : Boolean = o is Vector.<BitmapData>; /*FDT_IGNORE*/ } /*FDT_IGNORE*/
			
			if( res )
			{
				/*FDT_IGNORE*/
				TARGET::FLASH_9 { var v : Array = o as Array; }
				TARGET::FLASH_10 { var v : Vector.<BitmapData> = o as Vector.<BitmapData>; }
				TARGET::FLASH_10_1 { /*FDT_IGNORE*/
				var v : Vector.<BitmapData> = o as Vector.<BitmapData>; /*FDT_IGNORE*/ } /*FDT_IGNORE*/
				
				var ico : ByteArray = new ByteArray();
				ico.endian = Endian.LITTLE_ENDIAN;

				writeICOHeader( ico, v.length );
				writeICODirectories ( ico, v );

				return ico;
			}
			else
				throw new Error("ICOCodec.encode method accepts only objects of type Vector.<BitmapData> as argument");

			return null;
		}
		/**
		 * @inheritDoc
		 */
		override public function decode (o : *) : *
		{
			if( o is ByteArray )
			{
				var ico : ByteArray = o as ByteArray;
				ico.endian = Endian.LITTLE_ENDIAN;

				var imgnum : int = readICOHeader(ico);
				return readICODirectories( ico, imgnum );
			}
			else
				throw new Error("ICOCodec.decode method accepts only objects of type ByteArray as argument");

			return null;
		}
		
		private function writeICOHeader ( ico : ByteArray, imgnum : int ) : void
		{
			ico.writeShort(0); // reserved;
			ico.writeShort(0); // is an icon
			ico.writeShort( imgnum ); // number of icon
		}
		private function readICOHeader ( ico : ByteArray ) : int
		{
			ico.readShort(); // reserved
			ico.readShort(); // type
			return ico.readShort(); // number of images
		}
		private function writeICODirectories ( ico : ByteArray, v : * ) : void
		{
			var l : Number = v.length;
			var offsetPos : Array = [];
			var offsetValue : Array = [];
			var sizePos : Array = [];			var sizeValue : Array = [];
			var i:Number;
			var img : BitmapData;

			for( i = 0; i < l; i++ )
			{
				img = v[i];
				ico.writeByte( img.width ); // width
				ico.writeByte( img.height ); // height
				ico.writeByte( 0 ); // color count
				ico.writeByte( 0 ); // reserved
				ico.writeShort( 1 ); // color planes
				ico.writeShort( 32 ); // bpp
				sizePos[i] = ico.position;
				ico.writeUnsignedInt( 0 ); // bitmap data size
				offsetPos[i] = ico.position;
				ico.writeUnsignedInt( 0 ); // bitmap data offset
			}
			for( i = 0; i < l; i++ )
			{
				img = v[i];
				offsetValue[i] = ico.position;
				writeInfoHeader( ico, img );
				writeData( ico, img );
				sizeValue[i] = ico.position - offsetValue[i];
			}
			for( i = 0; i < l; i++ )
			{
				ico.position = sizePos[i];
				ico.writeUnsignedInt( sizeValue[i] );
				ico.position = offsetPos[i];
				ico.writeUnsignedInt( offsetValue[i] );
			}

		}
		private function readICODirectories ( ico : ByteArray, imgnum : int ) : *
		{
			/*FDT_IGNORE*/
			TARGET::FLASH_9 {
				var v : Array = [];
			}
			TARGET::FLASH_10 {
				var v : Vector.<BitmapData> = new Vector.<BitmapData>();
			}
			TARGET::FLASH_10_1 { /*FDT_IGNORE*/
			var v : Vector.<BitmapData> = new Vector.<BitmapData>(); /*FDT_IGNORE*/ } /*FDT_IGNORE*/
			
			for(var i:Number = 0;i<imgnum;i++)
			{
				var width : Number = ico.readByte() ; // width				var height : Number = ico.readByte() ; // height
				/*var colorCount : Number =*/ ico.readByte(); // color count				ico.readByte(); // reserved				/*var colorPlanes : Number =*/ ico.readShort(); // color planes				var bpp : int = ico.readShort(); // bpp				/*var size : uint =*/ ico.readUnsignedInt(); // bitmap data size				var offset : uint = ico.readUnsignedInt(); // bitmap data offset
				/*
				Log.debug( "width " + width +
						   "\nheight " + height +
						   "\ncolor count " + colorCount +						   "\ncolor planes " + colorPlanes +
						   "\nbpp " + bpp +
						   "\noffset " + offset +
						   "\nsize " + size );
				*/
				var prev : int = ico.position;
				ico.position = offset;

				var img : BitmapData = new BitmapData( width, height, true, 0x00000000 );

				readInfoHeader(ico);
				readData( ico, img, bpp );

				ico.position = prev;
				v.push( img );
			}
			return v;
		}
		/**
		 * @inheritDoc
		 */
		override public function get decodedType () : Class { return Vector; }
	}
}
