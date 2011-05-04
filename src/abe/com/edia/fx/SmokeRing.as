/** * @license */package abe.com.edia.fx{	import abe.com.mon.colors.Color;	import abe.com.mon.core.Allocable;	import abe.com.mon.core.Randomizable;	import abe.com.mon.core.Runnable;	import abe.com.mon.core.Suspendable;	import abe.com.mon.geom.Ellipsis;	import abe.com.mon.geom.pt;	import abe.com.mon.randoms.Random;	import abe.com.mon.utils.AllocatorInstance;	import abe.com.mon.utils.MathUtils;	import abe.com.mon.utils.RandomUtils;	import abe.com.motion.Impulse;	import abe.com.motion.ImpulseEvent;	import abe.com.motion.ImpulseListener;	import abe.com.motion.easing.Cubic;	import flash.display.Shape;	import flash.filters.BlurFilter;	import flash.geom.Point;	/**	 * @author Cédric Néhémie	 */	public class SmokeRing extends Shape implements ImpulseListener, Runnable, Suspendable, Allocable, Randomizable	{		protected var _isRunning : Boolean;		protected var points : Vector.<Point>;		protected var thickness : Vector.<Number>;		protected var center : Point;		public var color : Color;		public var bias : Number;
		public var ellipsis : Ellipsis;
		public var growthRate : Number;
		public var thicknessGrowthRate : Number;
		public var velocity : Point;
		public var thicknessMin : Number;		public var thicknessMax : Number;
		public var life : Number;		public var time : Number;
		public var blured : Boolean;
		public function SmokeRing  ( 									 ellipsis : Ellipsis = null,									 color : Color = null,									 bias : Number = 12,									 thicknessMin : Number = .5,									 thicknessMax : Number = 2,									 thicknessGrowthRate : Number = 1,									 growthRate : Number = .5,									 velocity : Point = null,									 life : Number = 5000,									 blured : Boolean = true									) 		{			this.ellipsis = ellipsis ? ellipsis : new Ellipsis(0, 0, 20, 10);			this.color = color ? color : Color.White;			this.bias = bias;			this.growthRate = growthRate;			this.thicknessGrowthRate = thicknessGrowthRate;			this.velocity = velocity ? velocity : pt(0,-8);			this.thicknessMin = thicknessMin;			this.thicknessMax = thicknessMax;			this.life = life;			this.blured = blured;			_randomSource = RandomUtils.RANDOM;		}		protected var _randomSource : Random;		public function get randomSource () : Random { return _randomSource; }		public function set randomSource (randomSource : Random) : void		{			_randomSource = randomSource;		}		public function tick (e : ImpulseEvent) : void		{			time += e.bias; 			var p : Point;			var t : Number;			// déplace, élargi et randomize			for ( var i : int = 0;i<bias; i++ )			{				p = points[i];				t = thickness[i];				p = getNoisePoint( p, center, _randomSource.random( growthRate * e.biasInSeconds ) );				p.x += velocity.x * e.biasInSeconds;				p.y += velocity.y * e.biasInSeconds;								t += _randomSource.random( thicknessGrowthRate * e.biasInSeconds );				points[i] = p;				thickness[i] = t;			}			center.x += velocity.x * e.biasInSeconds;			center.y += velocity.y * e.biasInSeconds;						draw();						if( blured )				filters = [new BlurFilter( 2 + ( time/life ) * 4, 2 + ( time/life ) * 4, 2)];						if( time > life )			{				if( parent )				{					if( parent.contains( this ) )						parent.removeChild( this );				}				stop();				this.graphics.clear();				AllocatorInstance.release(this);			}		}				public function init () : void		{			time = 0;			points = new Vector.<Point>(bias);			thickness = new Vector.<Number>(bias);						center = pt(ellipsis.x, ellipsis.y);			for ( var i : int = 0;i<bias; i++ )			{				points[i] = ellipsis.getPointAtAngle( MathUtils.PI2 / bias * i );				thickness[i] = _randomSource.rangeAB( thicknessMin, thicknessMax );			}			start();		}				public function dispose () : void		{			filters = [];			points = null;			thickness = null;			center = null;						stop();		}				public function isRunning () : Boolean		{			return _isRunning;		}				public function start () : void		{			if( !_isRunning )			{				_isRunning = true;				Impulse.register( tick );			}		}		public function stop () : void		{			if( _isRunning )			{				Impulse.unregister( tick );				_isRunning = false;			}		}				protected function draw () : void 		{			graphics.clear();			graphics.beginFill(color.hexa, Cubic.easeIn(time, 1, -1, life) );						drawClockWise();			drawCounterClockWise();						graphics.endFill();		}		protected function drawCounterClockWise () : void 		{			var p : Point = points[bias-1];			var t : Number = thickness[bias-1];			var p2 : Point = getInnerPoint( p, center, t );			graphics.moveTo(p2.x, p2.y);			for ( var i : int = bias-2; i >= 0; i-- )			{				p = points[i];				t = thickness[i];				p2 = getInnerPoint( p, center, t );				graphics.lineTo(p2.x, p2.y);			}			p = points[bias-1];			t = thickness[bias-1];			p2 = getInnerPoint( p, center, t );			graphics.lineTo(p2.x, p2.y);		}		protected function drawClockWise () : void 		{			var p : Point = points[0];			var t : Number = thickness[0];			var p2 : Point = getExternPoint( p, center, t );			graphics.moveTo(p2.x, p2.y);			for ( var i : int = 1;i<bias; i++ )			{				p = points[i];				t = thickness[i];				p2 = getExternPoint( p, center, t );				graphics.lineTo(p2.x, p2.y);			}			p = points[0];			t = thickness[0];			p2 = getExternPoint( p, center, t );			graphics.lineTo(p2.x, p2.y);		}				protected function getNoisePoint (p : Point, center : Point, t : Number) : Point 		{			var p2 : Point = p.subtract( center );			p2.x *= t;			p2.y *= t;			return p.add( p2 );		}		protected function getExternPoint (p : Point, center : Point, t : Number) : Point 		{			var p2 : Point = p.subtract( center );			p2.normalize( t );			return p.add( p2 );		}		protected function getInnerPoint (p : Point, center : Point, t : Number) : Point 		{			var p2 : Point = p.subtract( center );			p2.normalize( t );			return p.subtract( p2 );		}			}}