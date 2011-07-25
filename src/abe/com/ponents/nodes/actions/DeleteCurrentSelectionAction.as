package abe.com.ponents.nodes.actions 
{
    import abe.com.mon.utils.KeyStroke;
    import abe.com.patibility.settings.SettingsManagerInstance;
    import abe.com.ponents.actions.AbstractAction;
    import abe.com.ponents.containers.Dialog;
    import abe.com.ponents.nodes.core.CanvasNode;
    import abe.com.ponents.nodes.core.NodeLink;
    import abe.com.ponents.nodes.dialogs.PreventDeleteSelectionDialog;
    import abe.com.ponents.skinning.icons.Icon;
    import abe.com.ponents.tools.CameraCanvas;
    import abe.com.ponents.tools.ObjectSelection;

    import flash.events.ContextMenuEvent;
    import flash.ui.ContextMenuItem;
    /**
     * @author cedric
     */
    public class DeleteCurrentSelectionAction extends AbstractAction 
    {
        public var selection : ObjectSelection;
        public var canvas : CameraCanvas;
        public var nodeLayer : uint;

        public function DeleteCurrentSelectionAction (  selection : ObjectSelection = null, 
                                                        canvas : CameraCanvas = null,
                                                        nodeLayer : uint = 0,
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
        override public function execute( ... args ) : void 
        {
			if( !this.selection || !this.canvas )
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
