/**
 * @license
 */
package  aesia.com.ponents.dnd 
{
	import aesia.com.mon.logs.Log;
	import aesia.com.mon.utils.StageUtils;
	import aesia.com.ponents.core.Component;
	import aesia.com.ponents.transfer.DataFlavor;
	import aesia.com.ponents.transfer.Transferable;
	import aesia.com.ponents.utils.ToolKit;

	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Rectangle;

	[Event(name="dragEnter",  		type="aesia.com.ponents.dnd.DnDEvent")]
	[Event(name="dragExit",   		type="aesia.com.ponents.dnd.DnDEvent")]
	[Event(name="dragAbort",  		type="aesia.com.ponents.dnd.DnDEvent")]
	[Event(name="dragAccept", 		type="aesia.com.ponents.dnd.DnDEvent")]
	[Event(name="dragReject", 		type="aesia.com.ponents.dnd.DnDEvent")]
	[Event(name="dragStart",  		type="aesia.com.ponents.dnd.DnDEvent")]
	[Event(name="dragStop",  		type="aesia.com.ponents.dnd.DnDEvent")]
	[Event(name="drop", 			type="aesia.com.ponents.dnd.DnDEvent")]	[Event(name="dropTargetsChange",type="aesia.com.ponents.dnd.DnDEvent")]
	public class DnDManager extends EventDispatcher
	{		
		/*FDT_IGNORE*/ FEATURES::DND { /*FDT_IGNORE*/
		protected var _dropTargets : Array;
		protected var _dragging : Boolean;
		
		protected var _allowedDropTargets : Array;		protected var _allowedDropTargetsScreenVisibleArea : Array;
		
		public function DnDManager () 
		{
			_dropTargets = [];
		}
		public function get dragging () : Boolean { return _dragging; }
		public function get dropTargets () : Array { return _dropTargets; }		
		public function get allowedDropTargets () : Array { return _allowedDropTargets; }
		public function get allowedDropTargetsScreenVisibleArea () : Array { return _allowedDropTargetsScreenVisibleArea; }
		
		public function getScreenVisibleArea ( t : DropTarget ) : Rectangle
		{
			if( _allowedDropTargets.indexOf( t ) != -1 )
				return _allowedDropTargetsScreenVisibleArea[ _allowedDropTargets.indexOf( t ) ];
			else
				return null;
		}

		/*-------------------------------------------------------------------
		 * DROP TARGETS HANDLERS
		 *------------------------------------------------------------------*/
		
		public function registerDropTarget ( target : DropTarget ) : void
		{
			if( !isRegistered( target ) )
				_dropTargets.push( target );
		}

		public function unregisterDropTarget ( target : DropTarget ) : void
		{
			if( isRegistered( target ) )
				_dropTargets.splice( _dropTargets.indexOf( target ), 1 );
		}
		public function isRegistered (  target : DropTarget  ) : Boolean
		{
			return _dropTargets.indexOf( target ) != -1;
		}

		
		/*-------------------------------------------------------------------
		 * DRAG AND DROP HANDLERS
		 *------------------------------------------------------------------*/
		private var currentTransferable : Transferable;
		private var currentDragSource : DragSource;		private var currentDropTarget : DropTarget;
		private var currentTargetUnderTheMouse : DropTarget;

		public function enterFrame ( e : Event ) : void
		{
			var l : Number = _allowedDropTargets.length;
			/*
			 * On boucle sur toutes les cibles pour savoir si 
			 * l'une d'elle est sous la souris
			 */
			dispatchEvent( new DnDEvent( DnDEvent.DRAG, 
										 currentTransferable,
										 currentDragSource, 
										 currentTargetUnderTheMouse ) );
			while( l-- )
			{
				var target : DropTarget = _allowedDropTargets[ l ] as DropTarget;
				var r : Rectangle = _allowedDropTargetsScreenVisibleArea[ l ];
				// On a un contact avec une cible
				if( /*target.dropGeometry.parent &&
					target.dropGeometry.hitTestPoint( StageUtils.stage.mouseX , 
													  StageUtils.stage.mouseY )*/
					r.contains( StageUtils.stage.mouseX , StageUtils.stage.mouseY) )
				{
					// qui est différente de celle sous la souris
					if( target != currentTargetUnderTheMouse )
					{
						if( currentTargetUnderTheMouse )
							currentTargetUnderTheMouse.dragExit ( 
								new DropTargetDragEvent( currentTransferable, currentDragSource ) );
							
						currentTargetUnderTheMouse = target;
						
						currentTargetUnderTheMouse.dragEnter( 
							new DropTargetDragEvent( currentTransferable, currentDragSource ) );
						
						dispatchEvent( 
								new DnDEvent( 
										DnDEvent.DRAG_ENTER, 
										currentTransferable,
										currentDragSource, 
										currentTargetUnderTheMouse ) );
					}
					// c'est la même, on ne fait que se déplacer dessus
					else
					{
						if( currentDropTarget )
						currentDropTarget.dragOver( 
							new DropTargetDragEvent( currentTransferable, currentDragSource ) );
					}
					return;
				}
			}
			/*
			 * On n'a aucune cible sous la souris, mais une enregistrée
			 * précédemment, on vient donc de sortir
			 */
			if( currentTargetUnderTheMouse )
			{
				currentTargetUnderTheMouse.dragExit( 
							new DropTargetDragEvent( currentTransferable, currentDragSource ) );
				dispatchEvent( 
							new DnDEvent( 
									DnDEvent.DRAG_EXIT, 
									currentTransferable,
									currentDragSource, 
									currentTargetUnderTheMouse ) );
								
				currentTargetUnderTheMouse = null;
				currentDropTarget = null;
			}
		}
		public function refreshDropTargets () : void
		{
			var flavors : Array = currentTransferable.flavors;
			var a : Array = _dropTargets;
			
			var filter : Function = function(dt:DropTarget, ... args ) : Boolean 
			{	
				var f : Array = dt.supportedFlavors;
				var some : Function = function(flavor:DataFlavor, ... args ) : Boolean 
				{	
					return flavor.isSupported( flavors ); 
				};
				return dt.displayed && f.some( some ); 
			};
			
			_allowedDropTargets = a.filter( filter );
			_allowedDropTargetsScreenVisibleArea = _allowedDropTargets.map( function (item : DropTarget, ...args ) : * {
				if( item is Component )
				  return (item as Component).screenVisibleArea;
				else 
				  return (item as DisplayObject).getBounds( ToolKit.dndLevel );
			} );
			
			dispatchEvent( new DnDEvent(DnDEvent.DROP_TARGETS_CHANGE, 
										currentTransferable, 
										currentDragSource ) );
		}
		public function startDrag ( source : DragSource, transferable : Transferable ) : void
		{
			_dragging = true;
			currentDragSource = source;
			currentTransferable = transferable;
			
			refreshDropTargets();
			
			dispatchEvent( new DnDEvent(DnDEvent.DRAG_START, 
										currentTransferable, 
										currentDragSource ) );
										
			(currentDragSource as DisplayObject).addEventListener( Event.ENTER_FRAME, enterFrame);
		}

		public function drop() : void
		{
			if( currentDropTarget )
			{
				currentDropTarget.drop( new DropEvent ( currentTransferable ) );
				StageUtils.stage.focus = currentDropTarget as InteractiveObject;
				dispatchEvent( new DnDEvent( 
											DnDEvent.DROP, 
											currentTransferable, 
											currentDragSource, 
											currentDropTarget ) );
			}
			else
			{
				dispatchEvent( new DnDEvent( DnDEvent.DRAG_ABORT,
											currentTransferable,
											currentDragSource ) );
			}
			
			stopDrag();
		}

		public function stopDrag () : void
		{
			_dragging = false;
			dispatchEvent( new DnDEvent( DnDEvent.DRAG_STOP, 
										currentTransferable, 
										currentDragSource, 
										currentDropTarget ) );
			(currentDragSource as DisplayObject).removeEventListener( Event.ENTER_FRAME, enterFrame );
			currentDragSource = null;
			currentTransferable = null;
			currentDropTarget = null;
			currentTargetUnderTheMouse = null;
		}	

		public function acceptDrag ( target : DropTarget ) : void
		{
			currentDropTarget = target;
			dispatchEvent( new DnDEvent( DnDEvent.DRAG_ACCEPT, 
													currentTransferable, 
													currentDragSource,
													currentDropTarget ) );
		}

		public function rejectDrag ( target : DropTarget ) : void
		{
			currentDropTarget = null;
			dispatchEvent( new DnDEvent( DnDEvent.DRAG_REJECT, 
													currentTransferable, 
													currentDragSource,
													target ) );
		}
		
		/**
		 * Réécriture de la méthode <code>dispatchEvent</code> afin d'éviter la diffusion
		 * d'évènement en l'absence d'écouteurs pour cet évènement.
		 * 
		 * @param	evt	objet évènement à diffuser
		 * @return	<code>true</code> si l'évènement a bien été diffusé, <code>false</code>
		 * 			en cas d'échec ou d'appel de la méthode <code>preventDefault</code>
		 * 			sur cet objet évènement
		 */
		override public function dispatchEvent( evt : Event ) : Boolean 
		{
		 	if (hasEventListener(evt.type) || evt.bubbles) 
		 	{
		  		return super.dispatchEvent(evt);
		  	}
		 	return true;
		}
		/*FDT_IGNORE*/ } /*FDT_IGNORE*/
	}
}
