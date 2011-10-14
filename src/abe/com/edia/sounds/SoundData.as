package abe.com.edia.sounds
{
    import flash.media.Sound;
    /**
     * @author cedric
     */
    public class SoundData
    {
        public var name : String;
		public var sound : Sound;
		public var numChannels : int;
		public var maxChannels : uint;
        public var playUnits : Array;

        public function SoundData ()
        {
            playUnits = [];
        }
    }
}
