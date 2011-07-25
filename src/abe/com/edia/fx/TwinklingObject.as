package abe.com.edia.fx
{
	import abe.com.mon.core.Allocable;
	import abe.com.mon.core.LayeredSprite;
	import abe.com.mon.core.Randomizable;
	import abe.com.mon.core.Runnable;
	import abe.com.mon.core.Suspendable;
	import abe.com.mon.randoms.Random;
	import abe.com.mon.utils.AllocatorInstance;
	import abe.com.mon.utils.RandomUtils;
	import abe.com.motion.Impulse;
	import abe.com.motion.ImpulseListener;

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	/**
	 * @author Cédric Néhémie
	 */
	public class TwinklingObject implements ImpulseListener, Runnable, Suspendable, Allocable, Randomizable
	{
		[Embed(source="particles-collection.swf", symbol="star")]
		static public var star : Class;

		protected var particles : Dictionary;
		protected var _isRunning : Boolean;
		protected var _numParticles : uint;
		protected var _target : LayeredSprite;

		public function TwinklingObject ( target : LayeredSprite, numParticles : uint = 10 )
		{
			_target = target;
			_numParticles = numParticles;
			_randomSource = RandomUtils.RANDOM;
		}

		protected var _randomSource : Random;
		public function get randomSource () : Random { return _randomSource; }
		public function set randomSource (randomSource : Random) : void
		{
			_randomSource = randomSource;
		}

		public function tick (bias : Number, biasInSeconds : Number, time : Number) : void
		{
			for each( var p : DisplayObject in particles )
				if( _randomSource.boolean(.3) )
				{
					var bb : Rectangle = _target.middle.getBounds(_target as DisplayObject);
					setupParticle( p, bb );
				}
		}
		public function isRunning () : Boolean { return _isRunning; }

		public function start () : void
		{
			if( !_isRunning )
			{
				_isRunning = true;
				Impulse.register( tick );
			}
		}

		public function stop () : void
		{
			if( _isRunning )
			{
				Impulse.unregister( tick );
				_isRunning = false;
			}
		}

		public function init () : void
		{
			particles = new Dictionary ( true );
			var bb : Rectangle = _target.middle.getBounds(_target as DisplayObject);
			for( var i : int = 0; i < _numParticles; i++ )
			{
				var p : DisplayObject = AllocatorInstance.get(star) as DisplayObject;
				particles[p] = p
				setupParticle( p, bb );
				_target.foreground.addChild(p);
			}
			start();
		}
		public function dispose () : void
		{
			for( var c : * in particles )
			{
				var p : DisplayObject = particles[c];
				var pp : DisplayObjectContainer = (c as DisplayObject).parent;

				if( pp && pp.contains( p ) )
					pp.removeChild(p );

				AllocatorInstance.release( particles[c] );
				delete particles[c];
			}
			particles = null;
		}
		protected function setupParticle ( p : DisplayObject, r : Rectangle ) : void
		{
			p.scaleX = p.scaleY = _randomSource.rangeAB(.5,1);
			p.x = _randomSource.rangeAB( r.x, r.x + r.width );
			p.y = _randomSource.rangeAB( r.y, r.y + r.height );
		}
	}
}
