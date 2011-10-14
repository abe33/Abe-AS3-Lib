package abe.com.edia.sounds
{
	import flash.media.Sound;
	import flash.media.SoundChannel;
    /**
     * @author cedric
     */
    public class SoundPlayUnit
    {
        public var data 	: SoundData;
        public var channel 		: SoundChannel;
        public var processor 	: SoundProcessor;
        
		public var position 	: int;
		public var startTime 	: int;
		public var loops 		: int;
		public var volume 		: Number;
		public var paused 		: Boolean;
        public var pausedByAll 	: Boolean;

        public function SoundPlayUnit ( soundData : SoundData )
        {
            data = soundData;
			position = 0;
			volume = 1;
			startTime = 0;
			loops = 0;
			paused = false;
			pausedByAll = false;
        }
        public function get sound():Sound 
        {
            if( processor )
            {
                processor.input = data.sound;
                return processor.output;
            }
            else return data.sound;
        }

    }
}
