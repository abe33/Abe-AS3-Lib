/**
 * @license
 */
package abe.com.edia.fx 
{
	import abe.com.mon.core.Allocable;
	import abe.com.mon.core.Randomizable;
	import abe.com.mon.core.Runnable;
	import abe.com.mon.core.Suspendable;
	import abe.com.mon.utils.AllocatorInstance;
	import abe.com.mon.colors.Color;
	import abe.com.mon.randoms.Random;
	import abe.com.mon.utils.RandomUtils;
	import abe.com.motion.Impulse;
	import abe.com.motion.ImpulseEvent;
	import abe.com.motion.ImpulseListener;

	import flash.display.Shape;
	import flash.filters.GlowFilter;
	/**
	 * @author Cédric Néhémie
	 */
	public class Sparckles extends Shape implements ImpulseListener, Runnable, Suspendable, Allocable, Randomizable
	{
		public var sparckles : Vector.<Sparckle>;
		public var sparcklesNum : Number;
		public var sparcklesColor : Color;
		public var glowColor : Color;
		public var sparcklesSize : uint;
		
		protected var _isRunning : Boolean;

		public function Sparckles ( x : Number = 0, 
									y : Number = 0, 
									sparcklesNum : Number = 25,
									sparcklesSize : uint = 1,
									sparcklesColor : Color = null,
									glowColor : Color = null  )
		{
			this.x = x;
			this.y = y;
			this.sparcklesNum = sparcklesNum;
			this.sparcklesSize = sparcklesSize;
			this.sparcklesColor = sparcklesColor ? sparcklesColor : Color.White;
			this.glowColor = glowColor ? glowColor : Color.DeepSkyBlue;
			_randomSource = RandomUtils.RANDOM;
		}

		protected var _randomSource : Random;
		public function get randomSource () : Random { return _randomSource; }
		public function set randomSource (randomSource : Random) : void
		{
			_randomSource = randomSource;
		}

		public function init () : void
		{
			this.filters = [ new GlowFilter ( glowColor.hexa, 1, 3, 3, 1 ) ];
			reset();
			start();
		}		
		public function dispose () : void
		{
			if( isRunning() )
				stop();
			
			this.filters = [];
			this.graphics.clear();
			this.sparckles = null;
		}

		public function isRunning () : Boolean { return _isRunning; }
		public function start() : void
		{
			_isRunning = true;
			Impulse.register( tick );
		}
		public function stop() : void
		{
			_isRunning = false;
			Impulse.unregister( tick );
		}
		public function reset() : void
		{
			this.sparckles = new Vector.<Sparckle>();
			for ( var i : Number = 0; i < sparcklesNum; i++ )
			{
				sparckles.push( new Sparckle( 100 + _randomSource.random( 300 ), 0, 0, _randomSource ) ); 
			}
		}

		public function draw ( s : Sparckle ) : void
		{
			this.graphics.lineStyle( sparcklesSize, sparcklesColor.hexa, sparcklesColor.alpha );
			this.graphics.moveTo( s.lastX, s.lastY );
			this.graphics.lineTo( s.x, s.y );
		}

		public function tick ( e : ImpulseEvent ) : void
		{
			this.graphics.clear();
			if( sparckles )
			{
				var l : Number = sparckles.length;
				if( l >= 1 )
				{
					while ( l-- )
					{
						var s : Sparckle = sparckles[ l ];
						s.life -= e.bias;
						
						if( !s )
						{
							continue;
						}
						
						if( s.life <= 0 )
						{
							sparckles.splice( l, 1 );
							continue;
						}
						var tx : Number = s.x;
						var ty : Number = s.y;
						
						s.x += s.x - s.lastX;
						s.y += s.y - s.lastY;
						s.y += 9 * e.biasInSeconds;
						
						draw ( s );
						
						s.lastX = tx;
						s.lastY = ty;
					}
				}
				
				if( sparckles.length == 0 )
				{
					stop();
					if( this.parent )
						this.parent.removeChild( this );
					AllocatorInstance.release( this );
				}
			}
		}
	}
}

import abe.com.mon.randoms.Random;

internal class Sparckle 
{
	public var x : Number;
	public var y : Number;
	public var lastX : Number;
	public var lastY : Number;
	public var life : Number;
	
	public function Sparckle ( life : Number = 300, x : Number = 0, y : Number = 0, randomSource : Random = null )
	{
		this.lastX = x;
		this.lastY = y;
		this.x = randomSource.balance( 10 );
		this.y = randomSource.balance( 10 );
		this.life = life;
	}
}
