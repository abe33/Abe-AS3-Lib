package aesia.com.ponents.containers 
{
	import aesia.com.ponents.core.Component;
	import aesia.com.ponents.core.Dockable;
	import aesia.com.ponents.core.DockableContainer;
	import aesia.com.ponents.dnd.DropEvent;
	import aesia.com.ponents.dnd.DropTargetDragEvent;
	import aesia.com.ponents.events.DockEvent;
	import aesia.com.ponents.layouts.components.splits.Leaf;
	import aesia.com.ponents.tabs.ClosableTab;
	import aesia.com.ponents.tabs.SimpleTab;
	import aesia.com.ponents.tabs.Tab;
	import aesia.com.ponents.tabs.TabbedPane;
	import aesia.com.ponents.transfer.ComponentsFlavors;

	import flash.geom.Point;
	/**
	 * @author cedric
	 */
	public class DockableMultiSplitPane extends MultiSplitPane 
	{
		protected var _closeable : Boolean;

		public function DockableMultiSplitPane ( closeable : Boolean = false )
		{
			super();
			this._closeable = closeable;
		}
		public function get closeable () : Boolean { return _closeable; }
		public function set closeable (closeable : Boolean) : void { _closeable = closeable; firePropertyEvent("closeable", _closeable ); }		
		
		override public function get supportedFlavors () : Array { return [ ComponentsFlavors.DOCKABLE ];
		}
		override public function addComponent (c : Component) : void 
		{
			super.addComponent( c );
			if( c is DockableContainer )
				c.addWeakEventListener( DockEvent.DOCK_REMOVE, dockRemove );
		}
		override public function dragOver (e : DropTargetDragEvent) : void 
		{
			if( ComponentsFlavors.DOCKABLE.isSupported( e.flavors ) )
			{
				clearStatusShape();
				
				var c : Component = getComponentUnderPoint( new Point( stage.mouseX, stage.mouseY ) );
				//var dock : Dockable = e.transferable.getData( ComponentsFlavors.DOCKABLE );
				
				if( c )
					handleDragOver(c);
			}
			else
				super.dragOver(e);
		}
		override public function drop (e : DropEvent) : void 
		{
			if( ComponentsFlavors.DOCKABLE.isSupported( e.transferable.flavors ) )
			{
				clearStatusShape();
				
				var c : Component = getComponentUnderPoint( new Point( stage.mouseX, stage.mouseY ) );
				var dock : Dockable = e.transferable.getData( ComponentsFlavors.DOCKABLE );
				var pane : TabbedPane = new TabbedPane();
				
				var fake : Tab = new SimpleTab("Fake");
				fake.id=dock.id;
				pane.addTab( fake );
				
				var tab : Tab;
				
				if( _closeable )
					tab = new ClosableTab(dock.label, dock.content, dock.icon.clone());
				else					tab = new SimpleTab(dock.label, dock.content, dock.icon.clone());
				
				tab.id = dock.id;
				//var l : Leaf = multiSplitLayout.getLeafParent( c );
				
				if( c )
					if( handleDrop(c, pane, e.transferable ) )
					{
						pane.addTab( tab );
						pane.removeTab( fake );
					}
			}
			else
				super.drop(e);
		}
		protected function findDockableClone( dock : Dockable ) : DockableContainer
		{
			//var srcDock : Dockable;
			for each( var pane : DockableContainer in _children )
				 if( pane.hasDockableClone(dock) )
				 	return pane;

			return null;
		}
		public function dockRemove ( e : DockEvent ) : void
		{
			var dpane : DockableContainer = e.target as DockableContainer;
			if( dpane.numDocks() == 0 )
			{
				var l : Leaf = multiSplitLayout.getLeafParent(dpane);
				multiSplitLayout.removeSplitChild( l.parent, l );
				removeComponent(dpane);
			}
		}
	}
}
