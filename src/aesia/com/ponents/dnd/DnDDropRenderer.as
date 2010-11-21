package aesia.com.ponents.dnd 
{
	import aesia.com.mon.utils.StageUtils;
	import aesia.com.motion.SingleTween;
	import aesia.com.motion.TweenEvent;
	import aesia.com.ponents.core.Component;
	import aesia.com.ponents.events.ComponentEvent;
	import aesia.com.ponents.utils.ToolKit;

	import flash.display.Shape;
	import flash.events.Event;
	import flash.geom.Rectangle;

	/**
	 * @author Cédric Néhémie
	 */
	public class DnDDropRenderer 
	{
		protected var _shape : Shape;
		protected var _manager : DnDManager;
		
		protected var _currentTargets : Array;
		protected var _currentAcceptedTarget : DropTarget;
		
		protected var tween : SingleTween;		
		public function DnDDropRenderer ( manager : DnDManager )
		{
			manager.addEventListener( DnDEvent.DROP_TARGETS_CHANGE, dropTargetsChanged );					manager.addEventListener( DnDEvent.DRAG_ACCEPT, dragAccepted );					manager.addEventListener( DnDEvent.DRAG_START, dragStarted );					manager.addEventListener( DnDEvent.DRAG_EXIT, dragExited );		
			manager.addEventListener( DnDEvent.DRAG_STOP, dragStopped );		
			manager.addEventListener( DnDEvent.DRAG, drag );			manager.addEventListener( DnDEvent.DROP, drop );
			
			_manager = manager;
			_shape = new Shape();
			_shape.alpha = .5;
			tween = new SingleTween( _shape, "alpha", .5, 250, 0 );
		}
		
		protected function tweenEnd (event : TweenEvent) : void
		{
			tween.removeEventListener( TweenEvent.TWEEN_END, tweenEnd );
			tween.reversed = false;
			ToolKit.dndLevel.removeChild( _shape );
		}
		protected function drop (event : DnDEvent) : void
		{
			
		}
		
		protected function drag (event : DnDEvent) : void
		{
		}
		
		protected function dragStopped (event : DnDEvent) : void
		{
			tween.reversed = true;
			tween.addEventListener(TweenEvent.TWEEN_END, tweenEnd );
			tween.execute();
			//_shape.graphics.clear();
			//ToolKit.dndLevel.removeChild( _shape );
		}
		
		protected function dragStarted (event : DnDEvent) : void
		{			ToolKit.dndLevel.addChildAt( _shape, 0 );
			tween.execute(); 
		}

		protected function dragExited ( event : DnDEvent ) : void
		{
			_currentAcceptedTarget = null;
			drawDropTargets();
		}

		protected function dragAccepted ( event : DnDEvent ) : void
		{
			_currentAcceptedTarget = event.dropTarget;
			drawDropTargets();
		}

		protected function dropTargetsChanged (event : DnDEvent) : void
		{			
			if( _currentTargets )
				unregisterFromTargetsEvent( _currentTargets );
			
			_currentTargets = DnDManagerInstance.allowedDropTargets;
			
			if( _currentTargets )
				registerToTargetsEvent( _currentTargets );
			
			drawDropTargets ();
			
		}
		protected function dropTargetsRepaint (event : Event) : void
		{
			drawDropTargets();
		}
		
		protected function registerToTargetsEvent (currentTargets : Array) : void
		{
			for each( var c : Component in currentTargets )
				c.addEventListener( ComponentEvent.REPAINT, dropTargetsRepaint );
		}

		protected function unregisterFromTargetsEvent (currentTargets : Array) : void
		{
			for each( var c : Component in currentTargets )
				c.removeEventListener( ComponentEvent.REPAINT, dropTargetsRepaint );
		}

		protected function drawDropTargets () : void
		{
			_shape.graphics.clear();
			_shape.graphics.beginFill( 0 );			_shape.graphics.drawRect(0, 0, StageUtils.stage.stageWidth, StageUtils.stage.stageHeight );
			//_shape.graphics.endFill();			
			var bb : Rectangle; 
			var o : DropTarget;
			//_shape.graphics.endFill();
			for each ( o in _currentTargets )
			{
				bb = DnDManagerInstance.getScreenVisibleArea( o );

				//_shape.graphics.beginFill( 0xff0000 );
				_shape.graphics.drawRect(bb.x, bb.y, bb.width, bb.height );
				//_shape.graphics.endFill();
			}			_shape.graphics.endFill();
			
			for each ( o in _currentTargets )
			{
				bb = DnDManagerInstance.getScreenVisibleArea( o );
				if( o !== _currentAcceptedTarget )
				{
					_shape.graphics.beginFill( 0, .25 );
					_shape.graphics.drawRect(bb.x, bb.y, bb.width, bb.height );
					_shape.graphics.endFill();
				}
			}
			/*
			if( _currentAcceptedTarget )
			{
				bb = DnDManagerInstance.getScreenVisibleArea( _currentAcceptedTarget );
						
				_shape.graphics.beginFill( Color.YellowGreen.hexa );
				_shape.graphics.drawRect(bb.x, bb.y, bb.width, bb.height );
				_shape.graphics.endFill();
			}*/
		}
	}
}
