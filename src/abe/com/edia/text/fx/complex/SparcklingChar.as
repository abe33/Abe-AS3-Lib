/**
 * @license
 */
package abe.com.edia.text.fx.complex 
{
	import abe.com.edia.fx.Sparckles;
	import abe.com.edia.text.core.Char;
	import abe.com.edia.text.fx.AbstractCharEffect;
	import abe.com.mon.utils.AllocatorInstance;
	import abe.com.motion.ImpulseEvent;

	import flash.display.DisplayObject;
	import flash.utils.Dictionary;
	/**
	 * @author Cédric Néhémie
	 */
	public class SparcklingChar extends AbstractCharEffect 
	{
		protected var particles : Dictionary;
		
		public function SparcklingChar ( autoStart : Boolean = true )
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
					if( !particles[c] )
					{
						setupParticle( particles[c] = AllocatorInstance.get( Sparckles ), c );
						(c as DisplayObject).parent.addChild(particles[c]);
					}
				}
			}
		}
		protected function setupParticle ( p : DisplayObject, char : Char ) : void
		{
			p.x = char.x + char.width/2;
			p.y = char.y + char.height/2;
		}

		override public function dispose () : void
		{
			super.dispose();
			for( var c : * in particles )
			{
				var cd : DisplayObject = c as DisplayObject;
				var p : DisplayObject = particles[c];
				if( cd.parent.contains(p) )
					cd.parent.removeChild(p);
				delete particles[c];
			}
		}
	}
}
