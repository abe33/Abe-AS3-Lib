package aesia.com.ponents.containers 
{
	import aesia.com.ponents.core.Component;
	import aesia.com.ponents.dnd.DropEvent;
	import aesia.com.ponents.dnd.DropTarget;
	import aesia.com.ponents.dnd.DropTargetDragEvent;
	import aesia.com.ponents.layouts.components.MultiSplitLayout;
	import aesia.com.ponents.layouts.components.splits.Divider;
	import aesia.com.ponents.layouts.components.splits.Leaf;
	import aesia.com.ponents.layouts.components.splits.Node;
	import aesia.com.ponents.layouts.components.splits.Split;
	import aesia.com.ponents.skinning.cursors.Cursor;
	import aesia.com.ponents.transfer.ComponentsFlavors;

	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * @author Cédric Néhémie
	 */
	public class MultiSplitPane extends DropPanel implements DropTarget
	{
		protected var _allowResize : Boolean;
		protected var _dragging : Boolean;
		protected var _pressedX : Number;
		protected var _pressedY : Number;
		protected var _currentDivider : Divider;
		
		public function MultiSplitPane ()
		{
			super( true );
			_childrenLayout = new MultiSplitLayout( this );
			_allowResize = true;
			/*FDT_IGNORE*/ FEATURES::DND { /*FDT_IGNORE*/
				_dropBorderSize = 20;
			/*FDT_IGNORE*/ } /*FDT_IGNORE*/
		}

		public function get multiSplitLayout () : MultiSplitLayout
		{
			return ( _childrenLayout as MultiSplitLayout );
		}
		
		public function get allowResize () : Boolean { return _allowResize; }		
		public function set allowResize (allowResize : Boolean) : void
		{
			_allowResize = allowResize;
		}

		override protected function teardownChildren (c : Component) : void
		{
			var l : Leaf = multiSplitLayout.getLeafParent( c );
			if( l )
				multiSplitLayout.removeSplitChild( l.parent, l );
				
			super.teardownChildren( c );
		}
		
		/*FDT_IGNORE*/ FEATURES::CURSOR { /*FDT_IGNORE*/
		override public function mouseOver (e : MouseEvent) : void
		{
			if( _allowResize )
			{
				var d : Divider = multiSplitLayout.dividerAt( multiSplitLayout.modelRoot , mouseX, mouseY );
					
				if( d )
					cursor = d.isVertical() ? Cursor.get( Cursor.DRAG_V ) : Cursor.get( Cursor.DRAG_H );
				else
					cursor = null;
			}
			super.mouseOver( e );
		}
		override public function mouseMove (e : MouseEvent) : void
		{
			if( _allowResize )
			{
				var d : Divider = multiSplitLayout.dividerAt( multiSplitLayout.modelRoot , mouseX, mouseY );
					
				if( d )
					cursor = d.isVertical() ? Cursor.get( Cursor.DRAG_V ) : Cursor.get( Cursor.DRAG_H );
				else
					cursor = null;
			}
			super.mouseMove( e );
		}
		/*FDT_IGNORE*/ } /*FDT_IGNORE*/
		
		override public function mouseDown (e : MouseEvent) : void
		{
			super.mouseDown( e );
			dragStart(e);
		}
		override public function mouseUp (e : MouseEvent) : void
		{
			super.mouseUp( e );
			dragEnd(e);
		}	
		protected function dragStart ( e : MouseEvent ) : void
		{
			if( _enabled && _allowResize )
			{
				var d : Divider = multiSplitLayout.dividerAt( multiSplitLayout.modelRoot , mouseX, mouseY );
				
				if( d )
				{
					if( multiSplitLayout.dividerFloating )
						multiSplitLayout.disableFloating();
					
					_currentDivider = d;
					_dragging = true;
					
					_pressedX = mouseX - d.bounds.x - ( _currentDivider.location - _currentDivider.bounds.left );
					_pressedY = mouseY - d.bounds.y - ( _currentDivider.location - _currentDivider.bounds.top );
					
					drag ( null );
					stage.addEventListener( MouseEvent.MOUSE_MOVE, drag );
				}
			}
		}
		protected function dragEnd ( e : Event ) : void
		{
			if( _enabled && _allowResize && _dragging && _currentDivider )
			{
				_currentDivider = null;
				drag ( null );
				_dragging = false;
				stage.removeEventListener( MouseEvent.MOUSE_MOVE, drag );
				
			}			
		}
		protected function drag ( e : MouseEvent ) : void
		{
			if( _dragging && _currentDivider )
			{
				var previous : Divider = _currentDivider.siblingAtOffset(-2) as Divider;
				var next : Divider = _currentDivider.siblingAtOffset(2) as Divider;
				var ds : Number = multiSplitLayout.dividerSize;
				var parentBounds : Rectangle = _currentDivider.parent.bounds;
				
				if( _currentDivider.isVertical() )
				{
					var y : Number = mouseY - _pressedY;
					
					if( previous && y < previous.bounds.bottom )
						y = previous.bounds.bottom;
					else if( next && y + ds > next.bounds.top )
						y = next.bounds.top - ds;
					else if( parentBounds && y + ds > parentBounds.height )
						y = parentBounds.height - ds;
					else if( y < 0 )
						y = 0;
					else if( y + ds > height )
						y = height - ds;
					
					_currentDivider.location = y;
				}
				else
				{
					var x : Number = mouseX - _pressedX;
						
					if( previous && x < previous.bounds.right )
						x = previous.bounds.right;
					else if( next && x + ds > next.bounds.left )
						x = next.bounds.left - ds;
					else if(parentBounds && x + ds > parentBounds.width )
						x = parentBounds.width - ds;
					else if( x < 0 )
						x = 0;
					else if( x + ds > width )
						x = width - ds;
					
					_currentDivider.location = x;
				}
					
				invalidate();					
			}
		}
		
		/*FDT_IGNORE*/ FEATURES::DND { /*FDT_IGNORE*/
		protected var _dropBorderSize : Number;
		override public function dragEnter (e : DropTargetDragEvent) : void
		{
			if( ComponentsFlavors.COMPONENT.isSupported( e.flavors ) )
				e.acceptDrag( this );
			else
				e.rejectDrag( this );
		}
		
		override public function dragOver (e : DropTargetDragEvent) : void
		{
			super.dragOver(e);
			var c : Component = getComponentUnderPoint( new Point( stage.mouseX, stage.mouseY ) );
			var nc : Component = e.transferable.getData( ComponentsFlavors.COMPONENT );
			if( c && c != nc )
			{
				var l : Leaf = multiSplitLayout.getLeafParent(c);
				var bb : Rectangle = l.bounds;
				var left : Number = Math.min(bb.left + _dropBorderSize, bb.left + bb.width / 2);
				var right : Number = Math.max(bb.right - _dropBorderSize, bb.left + bb.width / 2);
				var top : Number = Math.min(bb.top + _dropBorderSize, bb.top + bb.height / 2);
				var bottom : Number = Math.max(bb.bottom - _dropBorderSize, bb.top + bb.height / 2);
				
				if( mouseX < left )
				{
					drawDropRect( bb.x, bb.y, bb.width / 2, bb.height );	
				}
				else if ( mouseX > right )
				{
					drawDropRect( bb.x + bb.width / 2, bb.y, bb.width / 2, bb.height );											
				}
				else if( mouseY < top )
				{
					drawDropRect( bb.x, bb.y, bb.width , bb.height/ 2 );	
				}
				else if ( mouseY > bottom )
				{
					drawDropRect( bb.x, bb.y+bb.height/ 2, bb.width , bb.height/ 2 );	
				}
			}
		}
		override public function drop (e : DropEvent) : void
		{
			super.drop(e);
			var c : Component = getComponentUnderPoint( new Point( stage.mouseX, stage.mouseY ) );
			var nc : Component = e.transferable.getData( ComponentsFlavors.COMPONENT );
			if( c && c != nc )
			{
				var l : Node = multiSplitLayout.getLeafParent(c);
				var bb : Rectangle = l.bounds;				
				var left : Number = Math.min( bb.left + _dropBorderSize, bb.left + bb.width / 2);
				var right : Number = Math.max( bb.right - _dropBorderSize, bb.left + bb.width / 2);
				var top : Number = Math.min( bb.top + _dropBorderSize, bb.top + bb.height / 2);
				var bottom : Number = Math.max( bb.bottom - _dropBorderSize, bb.top + bb.height / 2);
				var split : Split;
				var nl : Leaf;
				if( l.parent.rowLayout )
				{
					if( mouseX < left )
					{
						e.transferable.transferPerformed();
						insertBefore( e.transferable.getData( ComponentsFlavors.COMPONENT ), l );	
					}
					else if ( mouseX > right )
					{
						e.transferable.transferPerformed();
						insertAfter( e.transferable.getData( ComponentsFlavors.COMPONENT ), l );										
					}
					else if( mouseY < top )
					{
						e.transferable.transferPerformed();
						split = new Split( false );
						nl = new Leaf ( nc );
						multiSplitLayout.replaceSplitChild( l.parent, l, split );
						multiSplitLayout.addSplitChild( split, nl );
						multiSplitLayout.addSplitChild( split, l );
						addComponent(nc);
						(l.previousSiblings() as Divider).location = bb.height / 2;
					}
					else if ( mouseY > bottom )
					{
						e.transferable.transferPerformed();
						split = new Split( false );
						nl = new Leaf ( nc );
						multiSplitLayout.replaceSplitChild( l.parent, l, split );
						multiSplitLayout.addSplitChild( split, l );
						multiSplitLayout.addSplitChild( split, nl );
						addComponent(nc);
						(l.nextSiblings() as Divider).location = bb.height / 2;
					}
				}
				else
				{
					if( mouseX < left )
					{
						e.transferable.transferPerformed();
						split = new Split();
						nl = new Leaf ( nc );
						multiSplitLayout.replaceSplitChild( l.parent, l, split );
						multiSplitLayout.addSplitChild( split, nl );
						multiSplitLayout.addSplitChild( split, l );
						addComponent(nc);
						(l.previousSiblings() as Divider).location = bb.width / 2;
					}
					else if ( mouseX > right )
					{
						e.transferable.transferPerformed();
						split = new Split();
						nl = new Leaf ( nc );
						multiSplitLayout.replaceSplitChild( l.parent, l, split );
						multiSplitLayout.addSplitChild( split, l );
						multiSplitLayout.addSplitChild( split, nl );
						addComponent(nc);
						(l.nextSiblings() as Divider).location = bb.width / 2;
					}
					else if( mouseY < top )
					{
						e.transferable.transferPerformed();
						insertBefore( e.transferable.getData( ComponentsFlavors.COMPONENT ), l );	
					}
					else if ( mouseY > bottom )
					{
						e.transferable.transferPerformed();
						insertAfter( e.transferable.getData( ComponentsFlavors.COMPONENT ), l );										
					}
				}
			}
		}
		override public function get supportedFlavors () : Array { return [ ComponentsFlavors.COMPONENT ]; }
		
		protected function insertAfter ( c : Component, after : Node ) : void
		{
			var split : Split = after.parent;
			var l : Leaf = new Leaf( c );
			if( split )
			{
				multiSplitLayout.addSplitChildAfter( split, l, after );
				addComponent( c );
				var bb : Rectangle =  l.siblingAtOffset(-2).bounds;
				if( split.rowLayout )
					( l.previousSiblings() as Divider ).location = bb.x + bb.width / 2;
				else
					( l.previousSiblings() as Divider ).location = bb.y + bb.height / 2;
			}
		}

		protected function insertBefore (  c : Component, before : Node ) : void
		{
			var split : Split = before.parent;
			var l : Leaf = new Leaf( c );
			if( split )
			{
				multiSplitLayout.addSplitChildBefore( split, l, before );
				addComponent( c );
				var bb : Rectangle =  l.siblingAtOffset(2).bounds;
				if( split.rowLayout )
					( l.nextSiblings() as Divider ).location = bb.x + bb.width / 2;
				else
					( l.nextSiblings() as Divider ).location = bb.y + bb.height / 2;
			}
		}

		protected function drawDropOnDivider (d : Divider) : void
		{
			var bb : Rectangle = d.bounds;
			_dropStatusShape.graphics.beginFill( _style.dropZoneColor.hexa,
												 _style.dropZoneColor.alpha );
			_dropStatusShape.graphics.drawRect( bb.x, bb.y, bb.width, bb.height );
			_dropStatusShape.graphics.endFill( );
		}
		
		public function get dropBorderSize () : Number
		{
			return _dropBorderSize;
		}
		
		public function set dropBorderSize (dropBorderSize : Number) : void
		{
			_dropBorderSize = dropBorderSize;
		}
		/*FDT_IGNORE*/ } /*FDT_IGNORE*/
	}
}
