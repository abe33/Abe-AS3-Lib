/**
 * @license
 */
package abe.com.ponents.core
{
    import org.osflash.signals.DeluxeSignal;
    import abe.com.mon.core.IDisplayObject;
    import abe.com.mon.core.IDisplayObjectContainer;
    import abe.com.mon.core.IInteractiveObject;
    import abe.com.mon.core.LayeredSprite;
    import abe.com.mon.geom.Dimension;
    import abe.com.mon.geom.dm;
    import abe.com.mon.utils.StageUtils;
    import abe.com.mon.utils.StringUtils;
    import abe.com.patibility.lang._;
    import abe.com.patibility.lang._$;
    import abe.com.ponents.builder.styles.DefaultComponentPreview;
    import abe.com.ponents.core.focus.FocusGroup;
    import abe.com.ponents.core.focus.Focusable;
    import abe.com.ponents.core.paint.RepaintManagerInstance;
    import abe.com.ponents.dnd.DragSource;
    import abe.com.ponents.dnd.gestures.DragGesture;
    import abe.com.ponents.events.ComponentEvent;
    import abe.com.ponents.skinning.ComponentStyle;
    import abe.com.ponents.skinning.SkinManagerInstance;
    import abe.com.ponents.skinning.StyleProperties;
    import abe.com.ponents.skinning.cursors.Cursor;
    import abe.com.ponents.tips.ToolTipInstance;
    import abe.com.ponents.transfer.ComponentTransferable;
    import abe.com.ponents.transfer.Transferable;
    import abe.com.ponents.utils.Insets;

    import org.osflash.signals.Signal;

    import flash.display.DisplayObject;
    import flash.display.DisplayObjectContainer;
    import flash.display.InteractiveObject;
    import flash.display.Sprite;
    import flash.events.ContextMenuEvent;
    import flash.events.Event;
    import flash.events.FocusEvent;
    import flash.events.IEventDispatcher;
    import flash.events.MouseEvent;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import flash.ui.ContextMenuItem;
    import flash.utils.Dictionary;


/*-----------------------------------------------------------------
 *     STYLE METADATA
 *----------------------------------------------------------------*/
    [Style(name="insets",type="abe.com.ponents.utils.Insets")]
    [Style(name="borders",type="abe.com.ponents.utils.Borders")]
    [Style(name="corners",type="abe.com.ponents.utils.Corners")]
    [Style(name="background",type="abe.com.ponents.skinning.decorations.ComponentDecoration")]
    [Style(name="foreground",type="abe.com.ponents.skinning.decorations.ComponentDecoration")]
    [Style(name="outerFilters",type="Array", arrayType="flash.filters.BitmapFilter")]
    [Style(name="innerFilters",type="Array", arrayType="flash.filters.BitmapFilter")]
    [Style(name="textColor",type="abe.com.mon.colors.Color")]
    [Style(name="format",type="flash.text.TextFormat")]
/*-----------------------------------------------------------------
 *     SKIN METADATA
 *----------------------------------------------------------------*/
    [Skinable(skin="DefaultComponent")]
    public class AbstractComponent extends Sprite implements Component,
                                                             IDisplayObject,
                                                             IInteractiveObject,
                                                             IDisplayObjectContainer,
                                                             Focusable,
                                                             LayeredSprite,
                                                             IEventDispatcher,
                                                             DragSource

    {
/*-----------------------------------------------------------------
 *     STATIC MEMBERS
 *----------------------------------------------------------------*/

        FEATURES::BUILDER
        static public function defaultPreview () : Component
        {
            return new DefaultComponentPreview();
        }

/*-----------------------------------------------------------------
 *     IDENTIFICATION
 *
 *----------------------------------------------------------------*/
         protected var _id : String;
/*-----------------------------------------------------------------
 *     COMPONENTS STATES
 *----------------------------------------------------------------*/
        protected var _enabled : Boolean;
        protected var _selected : Boolean;
        protected var _focus : Boolean;
        protected var _displayed : Boolean;
        protected var _pressed : Boolean;
        protected var _over : Boolean;
        protected var _interactive : Boolean;

/*-----------------------------------------------------------------
 *     COMPONENTS STATES SWITCHES
 *----------------------------------------------------------------*/
        protected var _allowOver : Boolean;
        protected var _allowPressed : Boolean;
        protected var _allowSelected : Boolean;
        protected var _allowFocus : Boolean;
        protected var _allowFocusTraversing : Boolean;
        protected var _allowMask : Boolean;
        protected var _allowOverEventBubbling : Boolean;

/*-----------------------------------------------------------------
 *     COMPONENTS STYLE AND REPAINT PROPERTIES
 *----------------------------------------------------------------*/
        private var _backgroundCleared : Boolean;
        private var _foregroundCleared : Boolean;
        
        protected var _validateRoot : Boolean;
        protected var _state : uint;
        protected var _style : ComponentStyle;
        protected var _background : Sprite;
        protected var _foreground : Sprite;
/*-----------------------------------------------------------------
 *     DISPLAY LIST RELATED
 *----------------------------------------------------------------*/
        protected var _childrenContainer : Sprite;
        protected var _focusParent : FocusGroup;
        protected var _size : Dimension;
        protected var _preferredSize : Dimension;
        protected var _preferredSizeCache : Dimension;
        protected var _contentScrollH : Number;
        protected var _contentScrollV : Number;
        protected var _integerForSpatialInformations : Boolean;
        protected var _tooltipOverlayTarget : DisplayObject;
        protected var _tooltipOverlayOnMouseOver : Boolean;
        protected var _isComponentLeaf : Boolean;
    
/*-----------------------------------------------------------------------*
 * SIGNALS
 *-----------------------------------------------------------------------*/ 
 
        public var mouseEntered : Signal;
        public var mouseLeaved : Signal;
        public var mouseMoved : Signal;
        public var mousePressed : Signal;
        public var mouseReleased : Signal;
        public var mouseReleasedOutside : Signal;
        public var mouseWheelRolled : Signal;
         
        protected var _componentResized : Signal;
        protected var _componentChanged : Signal;
        protected var _componentPositionChanged : Signal;
        protected var _componentScrollChanged : Signal;
        protected var _componentEnableChanged : Signal;
        protected var _componentRepainted : Signal;
        protected var _propertyChanged : Signal;


        public function AbstractComponent ()
        {
            mouseMoved = new Signal();
            mousePressed = new Signal();
            mouseReleased = new Signal();
            mouseReleasedOutside = new Signal();
            mouseEntered = new Signal();
            mouseLeaved = new Signal();
            mouseWheelRolled = new Signal();
            _componentChanged = new Signal( Component );
            _componentEnableChanged = new Signal( Component, Boolean );
            _componentPositionChanged = new Signal( Component, Point );
            _componentRepainted = new Signal( Component );
            _componentResized = new Signal( Component, Dimension );
            _componentScrollChanged = new Signal( Component );
            _propertyChanged = new Signal();
            
            _enabled = true;
            _pressed = false;
            _selected = false;
            _over = false;
            _allowFocus = true;
            _allowOver = true;
            _allowPressed = true;
            _allowSelected = true;
            _allowMask = true;
            _allowFocusTraversing = true;
            _integerForSpatialInformations = true;
            _allowOverEventBubbling = false;
            _background = new Sprite();
            _foreground = new Sprite();
            _childrenContainer = new Sprite();            
            _style = SkinManagerInstance.getComponentStyle( this );
            _contentScrollH = 0;
            _tooltipOverlayOnMouseOver = false;
            _contentScrollV = 0;
            _interactive = true;
            _isComponentLeaf = true;

            FEATURES::DND { 
                _allowDrag = false;
            } 

            FEATURES::KEYBOARD_CONTEXT { 
                _keyboardContext = new Dictionary();
            } 

            FEATURES::MENU_CONTEXT { 
                _menuContextEnabled = true;
                _menuContextGroups = {};
                _menuContextOrder = [];
                _menuContextMap = {};
                _menuContextEnabledMap = new Dictionary(true);
            } 

            _background.mouseEnabled = false;
            _foreground.mouseEnabled = false;
            _childrenContainer.mouseEnabled = false;
            _childrenContainer.mouseChildren = false;

            buttonMode = true;
            useHandCursor = false;
            focusRect = false;
            
            _childrenContainer.name= "childrenContainer";
            _background.name= "background";
            _foreground.name= "foreground";

            addChild( _background );
            addChild( _childrenContainer );
            addChild( _foreground );

            addEventListener( Event.ADDED_TO_STAGE, addedToStage );
            addEventListener( Event.REMOVED_FROM_STAGE, removeFromStage );

            _style.propertyChanged.add( stylePropertyChanged );
        }
/*-----------------------------------------------------------------------*
 * SIGNALS
 *-----------------------------------------------------------------------*/
        public function get componentResized () : Signal { return _componentResized; }
        public function get componentChanged () : Signal { return _componentChanged; }
        public function get componentPositionChanged () : Signal { return _componentPositionChanged; }
        public function get componentScrollChanged () : Signal { return _componentScrollChanged; }
        public function get componentEnableChanged () : Signal { return _componentEnableChanged; }
        public function get componentRepainted () : Signal { return _componentRepainted; }
        public function get propertyChanged () : Signal { return _propertyChanged; }
/*-----------------------------------------------------------------
 *     GETTERS / SETTERS
 *----------------------------------------------------------------*/

        public function get id () : String { return _id; }
        public function set id (id : String) : void { _id = id; }
        
        public function get background () : Sprite { return _background; }
        public function get foreground () : Sprite { return _foreground; }
        public function get middle () : Sprite { return _childrenContainer; }
        public function get displayed () : Boolean { return _displayed; }
        public function get over () : Boolean { return _over; }
        public function get pressed () : Boolean { return _pressed; }

        public function get enabled () : Boolean { return _enabled;    }
        public function set enabled (b : Boolean) : void
        {
            if( b != _enabled )
            {
                _enabled = b;
                if( !b )
                {
                    if( _pressed && !_over )
                        releaseOutside( new UserActionContext( this, UserActionContext.PROGRAM_ACTION ) );
                    _over = _pressed = b;
                }
                else
                {
                    if( stage && this.hitTestPoint( stage.mouseX, stage.mouseY, true ) )
                        _over = true;
                }

                buttonMode = tabEnabled = b;
                fireComponentChangedSignal( );
                firePropertyChangedSignal( "enabled", b );
                _componentEnableChanged.dispatch( this, _enabled );
                invalidate( true );
            }
        }

        public function get position () : Point    {return new Point( x, y ); }
        public function set position (p : Point) : void
        {
            super.x = _integerForSpatialInformations ? Math.floor( p.x ) : p.x;
            super.y = _integerForSpatialInformations ? Math.floor( p.y ) : p.y;
            fireComponentChangedSignal();
            firePropertyChangedSignal( "position", p );
            fireComponentPositionChangedSignal();
            invalidate();
        }

        override public function set x (value : Number) : void
        {
            super.x = _integerForSpatialInformations ? Math.floor( value ) : value;
            fireComponentChangedSignal();
            firePropertyChangedSignal( "position", position );
            fireComponentPositionChangedSignal();
        }
        override public function set y (value : Number) : void
        {
            super.y = _integerForSpatialInformations ? Math.floor( value ) : value;
            fireComponentChangedSignal();
            firePropertyChangedSignal( "position", position );
            fireComponentPositionChangedSignal();
        }
        
        override public function get width () : Number { return _size ? _size.width : preferredWidth; }
        override public function set width (n : Number) : void { size = new Dimension( n, height ); }
       
        override public function get height () : Number { return _size ? _size.height : preferredHeight; }
        override public function set height (n : Number) : void { size = new Dimension( width, n ); }

        public function get size () : Dimension    { return _size;    }
        public function set size (d : Dimension) : void
        {
            var oldw : Number;
            var oldh : Number;

            if( _size )
            {
                oldw = _integerForSpatialInformations ? Math.floor( _size.width ) : _size.width;
                oldh = _integerForSpatialInformations ? Math.floor( _size.height ) : _size.height;
            }

            _size = d ? new Dimension( _integerForSpatialInformations ? Math.floor( d.width ) : d.width,
                                          _integerForSpatialInformations ? Math.floor( d.height ) : d.height ) :
                        d;

            if( _size )
            {
                if( _size.width < 0 )
                    _size.width = 0;

                if( _size.height < 0 )
                    _size.height = 0;
                
            }
            fireComponentResizedSignalIfSizeChanged( oldw, oldh );
            fireComponentChangedSignal();
            invalidateIfSizeChanged( oldw, oldh );
        }
        
        public function get preferredSize () : Dimension { return _preferredSize ? _preferredSize : _preferredSizeCache; }
        public function set preferredSize ( d : Dimension ) : void
        {
            var oldw : Number;
            var oldh : Number;

            if( _preferredSize )
            {
                oldw = _preferredSize.width;
                oldh = _preferredSize.height;
            }
            _preferredSize = d;
            fireComponentResizedSignalIfSizeChanged( oldw, oldh );
            fireComponentChangedSignal();
            invalidateIfSizeChanged( oldw, oldh );
        }
        public function get maximumSize() : Dimension 
        {
            var p : Container = parentContainer;
            if( p )
            {
                var d : Dimension = p.maximumContentSize;
                return d ? d : dm( width, height );
            }
            else
                return dm( width, height ); 
        }
        public function get maximumContentSize() : Dimension 
        {
            return maximumSize.grow( -_style.insets.horizontal, -_style.insets.vertical );
        }
        
        public function get preferredWidth () : Number { return preferredSize.width; }
        public function set preferredWidth ( n : Number) : void
        {
            preferredSize = new Dimension( n, preferredSize.height );
        }
        
        public function get preferredHeight () : Number { return preferredSize.height; }
        public function set preferredHeight ( n : Number) : void
        {
            preferredSize = new Dimension( preferredSize.width, n );
        }
        
        public function get style () : ComponentStyle { return _style; }
        
        public function get styleKey () : String { return _style.defaultStyleKey; }
        public function set styleKey ( s : String ) : void
        {
            _style.defaultStyleKey = s;
            invalidatePreferredSizeCache();
            fireComponentChangedSignal();
            firePropertyChangedSignal( "styleKey", styleKey );
        }
        
        public function get focusParent () : FocusGroup    { return _focusParent; }
        public function set focusParent ( parent : FocusGroup ) : void
        {
            _focusParent = parent;
            fireComponentChangedSignal();
            firePropertyChangedSignal( "focusParent", _focusParent );
        }
        
        public function get parentContainer () : Container
        {
            var d : DisplayObjectContainer = this;
            do
            {
                if( d.parent )
                {
                    d = d.parent;
                    if( d is Container )
                        return d as Container;
                }
                else
                    d = null;
            }
            while( d );

            return null;
        }
        
        public function get isVisible () : Boolean
        {
            if( !visible )
                return false;

            var d : DisplayObjectContainer = this;
            do
            {
                if( d.parent )
                {
                    d = d.parent;
                    if( !d.visible )
                        return false;
                }
                else
                    d = null;
            }
            while( d );

            return true;
        }
        
        public function get contentScrollH () : Number { return _contentScrollH; }
        public function set contentScrollH (contentScrollH : Number) : void
        {
            _contentScrollH = contentScrollH;
            _componentScrollChanged.dispatch( this );
            invalidate( true );
            fireComponentChangedSignal();
            firePropertyChangedSignal( "contentScrollH", contentScrollH );
        }
        
        public function get contentScrollV () : Number { return _contentScrollV; }
        public function set contentScrollV (contentScrollV : Number) : void
        {
            _contentScrollV = contentScrollV;
            _componentScrollChanged.dispatch( this );
            invalidate( true );
            fireComponentChangedSignal();
            firePropertyChangedSignal( "contentScrollV", contentScrollV );
        }
        
        public function get maxContentScrollV () : Number { return 0; }
        public function get maxContentScrollH () : Number { return 0; }
        
        public function get visibleArea () : Rectangle { return new Rectangle( 0, 0, width, height ); }
        public function get screenVisibleArea () : Rectangle
        {
            var r : Rectangle = visibleArea;
            var p : Container = parentContainer;
            var rp : Rectangle;

            if( _childrenContainer.scrollRect || !p )
            {
                r.x += x;
                r.y += y;
            }

            while( p )
            {
                rp = p.visibleArea;
                r = r.intersection( rp );
                //r = intersection( r, rp );

                r.x += p.x;
                r.y += p.y;
                p = p.parentContainer;
            }

            return r;
        }
        
        public function get allowOverEventBubbling () : Boolean { return _allowOverEventBubbling; }
        public function set allowOverEventBubbling (allowOverEventBubbling : Boolean) : void
        {
            _allowOverEventBubbling = allowOverEventBubbling;
            fireComponentChangedSignal();
        }
        
        public function get allowOver () : Boolean { return _allowOver; }
        public function set allowOver (allowOver : Boolean) : void
        {
            _allowOver = allowOver;
            fireComponentChangedSignal();
        }
        
        public function get allowPressed () : Boolean { return _allowPressed; }
        public function set allowPressed (allowPressed : Boolean) : void
        {
            _allowPressed = allowPressed;
            fireComponentChangedSignal();
        }
        
        public function get allowSelected () : Boolean { return _allowSelected;    }
        public function set allowSelected (allowSelected : Boolean) : void
        {
            _allowSelected = allowSelected;
            fireComponentChangedSignal();
        }
        
        public function get allowFocus () : Boolean { return _allowFocus; }
        public function set allowFocus (allowFocus : Boolean) : void
        {
            _allowFocus = allowFocus;
            fireComponentChangedSignal();
        }
        
        public function get allowFocusTraversing () : Boolean { return _allowFocusTraversing; }
        public function set allowFocusTraversing (allowFocusTraversing : Boolean) : void
        {
            _allowFocusTraversing = allowFocusTraversing;
        }
        
        public function get allowMask () : Boolean { return _allowMask; }
        public function set allowMask ( allowMask : Boolean ) : void
        {
            _allowMask = allowMask;
            fireComponentChangedSignal();
        }
        
        public function get isMouseOver () : Boolean { return _over; }

        public function get interactive () : Boolean { return _interactive; }
        public function set interactive (interactive : Boolean) : void
        {
            if( _interactive == interactive )
                return;

            _interactive = interactive;
            if( _displayed )
            {
                if( _interactive )
                    registerToOnStageEvents();
                else
                    unregisterFromOnStageEvents();
            }
            FEATURES::DND { 
                if( _dragGesture )
                    _dragGesture.enabled = _interactive;
            } 
        }
        
        public function get isComponentIndependent () : Boolean { return _isComponentLeaf; }
        public function set isComponentIndependent ( b : Boolean) : void
        {
            _isComponentLeaf = b;
        }
/*-----------------------------------------------------------------
 *     FLUENT CODING METHODS
 *----------------------------------------------------------------*/
        public function setSize ( d : Dimension ) : Component
        {
            size = d;
            return this;
        }
        public function setSizeWH ( w : Number, h : Number ) : Component
        {
            size = new Dimension(w,h);
            return this;
        }
        public function setWidth ( d : Number ) : Component
        {
            width = d;
            return this;
        }
        public function setHeight ( d : Number ) : Component
        {
            height = d;
            return this;
        }
        public function setPreferredSize ( d : Dimension ) : Component
        {
            preferredSize = d;
            return this;
        }
        public function setPreferredWidth ( w : Number ) : Component
        {
            preferredWidth = w;
            return this;
        }
        public function setPreferredHeight ( w : Number ) : Component
        {
            preferredWidth = w;
            return this;
        }
        public function setPreferredSizeWH ( w : Number, h : Number ) : Component
        {
            preferredSize = new Dimension(w,h);
            return this;
        }
        public function setStyleKey ( s : String ) : Component
        {
            styleKey = s;
            return this;
        }

/*-----------------------------------------------------------------
 *     VALIDATION & REPAINT
 *----------------------------------------------------------------*/
        public function ensureRectIsVisible ( r : Rectangle ) : Component
        {
            if( r.y < contentScrollV )
                contentScrollV = r.y - _style.insets.top;
            else if( r.y + r.height > contentScrollV + height )
                contentScrollV = r.y + r.height - height + _style.insets.bottom;

            if( r.x < contentScrollH )
                contentScrollH = r.x - _style.insets.left;
            else if( r.x + r.width > contentScrollH + width )
                contentScrollH = r.x + r.width - width + _style.insets.right;

            return this;
        }
        public function invalidate ( asValidateRoot : Boolean = false ) : void
        {
            _validateRoot = asValidateRoot;
            checkState();
            //if( stage && visible )
            RepaintManagerInstance.invalidate( this );
        }
        public function invalidatePreferredSizeCache () : void
        {
            invalidate( false );
        }
        protected function invalidateIfSizeChanged ( oldW : Number, oldH : Number ) : void
        {
            if( oldW != width || oldH != height )
            {
                firePropertyChangedSignal( "size", dm( width, height ) );
                invalidate();
            }
        }
        public function isValidateRoot () : Boolean
        {
            return _validateRoot;
        }
        public function repaint () : void
        {
            var size : Dimension = calculateComponentSize();
            _repaint( size );
        }
        protected function _repaint ( size : Dimension, forceClear : Boolean = true ) : void
        {
            _validateRoot = true;
            
            if( forceClear )
            {
                _background.graphics.clear();
                _foreground.graphics.clear();
            }
            else
            {
                clearBackgroundGraphics();
                clearForegroundGraphics();
            }
            if( size )
            {
                _style.draw( new Rectangle( 0, 0, size.width, size.height ), _background.graphics, _foreground.graphics, this );
                var insets : Insets = _style.insets;
                filters = _style.outerFilters;
                _childrenContainer.filters = _style.innerFilters;

                applyMask( size, insets );
            }
            else
            {
                _childrenContainer.scrollRect = null;
            }

            _componentRepainted.dispatch( this );
        }
        protected function applyMask ( size : Dimension, insets : Insets ) : void
        {
            if( _allowMask )
            {
                _childrenContainer.x = insets.left;
                _childrenContainer.y = insets.top;
                var w : Number = size.width - insets.horizontal;
                var h : Number = size.height - insets.vertical;

                if( w <= 0 || h <= 0 )
                    _childrenContainer.scrollRect = new Rectangle();
                else
                    _childrenContainer.scrollRect = new Rectangle( insets.left + _contentScrollH, insets.top + _contentScrollV, w, h );
            }
            else
                _childrenContainer.scrollRect = null;
        }
        protected function calculateComponentSize () : Dimension
        {
            return _size ?
                        _size :
                      ( _preferredSize ?
                            _preferredSize :
                          ( _preferredSizeCache ?
                                  _preferredSizeCache :
                                  new Dimension() ) );
        }
        protected function checkState () : void
        {
            var s : uint = 0;
            if( !_enabled )
                s += ComponentStates.DISABLED;
            else
            {
                if( _pressed && _over && _allowPressed )
                    s += ComponentStates.PRESSED;
                else if( _over && _allowOver )
                    s += ComponentStates.OVER;

                if( _focus && _allowFocus )
                    s += ComponentStates.FOCUS;
            }

            if( _selected && _allowSelected )
                s += ComponentStates.SELECTED;
            _style.currentState = s;
        }
/*-----------------------------------------------------------------
 *     FOCUSABLE METHODS
 *----------------------------------------------------------------*/
        public function focusNext () : void
        {
            if( _focusParent )
                _focusParent.focusNextChild( this );
            else
            {
                if( parent )
                {
                    var id : Number = parent.getChildIndex( this );
                    StageUtils.stage.focus = findNextFocusable( id + 1 );
                }
                else StageUtils.stage.focus = null;
            }
        }
        public function focusPrevious () : void
        {
            if( _focusParent )
                _focusParent.focusPreviousChild( this );
            else
            {
                if( parent )
                {
                    var id : Number = parent.getChildIndex( this );
                    StageUtils.stage.focus = findPreviousFocusable( id );
                }
                else StageUtils.stage.focus = null;
            }
        }
        public function hasFocus () : Boolean
        {
            return _focus;
        }
        protected function findNextFocusable ( id : Number = 0 ) : InteractiveObject
        {
            var l : Number = parent.numChildren;
            for(var i : Number = 0; i < l; i++)
                if( parent.getChildAt( ( i + id ) % l ) is InteractiveObject )
                    return parent.getChildAt( ( i + id ) % l ) as InteractiveObject;
            return null;
        }
        protected function findPreviousFocusable ( id : Number = 0 ) : InteractiveObject
        {
            var l : Number = parent.numChildren;
            var _id : Number;

            for(var i : Number = 0; i < l; i--)
            {
                _id = ( l - 1 + ( id - i ) ) % l;
                if( parent.getChildAt( _id ) is InteractiveObject )
                    return parent.getChildAt( _id ) as InteractiveObject;
            }

            return null;
        }
        public function grabFocus () : void
        {
            StageUtils.stage.focus = this;
        }
/*-----------------------------------------------------------------
 *     OTHER PUBLIC METHODS
 *----------------------------------------------------------------*/
        override public function toString () : String
        {
            return StringUtils.stringify(this);
        }
        public function isAncestor ( c : Component ) : Boolean
        {
            var p : Component = parentContainer;

            while( p )
            {
                if( p == c )
                    return true;
                else
                    p = p.parentContainer;
            }
            return false;
        }
        protected function containsComponentChild (child : DisplayObject) : Boolean
        {
            return child != null && _childrenContainer.contains( child );
        }
        public function addComponentChild( child : DisplayObject ) : void
        {
            _childrenContainer.addChild( child );
        }
        public function addComponentChildAt( child : DisplayObject, index : int ) : void
        {
            if( index < _childrenContainer.numChildren )
                _childrenContainer.addChildAt( child, index );
            else
                _childrenContainer.addChild( child );
        }
        public function addComponentChildAfter ( child : DisplayObject, after : DisplayObject ) : void
        {
            if( !containsComponentChild( after ) )
                return;

            var i : int = _childrenContainer.getChildIndex( after );
            if( i+1 >= _childrenContainer.numChildren )
                _childrenContainer.addChild( child );
            else
                _childrenContainer.addChildAt( child, i );
        }
        public function addComponentChildBefore ( child : DisplayObject, before : DisplayObject ) : void
        {
            if( !containsComponentChild( before ) )
                return;

            var i : int = _childrenContainer.getChildIndex( before );
            if( i-1 < 0 )
                _childrenContainer.addChildAt( child, 0 );
            else
                _childrenContainer.addChildAt(child, i-1);
        }
        public function removeComponentChild( child : DisplayObject ) : void
        {
            _childrenContainer.removeChild( child );
        }
        public function removeComponentChildAt( index : int ) : void
        {
            _childrenContainer.removeChildAt( index );
        }
        public function setComponentChildIndex ( child : DisplayObject, index : int ) : void
        {
            if( !child || numChildren <= 1 )
                return;
            if( index >= numChildren )
                index = numChildren - 1;
            if( index < 0 )
                index = 0;
            _childrenContainer.setChildIndex( child, index );
        }
        public function removeFromParent() : void
        {
            var p : Container =  parentContainer;
            if( p )
                p.removeComponent( this );
            else if( displayed )
                parent.removeChild( this );
        }
        public function clearBackgroundGraphics () : void
        {
            if( !_backgroundCleared )
            {
                _background.graphics.clear();
                _background.graphics.lineStyle();
                addEventListener(Event.EXIT_FRAME, exitFrame );
                _backgroundCleared = true;
            }
        }
        public function clearForegroundGraphics () : void
        {
            if( !_foregroundCleared )
            {
                _foreground.graphics.clear();
                _foreground.graphics.lineStyle();
                addEventListener(Event.EXIT_FRAME, exitFrame );
                _foregroundCleared = true;
            }
        }
        private function exitFrame (event : Event) : void
        {
            _backgroundCleared = false;
            _foregroundCleared = false;
            removeEventListener(Event.EXIT_FRAME, exitFrame );
        }
/*-----------------------------------------------------------------
 *     CONDITIONAL COMPILE RELATED
 *----------------------------------------------------------------*/
/*-----------------------------------------------------------------
 *     TOOLTIP
 *----------------------------------------------------------------*/
        FEATURES::TOOLTIP { 
            protected var _tooltip : String;
            protected var _userTooltip : String;
            public function get tooltip () : String { return _userTooltip ? _userTooltip : _tooltip; }
            public function set tooltip (tooltip : String) : void
            {
                _userTooltip = tooltip;
                firePropertyChangedSignal("tooltip", _userTooltip );
            }
            public function showToolTip ( overlay : Boolean = false ) : void
            {
                if( _userTooltip )
                    ToolTipInstance.show( _userTooltip, null, overlay ? _tooltipOverlayTarget ? _tooltipOverlayTarget : this : null );
                else if( _tooltip )
                    ToolTipInstance.show( _tooltip, null, overlay ? _tooltipOverlayTarget ? _tooltipOverlayTarget : this : null );
            }
            public function hideToolTip () : void
            {
                if( _tooltip || _userTooltip )
                    ToolTipInstance.hide();
            }
        } 
/*-----------------------------------------------------------------
 *     CURSOR
 *----------------------------------------------------------------*/
        FEATURES::CURSOR { 
            protected var _cursor : Cursor;
            public function get cursor () : Cursor { return _cursor; }
            public function set cursor (cursor : Cursor) : void
            {
                _cursor = cursor;
                if( _over && _enabled )
                    Cursor.setCursor( _cursor );

                fireComponentChangedSignal( );
                firePropertyChangedSignal( "cursor", cursor );
            }
            public function get hasCursor () : Boolean { return _cursor != null; }
        } 

/*-----------------------------------------------------------------
 *  DRAG AND DROP
 *----------------------------------------------------------------*/
        FEATURES::DND { 
            protected var _dragGesture : DragGesture;
            protected var _allowDrag : Boolean;
            public function get transferData () : Transferable { return new ComponentTransferable( this ); }
            public function get dragGeometry () : DisplayObject { return this; }
            public function get dragGestureGeometry () : InteractiveObject { return this; }
            public function get allowDrag () : Boolean { return _allowDrag; }
            public function set allowDrag (b : Boolean) : void
            {
                _allowDrag = b;
            }
            public function get gesture () : DragGesture { return _dragGesture; }
            public function set gesture (gesture : DragGesture) : void
            {
                if( _dragGesture )
                    _dragGesture.target = null;

                _dragGesture = gesture;

                if( _dragGesture )
                {
                    _dragGesture.target = this;
                    _dragGesture.enabled = _interactive;
                }


            }
        } 
/*-----------------------------------------------------------------
 *  KEYBOARD CONTEXT
 *----------------------------------------------------------------*/
        FEATURES::KEYBOARD_CONTEXT { 
            protected var _keyboardContext : Dictionary;
            public function get keyboardContext () : Dictionary    { return _keyboardContext; }
        } 
/*-----------------------------------------------------------------
 *     CONTEXTUAL MENU
 *----------------------------------------------------------------*/
        FEATURES::MENU_CONTEXT { 
            protected var _menuContextGroups : Object;
            protected var _menuContextOrder : Array;
            protected var _menuContextMap : Object;
            protected var _menuContextEnabledMap : Dictionary;
            protected var _menuContextEnabled : Boolean;
            public function get menuContextGroups () : Object { return _menuContextGroups; }
            public function set menuContextGroups ( o : Object ): void
            {
                _menuContextGroups = o;
            }
            public function get menuContextOrder () : Array { return _menuContextOrder; }
            public function set menuContextOrder ( a : Array ) : void
            {
                _menuContextOrder = a;
            }
            TARGET::FLASH_9
            public function get menuContext () : Array { return prepareMenuContext() as Array; }
            
            TARGET::FLASH_10
            public function get menuContext () : Vector.<ContextMenuItem> { return prepareMenuContext() as Vector.<ContextMenuItem>; }
            
            TARGET::FLASH_10_1 
            public function get menuContext () : Vector.<ContextMenuItem> {    return prepareMenuContext() as Vector.<ContextMenuItem>; }
            
            public function get menuContextEnabled () : Boolean { return _menuContextEnabled; }
            public function set menuContextEnabled ( b : Boolean ):void{ _menuContextEnabled = b; }
            
            private function prepareMenuContext():*
            {
                
                TARGET::FLASH_9 { var v : Array = []; }
                TARGET::FLASH_10 { var v : Vector.<ContextMenuItem> = new Vector.<ContextMenuItem> (); }
                TARGET::FLASH_10_1 { var v : Vector.<ContextMenuItem> = new Vector.<ContextMenuItem> (); } 
                
                if( _menuContextEnabled )
                {
                    var l : uint = _menuContextOrder.length;
                    for( var i:int=0;i < l;i++)
                    {
                        var contextGroup : Array = _menuContextGroups[ _menuContextOrder[i] ] as Array;
                        if( contextGroup )
                        {
                            var m : uint = contextGroup.length;
                            for(var j:int=0;j < m;j++)
                            {
                                var cmi : ContextMenuItem = contextGroup[j];
                                cmi.separatorBefore = i!=0 && j==0;
        
                                v.push( cmi );
                            }
                        }
                    }
                }
                return v;
            }
            protected function setContextMenu () : void
            {
                
                TARGET::FLASH_9 { var v : Array = menuContext; }
                TARGET::FLASH_10 { var v : Vector.<ContextMenuItem> = menuContext; }
                TARGET::FLASH_10_1 { var v : Vector.<ContextMenuItem> = menuContext; } 
                
                var l : Number = v.length;
                for( var i : Number = 0; i < l; i++ )
                {
                    var cmi : ContextMenuItem = v[ i ];
                    cmi.enabled = _menuContextEnabledMap[cmi] && _enabled;
                }
                StageUtils.setMenus( v );
            }
            protected function unsetContextMenu () : void
            {
                StageUtils.unsetMenus();
            }
            public function addNewContextMenuItemForGroup ( label : String,
                                                            id : String,
                                                            selectCallBack : Function = null,
                                                            group : String = "default",
                                                            groupOrder : int = -1,
                                                            disabled : Boolean = false ) : ContextMenuItem
            {


                var menu : ContextMenuItem = new ContextMenuItem( label, false, !disabled );

                if( selectCallBack != null )
                    menu.addEventListener( ContextMenuEvent.MENU_ITEM_SELECT, selectCallBack, false, 0, true );

                _menuContextMap[id] = menu;
                _menuContextEnabledMap[ menu ] = !disabled;
                registerContextMenuItemForGroup( menu, group, groupOrder);

                return menu;
            }
            public function addContextMenuItemForGroup ( menu : ContextMenuItem,
                                                         id : String,
                                                         group : String = "default",
                                                         groupOrder : int = -1,
                                                         disabled : Boolean = false ) : void
            {
                _menuContextMap[id] = menu;
                _menuContextEnabledMap[ menu ] = !disabled;
                registerContextMenuItemForGroup( menu, group, groupOrder);
            }
            public function registerContextMenuItemForGroup ( menu : ContextMenuItem, group : String, groupOrder : int = -1 ) : void
            {
                var menuGroup : Array;
                if( !hasContextMenuItemGroup( group ) )
                {
                    menuGroup = [];
                    _menuContextGroups[ group ] = menuGroup;
                    if( groupOrder != -1 && groupOrder < _menuContextOrder.length )
                        _menuContextOrder.splice( groupOrder, 0, group );
                    else
                        _menuContextOrder.push( group );
                }
                else
                    menuGroup = _menuContextGroups[ group ];

                menuGroup.push( menu );
            }
            public function removeContextMenuItemFromGroup( id : String, group : String ) : void
            {
                var cmi : ContextMenuItem = getContextMenuItem( id );
                if( !cmi )
                    throw new Error (_$(_("Unable to delete a contextual menu that does not exist: $0." ), id));

                if( groupContainsContextMenuItem( id, group ) )
                    _menuContextGroups[group].splice( _menuContextGroups[group].indexOf( cmi ), 1 );
            }
            public function putContextMenuItemInGroup( id : String, group : String, forceMove : Boolean = true ) : void
            {
                if( !hasContextMenuItem(id) )
                    throw new Error(_$( _("Can not handle an undefined menu: $0."), id ));
                if( !menuContextGroups.hasOwnProperty( group ) )
                    throw new Error(_$(_("The target group '$0' does not exist."), group ));
                if( isContextMenuItemContainedInGroup(id) )
                {
                    if( !forceMove )
                        throw new Error(_$(_("Unable to move the menu '$0' because it is already contained in the group '$1'."),
                                        id, getContextMenuItemGroup(id) ));

                    removeContextMenuItemFromGroup( id, getContextMenuItemGroup(id) );
                }
                registerContextMenuItemForGroup( getContextMenuItem( id ), group );
            }
            public function removeContextMenuItem ( id : String ) : void
            {
                if( !hasContextMenuItem( id ) )
                    throw new Error (_$(_("Unable to delete a contextual menu that does not exist: $0." ), id));

                if( isContextMenuItemContainedInGroup(id) )
                    removeContextMenuItemFromGroup( id, getContextMenuItemGroup( id ) );

                delete _menuContextMap[id];
            }
            public function cleanContextMenuItemGroup ( group : String ) : void
            {
                if( hasContextMenuItemGroup( group ) )
                {
                    var l : uint = _menuContextGroups[group].length;
                    while(l--)
                        removeContextMenuItem( getContextMenuItemId( _menuContextGroups[group][l] ) );
                }
            }
            public function isContextMenuItemContainedInGroup ( id : String ) : Boolean
            {
                return getContextMenuItemGroup(id) != null;
            }
            public function getContextMenuItemGroup ( id : String ) : String
            {
                for( var i : String in _menuContextGroups )
                    if( groupContainsContextMenuItem( id, i ) )
                        return i;

                return null;
            }
            public function groupContainsContextMenuItem ( id : String, group : String ) : Boolean
            {
                if( !hasContextMenuItemGroup( group ) )
                    throw new Error ( _$(_("The group '$0' does not exist in the list of groups for this instance $1." ), group, this ) );

                return _menuContextGroups[group].indexOf( getContextMenuItem( id ) ) != -1;
            }
            public function getContextMenuItem ( id : String ) : ContextMenuItem
            {
                if( hasContextMenuItem( id ) )
                    return _menuContextMap[id];
                else
                    return null;
            }
            public function getContextMenuItemId ( menu : ContextMenuItem ) : String 
            {
                for( var i : String in _menuContextMap )
                    if( _menuContextMap[ i ] == menu )
                        return i;
                
                return null;
            }
            public function hasContextMenuItem ( id : String ) : Boolean
            {
                return _menuContextMap.hasOwnProperty( id );
            }
            public function hasContextMenuItemGroup ( group : String ) : Boolean
            {
                return _menuContextGroups.hasOwnProperty( group );
            }
            public function setContextMenuItemCaption ( id : String, newCaption : String ) : void
            {
                if( hasContextMenuItem( id ) )
                    getContextMenuItem( id ).caption = newCaption;
            }
            public function setContextMenuItemEnabled ( id : String, enabled : Boolean ) : void
            {
                if( hasContextMenuItem( id ) )
                    _menuContextEnabledMap[ getContextMenuItem( id ) ] = enabled;
            }
        } 
/*-----------------------------------------------------------------
 *     EVENTS HANDLERS
 *----------------------------------------------------------------*/
        public function click ( context : UserActionContext ) : void {}
        public function releaseOutside ( context : UserActionContext ) : void {}

        public function mouseDown ( e : MouseEvent ) : void
        {
            if( _enabled )
            {
                _pressed = true;
                if( _allowPressed )
                    invalidate( true );

                if( this.stage )
                    this.stage.addEventListener( MouseEvent.MOUSE_UP, mouseUp );
                    
                mousePressed.dispatch( this );
            }
        }
        public function mouseUp ( e : MouseEvent ) : void
        {
            if( _enabled )
            {
                if( _pressed && _over )
                {
                    click( new UserActionContext( this, 
                                                  UserActionContext.MOUSE_ACTION, 
                                                  new Point( e.stageX, e.stageY ),
                                                  e.ctrlKey,
                                                  e.shiftKey,
                                                  e.altKey ) );
                    
                    mouseReleased.dispatch( this );
                    FEATURES::TOOLTIP { 
                        hideToolTip();
                    } 
                }
                else if( !_over )
                {
                    FEATURES::CURSOR { 
                        if( hasCursor )
                            Cursor.restoreCursor();
                    } 

                    if( this.stage )
                        this.stage.removeEventListener( MouseEvent.MOUSE_UP, mouseUp );

                    releaseOutside( new UserActionContext( this, 
                                                           UserActionContext.MOUSE_ACTION, 
                                                           new Point( e.stageX, e.stageY ),
                                                           e.ctrlKey,
                                                           e.shiftKey,
                                                           e.altKey ) );
                    
                    mouseReleasedOutside.dispatch( this );
                }
                _pressed = false;

                if( _allowPressed )
                    invalidate( true );
            }
        }
        public function mouseOut ( e : MouseEvent ) : void
        {
            if( _enabled )
            {
                _over = false;
                if( _pressed )
                    if( this.stage )
                        this.stage.addEventListener( MouseEvent.MOUSE_UP, mouseUp );

                FEATURES::CURSOR { 
                    if( !_pressed )
                        Cursor.restoreCursor();
                } 

                if( _allowOver )
                    invalidate( true );
                
                mouseLeaved.dispatch( this );
            }
            FEATURES::MENU_CONTEXT { 
                unsetContextMenu();
            } 

            if( !_allowOverEventBubbling )
                e.stopPropagation();

            FEATURES::TOOLTIP { 
                hideToolTip();
            } 
        }
        public function mouseOver ( e : MouseEvent ) : void
        {
            if( _enabled )
            {
                _over = true;
                if( this.stage )
                    this.stage.removeEventListener( MouseEvent.MOUSE_UP, mouseUp );

                FEATURES::CURSOR { 
                    if( hasCursor )
                        Cursor.setCursor( _cursor );
                    else
                        Cursor.restoreCursor();
                } 

                if( _allowOver )
                    invalidate( true );
                
                mouseEntered.dispatch( this );
            }
            FEATURES::MENU_CONTEXT { 
                setContextMenu();
            } 

            if( !_allowOverEventBubbling )
                e.stopPropagation();

            FEATURES::TOOLTIP { 
                if( _tooltipOverlayOnMouseOver )
                    showToolTip( true );
                else
                    showToolTip();
            } 
        }
        public function mouseMove ( e : MouseEvent ) : void
        {
            if( _enabled )
                mouseMoved.dispatch( this );
        }
        public function mouseWheel (event : MouseEvent) : void 
        {
            event.stopPropagation();
            if( _enabled )
                mouseWheelRolled.dispatch( this, event.delta );
        }
        public function focusIn ( e : FocusEvent ) : void
        {
            _focusIn( e );
        }
        protected function _focusIn ( e : FocusEvent ) : void
        {

            if( !_allowFocusTraversing )
                e.stopPropagation();

            if( !_enabled )
            {
                e.stopPropagation();

                if( e.shiftKey )
                    focusPrevious();
                else
                    focusNext();
                return;
            }
            _focus = true;
            fireComponentChangedSignal();
            if( _allowFocus )
                invalidate( true );
        }
        public function focusOut ( e : FocusEvent ) : void
        {
            _focusOut( e );
        }
        protected function _focusOut ( e : FocusEvent ) : void
        {
            if( !_allowFocusTraversing )
                e.stopPropagation();
            _focus = false;
            fireComponentChangedSignal();
            if( _allowFocus )
                invalidate( true );
        }
        public function keyFocusChange ( e : FocusEvent ) : void
        {
            if( _focusParent )
            {
                e.preventDefault();
                if( e.shiftKey )
                    focusPrevious();
                else
                    focusNext();
            }
        }
        protected function mouseFocusChange (event : FocusEvent) : void {}

        public function addedToStage ( e : Event ) : void
        {
            _displayed = true;
            _childrenContainer.visible = false;
            componentRepainted.addOnce(wasAddedToStage );
            invalidatePreferredSizeCache();
        
            registerToOnStageEvents();
        }
        protected function wasAddedToStage ( c : Component ) : void
        {
            _childrenContainer.visible = true;
        }
        public function removeFromStage ( e : Event ) : void
        {
            _displayed = false;
            _over = false;
            _pressed = false;

            unregisterFromOnStageEvents();

            FEATURES::TOOLTIP { 
                hideToolTip();
            } 
            _background.graphics.clear();
            _foreground.graphics.clear();
            
            if( StageUtils.stage.focus == this )
                StageUtils.stage.focus = null;
        }
        
        protected function onPropertyChanged ( propertyName : String, propertyValue : * ) : void {}
        protected function stylePropertyChanged ( propertyName : String, propertyValue : * ) : void
        {
            switch( propertyName )
            {
                case StyleProperties.INSETS :
                case StyleProperties.FORMAT :
                    invalidatePreferredSizeCache();
                    break;
                case StyleProperties.BACKGROUND :
                case StyleProperties.FOREGROUND :
                case StyleProperties.INNER_FILTERS :
                case StyleProperties.OUTER_FILTERS :
                case StyleProperties.CORNERS :
                case StyleProperties.TEXT_COLOR :
                case StyleProperties.BORDERS :
                default :
                    invalidate( true );
                    break;
            }
        }

/*-----------------------------------------------------------------
 *     EVENTS DISPATCHING
 *----------------------------------------------------------------*/
        protected function registerToOnStageEvents () : void
        {
            if( _interactive )
            {
                addEventListener( MouseEvent.MOUSE_DOWN, mouseDown );
                addEventListener( MouseEvent.MOUSE_OUT, mouseOut );
                addEventListener( MouseEvent.MOUSE_UP, mouseUp );
                addEventListener( MouseEvent.MOUSE_OVER, mouseOver );
                addEventListener( MouseEvent.MOUSE_MOVE, mouseMove );
                addEventListener( MouseEvent.MOUSE_WHEEL, mouseWheel );
                addEventListener( FocusEvent.FOCUS_IN, focusIn );
                addEventListener( FocusEvent.FOCUS_OUT, focusOut );
                addEventListener( FocusEvent.KEY_FOCUS_CHANGE, keyFocusChange );
                addEventListener( FocusEvent.MOUSE_FOCUS_CHANGE, mouseFocusChange );
            }
            //_style.registerToParentStyleEvent();
        }
        protected function unregisterFromOnStageEvents () : void
        {
            if( _interactive )
            {
                removeEventListener( MouseEvent.MOUSE_DOWN, mouseDown );
                removeEventListener( MouseEvent.MOUSE_OUT, mouseOut );
                removeEventListener( MouseEvent.MOUSE_UP, mouseUp );
                removeEventListener( MouseEvent.MOUSE_OVER, mouseOver );
                removeEventListener( MouseEvent.MOUSE_MOVE, mouseMove );
                removeEventListener( MouseEvent.MOUSE_WHEEL, mouseWheel );
                removeEventListener( FocusEvent.FOCUS_IN, focusIn );
                removeEventListener( FocusEvent.FOCUS_OUT, focusOut );
                removeEventListener( FocusEvent.KEY_FOCUS_CHANGE, keyFocusChange );
                removeEventListener( FocusEvent.MOUSE_FOCUS_CHANGE, mouseFocusChange );
            }
            //_style.unregisterToParentStyleEvent();
        }
        protected function fireComponentChangedSignal () : void
        {
            _componentChanged.dispatch( this );
        }
        protected function fireComponentPositionChangedSignal () : void
        {
            _componentPositionChanged.dispatch( this, position );
        }
        protected function fireComponentResizedSignalIfSizeChanged ( oldW : Number, oldH : Number) : void
        {
            if( oldW != width || oldH != height )
                fireComponentResizedSignal();
        }
        protected function fireComponentResizedSignal () : void
        {
            _componentResized.dispatch( this, dm( width, height ) );
        }
        protected function firePropertyChangedSignal ( pname : String, pvalue : * ) : void
        {
            onPropertyChanged( pname, pvalue );
            _propertyChanged.dispatch( pname, pvalue );
        }
    }
}
