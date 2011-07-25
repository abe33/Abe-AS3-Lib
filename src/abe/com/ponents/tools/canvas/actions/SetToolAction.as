package abe.com.ponents.tools.canvas.actions 
{
    import abe.com.mon.utils.KeyStroke;
    import abe.com.ponents.actions.AbstractAction;
    import abe.com.ponents.buttons.ToolButton;
    import abe.com.ponents.core.Component;
    import abe.com.ponents.events.ToolEvent;
    import abe.com.ponents.skinning.icons.Icon;
    import abe.com.ponents.tools.canvas.Tool;
    import abe.com.ponents.tools.canvas.ToolManager;

    /**
     * Évènement diffusé lorsqu'une propriété de l'action est modifiée.
     * 
     * <p>Les propriétés suivantes sont à l'origine de la diffusion de l'évènement
     * <code>propertyChange</code></p>
     * <ul>
     * <li>name</li>            
     * <li>icon</li>
     * <li>longDescription</li>
     * <li>accelerator</li>
     * <li>actionEnabled</li>
     * <li>selected</li>
     * </ul>
     * 
     * @eventType abe.com.ponents.events.PropertyEvent.PROPERTY_CHANGE
     */
    /**
     * @author Cédric Néhémie
     */
    public class SetToolAction extends AbstractAction 
    {
        public var tool : Tool;
        public var manager : ToolManager;
        protected var _selected : Boolean;

        public function SetToolAction ( manager : ToolManager, 
                                  tool : Tool, 
                                  name : String = "", 
                                  icon : Icon = null, 
                                  longDesc : String = null, 
                                  accelerator : KeyStroke = null )
        {
            super( name, icon, longDesc, accelerator );
            this.manager = manager;
            manager.toolSelected.add( toolSelected );
            this.tool = tool;
        }
        
        private function toolSelected ( ... args ) : void
        {
            selected = manager.tool == tool;
        }

        override public function execute( ... args ) : void
        {
            manager.tool = tool;    
            _commandEnded.dispatch( this );
        }
        
        public function get selected () : Boolean { return _selected; }        
        public function set selected (selected : Boolean) : void
        {
            if( _selected != selected )
            {
                _selected = selected;
                _propertyChanged.dispatch("selected", _selected );
            }
        }
        override public function get component () : Component 
        {
            return new ToolButton( this );
        }
    }
}
