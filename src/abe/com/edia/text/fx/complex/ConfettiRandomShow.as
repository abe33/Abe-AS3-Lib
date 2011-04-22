/**
 * @license
 */
package abe.com.edia.text.fx.complex 
{
	import abe.com.edia.fx.Confetti;
	import abe.com.edia.fx.Dust;
	import abe.com.edia.fx.Streamer;
	import abe.com.edia.text.core.Char;
	import abe.com.edia.text.fx.show.RandomTimeTweenScaleDisplayEffect;
	import abe.com.mon.utils.AllocatorInstance;
	import abe.com.mon.colors.Color;
	import abe.com.mon.utils.RandomUtils;
	import abe.com.motion.Impulse;
	import abe.com.motion.ImpulseEvent;

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;

	/**
	 * @author Cédric Néhémie
	 */
	public class ConfettiRandomShow extends RandomTimeTweenScaleDisplayEffect 
	{
		protected var amplitude : Number;
		protected var angle : Number;
		protected var speed : Number;
		protected var frequency : Number;

		public function ConfettiRandomShow ( delay : Number = 50, 
											 tweenDuration : Number = 500, 
											 easing : Function = null, 
											 timeout : Number = 0,
											 amplitude : Number = 10, 
											 angleSpeed : Number = Math.PI,
											 frequency : Number = 0.05, 
											 autoStart : Boolean = true)
		{
			super( delay, tweenDuration, easing, timeout, autoStart );
			this.angle = 0;
			this.amplitude = amplitude;
			this.speed = angleSpeed;
			this.frequency = frequency;
		}
		override public function init () :void
		{
			super.init();
			Impulse.register( wavetick );
		}
		override public function dispose () : void
		{
			super.dispose();
			
			Impulse.unregister( wavetick );
		}
		override protected function initCharPos ( char : Char ) : void
		{
			char.charContent.x = ( sizexs[ char ] - sizexs[ char ] * .1 ) / 2;
			char.charContent.y = ( sizeys[ char ] - sizeys[ char ] * .1 ) / 2;
		}
		override protected function updateCharPos ( char : Char, r : Number ) : void
		{
			char.charContent.x = ( sizexs[ char ] - sizexs[ char ] * r ) / 2;
			char.charContent.y = ( sizeys[ char ] - sizeys[ char ] * r ) / 2 + Math.cos( angle + frequency * char.x ) * amplitude;
		}
		public function wavetick ( e : ImpulseEvent ) : void
		{
			var l : Number = chars.length;
			
			for(var i : Number = 0; i < l; i++ )
			{
				var char : Char = chars[ i ];
				
				if( char != null )
					updateCharPos(char, char.scaleX);
			}
			angle += speed * e.biasInSeconds;	
		}
		override protected function processChar () : Char
		{
			var c : Char = super.processChar();
			var cd : DisplayObject = c as DisplayObject;
			
			if( cd )
			{
				var p : DisplayObjectContainer = cd.parent;
				
				var a : Array = [	Color.Blue, 
									Color.Cyan, 
									Color.Red, 
									Color.Orange, 
									Color.Yellow, 
									Color.Green, 
									Color.Magenta ];
				
				var a2 : Array = [	Color.LightBlue, 
									Color.LightCyan, 
									Color.LightCoral, 
									Color.Coral, 
									Color.LightYellow,
									Color.LightGreen,
									Color.Violet ];
				
				for(var i : Number = 0; i < 4; i++ )
				{
					var bb : Rectangle = cd.getBounds(p);
					
					p.addChild( AllocatorInstance.get( Dust, {
																x : c.x + RandomUtils.balance( 10 ),
																y : c.y + RandomUtils.balance( 10 ) + 20,
											  				  	size : RandomUtils.rangeAB(10,15),
											  				  	dist : RandomUtils.rangeAB(20,50), 
											  				  	life : RandomUtils.rangeAB(500,1000), 
											  				  	shadow : false 
											  				  } ) );

					p.addChild(  AllocatorInstance.get( Confetti, { 
																	color:a[ RandomUtils.irandom( a.length -1 ) ], 
																   	x:RandomUtils.rangeAB(bb.left, bb.right),
																 	y:RandomUtils.rangeAB(bb.top, bb.bottom),
																  	vel:new Point( RandomUtils.balance( 300 ), -100 + RandomUtils.balance( 300 ) ), 
																 	velrot:RandomUtils.sign() + RandomUtils.rangeAB( 5, 15 ) 
																 } ) );
				}
				p.addChild( AllocatorInstance.get( Streamer, {
																color:a2[ RandomUtils.irandom( a.length -1 ) ], 
																x:RandomUtils.rangeAB(bb.left, bb.right),
																y:RandomUtils.rangeAB(bb.top, bb.bottom), 
																vel:new Point( RandomUtils.balance( 150 ), -100 + RandomUtils.balance( 100 ) ), 
																length:RandomUtils.rangeAB( 15,25 ) 
															  } ) );
			}
			return c;
		}
	}
}
