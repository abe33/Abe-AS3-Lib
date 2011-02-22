package abe.com.ponents.layouts.components 
{
	import abe.com.ponents.events.ContainerEvent;
	import flash.events.Event;
	import abe.com.mon.geom.Dimension;
	import abe.com.mon.geom.dm;
	import abe.com.ponents.core.Component;
	import abe.com.ponents.core.Container;
	import abe.com.ponents.dnd.DnDManagerInstance;
	import abe.com.ponents.dnd.DropEvent;
	import abe.com.ponents.dnd.DropTarget;
	import abe.com.ponents.dnd.DropTargetDragEvent;
	import abe.com.ponents.transfer.ComponentsFlavors;
	import abe.com.ponents.transfer.DataFlavor;
	import abe.com.ponents.transfer.ToolBarTransferable;
	import abe.com.ponents.utils.Directions;
	import abe.com.ponents.utils.Insets;
	/**
	 * @author cedric
	 */
	public class ApplicationWindowLayout extends BorderLayout implements DropTarget
	{
		static public const TOOLBAR_DROP : String = "toolbarDrop";
		
		public var menuComponent : Component;
		
		public function ApplicationWindowLayout (container : Container = null, forceStretch : Boolean = true)
		{
			super( container, forceStretch );
			
			/*FDT_IGNORE*/ FEATURES::DND { /*FDT_IGNORE*/
			DnDManagerInstance.registerDropTarget(this);
			/*FDT_IGNORE*/ } /*FDT_IGNORE*/
		}
		override public function get preferredSize () : Dimension 
		{
			return menuComponent ? super.preferredSize.grow( 0, menuComponent.preferredHeight ) : super.preferredSize;
		}
		
		override public function layout (preferredSize : Dimension = null, insets : Insets = null) : void 
		{
			insets = insets ? insets : new Insets();
			if( menuComponent )
			{
				menuComponent.x = insets.left; 
				menuComponent.y = insets.top;
				menuComponent.width = preferredSize.width - insets.horizontal;
				
				super.layout( preferredSize, 
							  new Insets( insets.left , insets.top + menuComponent.height, insets.right, insets.bottom ) );
			}
			else
			super.layout( preferredSize, insets );
		}
		/*FDT_IGNORE*/ FEATURES::DND { /*FDT_IGNORE*/
		public function get component () : Component { return _container; }
		public function get supportedFlavors () : Array { return [ ComponentsFlavors.TOOLBAR ]; }
		public function dragEnter (e : DropTargetDragEvent) : void
		{
			if( _container.enabled &&
				supportedFlavors.some( function( item : DataFlavor, ...args ) : Boolean { return item.isSupported( e.transferable.flavors ); } )  )
			{
				e.acceptDrag( this );
				initDroppers();
			}
			else
				e.rejectDrag( this );
			
		}
		public function dragOver (e : DropTargetDragEvent) : void
		{
		}
		public function drop (e : DropEvent) : void
		{
			var tb : ToolBarTransferable = e.transferable as ToolBarTransferable;
			var c : Component = tb.getData( ComponentsFlavors.TOOLBAR );
			if( north is ToolBarDropper && north.isMouseOver )
			{
				handleChildDrop(c);
				
				_container.removeComponent(north);
				tb.transferPerformed();
				tb.toolbar.direction = Directions.LEFT_TO_RIGHT;
				north = c;
				_container.addComponent(c);
				fireToolBarDropEvent(tb.toolbar);
			}
			if( south is ToolBarDropper && south.isMouseOver )
			{
				handleChildDrop(c);
				
				_container.removeComponent(south);
				tb.transferPerformed();
				tb.toolbar.direction = Directions.LEFT_TO_RIGHT;
				south = c;
				_container.addComponent(c);				fireToolBarDropEvent(tb.toolbar);
			}
			if( east is ToolBarDropper && east.isMouseOver )
			{
				handleChildDrop(c);
				
				_container.removeComponent(east);
				tb.transferPerformed();
				tb.toolbar.direction = Directions.TOP_TO_BOTTOM;
				east = c;
				_container.addComponent(c);				fireToolBarDropEvent(tb.toolbar);
			}
			if( west is ToolBarDropper && west.isMouseOver )
			{
				handleChildDrop(c);
				
				_container.removeComponent(west);
				tb.transferPerformed();
				tb.toolbar.direction = Directions.TOP_TO_BOTTOM;
				west = c;
				_container.addComponent(c);				fireToolBarDropEvent(tb.toolbar);
			}
				
			releaseDroppers();
		}
		public function handleChildDrop( c : Component ) : void
		{
			if( _container.isDescendant(c) )
			{
				if( c == north )
					north = null;
				else if( c == south )
					south = null;
				else if( c == east )
					east = null;
				else if( c == west )
					west = null;
			}
		}
		public function dragExit (e : DropTargetDragEvent) : void
		{
			releaseDroppers();
		}			
		protected function releaseDroppers () : void 
		{
			if( north && north is ToolBarDropper )
			{
				_container.removeComponent(north);
				north = null;
			}
			if( south && south is ToolBarDropper )
			{
				_container.removeComponent(south);
				south = null;
			}
			if( west && west is ToolBarDropper )
			{
				_container.removeComponent(west);
				west = null;
			}
			if( east && east is ToolBarDropper )
			{
				_container.removeComponent(east);
				east = null;
			}
		}
		protected function initDroppers () : void 
		{
			if( !north )
			{
				north = new ToolBarDropper();
				north.preferredSize = dm(8,8);
				_container.addComponent(north);
			}
			if( !south )
			{
				south = new ToolBarDropper();
				south.preferredSize = dm(8,8);
				_container.addComponent(south);
			}
			if( !east )
			{
				east = new ToolBarDropper();
				east.preferredSize = dm(8,8);
				_container.addComponent(east);
			}
			if( !west )
			{
				west = new ToolBarDropper();
				west.preferredSize = dm(8,8);
				_container.addComponent(west);
			}
		}
		/*FDT_IGNORE*/ } /*FDT_IGNORE*/
		protected function fireToolBarDropEvent (child : Component) : void
		{
			dispatchEvent( new ContainerEvent(TOOLBAR_DROP, child ) );
		}
		public function getPosition (c : Component) : String
		{
			if( _container.isDescendant(c) )
			{
				if( isAtPosition( c, north ) )
					return "north";
				else if( isAtPosition( c, south ) )
					return "south";
				else if( isAtPosition( c, east ) )
					return "east";
				else if( isAtPosition( c, west ) )
					return "west";
				else if( isAtPosition( c, center ) )
					return "center";
				else 
					return null;
			}
			else return null;
		}
		public function isAtPosition( c : Component, ct : Component ) : Boolean
		{
			return c == ct ||
				   ( (ct && ct is Container ) ? ( ct as Container ).isDescendant(c) : false );
		}
	}
}

import abe.com.ponents.core.AbstractContainer;

internal class ToolBarDropper extends AbstractContainer
{
	
}
