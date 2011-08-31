package abe.com.ponents.tools.canvas.actions
{
	import abe.com.ponents.nodes.core.CanvasElement;
	import abe.com.mon.utils.KeyStroke;
	import abe.com.patibility.settings.SettingsManagerInstance;
	import abe.com.ponents.actions.AbstractAction;
	import abe.com.ponents.containers.Dialog;
	import abe.com.ponents.core.Component;
	import abe.com.ponents.nodes.dialogs.PreventDeleteSelectionDialog;
	import abe.com.ponents.skinning.icons.Icon;
	import abe.com.ponents.tools.CameraCanvas;
	import abe.com.ponents.tools.ObjectSelection;
	
	import flash.display.DisplayObject;
	import flash.events.ContextMenuEvent;
	import flash.ui.ContextMenuItem;
	
	public class DeleteSelection extends AbstractAction
	{
		private var _canvas:CameraCanvas;
		private var _selection:ObjectSelection;
		private var _subObjectSelection:ObjectSelection;
		
		public function DeleteSelection( canvas : CameraCanvas, 
										 selection : ObjectSelection, 
										 name:String="", 
										 icon:Icon=null, 
										 longDescription:String=null, 
										 accelerator:KeyStroke=null,
										 subObjectSelection : ObjectSelection = null)
		{
			super(name, icon, longDescription, accelerator);
			_canvas = canvas;
			_selection = selection;
            _subObjectSelection = subObjectSelection;
		}
		override public function execute(...args):void
		{
			if( !this._selection || !this._canvas )
				return;
			
			var dial : PreventDeleteSelectionDialog = new PreventDeleteSelectionDialog();
			FEATURES::SETTINGS_MEMORY {
				if( SettingsManagerInstance.get( dial, "ignoreWarning") )
				{
					resultDeleteSelection(null, Dialog.RESULTS_YES);
					return;
				}
			}
			dial.dialogResponded.addOnce( resultDeleteSelection );
			dial.open( Dialog.CLOSE_ON_RESULT );
			
		}
		protected function resultDeleteSelection ( d : Dialog, result : uint ) : void 
		{
			if( result == Dialog.RESULTS_YES )
			{
                var sel : ObjectSelection = (_subObjectSelection && !_subObjectSelection.isEmpty() ) ? 
                	_subObjectSelection : 
                    _selection;
                var objects : Array = sel.objects;
				for each( var o : DisplayObject in objects )
				{
                    if( o is CanvasElement )
                    	( o as CanvasElement ).remove();
					else if( o is Component )
						( o as Component ).parentContainer.removeComponent( o as Component );
					else
						o.parent.removeChild( o );
				}
				sel.removeAll();
			}
			_commandEnded.dispatch( this );
		}
		FEATURES::MENU_CONTEXT {
			public function get contextMenuItem () : ContextMenuItem
			{
				var cmrm : ContextMenuItem = new ContextMenuItem( name );
				cmrm.addEventListener( ContextMenuEvent.MENU_ITEM_SELECT, execute );
				propertyChanged.add( function( propertyName : String, propertyValue : * ) : void
				{
					switch( propertyName ) 
					{
						case "name" : 
							cmrm.caption = propertyValue;
							break;
						case "actionEnabled" : 
							cmrm.enabled = propertyValue;
							break;
						default : break;
					}
				});
				return cmrm;
			}
		}
	}
}