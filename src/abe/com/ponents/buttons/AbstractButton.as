/**
 * @license
 */
package abe.com.ponents.buttons
{
    import abe.com.mands.*;
    import abe.com.mon.core.*;
    import abe.com.mon.geom.*;
    import abe.com.mon.logs.*;
    import abe.com.mon.utils.*;
    import abe.com.ponents.actions.*;
    import abe.com.ponents.core.*;
    import abe.com.ponents.core.focus.*;
    import abe.com.ponents.events.ComponentEvent;
    import abe.com.ponents.layouts.display.DOInlineLayout;
    import abe.com.ponents.skinning.icons.Icon;
    import abe.com.ponents.text.TextFieldImpl;
    import abe.com.ponents.utils.KeyboardControllerInstance;
   
    import flash.display.DisplayObject;
    import flash.events.Event;
    import flash.events.IEventDispatcher;
    import flash.events.MouseEvent;
    import flash.geom.Rectangle;
    
    import org.osflash.signals.Signal;

    [Style(name="embedFonts",type="Boolean",enumeration="true,false")]
    [Skinable(skin="Button")]
    [Skin(define="ToolBar_Button",
          inherit="Button",
          state__0_1_4_5__foreground="skin.noDecoration",
          state__0_1_4_5__background="skin.emptyDecoration",
          state__0_1_4_5__outerFilters="[]"
    )]
    [Skin(define="Button",
          inherit="DefaultGradientComponent",
          preview="abe.com.ponents.buttons::AbstractButton.defaultButtonPreview",
          state__all__insets="new cutils::Insets(3)",
          state__all__corners="new cutils::Corners(4)",

          custom_embedFonts="false"
    )]
    /**
     * @author Cédric Néhémie
     */
    public class AbstractButton extends SimpleDOContainer implements IDisplayObject,
                                                                     IInteractiveObject,
                                                                     IDisplayObjectContainer,
                                                                     Component,
                                                                     Focusable,
                                                                      LayeredSprite,
                                                                      IEventDispatcher
    {
        FEATURES::BUILDER { 
            static public function defaultButtonPreview () : Component
            {
                return new Button();
            }
        } 
        
        public var actionTriggered : Signal;
        public var actionChanged : Signal;
        public var buttonClicked : Signal;
        public var buttonDoubleClicked : Signal;
        public var buttonReleasedOutside : Signal;
        public var componentSelectedChanged : Signal;
        public var buttonDisplayModeChanged : Signal;
        
        public var disableButtonDuringActionExecution : Boolean = false;
        
        protected var _action : Action;
        protected var _label : *;
        protected var _safeLabel : *;
        protected var _icon : Icon;
        protected var _safeIcon : Icon;
        protected var _labelTextField : ITextField;
        protected var _removeLabelOnEmptyString : Boolean;
        protected var _buttonDisplayMode : uint;
        protected var _iconIndex : int;
        protected var _labelIndex : int;

        public function AbstractButton ( actionOrLabel : * = null, icon : Icon = null )
        {
            super();
            
            actionTriggered = new Signal();
            actionChanged = new Signal();
            buttonClicked = new Signal();
            buttonDoubleClicked = new Signal();
            buttonReleasedOutside = new Signal( );
            componentSelectedChanged = new Signal();
            buttonDisplayModeChanged = new Signal();
            
            _labelIndex = 0;
            _iconIndex = 1;
            _removeLabelOnEmptyString = true;
            _labelTextField = _labelTextField ? _labelTextField : new TextFieldImpl();
            _labelTextField.autoSize = "left";
            _labelTextField.selectable = false;
            _labelTextField.defaultTextFormat = _style.format;
            //_labelTextField.embedFonts = _style.embedFonts;
            _childrenLayout = _childrenLayout ? _childrenLayout : new DOInlineLayout( _childrenContainer );
            _childrenContainer.addChild( _labelTextField as DisplayObject );
            _tooltipOverlayTarget = _labelTextField as DisplayObject;

            if( actionOrLabel != null && actionOrLabel is Action )
                this.action = actionOrLabel;
            else if ( actionOrLabel != null && actionOrLabel is String )
                label = actionOrLabel;
            else
                label = "Button";

            if( icon )
                this.icon = icon;
            
            this.buttonDisplayMode = ButtonDisplayModes.TEXT_AND_ICON;

            FEATURES::KEYBOARD_CONTEXT { 
                _keyboardContext[ KeyStroke.getKeyStroke( Keys.ENTER ) ] = new ProxyCommand( click, true );
                _keyboardContext[ KeyStroke.getKeyStroke( Keys.SPACE ) ] = new ProxyCommand( click, true );
            } 
            
        }
        /*-----------------------------------------------------------------
         *     GETTERS & SETTERS
         *----------------------------------------------------------------*/
        public function get action () : Action { return _action; }
        public function set action (action : Action) : void
        {
            if( _action )
                unregisterToCommandEvents( _action );

            _action = action;
            firePropertyChangedSignal("action", action);
            if( _action )
            {
                if( _action.name && _action.name != "" )
                    label = _action.name;

                enabled = _action.actionEnabled;
                if( _action.icon != null )
                    icon = ( _action.icon as Icon ).clone();

                registerToCommandEvents(_action);
            }
            actionChanged.dispatch( this, _action );
        }
        public function get labelTextField () : ITextField { return _labelTextField; }
        public function get buttonDisplayMode () : uint { return _buttonDisplayMode; }
        public function set buttonDisplayMode (displayMode : uint) : void
        {
            _size = null;
            _buttonDisplayMode = displayMode;
            checkDisplayMode();
            firePropertyChangedSignal( "displayMode", _buttonDisplayMode );
            buttonDisplayModeChanged.dispatch( this, displayMode );
        }
        public function get icon () : Icon    { return _icon;    }
        public function set icon (icon : Icon ) : void
        {
            if( _buttonDisplayMode == ButtonDisplayModes.ICON_ONLY ||
                _buttonDisplayMode == ButtonDisplayModes.TEXT_AND_ICON )
            {
                setIcon ( icon );
            }
            else
                _safeIcon = icon;

            firePropertyChangedSignal( "icon", _icon );
        }
        public function get label () : * { return _label; }
        public function set label ( val : * ) : void
        {
            if( _buttonDisplayMode == ButtonDisplayModes.TEXT_ONLY ||
                _buttonDisplayMode == ButtonDisplayModes.TEXT_AND_ICON )
            {
                setLabel ( val );
            }
            else
            {
                _safeLabel = val;
                if( !_icon )
                    setLabel(val);
            }

            firePropertyChangedSignal( "label", _label );
        }
        public function get selected () : Boolean { return _selected; }
        public function set selected ( b : Boolean ) : void
        {
            if( b != _selected )
            {
                _selected = b;
                invalidate( );
                componentSelectedChanged.dispatch( this, _selected );
                fireComponentChangedSignal();
                firePropertyChangedSignal( "selected", _selected );
            }
        }
        override public function get maxContentScrollV () : Number
        {
            return _childrenLayout.preferredSize.height - ( _childrenContainer.scrollRect.height - _style.insets.vertical );
        }
        override public function get maxContentScrollH () : Number
        {
            return _childrenLayout.preferredSize.width - ( _childrenContainer.scrollRect.width - _style.insets.vertical );
        }
        /*-----------------------------------------------------------------
         *     KEYBOARD TRIGGER
         *----------------------------------------------------------------*/
        FEATURES::KEYBOARD_CONTEXT { 
            protected var _keyStroke : KeyStroke;
           
            public function get keyStroke () : KeyStroke { return _keyStroke; }
            public function set keyStroke (keyStroke : KeyStroke) : void
            {
                if( _keyStroke )
                    KeyboardControllerInstance.removeGlobalKeyStroke( _keyStroke );

                _keyStroke = keyStroke;

                if( _keyStroke )
                    KeyboardControllerInstance.addGlobalKeyStroke( _keyStroke, new ProxyCommand( click ) );
            }
        } 
        /*-----------------------------------------------------------------
         *     MISC & UTILS
         *----------------------------------------------------------------*/
        protected function setIcon ( icon : Icon ) : void
        {
            if( _icon && contains( _icon ) )
            {
                _icon.componentResized.remove( iconResized );
                removeComponentChild( _icon );
            }

            disposeIcon();

            _icon = icon;

            if( _icon )
            {
                _icon.init();
                _icon.invalidate();
                _icon.componentResized.add( iconResized );

                if( _labelTextField && containsComponentChild( _labelTextField as DisplayObject ) )
                    addComponentChildAfter( _icon, _labelTextField as DisplayObject );
                else
                    addComponentChildAt( _icon, _iconIndex );
            }

            invalidatePreferredSizeCache();
        }
        public function disposeIcon () : void
        {
            if( _icon )
                _icon.dispose();
        }
        protected function setLabel ( val : * ) : void
        {
            if( _label == val )
                return;

            _label = val;
            updateLabelText();
            checkForEmptyString ();
            invalidatePreferredSizeCache();
        }
        protected function checkForEmptyString () : void
        {
            var valueNotEmpty : Boolean = isEmpty();
            var labelExist : Boolean = _childrenContainer.contains( _labelTextField as DisplayObject  );

            if( !valueNotEmpty && labelExist && _removeLabelOnEmptyString )
                    removeComponentChild( _labelTextField as DisplayObject  );

            else if( valueNotEmpty && _removeLabelOnEmptyString && !labelExist )
            {
                if( _icon && containsComponentChild( _icon ) )
                    addComponentChildBefore( _labelTextField as DisplayObject, _icon );
                else
                    addComponentChildAt( _labelTextField as DisplayObject, _labelIndex );
            }
            else if( !_removeLabelOnEmptyString && !labelExist )
            {
                if( _icon && containsComponentChild( _icon ) )
                    addComponentChildBefore( _labelTextField as DisplayObject, _icon );
                else
                    addComponentChildAt( _labelTextField as DisplayObject, _labelIndex );
            }
        }
        FEATURES::TOOLTIP 
        override public function showToolTip ( overlay : Boolean = false ) : void
        {
            var r : Rectangle = screenVisibleArea;
            var w : Number = r.width;
            var h : Number = r.height;
            var s : String;
            var ks : Array = [];

            // si une action est définie
            if( _action )
            {
                if( _action.longDescription )
                {
                    s = _action.longDescription;
                    overlay = false;
                }
                else if( buttonDisplayMode == ButtonDisplayModes.ICON_ONLY && _action.name )
                    s = _action.name;
                else if( _action.accelerator && _action.name )
                    s = _action.name;
                else
                    s = "";

                if( _action.accelerator )
                    ks.push( _action.accelerator );
            }
            else if( buttonDisplayMode == ButtonDisplayModes.ICON_ONLY && _safeLabel )
                s = _safeLabel;

            FEATURES::KEYBOARD_CONTEXT { 
            if( _keyStroke )
                ks.push( _keyStroke );
            } 

            if( ks.length > 0 )
            {
                if( !s )
                    s = _labelTextField.htmlText;

                s += " (" + ks.join(",") + ")";
            }
            else if( !s && ( _labelTextField.textWidth > _labelTextField.width ||
              _labelTextField.x + _labelTextField.textWidth > w ||
              _labelTextField.y + _labelTextField.textHeight > h ) &&
              buttonDisplayMode != ButtonDisplayModes.ICON_ONLY )
                s = _labelTextField.htmlText;

            _tooltip = s;
            super.showToolTip(overlay);
        }
        protected function checkDisplayMode () : void
        {
            var valueNotEmpty : Boolean = isEmpty();
            var safeValueNotEmpty : Boolean = _safeLabel !== "" && _safeLabel != null;

            switch( _buttonDisplayMode )
            {
                case ButtonDisplayModes.ICON_ONLY :
                    if( valueNotEmpty )
                    {
                        _safeLabel = _label;
                        setLabel("");
                    }
                    if( !_icon )
                    {
                        if( _safeIcon )
                            setIcon(_safeIcon);
                        else
                        {
                            setLabel(_safeLabel);
                        }
                    }
                    break;

                case ButtonDisplayModes.TEXT_ONLY :
                    if( _icon )
                    {
                        _safeIcon = _icon;
                        setIcon(null);
                    }
                    if( !valueNotEmpty )
                    {
                        if( safeValueNotEmpty )
                            setLabel( _safeLabel );
                        else
                            setIcon(_safeIcon);
                    }
                    break;

                case ButtonDisplayModes.TEXT_AND_ICON :
                default :
                    if( !valueNotEmpty )
                        if( safeValueNotEmpty )
                            setLabel( _safeLabel);
                    if( !_icon )
                        if( _safeIcon )
                            setIcon (_safeIcon);
                    break;
            }
            checkForEmptyString ();
            invalidatePreferredSizeCache();
        }
        /*-----------------------------------------------------------------
         *     VALIDATION & REPAINT
         *----------------------------------------------------------------*/
        override public function repaint () : void
        {
            checkForEmptyString ();
            updateLabelText ();
            var size : Dimension = calculateComponentSize();

            super.repaint();

            if( _icon )
                _icon.repaint();

        }
        protected function updateLabelText () : void
        {
            var valueNotEmpty : Boolean = isEmpty();
            if( _labelTextField )
            {
                _labelTextField.defaultTextFormat = _style.format;
                _labelTextField.textColor = _style.textColor.hexa;
                if( valueNotEmpty )
                {
                    if( _removeLabelOnEmptyString )
                         affectLabelText ()
                    else if( String( _label ) == "" )
                        _labelTextField.htmlText = " ";
                    else
                        affectLabelText();
                }
            }
        }
        protected function affectLabelText () : void
        {
            if( _labelTextField )
                _labelTextField.htmlText = String(_label);
        }
        protected function isEmpty () : Boolean
        {
            return ( _label != "" && _label != undefined ) || _label === false;
        }
        override public function invalidatePreferredSizeCache () : void
        {
            updateLabelText ();
            super.invalidatePreferredSizeCache();
        }
/*-----------------------------------------------------------------
 *     EVENT REGISTRATION
 *----------------------------------------------------------------*/
        override protected function registerToOnStageEvents () : void
        {
            super.registerToOnStageEvents();
            addEventListener( MouseEvent.DOUBLE_CLICK, doubleClick );
        }
        override protected function unregisterFromOnStageEvents () : void
        {
            super.unregisterFromOnStageEvents( );
            removeEventListener( MouseEvent.DOUBLE_CLICK, doubleClick );
        }
        protected function registerToCommandEvents (action : Action) : void
        {
            try
            {
                action.propertyChanged.add( actionPropertyChanged );
                action.commandEnded.add( commandEnded );
                action.commandFailed.add( commandFailed );

                if( action is Cancelable )
                  ( action as Cancelable ).commandCancelled.add( commandCancelled );
            }
            catch( e : Error )
            {
                Log.debug( "It failed for " + action );
            }
        }
        protected function unregisterToCommandEvents (action : Action) : void
        {
            action.propertyChanged.remove( actionPropertyChanged );
            action.commandEnded.remove( commandEnded );
            action.commandFailed.remove( commandFailed );

            if( action is Cancelable )
              ( action as Cancelable ).commandCancelled.remove( commandCancelled );
        }

/*-----------------------------------------------------------------
 *     EVENT HANDLERS
 *----------------------------------------------------------------*/
        protected function iconResized ( c : Component, d : Dimension ) : void
        {
            invalidatePreferredSizeCache();
        }
        override protected function stylePropertyChanged (propertyName : String, propertyValue : * ) : void
        {
            switch( propertyName )
            {
                case "embedFonts" :
                    _labelTextField.embedFonts = propertyValue;
                    updateLabelText();
                    invalidatePreferredSizeCache();
                    break;
                default :
                    super.stylePropertyChanged( propertyName, propertyValue );
                    break;
            }
        }
        protected function actionPropertyChanged ( propertyName : String, propertyValue : * ) : void
        {
            switch( propertyName )
            {
                case "actionEnabled" :
                    enabled = propertyValue;
                    break;
                case "name" :
                    label = propertyValue;
                    invalidatePreferredSizeCache();
                    size = null;
                    break;
                case "icon" :
                    icon = ( propertyValue as Icon ).clone();
                    invalidatePreferredSizeCache();
                    size = null;
                    break;
                default :
                    break;
            }
            actionChanged.dispatch( this, _action );
        }
        override public function releaseOutside ( context : UserActionContext ) : void
        {
            buttonReleasedOutside.dispatch( this );
        }
        protected function doubleClick ( event : MouseEvent = null ) : void
        {
            buttonDoubleClicked.dispatch( this );
        }
        override public function click ( context : UserActionContext ) : void
        {
            if( _action )
            {
                if( disableButtonDuringActionExecution )
                    enabled = false;

                _action.execute( context );
            }
            actionTriggered.dispatch( this, action );
            buttonClicked.dispatch( this );
        }
        protected function commandEnded ( command : Command ) : void
        {
            if( disableButtonDuringActionExecution )
                enabled = _action.actionEnabled;
        }
        protected function commandFailed ( command : Command, msg : String ) : void
        {
            if( disableButtonDuringActionExecution )
                enabled = true;
        }
        protected function commandCancelled ( command : Command ) : void
        {
            if( disableButtonDuringActionExecution )
                enabled = true;
        }
    }
}
