/**
 * @license
 */
package abe.com.edia.text.fx.show 
{
    import abe.com.edia.text.core.Char;
    import abe.com.edia.text.fx.AbstractCharEffect;
    import abe.com.mands.Interval;
    import abe.com.mands.Timeout;

    import flash.events.Event;
	/**
	 * @author Cédric Néhémie
	 */
	public class DefaultTimedDisplayEffect extends AbstractCharEffect implements TimedDisplayEffect
	{
		protected var timeout : Timeout;
		protected var interval : Interval;
		protected var iterator : VectorIterator;

		public function DefaultTimedDisplayEffect( delay : Number = 50, start : Number = 0, autoStart : Boolean = true )
		{
			super( autoStart );
			this.interval = new Interval( processChar, delay );
			this.timeout = new Timeout( interval.execute, start );
		}
		override public function start() : void
		{
			_isRunning = true;
			timeout.start();
		}
		override public function stop() : void
		{
			_isRunning = false;
			timeout.stop();
			interval.stop();
		}
		public function reset () : void
		{
			if( timeout )
			{
				timeout.stop();
				timeout.reset();
			}
			if( interval )
			{
				interval.stop();
				interval.reset();
			}
			if( iterator )
				iterator.reset();
			
			for each( var c : Char in chars )
				if( c )
					c.visible = false;
		}
		override public function init () : void
		{
			super.init();
			iterator = new VectorIterator( chars );
		}
		override public function dispose () : void
		{
			super.stop();
			super.dispose();
			iterator = null;
		}

		override public function addChar (l : Char) : void
		{
			super.addChar(l);
			l.visible = false;
		}

		
		protected function processChar () : Char
		{
			var char : Char = iterator.next() as Char;
			
			if( char != null )
			{
				showChar(char);
			}
			
			if( !iterator.hasNext() )
				charProcessingComplete();
			
			return char;
		}
		protected function charProcessingComplete() : void
		{
			stop();
			fireComplete();
		}
		
		public function showAll() : void
		{
			interval.stop();
			timeout.stop();
			
			while( iterator.hasNext() )
			{
				var char : Char = iterator.next() as Char;
			
				if( char != null )
				{
					showCharOnShowAll(char);
				}
			}
			
			fireComplete();
		}
		public function fireComplete () : void
		{
			dispatchEvent( new Event( Event.COMPLETE ) );
		}
		protected function showChar (  char : Char  ) : void
		{
			char.visible = true;
		}
		protected function showCharOnShowAll( char : Char ) : void
		{
			showChar( char );
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


