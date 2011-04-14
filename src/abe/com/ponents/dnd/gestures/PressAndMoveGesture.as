package abe.com.ponents.dnd.gestures 
{
	import abe.com.mon.utils.StageUtils;
	import abe.com.ponents.dnd.DnDManagerInstance;
	import abe.com.ponents.dnd.DragSource;

	import flash.events.MouseEvent;
	/**
	 * @author cedric
	 */
	public class PressAndMoveGesture implements DragGesture
	{
		/**
		 * 
		 */
		static public const DRAG_THRESHOLD : Number = 6;
		
		protected var _target : DragSource;
		protected var _pressed : Boolean;
		protected var _pressedX : Number;
		protected var _pressedY : Number;
		protected var _dragging : Boolean;
		protected var _enabled : Boolean;

		public function PressAndMoveGesture () 
		{
			_enabled = true;
		}

		public function get enabled () : Boolean { return _enabled; }		
		public function set enabled (b : Boolean) : void
		{
			if( _enabled == b )
				return;
			
			_enabled = b;
			
			if( _enabled )
			{
				if( _target )
					registerToTargetEvents( _target );
			}
			else
			{
				if( _target )
					unregisterFromTargetEvents( _target );
			}
		}
		public function get target () : DragSource { return _target; }	
		public function set target ( target : DragSource ) : void
		{
			if( _target && _enabled )
				unregisterFromTargetEvents( _target );
				
			_target = target;
			if( _target && _enabled )
				registerToTargetEvents( _target );
		}
		
		protected function registerToTargetEvents ( target : DragSource ) : void
		{
			target.dragGestureGeometry.addEventListener( MouseEvent.MOUSE_DOWN, mouseDown, false, 1 );
			target.dragGestureGeometry.addEventListener( MouseEvent.MOUSE_OUT, mouseOut, false, 1 );
			//target.dragGestureGeometry.addEventListener( MouseEvent.MOUSE_UP, mouseUp, false, 1 );			StageUtils.stage.addEventListener( MouseEvent.MOUSE_UP, mouseUp, false, 1 );
			StageUtils.stage.addEventListener( MouseEvent.MOUSE_MOVE, mouseMove );
		}
		
		protected function unregisterFromTargetEvents (target : DragSource ) : void
		{
			target.dragGestureGeometry.removeEventListener( MouseEvent.MOUSE_DOWN, mouseDown );
			target.dragGestureGeometry.removeEventListener( MouseEvent.MOUSE_OUT, mouseOut );
			//target.dragGestureGeometry.removeEventListener( MouseEvent.MOUSE_UP, mouseUp );			StageUtils.stage.removeEventListener( MouseEvent.MOUSE_UP, mouseUp );
			StageUtils.stage.removeEventListener( MouseEvent.MOUSE_MOVE, mouseMove );
		}
		
		protected function mouseOut ( event : MouseEvent ) : void {}
	
		protected function mouseUp ( event : MouseEvent ) : void
		{
			_pressed = false;
			if( _dragging )
			{
				_dragging = false;
				DnDManagerInstance.drop();
			}
		}
	
		protected function mouseDown ( event : MouseEvent ) : void
		{
			if( _target.allowDrag )
			{
				_pressed = true;
				_pressedX = _target.stage.mouseX;
				_pressedY = _target.stage.mouseY;
			}
		}
		protected function mouseMove ( event : MouseEvent ) : void
		{
			if( _pressed && !_dragging )
			{
				if( Math.abs( _target.stage.mouseX - _pressedX ) > DRAG_THRESHOLD ||
					Math.abs( _target.stage.mouseY - _pressedY ) > DRAG_THRESHOLD )
				{
					DnDManagerInstance.startDrag( _target , _target.transferData );
					_dragging = true;
				}
			}
		}
		public function get isDragging () : Boolean { return _dragging; }
	}
}
