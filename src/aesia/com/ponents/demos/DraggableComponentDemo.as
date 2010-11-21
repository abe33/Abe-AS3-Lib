package aesia.com.ponents.demos 
{
	import aesia.com.mon.geom.Dimension;
	import aesia.com.mon.logs.Log;
	import aesia.com.mon.utils.StageUtils;
	import aesia.com.ponents.containers.ScrollPane;
	import aesia.com.ponents.dnd.DnDDragObjectRenderer;
	import aesia.com.ponents.dnd.DnDDropRenderer;
	import aesia.com.ponents.dnd.DnDEvent;
	import aesia.com.ponents.dnd.DnDManagerInstance;
	import aesia.com.ponents.transfer.ComponentsFlavors;
	import aesia.com.ponents.utils.KeyboardControllerInstance;
	import aesia.com.ponents.utils.ToolKit;

	import flash.display.Sprite;

	/**
	 * @author Cédric Néhémie
	 */
	public class DraggableComponentDemo extends Sprite 
	{
		private var dragRenderer : DnDDragObjectRenderer;		private var dropRenderer : DnDDropRenderer;
		
		public function DraggableComponentDemo ()
		{
			StageUtils.setup( this );
			StageUtils.flexibleStage();
			ToolKit.initializeToolKit();

			KeyboardControllerInstance.eventProvider = stage;
			
			var source : Source = new Source();	
			source.x = 50;
			source.y = 50;
			//StageUtils.lockToStage( source );
			
			var target1 : Target = new Target();
			target1.x = 50;
			target1.y = 120;			target1.preferredSize = new Dimension(80,80);			
			var target2 : Target = new Target( );
			target2.x = 150;
			target2.y = 120;
			target2.preferredSize = new Dimension(80,80);			
			var target3 : Target = new Target();
			target3.x = 50;
			target3.y = 220;
			target3.preferredSize = new Dimension(80,80);
			target3.supportedFlavors = [ ComponentsFlavors.ACTION ];			
			var target4 : Target = new Target( );
			target4.preferredSize = new Dimension(200,200);
			
			var scp : ScrollPane = new ScrollPane();
			scp.viewport.view = target4;
			scp.x = 150;
			scp.y = 220;
			scp.preferredSize = new Dimension(80,80);
			
			dragRenderer = new DnDDragObjectRenderer( DnDManagerInstance );			dropRenderer = new DnDDropRenderer( DnDManagerInstance );
			
			ToolKit.mainLevel.addChild( target1 );		
			ToolKit.mainLevel.addChild( target2 );		
			ToolKit.mainLevel.addChild( target3 );		
			ToolKit.mainLevel.addChild( scp );
			ToolKit.mainLevel.addChild( source );		
			 
			DnDManagerInstance.addEventListener( DnDEvent.DRAG_ABORT, 	dragAborted  );		
			DnDManagerInstance.addEventListener( DnDEvent.DRAG_START, 	dragStarted  );		
			DnDManagerInstance.addEventListener( DnDEvent.DRAG_STOP, 	dragStopped  );		
			DnDManagerInstance.addEventListener( DnDEvent.DRAG_ENTER, 	dragEntered  );		
			DnDManagerInstance.addEventListener( DnDEvent.DRAG_EXIT, 		dragExited   );		
			DnDManagerInstance.addEventListener( DnDEvent.DRAG_ACCEPT, 	dragAccepted );		
			DnDManagerInstance.addEventListener( DnDEvent.DRAG_REJECT, 	dragRejected );		
			DnDManagerInstance.addEventListener( DnDEvent.DROP, 			drop );
		}

		public function dragStarted ( e : DnDEvent ) : void
		{
			Log.info( "Drag started" );
		}
		public function dragStopped ( e : DnDEvent ) : void
		{
			Log.info( "Drag stopped" );
		}
		public function dragAborted ( e : DnDEvent ) : void
		{
			Log.info( "Drag aborted" );
		}
		public function dragEntered ( e : DnDEvent ) : void
		{
			Log.info( "Drag entered in " + e.dropTarget );
		}
		public function dragExited ( e : DnDEvent ) : void
		{
			Log.info( "Drag exited from " + e.dropTarget );
		}
		public function dragAccepted ( e : DnDEvent ) : void
		{
			Log.info( e.dropTarget + " has accepted drag" );
		}
		public function dragRejected ( e : DnDEvent ) : void
		{
			Log.info( e.dropTarget + " has rejected drag" );
		}
		public function drop ( e : DnDEvent ) : void
		{
			Log.info( "drop was performed" );
		}
	}
}

import aesia.com.mon.logs.Log;
import aesia.com.ponents.buttons.DraggableButton;
import aesia.com.ponents.core.AbstractComponent;
import aesia.com.ponents.core.Component;
import aesia.com.ponents.dnd.DnDManagerInstance;
import aesia.com.ponents.dnd.DropEvent;
import aesia.com.ponents.dnd.DropTarget;
import aesia.com.ponents.dnd.DropTargetDragEvent;
import aesia.com.ponents.transfer.DataFlavor;
import aesia.com.ponents.transfer.Transferable;

import flash.display.DisplayObject;
import flash.events.Event;

internal class FakeTransferable implements Transferable
{
	static public const FAKE_FLAVOR : DataFlavor =  new DataFlavor( "fake" );
	
	private var _c : Component;
	
	public function FakeTransferable ( o : Component )
	{
		_c = o;
	}

	public function getData (flavor : DataFlavor) : *
	{
		return _c;
	}
	public function get flavors () : Array
	{
		return [ FAKE_FLAVOR ];
	}
	
	public function transferPerformed () : void
	{
	}
	
	public function get mode () : String
	{
		return "move";
	}
}



internal class Source extends DraggableButton
{
	public function Source ()
	{
		label = "Drag Me !";
	}
	
	override public function click ( e : Event = null ) : void
	{
		Log.debug( "a simple click occured" );
	}

	override public function get transferData () : Transferable
	{
		return new FakeTransferable( this );
	}

	override public function get dragGeometry () : DisplayObject
	{
		return this;
	}
}

internal class Target extends AbstractComponent implements DropTarget 
{
	
	protected var _supportedFlavors : Array;

	public function Target ()
	{
		DnDManagerInstance.registerDropTarget( this );
		_allowFocus = false;
		_allowOver = false;
		_allowPressed = false;
		_allowSelected = false;
		_supportedFlavors = [ FakeTransferable.FAKE_FLAVOR ];
		buttonMode = false;
	}

	public function dragEnter (e : DropTargetDragEvent) : void
	{
		var a : Array = e.flavors;
		if( supportedFlavors.some( function(item : DataFlavor, ...arg) : Boolean {
			return item.isSupported( a );
		} ) )
			e.acceptDrag( this );
		else
			e.rejectDrag( this );
		//Log.warn( "drag enter " + this );
	}
	public function dragOver (e : DropTargetDragEvent) : void
	{
		//Log.warn( "drag over " + this );
	}
	public function dragExit (e : DropTargetDragEvent) : void
	{
		//Log.warn( "drag exit " + this );
	}
	public function drop (e : DropEvent) : void
	{
		var c : Component = e.transferable.getData( null ) as Component;
		
		Log.warn( c + " was dropped on " + this );
		c.x = x;
		c.y = y;
		c.width = width;
		c.height = height;
	}
	
	public function get supportedFlavors () : Array
	{
		return _supportedFlavors;
	}

	public function set supportedFlavors (supportedFlavors : Array) : void
	{
		_supportedFlavors = supportedFlavors;
	}
}
