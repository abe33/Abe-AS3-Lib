package abe.com.mon.colors 
{
	/**
	 * @author cedric
	 */
	public class ColorBlending 
	{
		static public function multiply (v1 : uint,v2 : uint ) : uint
		{
			return v1 * v2 / 255;
		}
		static public function screen (v1 : uint,v2 : uint ) : uint
		{
			return v1 + v2 - v1 * v2 / 255;
		}
		static public function overlay (v1 : uint,v2 : uint ) : uint
		{
			return (v2 < 128) ? (2 * v1 * v2 / 255) : (255 - 2 * (255 - v1) * (255 - v2) / 255);
		}
		static public function softlight (v1 : uint,v2 : uint ) : uint
		{
			if ( v1 > 127.5 )
				return v2 + (255 - v2) * ((v1 - 127.5) / 127.5) * (0.5 - Math.abs( v2 - 127.5 ) / 255);
			else
				return v2 - v2 * ((127.5 - v1) / 127.5) * (0.5 - Math.abs( v2 - 127.5 ) / 255);
		}
		static public function hardlight (v1 : uint,v2 : uint ) : uint
		{
			if ( v1 > 127.5 )
				return v2 + (255 - v2) * ((v1 - 127.5) / 127.5);
			else
				return v2 * v1 / 127.5;
		}
		static public function colordodge (v1 : uint,v2 : uint ) : uint
		{
			return (v1 === 255) ? v1 : Math.min( 255, ((v2 << 8 ) / (255 - v1)) );
		}
		static public function colorburn (v1 : uint,v2 : uint ) : uint
		{
			return (v1 === 0) ? v1 : Math.max( 0, (255 - ((255 - v2) << 8 ) / v1) );
		}
		static public function linearcolordodge (v1 : uint,v2 : uint ) : uint
		{
			return Math.min( v1 + v2, 255 );
		}
		static public function linearcolorburn (v1 : uint,v2 : uint ) : uint
		{
			return ((v1 + v2) < 255) ? 0 : (v1 + v2 - 255);
		}
	}
}
