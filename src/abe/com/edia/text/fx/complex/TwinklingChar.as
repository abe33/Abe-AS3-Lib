/**
 * @license
 */
package abe.com.edia.text.fx.complex 
{
	import abe.com.edia.text.core.Char;
	import abe.com.edia.text.fx.AbstractCharEffect;
	import abe.com.mon.utils.AllocatorInstance;
	import abe.com.mon.utils.RandomUtils;
	import abe.com.motion.ImpulseEvent;

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.utils.Dictionary;
	/**
	 * @author Cédric Néhémie
	 */
	public class TwinklingChar extends AbstractCharEffect 
	{
		protected var particles : Dictionary;
		[Embed(source="../../../fx/particles-collection.swf", symbol="star")]
		static public var star : Class;
		
		public function TwinklingChar ( autoStart : Boolean = true )
		{
			particles = new Dictionary( true );
			super( autoStart );
		}

		override public function tick (e : ImpulseEvent) : void
		{
			super.tick( e );
			for each( var c : Char in chars )
			{
				if( c.visible )
				{
					if( particles[c] )
					{
						if( RandomUtils.boolean(.3) )
							setupParticle( particles[c], c );
					}
					else
					{
						setupParticle( particles[c] = AllocatorInstance.get(star), c );
						(c as DisplayObject).parent.addChild(particles[c]);
					}
				}
			}
		}
		protected function setupParticle ( p : DisplayObject, char : Char ) : void
		{
			p.scaleX = p.scaleY = RandomUtils.rangeAB(.5,1);
			p.x = RandomUtils.rangeAB( char.x, char.x + char.width );
			p.y = RandomUtils.rangeAB( char.y, char.y + char.height );
		}

		override public function dispose () : void
		{
			super.dispose();
			for( var c : * in particles )
			{
				var p : DisplayObject = particles[c];
				var pp : DisplayObjectContainer = (c as DisplayObject).parent;
				
				if( pp && pp.contains( p ) )
					pp.removeChild(p );
				
				AllocatorInstance.release( particles[c] );
				delete particles[c];
			}
		}
	}
}
