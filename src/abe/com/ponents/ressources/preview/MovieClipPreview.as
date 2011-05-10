package abe.com.ponents.ressources.preview 
{
	import abe.com.ponents.buttons.ToggleButton;
	import abe.com.ponents.events.ComponentEvent;
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
		protected var _previewFrameRate : Spinner;		protected var _previewFrame : Spinner;
		protected var _playButton : ToggleButton;

		public function MovieClipPreview ()
		{
			super( );
		}
		override protected function buildChildren () : void 
		{
			super.buildChildren( );
			_playButton = new ToggleButton( _( "Play" ) );
			_previewFrameRate = new Spinner( new SpinnerNumberModel( 24, 1, 100, 1, true ) );
			_previewFrame = new Spinner( new SpinnerNumberModel( 1, 1, 1, 1, true ) );			_previewFrameRate.preferredSize = dm( 50, 20 );
			_previewFrame.preferredSize = dm( 50, 20 );			_toolBar.addComponentAt( _previewFrameRate, 0 );			_toolBar.addComponentAt( new Label( _( "FPS :" ) ), 0 );			_toolBar.addComponentAt( _previewFrame, 0 );			_toolBar.addComponentAt( new Label( _( "F :" ) ), 0 );
			_toolBar.addComponentAt( _playButton, 0 );
		}
		override public function set displayObject (displayObject : DisplayObject) : void 
		{
			super.displayObject = displayObject;
			var mc : MovieClip = _displayObject as MovieClip;
			_previewFrame.model = new SpinnerNumberModel( 1, 1, mc.totalFrames, 1, true );
			mc.gotoAndStop( 1 );
		}
		override public function addedToStage (e : Event) : void 
		{
			super.addedToStage( e );
			
			_previewFrame.addEventListener( ComponentEvent.DATA_CHANGE, frameChange );			_playButton.addEventListener( ComponentEvent.DATA_CHANGE, playChange );			if( _playButton.selected )
				start();
		}
		override public function removeFromStage (e : Event) : void 
		{			
			super.removeFromStage( e );
			
			_previewFrame.addEventListener( ComponentEvent.DATA_CHANGE, frameChange );
			_playButton.removeEventListener( ComponentEvent.DATA_CHANGE, playChange );
			stop();
		}
		public function start () : void
		{
			if( !_isRunning )
			{
				Impulse.register( tick );
				_isRunning = true;
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
		public function isRunning () : Boolean
		{
			return _isRunning;
		}
		protected function playChange (event : ComponentEvent) : void 
		{
			_playButton.selected ? start() : stop();
		}
		protected function frameChange (event : ComponentEvent) : void 
		{
			var mc : MovieClip = _displayObject as MovieClip;
			mc.gotoAndStop( _previewFrame.value );
		}

		private var _t : Number = 0; 

		public function tick (e : ImpulseEvent) : void
		{
			var mc : MovieClip = _displayObject as MovieClip;
			_t += e.biasInSeconds * _previewFrameRate.value;
			_previewFrame.value = 1 + Math.floor( _t % mc.totalFrames );
		}
	}
}
