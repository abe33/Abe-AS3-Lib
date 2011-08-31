package abe.com.ponents.nodes.core 
{
    import abe.com.mon.geom.ClosedGeometry;
    import abe.com.mon.geom.Ellipsis;
    import abe.com.mon.geom.Rectangle2;
    import abe.com.mon.logs.Log;
    import abe.com.mon.utils.StageUtils;
    import abe.com.mon.utils.StringUtils;
    import abe.com.mon.utils.magicClone;
    import abe.com.mon.utils.magicCopy;
    import abe.com.patibility.lang._;
    import abe.com.ponents.actions.builtin.EditObjectPropertiesAction;
    import abe.com.ponents.containers.Panel;
    import abe.com.ponents.containers.Window;
    import abe.com.ponents.core.Component;
    import abe.com.ponents.forms.FormObject;
    import abe.com.ponents.forms.managers.SimpleFormManager;
    import abe.com.ponents.history.UndoManagerInstance;
    import abe.com.ponents.layouts.components.InlineLayout;
    import abe.com.ponents.nodes.renderers.nodes.NodeRendererFactoryInstance;
    import abe.com.ponents.skinning.decorations.SimpleEllipsisBorders;
    import abe.com.ponents.skinning.decorations.SimpleEllipsisFill;
    import abe.com.ponents.utils.Inspect;

    import org.osflash.signals.Signal;

    import flash.display.DisplayObject;
    import flash.events.Event;
    import flash.events.MouseEvent;

    [Skinable(skin="SquareNode")]
    [Skin(define="RoundNode",
          inherit="DefaultComponent",
          state__all__background="new deco::SimpleEllipsisFill( skin.backgroundColor )",
          state__all__foreground="new deco::SimpleEllipsisBorders( skin.borderColor )",
          state__all__insets="new cutils::Insets(3)"
    )]
    [Skin(define="SquareNode",
          inherit="DefaultComponent",
          state__all__insets="new cutils::Insets(3)"
    )]
    /**
     * @author cedric
     */
    public class CanvasNode extends Panel implements CanvasElement
    {
        static public const ROUND_SHAPE:String = "round";
        static public const RECT_SHAPE:String = "rect";
        
        static private const SKIN_DEPENDENCIES : Array = [ SimpleEllipsisFill, SimpleEllipsisBorders ];
        
        TARGET::FLASH_9
        protected var _connections : Array;
        TARGET::FLASH_10
        protected var _connections : Vector.<NodeLink>;
        TARGET::FLASH_10_1
        protected var _connections : Vector.<NodeLink>;
        
        protected var _userObject : *;
        protected var _shape : String;
        protected var _editObjectCallback : Function;
        
        public var selectedChanged : Signal;
        public var connectionAdded : Signal;
        public var connectionRemoved : Signal;

        public function CanvasNode ( userObject : * = null )
        {
            selectedChanged = new Signal();
            connectionAdded = new Signal();
            connectionRemoved = new Signal();
            
            _childrenLayout = _childrenLayout ? _childrenLayout : new InlineLayout(this, 3, "center", "top", "topToBottom", true );
            super();
            _allowChildrenFocus = false;
            _allowSelected = true;    
            _allowFocus = false;        
            _shape = RECT_SHAPE;
            _childrenContainer.mouseChildren = false;
            
            TARGET::FLASH_9 { _connections = []; }
            TARGET::FLASH_10 { _connections = new Vector.<NodeLink>(); }
            TARGET::FLASH_10_1 { _connections = new Vector.<NodeLink>(); }
            
            doubleClickEnabled = true;
            
            FEATURES::MENU_CONTEXT { 
                addNewContextMenuItemForGroup(  _("Edit content properties"), 
                                                "properties", 
                                                editObjectProperties, 
                                                "objects", 
                                                -1, 
                                                true );
            }
            
            if( userObject )
                this.userObject = userObject;
        }
        TARGET::FLASH_9
        public function get connections () : Array { return _connections; }
        TARGET::FLASH_10
        public function get connections () : Vector.<NodeLink> { return _connections; }
        TARGET::FLASH_10_1
        public function get connections () : Vector.<NodeLink> { return _connections; }
        
        public function get hasSubObjects () : Boolean { return false; }
        public function get isSelectable () : Boolean { return true; }
        public function get isMovable () : Boolean { return true; }
        public function get userObject () : * {    return _userObject;    }
        public function set userObject (userObject : *) : void
        {
            _userObject = userObject;
            
            FEATURES::MENU_CONTEXT {
                this.setContextMenuItemEnabled("properties", _userObject != null );    
            }
            
            removeAllComponents();
            var res : * = NodeRendererFactoryInstance.getRenderer(userObject).render(userObject);
            if( res is Component )
                addComponent( res as Component );
            if( res is Array )
                addComponents.apply( this, res );
        }
        override public function set doubleClickEnabled (enabled : Boolean) : void 
        {
            super.doubleClickEnabled = enabled;
            _childrenContainer.doubleClickEnabled = enabled;
            for each( var c : Component in _children )
                c.doubleClickEnabled = enabled;
        }
        public function get shape () : String { return _shape; }
        public function set shape (shape : String) : void
        {
            _shape = shape;
            switch( shape )
            {
                case ROUND_SHAPE : 
                    styleKey = "RoundNode";
                    break;
                case RECT_SHAPE : 
                default : 
                    styleKey = "SquareNode";
                    break;
            }
        }
        public function get anchorGeometry() : ClosedGeometry
        {
            switch( _shape )
            {
                case ROUND_SHAPE : 
                    return new Ellipsis(x+width/2, y+height/2, width/2, height/2 );
                case RECT_SHAPE : 
                default : 
                    return new Rectangle2(x, y, width, height);
            }
        }
        public function get selected () : Boolean { return _selected; }
        public function set selected ( b : Boolean ) : void
        {
            if( b != _selected )
            {
                _selected = b;
                invalidate();
                fireComponentChangedSignal();
                selectedChanged.dispatch(this,_selected)
                firePropertyChangedSignal( "selected", _selected );
            }
        }
        public function get editObjectCallback () : Function { return _editObjectCallback; }
        public function set editObjectCallback (editObjectCallback : Function) : void {    _editObjectCallback = editObjectCallback; }
    	
        public function isSubObject( o : DisplayObject ) : Boolean { return false; }
    
    	public function remove():void{}
    
        public function createConnection( o : CanvasNode, relashionship : String = "undefined", relashionshipDirection : String = "none" ) : NodeLink
        {
            var link : NodeLink = new NodeLink( this, o, relashionship, relashionshipDirection );
            
            addConnection( link );
            o.addConnection( link );
            return link;
        }
        public function addConnection( link : NodeLink ) : void
        {
            if( isConcerned(link) && !containsConnection( link ) )
                _connections.push( link );
            
            connectionAdded.dispatch( this, link.b, link );
        }
        public function removeConnection( link : NodeLink ):void
        {
            if( isConcerned(link) && containsConnection( link ) )
                _connections.splice( _connections.indexOf( link ), 1);
            
            connectionRemoved.dispatch( this, link.b, link );
        }
        public function removeConnectionsWith( o : CanvasNode ):void
        {
            var a : Array = getConnectionsWith( o );
            if( hasConnectionsWith( o ) )
                for each( var link : NodeLink in a )
                    _connections.splice( _connections.indexOf( link ), 1);
            
            connectionRemoved.dispatch( this, o, a );
        }
        public function containsConnection( link : NodeLink ) : Boolean
        {
            return _connections.indexOf( link ) != -1;
        }
        public function hasConnectionsWith( o : CanvasNode ) : Boolean
        {
            for each( var link : NodeLink in _connections )
                if ( link.a == o || link.b == o )
                    return true;
            
            return false;
        }
        public function getConnectionsWith( o : CanvasNode ):Array
        {
            var a : Array = [];
            for each( var link : NodeLink in _connections )
                if ( o.isConcerned(link) )
                    a.push( link );
            
            return a;
        }
		public function removeAllConnections() : void
		{
			var a : Vector.<NodeLink> = _connections.concat();
			for each( var link : NodeLink in a )
				removeConnection( link );
		}
        public function isConcerned( link : NodeLink ) : Boolean
        {
            return link.a == this || link.b == this;
        }
        /*
        override public function invalidate ( asValidateRoot : Boolean = false ) : void 
        {
            _validateRoot = true;
            checkState();
            RepaintManagerInstance.invalidate( this );
        }
        */
        protected function editObjectProperties ( e : Event = null ) : void 
        {
            if( _userObject )
                new EditObjectPropertiesAction( _userObject, 
                                                _editObjectCallback != null ? _editObjectCallback : editObjectPropertiesCallback, 
                                                null, null, null, null, true ).execute();
        }
        protected function editObjectPropertiesCallback ( o : Object, 
                                                           form : FormObject, 
                                                           manager : SimpleFormManager,
                                                           window : Window ):void
        {
            //Log.debug( form + ", " + manager + ", " + window );
            //Log.debug( o + " : " + StringUtils.prettyPrint( o ) );
            //Log.debug( form.target + " : " + StringUtils.prettyPrint( form.target ) );
            //Log.debug( o == form.target );
            manager.save();
            
            UndoManagerInstance.add( new CopyUndoable( this, form.target, magicClone(_userObject), _userObject ) );
            
            Log.debug( form.target + "\n" + Inspect.inspect(form.target.data) +
                       "\n---------------\n" +
                       _userObject+"\n" + Inspect.inspect(_userObject.data) );
            
            magicCopy( form.target, _userObject );
            
            Log.info( "after copy userObject = " + _userObject+"\n" + Inspect.inspect(_userObject.data) );
            
            NodeRendererFactoryInstance.getRenderer(_userObject).update( this, _userObject);
            invalidatePreferredSizeCache();
            
            
            window.close();
            StageUtils.stage.focus = null;
        }
        
        override public function addComponent (c : Component) : void 
        {
            c.doubleClickEnabled = doubleClickEnabled;
            super.addComponent( c );
        }
        override public function addComponentAt (c : Component, id : uint) : void 
        {
            c.doubleClickEnabled = doubleClickEnabled;
            super.addComponentAt( c, id );
        }
        override protected function registerToOnStageEvents () : void 
        {
            addEventListener(MouseEvent.DOUBLE_CLICK, doubleClick );
            super.registerToOnStageEvents( );
        }
        override protected function unregisterFromOnStageEvents () : void 
        {
            removeEventListener(MouseEvent.DOUBLE_CLICK, doubleClick );
            super.unregisterFromOnStageEvents( );
        }
        protected function doubleClick (event : MouseEvent) : void 
        {
            editObjectProperties();
        }
        override public function toString() : String 
        {
            return StringUtils.stringify(this, {userObject:userObject} );
        }
    }
}
import abe.com.mon.utils.magicCopy;
import abe.com.patibility.lang._;
import abe.com.ponents.history.AbstractUndoable;
import abe.com.ponents.nodes.core.CanvasNode;
import abe.com.ponents.nodes.renderers.nodes.NodeRendererFactoryInstance;

internal class CopyUndoable extends AbstractUndoable
{
    public var node : CanvasNode;
    public var a : Object;
    public var b : Object;
    public var c : Object;

    public function CopyUndoable ( node : CanvasNode, a : Object, b : Object, c : Object ) 
    {
        this.node = node;
        this.a = a;
        this.b = b;
        this.c = c;
        _label = _("Edit node");
    }
    override public function undo () : void 
    {
        magicCopy( b, c );
        NodeRendererFactoryInstance.getRenderer( c ).update( node, c );
        node.invalidatePreferredSizeCache();
        super.undo();
    }
    override public function redo () : void 
    {
        magicCopy( a, c );
        NodeRendererFactoryInstance.getRenderer( c ).update( node, c );
        node.invalidatePreferredSizeCache();
        super.redo();
    }
}
