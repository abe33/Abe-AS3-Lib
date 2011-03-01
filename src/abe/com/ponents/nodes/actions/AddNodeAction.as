package abe.com.ponents.nodes.actions 
{
	import abe.com.mon.utils.KeyStroke;
	import abe.com.ponents.actions.AbstractAction;
	import abe.com.ponents.events.PropertyEvent;
	import abe.com.ponents.history.UndoManagerInstance;
	import abe.com.ponents.nodes.core.CanvasNode;
	import abe.com.ponents.skinning.icons.Icon;
	import abe.com.ponents.tools.CameraCanvas;

	import flash.events.ContextMenuEvent;
	import flash.events.Event;
	import flash.ui.ContextMenuItem;
	/**
	 * @author cedric
	 */
	public class AddNodeAction extends AbstractAction 
	{
		public var canvas : CameraCanvas;
		public var userObjectProvider : *;
		public var layer : uint;

		public function AddNodeAction ( canvas : CameraCanvas,
										layer:uint = 0, 
										userObjectProvider : * = null, 
										name : String = "", 
										icon : Icon = null, 
										longDescription : String = null, 
										accelerator : KeyStroke = null)
		{
			super( name, icon, longDescription, accelerator );
			this.canvas = canvas;
			this.layer = layer;
			this.userObjectProvider = userObjectProvider;
		}
		override public function execute (e : Event = null) : void 
		{
			var n : CanvasNode = new CanvasNode();
			
			if( userObjectProvider != null )
			{
				if( userObjectProvider is Class )
					n.userObject = new userObjectProvider();
				if( userObjectProvider is Function )
					n.userObject = userObjectProvider();
				else
					n.userObject = null;
			}
			n.x = canvas.getLayerAt(layer).mouseX;
			canvas.addComponentToLayer( n, layer );
			UndoManagerInstance.add( new AddNodeUndoable( canvas, layer, n ) );
			super.execute( e );
		}
		/*FDT_IGNORE*/ FEATURES::MENU_CONTEXT { /*FDT_IGNORE*/
		public function get contextMenuItem () : ContextMenuItem
		{
			var cmadd : ContextMenuItem = new ContextMenuItem( name );
			cmadd.addEventListener( ContextMenuEvent.MENU_ITEM_SELECT, execute );
			addEventListener(PropertyEvent.PROPERTY_CHANGE, 
			function( e : PropertyEvent ) : void
			{
				switch( e.propertyName ) 
				{
					case "name" : 
						cmadd.caption = e.propertyValue;
						break;
					case "actionEnabled" : 
						cmadd.enabled = e.propertyValue;
						break;
					default : break;
				}
			});
			return cmadd;
		}
		/*FDT_IGNORE*/ } /*FDT_IGNORE*/
	}
}

import abe.com.patibility.lang._;
import abe.com.ponents.history.AbstractUndoable;
import abe.com.ponents.nodes.core.CanvasNode;
import abe.com.ponents.tools.CameraCanvas;

internal class AddNodeUndoable extends AbstractUndoable 
{
	
	private var layer : uint;
	private var node : CanvasNode;
	private var canvas : CameraCanvas;

	public function AddNodeUndoable ( canvas : CameraCanvas, layer : uint, node : CanvasNode ) 
	{
		_label = _("Add Node");
		this.canvas = canvas;
		this.layer = layer;
		this.node = node;
	}
	override public function undo () : void 
	{
		canvas.removeComponent( node );
		super.undo();
	}
	override public function redo () : void 
	{
		canvas.addComponentToLayer( node, layer );
		super.redo();
	}
}