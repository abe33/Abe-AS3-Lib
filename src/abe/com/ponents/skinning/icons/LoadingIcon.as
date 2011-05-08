package abe.com.ponents.skinning.icons 
{
	import abe.com.mon.utils.MathUtils;

	import flash.display.Shape;
	import flash.events.Event;
	/**
	 * @author Cédric Néhémie
	 */
	public class LoadingIcon extends Shape 
	{
		protected var _angle : Number;
		
		public function LoadingIcon ()
		{
			_angle = 0;
			addEventListener(Event.ADDED_TO_STAGE, addedToStage );			addEventListener(Event.REMOVED_FROM_STAGE, removedFromStage );
			enterFrame(null );
		}
		protected function removedFromStage (event : Event) : void
		{
			removeEventListener(Event.ENTER_FRAME, enterFrame );
		}
		protected function addedToStage (event : Event) : void
		{
			addEventListener(Event.ENTER_FRAME, enterFrame );
		}
		protected function enterFrame (event : Event) : void
		{
			this.graphics.clear();
			
			var l : uint = 8;
			var i : int;
			var a : Number = 0;
			var astep : Number = MathUtils.PI2/8;
			var bigRadius : Number = 6;
			var dotRadius : Number = 2; 
			
			for( i = 0 ; i < l ; i++)
			{
				var alpha : Number = 1.1 - ( (_angle + a ) % MathUtils.PI2/ MathUtils.PI2 );
				this.graphics.beginFill(0, alpha);
				
				var x : Number = dotRadius + bigRadius + Math.sin( a ) * bigRadius;				var y : Number = dotRadius + bigRadius + Math.cos( a ) * bigRadius;
				
				this.graphics.drawCircle( x, y, dotRadius );
				this.graphics.endFill();				
				a += astep;	
			}
			
			_angle += .3;	
		}
	}
}
