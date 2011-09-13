package abe.com.ponents.tools.canvas 
{
    import abe.com.mon.utils.KeyStroke;
    import abe.com.mon.utils.StageUtils;
    import abe.com.ponents.skinning.cursors.Cursor;
    import abe.com.ponents.tools.CameraCanvas;
    import abe.com.ponents.tools.canvas.core.NullTool;
    import abe.com.ponents.utils.preventToolOperation;

    import org.osflash.signals.Signal;

    import flash.display.DisplayObject;
    import flash.display.DisplayObjectContainer;
    import flash.events.Event;
    import flash.events.KeyboardEvent;
    import flash.events.MouseEvent;
    import flash.geom.Point;

    public class ToolManager
    {
        static private const NULL_TOOL : NullTool = new NullTool();

        protected var _canvas : CameraCanvas;
        protected var _currentTool : Tool;
        protected var _safeTool : Tool;
        protected var _lastObjectUnderTheMouse : DisplayObject;
        
        protected var _inAlternateToolMode : Boolean;        
        protected var _mouseDown : Boolean;
        protected var _mouseOver : Boolean;
        protected var _ctrlPressed : Boolean;
        protected var _shiftPressed : Boolean;
        protected var _altPressed : Boolean;
        
        public var toolSelected : Signal;
        public var toolUsed : Signal;
        public var actionStarted : Signal;
        public var actionFinished : Signal;
        public var actionAborted : Signal;
        
        public function ToolManager ( canvas : CameraCanvas )
        {
            toolSelected = new Signal();
            toolUsed = new Signal();
            actionStarted = new Signal();
            actionFinished = new Signal();
            actionAborted = new Signal();
        
            _currentTool = NULL_TOOL;
            _canvas = canvas;
            
            registerToCanvasEvents( _canvas );
        }
        public function get tool () : Tool { return _currentTool; }
        public function set tool ( tool : Tool ) : void
        {
            if( _currentTool )
                _currentTool.toolUnselected( getGestureData () );
                
            _currentTool = tool;
            _currentTool.toolSelected( getGestureData () );
            
            if( _currentTool.hasCustomCursor ()  )
                _canvas.cursor = _currentTool.cursor;
            else 
                _canvas.cursor = null;
            
            fireToolSelected();
        }
        
        public function get canvas () : CameraCanvas
        {
            return _canvas;
        }

        public function clearTool () : void
        {
            if( _currentTool.hasCustomCursor () )
                _canvas.cursor = null;
            
            _currentTool = NULL_TOOL;
            
            fireToolSelected();
        }
        
        public function get inAlternateToolMode () : Boolean
        {
            return _inAlternateToolMode;
        }

        public function get canvasChildUnderTheMouse () : DisplayObject
        {
            return _lastObjectUnderTheMouse;
        }

        protected function mouseDown ( e : MouseEvent ) : void
        {
			if( !preventToolOperation )
			{
	            solveModalKeys ( e );
	            _mouseDown = true;
	            _currentTool.actionStarted ( getGestureData () );
	            actionStarted.dispatch( this, getGestureData () );
	            fireToolUsed ();
			}
        }
        protected function mouseUp ( e : MouseEvent ) : void
        {
			if( !preventToolOperation )
			{
	            solveModalKeys ( e );
	            _mouseDown = false;
	            _currentTool.actionFinished ( getGestureData () );
	            actionFinished.dispatch( this, getGestureData () );
	            fireToolUsed ();
			}
        }
        protected function mouseUpOutside ( e : MouseEvent ) : void
        {
			if( !preventToolOperation )
			{
	            solveModalKeys ( e );
	            _mouseDown = false;
	            
	            if( !_mouseOver )
	            {
	                _currentTool.actionAborted ( getGestureData () );
	                actionAborted.dispatch( this, getGestureData () );
	                fireToolUsed ();
	            }
			}
        }
        
        protected function mouseMove  ( e : MouseEvent ) : void
        {
			if( !preventToolOperation )
			{
	            solveModalKeys ( e );
	            
	            var obj : DisplayObject = getCanvasChildUnderTheMouse();
	            
	            if( obj != _lastObjectUnderTheMouse )
	            {
	                _lastObjectUnderTheMouse = obj;
	                _currentTool.objectUnderTheMouseChanged( getGestureData() ); 
	            }
	    
	            if( _mouseDown )
	            {
	                _currentTool.mousePositionChanged ( getGestureData () );
	                fireToolUsed ();
	            }
	            _currentTool.mouseMove( getGestureData() );
			}
        }
        
        protected function mouseOver ( e : MouseEvent ) : void
        {
			if( !preventToolOperation )
			{
	            solveModalKeys ( e );
	            
	            _mouseOver = true;
	            if( _mouseDown )
	            {
	                _currentTool.actionResumed ( getGestureData() );
	            }
	            else
	            {
	                if( _currentTool.hasCustomCursor () )
	                    _canvas.cursor = _currentTool.cursor;
	            }
			}
        }
        
        protected function mouseOut  ( e : MouseEvent ) : void
        {
			if( !preventToolOperation )
			{
	            solveModalKeys ( e );
	            
	            _mouseOver = false;
	            if( _mouseDown )
	            {
	                _currentTool.actionPaused ( getGestureData() );
	            }
	            else
	            {
	                if( _currentTool.hasCustomCursor () )
	                    _canvas.cursor = null;
	            }
			}
        }
        
        protected function keyDown ( e : KeyboardEvent ) : void
        {
			if( !preventToolOperation )
			{
	            solveModalKeys ( e );
	            
	            var k : KeyStroke = KeyStroke.getKeyStroke( e.keyCode, KeyStroke.getModifiers( e.ctrlKey, e.shiftKey, e.altKey ) );
	            
	            // si on est pas dans un mode d'outil alternatif, on procède de façon classique à la recherche d'outil alternatif 
	            if( !_inAlternateToolMode) 
	            {
	                // on ne procède que si un outil alternatif existe pour cet outil, 
	                // avec cette combinaison de touche, qu'il ne pointe pas vers l'outil 
	                // courant et qu'une touche combinaison n'a pas été précédemment
	                // déclenché
	                if( _currentTool.hasAlternateTools() )
	                if( _currentTool.alterternateTools[ k ] != null &&
	                    _currentTool.alterternateTools[ k ] != _currentTool )
	                {
	                    // on annule l'action en court
	                    _currentTool.actionAborted ( getGestureData () );
	                    
	                    // on sauvegarde l'outil parent
	                    _safeTool = _currentTool;
	                    
	                    // on définit le nouvel outil
	                    _currentTool =  _currentTool.alterternateTools[ k ] as Tool;
	                    
	                    // ce nouvel outil est un outil alternatif
	                    _currentTool.setAsAlternateTool ( true );
	                    
	                    // définit le curseur, si un curseur est défini
	                    if ( _currentTool.hasCustomCursor () )
	                        Cursor.setCursor ( _currentTool.cursor );
	                    else
	                        Cursor.restoreCursor();
	                    
	                    // et si la souris à été enfoncée précedemment
	                    if( _mouseDown )
	                    {
	                        _currentTool.actionStarted ( getGestureData () );
	                        fireToolUsed ();
	                    }
	                    
	                    // on marque qu'on est bien dans un mode alternatif
	                    _inAlternateToolMode = true;
	                }
	            }
	            // si on est déjà dans un mode alternatif, on regarde
	            // si une combinaison plus complèxe éxiste
	            else
	            {
	                if( _safeTool.alterternateTools[ k ] != null &&
	                    _safeTool.alterternateTools[ k ] != _currentTool )
	                {
	                    // on annule l'action en court
	                    _currentTool.actionAborted ( getGestureData () );
	                    _currentTool.setAsAlternateTool ( false );
	                    
	                    // on définit le nouvel outil
	                    _currentTool = _safeTool.alterternateTools[ k ] as Tool;
	                    
	                    // ce nouvel outil est un outil alternatif
	                    _currentTool.setAsAlternateTool ( true );
	                    
	                    // définit le curseur, si un curseur est défini
	                    if ( _currentTool.hasCustomCursor () )
	                        Cursor.setCursor ( _currentTool.cursor );
	                    else
	                        Cursor.restoreCursor();
	                    
	                    // et si la souris à été enfoncée précedemment
	                    if( _mouseDown )
	                    {
	                        _currentTool.actionStarted ( getGestureData () );
	                        fireToolUsed ();
	                    }
	                }
	            }
			}
        }
        
        protected function keyUp ( e : KeyboardEvent ) : void
        {
			if( !preventToolOperation )
			{
	            if( _safeTool != null && _inAlternateToolMode )
	            {
	                _currentTool.actionAborted ( getGestureData () );
	                _currentTool.setAsAlternateTool ( false );
	                _currentTool = _safeTool;
	                _safeTool = null;
	                
	                if ( _currentTool.hasCustomCursor () )
	                    Cursor.setCursor ( _currentTool.cursor );
	                else
	                    Cursor.restoreCursor();
	                
	                if( _mouseDown )
	                {
	                    _currentTool.actionStarted ( getGestureData () );
	                    fireToolUsed ();
	                }
	                _inAlternateToolMode = false;
	            }
			}
        }
        
        protected function getCanvasChildUnderTheMouse () : DisplayObject
        {
            return _canvas.getObjectUnderTheMouse();
        }
        protected function getGestureData () : ToolGestureData
        {
            return new ToolGestureData( this, new Point( _canvas.mouseX, _canvas.mouseY ), _ctrlPressed, _shiftPressed, _altPressed );
        }
        protected function solveModalKeys ( e : Event ) : void
        {
            if( e is KeyboardEvent )
            {
                var ke : KeyboardEvent = e as KeyboardEvent;
                _shiftPressed = ke.shiftKey;
                _ctrlPressed = ke.ctrlKey;
                _altPressed = ke.altKey;
            }
            else if( e is MouseEvent )
            {
                var me : MouseEvent = e as MouseEvent;
                _shiftPressed = me.shiftKey;
                _ctrlPressed = me.ctrlKey;
                _altPressed = me.altKey;
            }
        }
        protected function registerToCanvasEvents ( canvas : DisplayObjectContainer ) : void
        {
            canvas.addEventListener( MouseEvent.MOUSE_DOWN,     mouseDown );    
            canvas.addEventListener( MouseEvent.MOUSE_UP,         mouseUp );    
            canvas.addEventListener( MouseEvent.MOUSE_OVER,     mouseOver );    
            canvas.addEventListener( MouseEvent.MOUSE_OUT,         mouseOut );    
            
            StageUtils.stage.addEventListener( KeyboardEvent.KEY_DOWN,     keyDown );    
            StageUtils.stage.addEventListener( KeyboardEvent.KEY_UP,     keyUp );    
            StageUtils.stage.addEventListener( MouseEvent.MOUSE_MOVE,    mouseMove );    
            StageUtils.stage.addEventListener( MouseEvent.MOUSE_UP,     mouseUpOutside );    
        }
        protected function unregisterToCanvasEvents ( canvas : DisplayObjectContainer ) : void
        {
            canvas.removeEventListener( MouseEvent.MOUSE_DOWN,         mouseDown );    
            canvas.removeEventListener( MouseEvent.MOUSE_UP,         mouseUp );    
            canvas.removeEventListener( MouseEvent.MOUSE_OVER,         mouseOver );    
            canvas.removeEventListener( MouseEvent.MOUSE_OUT,         mouseOut );    
            
            StageUtils.stage.removeEventListener( KeyboardEvent.KEY_DOWN,     keyDown );    
            StageUtils.stage.removeEventListener( KeyboardEvent.KEY_UP,     keyUp );
            StageUtils.stage.removeEventListener( MouseEvent.MOUSE_MOVE,    mouseMove );    
            StageUtils.stage.removeEventListener( MouseEvent.MOUSE_UP,         mouseUpOutside );        
        }

        protected function fireToolSelected () : void
        {
            toolSelected.dispatch( getGestureData() );
        }
        protected function fireToolUsed () : void
        {
            toolUsed.dispatch( getGestureData() );
        }
    }
}
