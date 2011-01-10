package aesia.com.ponents.nodes.actions 
{
	import aesia.com.patibility.settings.SettingsManagerInstance;
	import aesia.com.mon.utils.KeyStroke;
	import aesia.com.ponents.actions.AbstractAction;
	import aesia.com.ponents.containers.Dialog;
	import aesia.com.ponents.events.DialogEvent;
	import aesia.com.ponents.events.PropertyEvent;
	import aesia.com.ponents.nodes.core.CanvasNode;
	import aesia.com.ponents.nodes.core.NodeLink;
	import aesia.com.ponents.nodes.dialogs.PreventDeleteSelectionDialog;
	import aesia.com.ponents.skinning.icons.Icon;
	import aesia.com.ponents.tools.CameraCanvas;
	import aesia.com.ponents.tools.ObjectSelection;
	import aesia.com.ponents.utils.SettingsMemoryChannels;

	import flash.events.ContextMenuEvent;
	import flash.events.Event;
	import flash.ui.ContextMenuItem;
	/**
	 * @author cedric
	 */
	public class DeleteCurrentSelectionAction extends AbstractAction 
	{
		public var selection : ObjectSelection;
		public var canvas : CameraCanvas;
		public var nodeLayer : uint;

		public function DeleteCurrentSelectionAction ( selection : ObjectSelection, 
														canvas : CameraCanvas,
														nodeLayer : uint,
													 name : String = "", 
													 icon : Icon = null, 
													 longDescription : String = null, 
													 accelerator : KeyStroke = null )
		{
			super( name, icon, longDescription, accelerator );
			this.selection = selection;
			this.canvas = canvas;
			this.nodeLayer = nodeLayer;
		}
		override public function execute (e : Event = null) : void 
		{
			var dial : PreventDeleteSelectionDialog = new PreventDeleteSelectionDialog();
			/*FDT_IGNORE*/ FEATURES::SETTINGS_MEMORY { /*FDT_IGNORE*/
			if( SettingsManagerInstance.get( dial, "ignoreWarning") )
			{
				resultDeleteSelection(new DialogEvent("", Dialog.RESULTS_YES));
				return;
			}
			/*FDT_IGNORE*/ } /*FDT_IGNORE*/
			dial.addEventListener( DialogEvent.DIALOG_RESULT ,resultDeleteSelection, false, 0, true );
			dial.open( Dialog.CLOSE_ON_RESULT );
			
		}
		protected function resultDeleteSelection ( e : DialogEvent ) : void 
		{
			if( e.result == Dialog.RESULTS_YES )
			{
				selection.objects.sort(function(a:*,b:*):int{
					if( a is CanvasNode && b is CanvasNode )
						return 0;
					else if( a is CanvasNode )
						return 1;
					else
						return -1;
				});
				for each( var o : Object in selection.objects )
					if( o is NodeLink )
						new UnlinkNodesCommand( o as NodeLink ).execute();
					else if( o is CanvasNode )
						new DeleteNodeCommand( canvas, nodeLayer, o as CanvasNode ).execute();
			
				selection.removeAll();
				
			}
			fireCommandEnd();
		}
		/*FDT_IGNORE*/ FEATURES::MENU_CONTEXT { /*FDT_IGNORE*/
		public function get contextMenuItem () : ContextMenuItem
		{
			var cmrm : ContextMenuItem = new ContextMenuItem( name );
			cmrm.addEventListener( ContextMenuEvent.MENU_ITEM_SELECT, execute );
			addEventListener(PropertyEvent.PROPERTY_CHANGE, 
			function( e : PropertyEvent ) : void
			{
				switch( e.propertyName ) 
				{
					case "name" : 
						cmrm.caption = e.propertyValue;
						break;
					case "actionEnabled" : 
						cmrm.enabled = e.propertyValue;
						break;
					default : break;
				}
			});
			return cmrm;
		}
		/*FDT_IGNORE*/ } /*FDT_IGNORE*/
	}
}
