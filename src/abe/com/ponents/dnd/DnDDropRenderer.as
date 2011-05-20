package abe.com.ponents.dnd 
{
	import abe.com.mon.utils.StageUtils;
	import abe.com.motion.SingleTween;
	import abe.com.motion.TweenEvent;
	import abe.com.ponents.core.Component;
	import abe.com.ponents.core.Container;
	import abe.com.ponents.events.ComponentEvent;
	import abe.com.ponents.utils.ToolKit;

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
		
		protected var _drawnShapes : Array;
		
		public function DnDDropRenderer ( manager : DnDManager )
		{
			manager.addEventListener( DnDEvent.DROP_TARGETS_CHANGE, dropTargetsChanged );		
			manager.addEventListener( DnDEvent.DRAG_ACCEPT, dragAccepted );		
			manager.addEventListener( DnDEvent.DRAG_START, dragStarted );		
			manager.addEventListener( DnDEvent.DRAG_EXIT, dragExited );		
			manager.addEventListener( DnDEvent.DRAG_STOP, dragStopped );		
			manager.addEventListener( DnDEvent.DRAG, drag );
			manager.addEventListener( DnDEvent.DROP, drop );
			
			_manager = manager;
			_shape = new Shape();
			_shape.alpha = .5;
			tween = new SingleTween( _shape, "alpha", .5, 250, 0 );
		}
		
		protected function tweenEnd (event : TweenEvent) : void
		{
			tween.commandEnded.remove( tweenEnd );
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
			tween.commandEnded.add( tweenEnd );
			tween.execute();
			//_shape.graphics.clear();
			//ToolKit.dndLevel.removeChild( _shape );
		}
		
		protected function dragStarted (event : DnDEvent) : void
		{
			ToolKit.dndLevel.addChildAt( _shape, 0 );
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
			
			
			_currentTargets = DnDManagerInstance.allowedDropTargets.concat();
			
			if( _currentTargets )
				registerToTargetsEvent( _currentTargets );
			
			drawDropTargets ();
			
		}
		
		protected function dropTargetsRepainted ( c : Component ) : void
		{
			drawDropTargets();
		}
		
		protected function registerToTargetsEvent (currentTargets : Array) : void
		{
			for each( var c : Component in currentTargets )
				c.componentRepainted.add( dropTargetsRepainted );
		}

		protected function unregisterFromTargetsEvent (currentTargets : Array) : void
		{
			for each( var c : Component in currentTargets )
				c.componentRepainted.remove( dropTargetsRepainted );
		}
		protected function hasAnAncestorInDropTargets ( o : DropTarget, targets : Array ) : Boolean
		{
			for each( var dt : DropTarget in targets )
			{
				if( lookupAncestors(o, dt) )
					return true;
			}
			return false;
		}
		protected function lookupAncestors( a : DropTarget, b : DropTarget ) : Boolean
		{
			return a && b && a != b && ( b.component is Container ) && (b.component as Container).isDescendant( a.component );
		}
		 
		protected function drawDropTargets () : void
		{
			_drawnShapes = [];
			
			_shape.graphics.clear();
			_shape.graphics.beginFill( 0 );
			_shape.graphics.drawRect(0, 0, StageUtils.stage.stageWidth, StageUtils.stage.stageHeight );
			//_shape.graphics.endFill();
			
			var bb : Rectangle; 
			var o : DropTarget;
			//_shape.graphics.endFill();
			for each ( o in _currentTargets )
			{
				if( hasAnAncestorInDropTargets( o, _currentTargets ) )
					continue;
				
				bb = DnDManagerInstance.getScreenVisibleArea( o );
				
				var a: Array = checkDropShape( bb, _drawnShapes );
				
				_shape.graphics.drawRect(bb.x, bb.y, bb.width, bb.height );
				_drawnShapes.push(bb);
				if( a.length > 0 )
				{
					for( var i:uint=0;i< a.length;i++)
					{
						var r : Rectangle =a[i];
						_shape.graphics.drawRect(r.x, r.y, r.width, r.height );
					}
				}
			}
			_shape.graphics.endFill();
			
			for each ( o in _currentTargets )
			{
				bb = DnDManagerInstance.getScreenVisibleArea( o );
				if( o !== _currentAcceptedTarget )
				{
					if( hasAnAncestorInDropTargets( _currentAcceptedTarget, _currentTargets ) )
						continue;
					
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
		protected function checkDropShape (bb : Rectangle, drawnShapes : Array) : Array 
		{
			var a : Array = [];
			for each( var r : Rectangle in drawnShapes )
				if( r.intersects( bb ) )
					a.push(r.intersection( bb ));
					
			return a;
		}
	}
}
