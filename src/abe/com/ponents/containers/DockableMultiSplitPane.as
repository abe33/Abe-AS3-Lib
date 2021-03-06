package abe.com.ponents.containers 
{
	import abe.com.ponents.core.Component;
	import abe.com.ponents.core.Dockable;
	import abe.com.ponents.core.DockableContainer;
	import abe.com.ponents.dnd.*;
	import abe.com.ponents.events.*;
	import abe.com.ponents.layouts.components.splits.Leaf;
	import abe.com.ponents.tabs.ClosableTab;
	import abe.com.ponents.tabs.SimpleTab;
	import abe.com.ponents.tabs.Tab;
	import abe.com.ponents.tabs.TabbedPane;
	import abe.com.ponents.transfer.*;
	
	import flash.geom.Point;

    import org.osflash.signals.events.IBubbleEventHandler;
    import org.osflash.signals.events.IEvent;
	/**
	 * @author cedric
	 */
	public class DockableMultiSplitPane extends MultiSplitPane implements IBubbleEventHandler 
	{
		protected var _closeable : Boolean;

		public function DockableMultiSplitPane ( closeable : Boolean = false )
		{
			super();
			this._closeable = closeable;
		}
		public function get closeable () : Boolean { return _closeable; }
		public function set closeable (closeable : Boolean) : void { _closeable = closeable; firePropertyChangedSignal("closeable", _closeable ); }		
		
		override public function get supportedFlavors () : Array { return [ ComponentsFlavors.DOCKABLE ];
		}
		override public function addComponent (c : Component) : void 
		{
			super.addComponent( c );
			/*
			if( c is DockableContainer )
				c.addWeakEventListener( DockEvent.DOCK_REMOVE, dockRemove );*/
		}
		override public function dragOver ( manager : DnDManager, transferable : Transferable, source : DragSource ) : void 
		{
			if( ComponentsFlavors.DOCKABLE.isSupported( transferable.flavors ) )
			{
				clearStatusShape();
				
				var c : Component = getComponentUnderPoint( new Point( stage.mouseX, stage.mouseY ) );
				//var dock : Dockable = transferable.getData( ComponentsFlavors.DOCKABLE );
				
				if( c )
					handleDragOver(c);
			}
			else
				super.dragOver( manager, transferable, source );
		}
		override public function drop ( manager : DnDManager, transferable : Transferable ) : void 
		{
			if( ComponentsFlavors.DOCKABLE.isSupported( transferable.flavors ) )
			{
				clearStatusShape();
				
				var c : Component = getComponentUnderPoint( new Point( stage.mouseX, stage.mouseY ) );
				var dock : Dockable = transferable.getData( ComponentsFlavors.DOCKABLE );
				var pane : TabbedPane = new TabbedPane();
				
				var fake : Tab = new SimpleTab("Fake");
				fake.id=dock.id;
				pane.addTab( fake );
				
				var tab : Tab;
				
				if( _closeable )
					tab = new ClosableTab(dock.label, dock.content, dock.icon ? dock.icon.clone() : null );
				else
					tab = new SimpleTab(dock.label, dock.content, dock.icon ? dock.icon.clone() : null );
				
				tab.id = dock.id;
				//var l : Leaf = multiSplitLayout.getLeafParent( c );
				
				if( c )
					if( handleDrop(c, pane, transferable ) )
					{
						pane.addTab( tab );
						pane.removeTab( fake );
					}
			}
			else
				super.drop( manager, transferable );
		}
		protected function findDockableClone( dock : Dockable ) : DockableContainer
		{
			//var srcDock : Dockable;
			for each( var pane : DockableContainer in _children )
				 if( pane.hasDockableClone(dock) )
				 	return pane;

			return null;
		}
		public function dockRemoved ( dpane : DockableContainer ) : void
		{
			if( dpane.numDocks() == 0 )
			{
				var l : Leaf = multiSplitLayout.getLeafParent(dpane);
				multiSplitLayout.removeSplitChild( l.parent, l );
				removeComponent(dpane);
			}
		}
		public function onEventBubbled( e : IEvent ):Boolean
        {
            var evt : ComponentSignalEvent = e as ComponentSignalEvent;
            if( evt.signalName == "dockRemoved" )
                dockRemoved( evt.target as DockableContainer );
              
            return false;
        }
	}
}
