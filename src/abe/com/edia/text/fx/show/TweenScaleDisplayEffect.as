/**
 * @license
 */
package abe.com.edia.text.fx.show 
{
	import abe.com.edia.text.core.Char;
	import abe.com.motion.Impulse;
	import abe.com.motion.ImpulseEvent;
	import abe.com.motion.easing.Linear;

	import flash.utils.Dictionary;
	/**
	 * @author Cédric Néhémie
	 */
	public class TweenScaleDisplayEffect extends DefaultTimedDisplayEffect
	{
		protected var activeChars : Vector.<Char>;
		protected var charsLife : Dictionary;
		protected var tweenDuration : Number;
		protected var sizexs : Dictionary;
		protected var sizeys : Dictionary;
		protected var easing : Function;

		public function TweenScaleDisplayEffect( delay : Number = 50, 
												 tweenDuration : Number = 500,
												 easing : Function = null, 
												 timeout : Number = 0, 
												 autoStart : Boolean = true )
		{
			super( delay, timeout, autoStart );
			this.tweenDuration = tweenDuration;
			this.easing = easing != null ? easing : Linear.easeNone;
		}

		override public function init () : void
		{
			activeChars = new Vector.<Char>( );
			charsLife = new Dictionary( true );
			sizexs = new Dictionary( true );
			sizeys = new Dictionary( true );
			
			var l : Number = chars.length;
			for(var i : Number = 0; i < l; i++ )
			{
				var char : Char = chars[ i ];
				sizexs[ char ] = char.width;
				sizeys[ char ] = char.height;
			}
			
			super.init();
		}
		override public function start () : void
		{
			super.start();
			Impulse.register( tick );
		}
		override public function stop () : void
		{
			super.stop();
			Impulse.unregister( tick );
		}
		override public function dispose () : void
		{
			activeChars = null;
			charsLife = null;
			stop();
			super.dispose();
		}

		override public function addChar (l : Char) : void
		{
			l.visible = false;
			super.addChar(l);
		}

		override public function tick ( e : ImpulseEvent ) : void
		{
			if( activeChars.length > 0 )
			{
				for each( var char : Char in activeChars )
				{
					var l : Number = charsLife[ char ];
					if( isNaN( l ) )
						charsLife[ char ] = l = 0;
					
					var r : Number = this.easing ( l, 0, 1, tweenDuration );
					
					char.charContent.scaleX = char.charContent.scaleY = r;
					
					updateCharPos( char, r );
					
					l = charsLife[ char ] += e.bias;
					
					if( l > tweenDuration )
					{
						char.charContent.scaleX = char.charContent.scaleY = 1;
						char.charContent.x = 0;
						char.charContent.y = 0;
						activeChars.splice( activeChars.indexOf( char ), 1 );
					}
						
					if( activeChars.length == 0 )
					{
						stop();
						fireComplete();
					}
				}
			}
		}

		override protected function showCharOnShowAll (char : Char) : void
		{
			showChar(char);
			char.charContent.scaleX = char.charContent.scaleY = 1;
			updateCharPos(char, 1);
		}

		override protected function processChar () : Char
		{
			var char : Char = iterator.next() as Char;
			
			if( char != null )
			{
				showChar(char);
				char.charContent.scaleX = char.charContent.scaleY = .1;
				initCharPos(char);
				activeChars.push( char );
			}
			
			if( !iterator.hasNext() )
			{
				interval.stop();
				fireComplete();
			}
			
			return char;
		}
		override public function showAll() : void
		{
			for each ( var char : Char in activeChars )
				showCharOnShowAll(char);
				
			activeChars.length = 0;
			Impulse.unregister( tick );
			
			super.showAll();
		}
		
		protected function initCharPos ( char : Char ) : void
		{
			char.charContent.x = ( sizexs[ char ] - sizexs[ char ] * .1 ) / 2;
			char.charContent.y = ( sizeys[ char ] - sizeys[ char ] * .1 ) / 2;
		}
		protected function updateCharPos ( char : Char, r : Number ) : void
		{
			char.charContent.x = ( sizexs[ char ] - sizexs[ char ] * r ) / 2;
			char.charContent.y = ( sizeys[ char ] - sizeys[ char ] * r ) / 2;
		}
	}
}

import abe.com.edia.text.core.Char;
import abe.com.mon.core.ListIterator;

/**
 * @author Cédric Néhémie
	 */
internal class VectorIterator implements ListIterator
{
	private var _aVector : Vector.<Char>;
	    private var _nSize : Number;
	    private var _nIndex : Number;
	    private var _nI : Number;
	    private var _bRemoved : Boolean;
	    private var _bAdded : Boolean;

		public function VectorIterator ( a : Vector.<Char>, i : uint = 0 )
	    {
	    	if( a == null )
	    		throw new Error( "The target Vector of " + this + "can't be null" );
	    	if( i > a.length )
	    		throw new Error ( "The passed-in index " + i + " is not a valid for an Vector of length " + a.length );
		
			_aVector = a;
			_bRemoved = false;
			_bAdded = false;
			_nI = i;
			reset();
		}
		public function reset () : void
		{
			_nSize = _aVector.length;
	        _nIndex = _nI - 1;
		}
	    public function hasNext () : Boolean
	    {
	        return ( _nIndex + 1 < _nSize );
	    }

	    public function next () : *
	    {
	    	if( !hasNext() )
				throw new Error ( this + " has no more elements at " + ( _nIndex + 1 ) );
			
	    	_bRemoved = false;
			_bAdded = false;
			return _aVector[ ++_nIndex ];
	    }

		public function remove () : void
		{
			if( _bRemoved )
			{
				_aVector.splice( _nIndex--, 1 );
				_nSize--;
				_bRemoved = true;
			}
			else
			{
				throw new Error ( this + ".remove() have been already called for this iteration" );
			}
		}

		public function add ( o : Object ) : void
		{
			if( !_bAdded )
			{
				_aVector.splice( _nIndex + 1, 0, o );
				_nSize++;
				_bAdded = true;
			}
			else
			{
				throw new Error ( this + ".add() have been already called for this iteration" );
			}
		}

		public function hasPrevious () : Boolean
		{
			return _nIndex >= 0;
		}

		public function nextIndex () : uint
		{
			return _nIndex + 1;
		}

		public function previous () : *
		{
			if( !hasPrevious() )
				throw new Error ( this + " has no more elements at " + ( _nIndex ) );
			
	    	_bRemoved = false;
			_bAdded = false;
			
			return _aVector[ _nIndex-- ];
		}

		public function previousIndex () : uint
		{
			return _nIndex;
		}

		public function set ( o : * ) : void
		{
		}
	}


