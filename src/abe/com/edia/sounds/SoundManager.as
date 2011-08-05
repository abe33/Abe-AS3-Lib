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
		// singleton instance
		private static var _instance:SoundManager;

		private var _soundsDict:Dictionary;
		private var _sounds:Array;

		private var _channelsDict : Dictionary;

		static public const MAX_CHANNELS_PER_SOUND : uint = 4;

		/**
		 *
		 */
		public static function getInstance():SoundManager
		{
			if (SoundManager._instance == null)
				SoundManager._instance = new SoundManager();
			return SoundManager._instance;
		}

		/**
		 *
		 */
		public function SoundManager()
		{
			SoundShortcuts.init();
			_soundsDict = new Dictionary(true);
			_sounds = new Array();
			_channelsDict = new Dictionary( true );
		}
		/**
		 *
		 */
		public function get sounds():Array { return this._sounds; }

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
			for (var i:int = 0; i < this._sounds.length; i++)
				if (this._sounds[i].name == name)
					return false;

			var sndObj:SoundObject = new SoundObject();
			var snd:Sound = new linkageID;
			sndObj.name = name;
			sndObj.sound = snd;
			sndObj.channel = new SoundChannel();
			sndObj.position = 0;
			sndObj.paused = true;
			sndObj.volume = 1;
			sndObj.startTime = 0;
			sndObj.loops = 0;
			sndObj.pausedByAll = false;
			sndObj.numChannels = 0;
			sndObj.maxChannels = maxChannels;
			this._soundsDict[name] = sndObj;
			this._sounds.push(sndObj);
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
		public function addExternalSound(path:String, name:String, buffer:Number = 1000, checkPolicyFile:Boolean = false, maxChannels : uint = MAX_CHANNELS_PER_SOUND):Boolean
		{
			for (var i:int = 0; i < this._sounds.length; i++)
				if (this._sounds[i].name == name)
					return false;

			var sndObj:SoundObject = new SoundObject();
			var snd:Sound = new Sound(new URLRequest(path), new SoundLoaderContext(buffer, checkPolicyFile));
			sndObj.name = name;
			sndObj.sound = snd;
			sndObj.channel = new SoundChannel();
			sndObj.position = 0;
			sndObj.paused = true;
			sndObj.volume = 1;
			sndObj.startTime = 0;
			sndObj.loops = 0;
			sndObj.pausedByAll = false;
			sndObj.numChannels = 0;
			sndObj.maxChannels = maxChannels;
			this._soundsDict[name] = sndObj;
			this._sounds.push(sndObj);
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
			for (var i:int = 0; i < this._sounds.length; i++)
			{
				if (this._sounds[i].name == name)
				{
					this._sounds[i] = null;
					this._sounds.splice(i, 1);
				}
			}
			delete this._soundsDict[name];
		}
		/**
		 * Removes all sounds from the sound dictionary.
		 *
		 * @return void
		 */
		public function removeAllSounds():void
		{
			for (var i:int = 0; i < this._sounds.length; i++)
				this._sounds[i] = null;

			this._sounds = new Array();
			this._soundsDict = new Dictionary(true);
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
		public function playSound(name:String, volume:Number = 1, startTime:Number = 0, loops:int = 0):void
		{
			var snd:SoundObject = this._soundsDict[name];

			if( !snd )
				return;

			if( snd.numChannels + 1 > snd.maxChannels )
				return;

			try
			{
				snd.volume = volume;
				snd.startTime = startTime;
				snd.loops = loops;


				if (snd.paused)
					snd.channel = snd.sound.play( snd.position, 0, new SoundTransform( snd.volume ));
				else
					snd.channel = snd.sound.play ( startTime, snd.loops, new SoundTransform ( snd.volume ) );

				snd.channel.addEventListener ( Event.SOUND_COMPLETE, soundComplete );
				_channelsDict[ snd.channel ] = snd;

				snd.numChannels++;
				snd.paused = false;
			}
			catch( e : Error )
			{
				/*FDT_IGNORE*/ CONFIG::DEBUG { /*FDT_IGNORE*/
					Log.error( "Error in SoundManager.playsound for sound " + name +"\n" + e.message + "\n" + e.getStackTrace() );
				/*FDT_IGNORE*/ } /*FDT_IGNORE*/
			}
		}

		protected function soundComplete ( event : Event ) : void
		{
			var volume : Number = (event.target as SoundChannel).soundTransform.volume;
			var snd : SoundObject = _channelsDict[event.target];
			event.target.removeEventListener ( Event.SOUND_COMPLETE, soundComplete );
			_channelsDict[event.target].numChannels--;
			delete _channelsDict[event.target];

			if( snd.loops )
			{
				snd.loops--;
				playSound ( snd.name, volume, 0, snd.loops );
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
			var snd : SoundObject = this._soundsDict[name];
			if( snd && snd.channel )
			{
				//snd.paused = true;
				snd.channel.stop();
				snd.channel.removeEventListener ( Event.SOUND_COMPLETE, soundComplete );
				snd.numChannels = 0;
				delete _channelsDict[snd.channel];
				/*
				snd.channel.removeEventListener ( Event.SOUND_COMPLETE, soundComplete );
				snd.numChannels--;
				delete _channelsDict[snd.channel];*/
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
			var snd : SoundObject = this._soundsDict[name];
			if( snd && snd.channel )
			{
				snd.paused = true;
				snd.position = snd.channel.position;
				snd.channel.stop ();
				snd.channel.removeEventListener ( Event.SOUND_COMPLETE, soundComplete );
				snd.numChannels--;
				delete _channelsDict[snd.channel];
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
			for (var i:int = 0; i < this._sounds.length; i++)
			{
				var id:String = this._sounds[i].name;
				if (useCurrentlyPlayingOnly)
				{
					if ( this._soundsDict[id] && this._soundsDict[id].pausedByAll)
					{
						this._soundsDict[id].pausedByAll = false;
						this.playSound(id, _sounds[i].volume, 0, _sounds[i].loops );
					}
				}
				else
				{
					this.playSound(id, _sounds[i].volume, 0, _sounds[i].loops);
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
			for (var i:int = 0; i < this._sounds.length; i++)
			{
				var id:String = this._sounds[i].name;
				if (useCurrentlyPlayingOnly)
				{
					if (!this._soundsDict[id].paused)
					{
						//this._soundsDict[id].pausedByAll = true;
						this.stopSound(id);
					}
				}
				else
				{
					this.stopSound(id);
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
			for (var i:int = 0; i < this._sounds.length; i++)
			{
				var id:String = this._sounds[i].name;
				if (useCurrentlyPlayingOnly)
				{
					if (!this._soundsDict[id].paused)
					{
						this._soundsDict[id].pausedByAll = true;
						this.pauseSound(id);
					}
				}
				else
				{
					this.pauseSound(id);
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
			var snd : SoundObject = this._soundsDict[name];
			SingleTween.add ( snd.channel, { setter:"sound_volume", end:targVolume, duration:fadeLength } );
		}
		public function spacializeSound( name:String, position : Number = 0, volume : Number = 1 ):void
		{
			var snd : SoundObject = this._soundsDict[name];
			snd.channel.soundTransform = new SoundTransform(volume, position );
		}

		/**
		 * Mutes the volume for all sounds in the sound dictionary.
		 *
		 * @return void
		 */
		public function muteAllSounds():void
		{
			for (var i:int = 0; i < this._sounds.length; i++)
			{
				var id:String = this._sounds[i].name;
				this.setSoundVolume(id, 0);
			}
		}
		/**
		 * Resets the volume to their original setting for all sounds in the sound dictionary.
		 *
		 * @return void
		 */
		public function unmuteAllSounds():void
		{
			for (var i:int = 0; i < this._sounds.length; i++)
			{
				var id:String = this._sounds[i].name;
				var snd:SoundObject = this._soundsDict[id];
				var curTransform:SoundTransform = snd.channel.soundTransform;
				curTransform.volume = snd.volume;
				snd.channel.soundTransform = curTransform;
			}
		}
		public function setAllSoundVolume( volume : Number ) : void
		{
			for (var i:int = 0; i < this._sounds.length; i++)
			{
				var id:String = this._sounds[i].name;
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
			var snd : SoundObject = this._soundsDict[name];
			if( snd && snd.channel )
			{
				var curTransform:SoundTransform = snd.channel.soundTransform;
				curTransform.volume = volume;
				snd.volume = volume;
				snd.channel.soundTransform = curTransform;
			}
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
			return this._soundsDict[name].channel.soundTransform.volume;
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
			return this._soundsDict[name].channel.position;
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
			return this._soundsDict[name].sound.length;
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
			return this._soundsDict[name].sound;
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
			return this._soundsDict[name].paused;
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
			return this._soundsDict[name].pausedByAll;
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
	public var channel : SoundChannel;
	public var position : int;
	public var paused : Boolean;
	public var volume : Number;
	public var startTime : int;
	public var loops : int;
	public var pausedByAll : Boolean;
	public var numChannels : int;	public var maxChannels : uint;
}