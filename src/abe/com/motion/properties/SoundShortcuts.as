package abe.com.motion.properties
{
    import abe.com.motion.AbstractTween;

    import flash.media.SoundTransform;
	/**
	 * @author Cédric Néhémie
	 */
	public class SoundShortcuts
	{
		public static function init ():void
		{
			// Normal properties
			AbstractTween.registerSpecialProperty ( "sound_volume", sound_volume_get, sound_volume_set );
			AbstractTween.registerSpecialProperty ( "sound_volume", sound_volume_get, sound_volume_set );
		}

		public static function sound_volume_get ( obj : Object, args : Array = null ):Number
		{
			return obj.soundTransform.volume;
		}
		public static function sound_volume_set ( obj : Object, value : Number, args : Array = null ):void
		{
			var sndTransform : SoundTransform = obj.soundTransform;
			sndTransform.volume = value;
			obj.soundTransform = sndTransform;
		}

		public static function sound_pan_get ( obj : Object, args : Array = null ):Number
		{
			return obj.soundTransform.pan;
		}
		public static function sound_pan_set ( obj : Object, value : Number, args : Array = null ):void
		{
			var sndTransform : SoundTransform = obj.soundTransform;
			sndTransform.pan = value;
			obj.soundTransform = sndTransform;
		}
	}
}
