package abe.com.edia.sounds.processors
{
    import abe.com.edia.sounds.SoundProcessor;
    import abe.com.mon.core.Allocable;

    import flash.events.SampleDataEvent;
    import flash.media.Sound;
    import flash.media.SoundChannel;
    import flash.utils.ByteArray;

	/**
	 * @author Andre Michelle (andre.michelle@gmail.com)
	 */
	public class Pitch implements Allocable, SoundProcessor
	{
		private const BLOCK_SIZE: int = 3072;
		
		private var _targetSound: Sound;
		private var _sound: Sound;
		
		private var _target: ByteArray;
		
		private var _position: Number;
        private var _rate : Number;
        private var _channel : SoundChannel;
		
		public function Pitch( rate : Number = 1.0, targetSound : Sound = null )
		{
			_targetSound = targetSound;
            _rate = rate;
            init();
		}
        
        public function get input () : Sound { return _targetSound; }
        public function set input ( targetSound : Sound ) : void { _targetSound = targetSound; _position = 0; }

        public function get output () : Sound { return _sound; }
		public function set channel ( soundChannel : SoundChannel ) : void { _channel = soundChannel; }
        
		public function get rate(): Number { return _rate; }
		public function set rate( value: Number ): void
		{
			if( value < 0.0 )
				value = 0;

			_rate = value;
		}

        public function init () : void
        {
            _target = new ByteArray();
			_sound = new Sound();

			_position = 0.0;
            
			_sound.addEventListener( SampleDataEvent.SAMPLE_DATA, sampleData );
        }

        public function dispose () : void
        {
            _sound.removeEventListener( SampleDataEvent.SAMPLE_DATA, sampleData );

            _target = null;
            _sound = null;
        }

		private function sampleData( event: SampleDataEvent ): void
		{
			//-- REUSE INSTEAD OF RECREATION
			_target.position = 0;
			
			//-- SHORTCUT
			var data: ByteArray = event.data;
			
			var scaledBlockSize: Number = BLOCK_SIZE * _rate;
			var positionInt: int = _position;
                                   
			var alpha: Number = _position - positionInt;

			var positionTargetNum: Number = alpha;
			var positionTargetInt: int = -1;

			//-- COMPUTE NUMBER OF SAMPLES NEED TO PROCESS BLOCK (+2 FOR INTERPOLATION)
			var need: int = Math.ceil( scaledBlockSize ) + 2;
			
			//-- EXTRACT SAMPLES
			var read: int = _targetSound.extract( _target, need, positionInt );

			var n: int = read == need ? BLOCK_SIZE : read / _rate;

			var l0: Number;
			var r0: Number;
			var l1: Number;
			var r1: Number;

			for( var i: int = 0 ; i < n ; ++i )
			{
				//-- AVOID READING EQUAL SAMPLES, IF RATE < 1.0
				if( int( positionTargetNum ) != positionTargetInt )
				{
					positionTargetInt = positionTargetNum;
					
					//-- SET TARGET READ POSITION
					_target.position = positionTargetInt << 3;
					try
                    {
						//-- READ TWO STEREO SAMPLES FOR LINEAR INTERPOLATION
						l0 = _target.readFloat();
						r0 = _target.readFloat();
	
						l1 = _target.readFloat();
						r1 = _target.readFloat();
                    }
                    catch(e:Error)
                    {
                        l0 = 0;
                        r0 = 0;
                        l1 = 0;
                        r1 = 0;
                    }
				}
				
				//-- WRITE INTERPOLATED AMPLITUDES INTO STREAM
				data.writeFloat( l0 + alpha * ( l1 - l0 ) );
				data.writeFloat( r0 + alpha * ( r1 - r0 ) );
				
				//-- INCREASE TARGET POSITION
				positionTargetNum += _rate;
				
				//-- INCREASE FRACTION AND CLAMP BETWEEN 0 AND 1
				alpha += _rate;
				while( alpha >= 1.0 ) --alpha;
			}

			//-- INCREASE SOUND POSITION
            _position += scaledBlockSize;
            _position %= _targetSound.bytesLoaded*4;
        }
  	}
}

