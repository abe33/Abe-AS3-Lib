package abe.com.edia.sounds
{
    import abe.com.mon.logs.Log;
    import abe.com.motion.SingleTween;
    import abe.com.motion.properties.SoundShortcuts;

    import flash.events.Event;
    import flash.media.Sound;
    import flash.media.SoundChannel;
    import flash.media.SoundLoaderContext;
    import flash.media.SoundTransform;
    import flash.net.URLRequest;
    import flash.utils.Dictionary;
    import flash.utils.getQualifiedClassName;
	public class SoundManager
	{
		/*-----------------------------------------------------------------------------*
		 * PRIVATE & PROTECTED VARIABLES
		 *-----------------------------------------------------------------------------*/
		
		private var _soundsDict:Dictionary;
		private var _channelsDict:Dictionary;
		private var _sounds:Array;

		static public const MAX_CHANNELS_PER_SOUND : uint = 2;

		/**
		 *
		 */
		public function SoundManager()
		{
			SoundShortcuts.init();
			_soundsDict = new Dictionary(true);
			_channelsDict = new Dictionary(true);
			_sounds = new Array();
		}
		/**
		 *
		 */
		public function get sounds():Array { return _sounds; }

		/**
		 * Adds a sound from the library to the sounds dictionary for playing in the future.
		 *
		 * @param linkageID The class name of the library symbol that was exported for AS
		 * @param name The string identifier of the sound to be used when calling other methods on the sound
		 *
		 * @return Boolean A boolean value representing if the sound was added successfully
		 */
		public function addLibrarySound( linkageID:*, name:String, maxChannels : uint = MAX_CHANNELS_PER_SOUND ):Boolean
		{
			for (var i:int = 0; i < _sounds.length; i++)
				if (_sounds[i].name == name)
					return false;

			var sndObj:SoundData = new SoundData();
			var snd:Sound = new linkageID;
			sndObj.name = name;
			sndObj.sound = snd;
			sndObj.numChannels = 0;
			sndObj.maxChannels = maxChannels;
			_soundsDict[name] = sndObj;
			_sounds.push(sndObj);
/*
			sndObj.channel = new SoundChannel();
			sndObj.position = 0;
			sndObj.paused = true;
			sndObj.volume = 1;
			sndObj.startTime = 0;
			sndObj.loops = 0;
			sndObj.pausedByAll = false;*/
			return true;
		}
		/**
		 * Adds an external sound to the sounds dictionary for playing in the future.
		 *
		 * @param path A string representing the path where the sound is on the server
		 * @param name The string identifier of the sound to be used when calling other methods on the sound
		 * @param buffer The number, in milliseconds, to buffer the sound before you can play it (default: 1000)
		 * @param checkPolicyFile A boolean that determines whether Flash Player should try to download a cross-domain policy file from the loaded sound's server before beginning to load the sound (default: false)
		 *
		 * @return Boolean A boolean value representing if the sound was added successfully
		 */
		public function addExternalSound( path:String, 
        								  name:String, 
                                          callback : Function = null,
                                          buffer:Number = 1000, 
                                          checkPolicyFile:Boolean = false, 
                                          maxChannels : uint = MAX_CHANNELS_PER_SOUND
                                        ) : Boolean
		{
            var i : int;
            var l : int;
			for ( i = 0, l = _sounds.length; i < l; i++)
				if (_sounds[i].name == name)
					return false;

			var sndObj:SoundData = new SoundData();
			var snd:Sound = new Sound();
			sndObj.name = name;
			sndObj.sound = snd;
			sndObj.numChannels = 0;
			sndObj.maxChannels = maxChannels;
/*
			sndObj.channel = new SoundChannel();
			sndObj.position = 0;
			sndObj.paused = true;
			sndObj.volume = 1;
			sndObj.startTime = 0;
			sndObj.loops = 0;
			sndObj.pausedByAll = false;*/
			_soundsDict[name] = sndObj;
			_sounds.push(sndObj);
            
            if( callback != null )
            	snd.addEventListener(Event.COMPLETE, callback );
            
            snd.load(new URLRequest(path), new SoundLoaderContext(buffer, checkPolicyFile));
			return true;
		}
		/**
		 * Removes a sound from the sound dictionary.  After calling this, the sound will not be available until it is re-added.
		 *
		 * @param name The string identifier of the sound to remove
		 *
		 * @return void
		 */
		public function removeSound(name:String):void
		{
            var l : int = _sounds.length ;
			while (--l -(-1))
			{
				if ( _sounds[l].name == name )
				{
					_sounds[l] = null;
					_sounds.splice(l, 1);
				}
			}
			delete _soundsDict[name];
		}
		/**
		 * Removes all sounds from the sound dictionary.
		 *
		 * @return void
		 */
		public function removeAllSounds():void
		{
            var l : int = _sounds.length ;
			while (--l -(-1))
				_sounds[l] = null;

			_sounds = new Array();
			_soundsDict = new Dictionary(true);
		}
		/**
		 * Plays or resumes a sound from the sound dictionary with the specified name.
		 *
		 * @param name The string identifier of the sound to play
		 * @param volume A number from 0 to 1 representing the volume at which to play the sound (default: 1)
		 * @param startTime A number (in milliseconds) representing the time to start playing the sound at (default: 0)
		 * @param loops An integer representing the number of times to loop the sound (default: 0)
		 *
		 * @return void
		 */
		public function playSound( name:String, 
        						   volume:Number = 1,
								   startTime:Number = 0, 
                                   loops:int = 0,
                                   processor : SoundProcessor = null
                                 ) : void
		{
            var sd : SoundData = _soundsDict[name];

			if( !sd )
				return;

			if( sd.numChannels + 1 > sd.maxChannels )
				return;

			try
			{
				var snd:SoundPlayUnit = new SoundPlayUnit( sd );
                sd.playUnits.push(snd);
				sd.numChannels++;
                
                snd.processor = processor;
				snd.volume = volume;
				snd.startTime = startTime;
				snd.loops = loops;

				if (snd.paused)
					snd.channel = snd.sound.play( snd.position, 0, new SoundTransform( snd.volume ));
				else
					snd.channel = snd.sound.play ( startTime, snd.loops, new SoundTransform ( snd.volume ) );
				
                if( snd.processor )
                	snd.processor.channel = snd.channel;

				snd.channel.addEventListener ( Event.SOUND_COMPLETE, soundComplete );

				snd.paused = false;
                
                _channelsDict[snd.channel] = snd;
			}
			catch( e : Error )
			{
				CONFIG::DEBUG {
					Log.error( "Error in SoundManager.playsound for sound " + name + "\n" + e.message + "\n" + e.getStackTrace() );
				}
			}
		}

		protected function soundComplete ( event : Event ) : void
		{
			var volume : Number = (event.target as SoundChannel).soundTransform.volume;
			var snd : SoundPlayUnit = _channelsDict[event.target];
			event.target.removeEventListener ( Event.SOUND_COMPLETE, soundComplete );
            snd.data.playUnits.splice( snd.data.playUnits.indexOf( snd ), 1 );
            snd.data.numChannels--;
			delete _channelsDict[event.target];

			if( snd.loops )
			{
				snd.loops--;
				playSound ( snd.data.name, volume, 0, snd.loops, snd.processor );
			}
		}
		/**
		 * Stops the specified sound.
		 *
		 * @param name The string identifier of the sound
		 *
		 * @return void
		 */
		public function stopSound(name:String):void
		{
            var sd : SoundData = _soundsDict[name];
            for each( var snd : SoundPlayUnit in sd.playUnits )
            {               
				if( snd && snd.channel )
				{
					//snd.paused = true;
					snd.channel.stop();
					snd.channel.removeEventListener ( Event.SOUND_COMPLETE, soundComplete );
					snd.data.numChannels = 0;
					delete _channelsDict[snd.channel];
					/*
					snd.channel.removeEventListener ( Event.SOUND_COMPLETE, soundComplete );
					snd.numChannels--;
					delete _channelsDict[snd.channel];*/
				}
            }
		}
		/**
		 * Pauses the specified sound.
		 *
		 * @param name The string identifier of the sound
		 *
		 * @return void
		 */
		public function pauseSound(name:String):void
		{
			var sd : SoundData = _soundsDict[name];
            for each( var snd : SoundPlayUnit in sd.playUnits )
            {                
				if( snd && snd.channel )
				{
					snd.paused = true;
					snd.position = snd.channel.position;
					snd.channel.stop ();
					snd.channel.removeEventListener ( Event.SOUND_COMPLETE, soundComplete );
					snd.data.numChannels--;
					delete _channelsDict[snd.channel];
				}
            }
		}
		/**
		 * Plays all the sounds that are in the sound dictionary.
		 *
		 * @param useCurrentlyPlayingOnly A boolean that only plays the sounds which were currently playing before a pauseAllSounds() or stopAllSounds() call (default: false)
		 *
		 * @return void
		 */
		public function playAllSounds(useCurrentlyPlayingOnly:Boolean = false):void
		{
			for (var i:int = 0; i < _sounds.length; i++)
			{
				var id:String = _sounds[i].name;
				if (useCurrentlyPlayingOnly)
				{
					if ( _soundsDict[id] && _soundsDict[id].pausedByAll)
					{
						_soundsDict[id].pausedByAll = false;
						playSound(id, _sounds[i].volume, 0, _sounds[i].loops );
					}
				}
				else
				{
					playSound(id, _sounds[i].volume, 0, _sounds[i].loops);
				}
			}
		}
		/**
		 * Stops all the sounds that are in the sound dictionary.
		 *
		 * @param useCurrentlyPlayingOnly A boolean that only stops the sounds which are currently playing (default: true)
		 *
		 * @return void
		 */
		public function stopAllSounds(useCurrentlyPlayingOnly:Boolean = true):void
		{
			for (var i:int = 0; i < _sounds.length; i++)
			{
				var id:String = _sounds[i].name;
				if (useCurrentlyPlayingOnly)
				{
					if (!_soundsDict[id].paused)
					{
						//_soundsDict[id].pausedByAll = true;
						stopSound(id);
					}
				}
				else
				{
					stopSound(id);
				}
			}
		}
		/**
		 * Pauses all the sounds that are in the sound dictionary.
		 *
		 * @param useCurrentlyPlayingOnly A boolean that only pauses the sounds which are currently playing (default: true)
		 *
		 * @return void
		 */
		public function pauseAllSounds(useCurrentlyPlayingOnly:Boolean = true):void
		{
			for (var i:int = 0; i < _sounds.length; i++)
			{
				var id:String = _sounds[i].name;
				if (useCurrentlyPlayingOnly)
				{
					if (!_soundsDict[id].paused)
					{
						_soundsDict[id].pausedByAll = true;
						pauseSound(id);
					}
				}
				else
				{
					pauseSound(id);
				}
			}
		}
		/**
		 * Fades the sound to the specified volume over the specified amount of time.
		 *
		 * @param name The string identifier of the sound
		 * @param targVolume The target volume to fade to, between 0 and 1 (default: 0)
		 * @param fadeLength The time to fade over, in milli-seconds (default: 1)
		 *
		 * @return void
		 */
		public function fadeSound(name:String, targVolume:Number = 0, fadeLength:Number = 1000 ):void
		{
			var sd : SoundData = _soundsDict[name];
            for each( var snd : SoundPlayUnit in sd.playUnits )
				SingleTween.add ( snd.channel, { setter:"sound_volume", end:targVolume, duration:fadeLength } );
		}
		public function spacializeSound( name:String, position : Number = 0, volume : Number = 1 ):void
		{
			var sd : SoundData = _soundsDict[name];
            for each( var snd : SoundPlayUnit in sd.playUnits )
				snd.channel.soundTransform = new SoundTransform(volume, position );
		}

		/**
		 * Mutes the volume for all sounds in the sound dictionary.
		 *
		 * @return void
		 */
		public function muteAllSounds():void
		{
			for (var i:int = 0; i < _sounds.length; i++)
			{
				var id:String = _sounds[i].name;
				setSoundVolume(id, 0);
			}
		}
		/**
		 * Resets the volume to their original setting for all sounds in the sound dictionary.
		 *
		 * @return void
		 */
		public function unmuteAllSounds():void
		{
			for (var i:int = 0; i < _sounds.length; i++)
			{
				var id:String = _sounds[i].name;
				var sd : SoundData = _soundsDict[id];
            	for each( var snd : SoundPlayUnit in sd.playUnits )
                {
					var curTransform:SoundTransform = snd.channel.soundTransform;
					curTransform.volume = snd.volume;
					snd.channel.soundTransform = curTransform;
                }
			}
		}
        
		public function setAllSoundVolume( volume : Number ) : void
		{
			for (var i:int = 0; i < _sounds.length; i++)
			{
				var id:String = _sounds[i].name;
				setSoundVolume( id, volume);
			}
		}
		/**
		 * Sets the volume of the specified sound.
		 *
		 * @param name The string identifier of the sound
		 * @param volume The volume, between 0 and 1, to set the sound to
		 *
		 * @return void
		 */
		public function setSoundVolume(name:String, volume:Number):void
		{
			var sd : SoundData = _soundsDict[name];
            for each( var snd : SoundPlayUnit in sd.playUnits )
            {
				if( snd && snd.channel )
				{
					var curTransform:SoundTransform = snd.channel.soundTransform;
					curTransform.volume = volume;
					snd.volume = volume;
					snd.channel.soundTransform = curTransform;
				}
            }
		}
        public function getSoundUnits(name:String):Array
        {
            return _soundsDict[name].playUnits;
        }
		/**
		 * Gets the volume of the specified sound.
		 *
		 * @param name The string identifier of the sound
		 *
		 * @return Number The current volume of the sound
		 */
		public function getSoundVolume(name:String):Number
		{
			return _soundsDict[name].playUnits[0].channel.soundTransform.volume;
		}
		/**
		 * Gets the position of the specified sound.
		 *
		 * @param name The string identifier of the sound
		 *
		 * @return Number The current position of the sound, in milliseconds
		 */
		public function getSoundPosition(name:String):Number
		{
			return _soundsDict[name].playUnits[0].channel.position;
		}
		/**
		 * Gets the duration of the specified sound.
		 *
		 * @param name The string identifier of the sound
		 *
		 * @return Number The length of the sound, in milliseconds
		 */
		public function getSoundDuration(name:String):Number
		{
			return _soundsDict[name].playUnits[0].sound.length;
		}
		/**
		 * Gets the sound object of the specified sound.
		 *
		 * @param name The string identifier of the sound
		 *
		 * @return Sound The sound object
		 */
		public function getSoundObject(name:String):Sound
		{
			return _soundsDict[name].sound;
		}
		/**
		 * Identifies if the sound is paused or not.
		 *
		 * @param name The string identifier of the sound
		 *
		 * @return Boolean The boolean value of paused or not paused
		 */
		public function isSoundPaused(name:String):Boolean
		{
			return _soundsDict[name].playUnits[0].paused;
		}
		/**
		 * Identifies if the sound was paused or stopped by calling the stopAllSounds() or pauseAllSounds() methods.
		 *
		 * @param name The string identifier of the sound
		 *
		 * @return Number The boolean value of pausedByAll or not pausedByAll
		 */
		public function isSoundPausedByAll(name:String):Boolean
		{
			return _soundsDict[name].playUnits[0].pausedByAll;
		}
		/**
		 *
		 */
		public function toString():String
		{
			return getQualifiedClassName(this);
		}
	}
}
import flash.media.Sound;
import flash.media.SoundChannel;

internal class SoundObject
{
	public var name : String;
	public var sound : Sound;
	public var numChannels : int;	public var maxChannels : uint;
    
	public var channel : SoundChannel;
	public var position : int;
	public var paused : Boolean;
	public var volume : Number;
	public var startTime : int;
	public var loops : int;
	public var pausedByAll : Boolean;
}