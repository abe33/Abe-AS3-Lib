package abe.com.ponents.ressources.preview 
{
	import abe.com.mon.core.Suspendable;
	import abe.com.mon.geom.dm;
	import abe.com.motion.Impulse;
	import abe.com.motion.ImpulseEvent;
	import abe.com.motion.ImpulseListener;
	import abe.com.patibility.lang._;
	import abe.com.ponents.models.SpinnerNumberModel;
	import abe.com.ponents.spinners.Spinner;
	import abe.com.ponents.text.Label;

	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	/**
	 * @author cedric
	 */
	public class MovieClipPreview extends DisplayObjectPreview implements Suspendable, ImpulseListener
	{
		protected var _isRunning : Boolean;
		protected var _previewFrameRate : Spinner;

		public function MovieClipPreview ()
		{
			super();
		}
		override protected function buildChildren () : void 
		{
			super.buildChildren();
			_previewFrameRate = new Spinner(new SpinnerNumberModel( 24, 1, 100, 1, true ) );
			_previewFrameRate.preferredSize = dm( 50, 20 );
			_toolBar.addComponentAt( _previewFrameRate, 0 );			_toolBar.addComponentAt( new Label(_("FPS :")), 0 );
		}
		override public function set displayObject (displayObject : DisplayObject) : void 
		{
			super.displayObject = displayObject;
			var mc : MovieClip =  _displayObject as MovieClip;
			mc.gotoAndStop(1);
		}
		override public function addedToStage (e : Event) : void 
		{
			super.addedToStage( e );
			start();
		}
		override public function removeFromStage (e : Event) : void 
		{
			super.removeFromStage( e );
			stop();
		}
		public function start () : void
		{
			if( !_isRunning )
			{
				Impulse.register(tick );
				_isRunning = true;
			}
		}
		public function stop () : void
		{
			if( _isRunning )
			{
				Impulse.unregister(tick );
				_isRunning = false;
			}
		}
		public function isRunning () : Boolean
		{
			return _isRunning;
		}
		private var _t : Number = 0; 
		public function tick (e : ImpulseEvent) : void
		{
			var mc : MovieClip =  _displayObject as MovieClip;
			_t += e.biasInSeconds * _previewFrameRate.value;
			mc.gotoAndStop( 1 + Math.floor( _t % mc.totalFrames ) );
		}
	}
}
