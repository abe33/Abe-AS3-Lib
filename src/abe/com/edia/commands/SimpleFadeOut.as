/**
 * @license
 */
package abe.com.edia.commands 
{
	import abe.com.mands.AbstractCommand;
	import abe.com.mands.Command;
	import abe.com.mon.core.Runnable;
	import abe.com.mon.core.Suspendable;
	import abe.com.mon.colors.Color;
	import abe.com.mon.utils.StageUtils;
	import abe.com.motion.Impulse;
	import abe.com.motion.ImpulseEvent;
	import abe.com.motion.ImpulseListener;
	import abe.com.motion.easing.Linear;

	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.events.Event;

	/**
	 * @author Cédric Néhémie
	 */
	public class SimpleFadeOut extends AbstractCommand implements Command, Runnable, Suspendable, ImpulseListener
	{
		protected var _level : DisplayObjectContainer;
		protected var _color : Color;
		protected var _fadeDuration : Number;
		protected var _easing : Function;
		protected var _shape : Shape;
		
		private var _t : Number;

		public function SimpleFadeOut ( level : DisplayObjectContainer, 
									   color : Color = null, 
									   fadeDuration : Number = 500, 
									   easing : Function = null )
		{
			super( );
			_level = level;
			_color = color ? color : Color.Black;
			_fadeDuration = fadeDuration;
			_easing = easing != null ? easing : Linear.easeNone;
		}

		override public function execute (e : Event = null) : void 
		{
			_shape = new Shape();
			_shape.graphics.beginFill(_color.hexa, _color.alpha );
			_shape.graphics.drawRect(0, 0, StageUtils.stage.stageWidth, StageUtils.stage.stageHeight );
			_shape.graphics.endFill();
			_shape.alpha = 0;
			
			_level.addChild(_shape);
			
			_t = 0;
			
			start();
		}
		
		public function start () : void
		{
			if( !_isRunning )
			{
				_isRunning = true;
				Impulse.register(tick);
			}
		}
		public function stop () : void
		{
			if( _isRunning )
			{
				_isRunning = false;
				Impulse.unregister(tick);
			}
		}
		public function tick (e : ImpulseEvent) : void
		{
			_t += e.bias;
			
			_shape.alpha = _easing( _t, 0, 1, _fadeDuration );
			
			if( _t >= _fadeDuration )
			{
				stop();
				_level.removeChild(_shape);
				fireCommandEnd();
			}
		}
	}
}
