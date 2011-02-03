package aesia.com.ponents.tools.canvas 
{
	import aesia.com.mon.utils.KeyStroke;
	import aesia.com.mon.utils.StageUtils;
	import aesia.com.ponents.events.ToolEvent;
	import aesia.com.ponents.skinning.cursors.Cursor;
	import aesia.com.ponents.tools.CameraCanvas;
	import aesia.com.ponents.tools.canvas.core.NullTool;

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	[Event (name="toolSelect", type="aesia.com.ponents.events.ToolEvent")]	[Event (name="toolUse", type="aesia.com.ponents.events.ToolEvent")]	[Event (name="actionStart", type="aesia.com.ponents.events.ToolEvent")]	[Event (name="actionFinish", type="aesia.com.ponents.events.ToolEvent")]	[Event (name="actionAbort", type="aesia.com.ponents.events.ToolEvent")]
	public class ToolManager extends EventDispatcher
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
		
		public function ToolManager ( canvas : CameraCanvas )
		{
			_currentTool = NULL_TOOL;
			_canvas = canvas;
			
			registerToCanvasEvents( _canvas );
		}
		public function get tool () : Tool { return _currentTool; }
		public function set tool ( tool : Tool ) : void
		{
			if( _currentTool )
				_currentTool.toolUnselected( getEvent () );
				
			_currentTool = tool;
			_currentTool.toolSelected( getEvent () );
			
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
			solveModalKeys ( e );
			_mouseDown = true;
			_currentTool.actionStarted ( getEvent () );
			dispatchEvent( new ToolEvent( ToolEvent.ACTION_START, this ));			fireToolUsed ();
		}
		protected function mouseUp ( e : MouseEvent ) : void
		{
			solveModalKeys ( e );
			_mouseDown = false;
			_currentTool.actionFinished ( getEvent () );
			dispatchEvent( new ToolEvent( ToolEvent.ACTION_FINISH, this ));			fireToolUsed ();
		}
		protected function mouseUpOutside ( e : MouseEvent ) : void
		{
			solveModalKeys ( e );
			_mouseDown = false;
			
			if( !_mouseOver )
			{
				_currentTool.actionAborted ( getEvent () );
				dispatchEvent( new ToolEvent( ToolEvent.ACTION_ABORT, this ));
				fireToolUsed ();
			}
		}
		
		protected function mouseMove  ( e : MouseEvent ) : void
		{
			solveModalKeys ( e );
			
			var obj : DisplayObject = getCanvasChildUnderTheMouse();
			
			if( obj != _lastObjectUnderTheMouse )
			{
				_lastObjectUnderTheMouse = obj;
				_currentTool.objectUnderTheMouseChanged( getEvent() ); 
			}
	
			if( _mouseDown )
			{
				_currentTool.mousePositionChanged ( getEvent () );
				fireToolUsed ();
			}
			_currentTool.mouseMove( getEvent() );
		}
		
		protected function mouseOver ( e : MouseEvent ) : void
		{
			solveModalKeys ( e );
			
			_mouseOver = true;
			if( _mouseDown )
			{
				_currentTool.actionResumed ( getEvent() );
			}
			else
			{
				if( _currentTool.hasCustomCursor () )
					_canvas.cursor = _currentTool.cursor;
			}
		}
		
		protected function mouseOut  ( e : MouseEvent ) : void
		{
			solveModalKeys ( e );
			
			_mouseOver = false;
			if( _mouseDown )
			{
				_currentTool.actionPaused ( getEvent() );
			}
			else
			{
				if( _currentTool.hasCustomCursor () )
					_canvas.cursor = null;
			}
		}
		
		protected function keyDown ( e : KeyboardEvent ) : void
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
					_currentTool.actionAborted ( getEvent () );
					
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
						_currentTool.actionStarted ( getEvent () );
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
					_currentTool.actionAborted ( getEvent () );
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
						_currentTool.actionStarted ( getEvent () );
						fireToolUsed ();
					}
				}
			}
		}
		
		protected function keyUp ( e : KeyboardEvent ) : void
		{
			if( _safeTool != null && _inAlternateToolMode )
			{
				_currentTool.actionAborted ( getEvent () );
				_currentTool.setAsAlternateTool ( false );
				_currentTool = _safeTool;
				_safeTool = null;
				
				if ( _currentTool.hasCustomCursor () )
					Cursor.setCursor ( _currentTool.cursor );
				else
					Cursor.restoreCursor();
				
				if( _mouseDown )
				{
					_currentTool.actionStarted ( getEvent () );
					fireToolUsed ();
				}
				_inAlternateToolMode = false;
			}
		}
		
		protected function getCanvasChildUnderTheMouse () : DisplayObject
		{
			return _canvas.getObjectUnderTheMouse();
		}
		protected function getEvent ( type : String = "" ) : ToolEvent
		{
			var event : ToolEvent = new ToolEvent( type, this );
			event.altPressed = _altPressed;
			event.ctrlPressed = _ctrlPressed;
			event.shiftPressed = _shiftPressed;
	
			event.mousePosition = new Point( _canvas.mouseX, _canvas.mouseY );
			
			return event;
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
			canvas.addEventListener( MouseEvent.MOUSE_DOWN, 	mouseDown );				canvas.addEventListener( MouseEvent.MOUSE_UP, 		mouseUp );				canvas.addEventListener( MouseEvent.MOUSE_OVER, 	mouseOver );				canvas.addEventListener( MouseEvent.MOUSE_OUT, 		mouseOut );	
			
			StageUtils.stage.addEventListener( KeyboardEvent.KEY_DOWN, 	keyDown );				StageUtils.stage.addEventListener( KeyboardEvent.KEY_UP, 	keyUp );	
			StageUtils.stage.addEventListener( MouseEvent.MOUSE_MOVE,	mouseMove );				StageUtils.stage.addEventListener( MouseEvent.MOUSE_UP, 	mouseUpOutside );	
		}
		protected function unregisterToCanvasEvents ( canvas : DisplayObjectContainer ) : void
		{
			canvas.removeEventListener( MouseEvent.MOUSE_DOWN, 		mouseDown );	
			canvas.removeEventListener( MouseEvent.MOUSE_UP, 		mouseUp );	
			canvas.removeEventListener( MouseEvent.MOUSE_OVER, 		mouseOver );	
			canvas.removeEventListener( MouseEvent.MOUSE_OUT, 		mouseOut );	
			
			StageUtils.stage.removeEventListener( KeyboardEvent.KEY_DOWN, 	keyDown );	
			StageUtils.stage.removeEventListener( KeyboardEvent.KEY_UP, 	keyUp );
			StageUtils.stage.removeEventListener( MouseEvent.MOUSE_MOVE,	mouseMove );	
			StageUtils.stage.removeEventListener( MouseEvent.MOUSE_UP, 		mouseUpOutside );		
		}

		protected function fireToolSelected () : void
		{
			dispatchEvent( getEvent( ToolEvent.TOOL_SELECT ) );
		}
		protected function fireToolUsed () : void
		{
			dispatchEvent( getEvent( ToolEvent.TOOL_USE  ) );
		}
		/**
		 * Réécriture de la méthode <code>dispatchEvent</code> afin d'éviter la diffusion
		 * d'évènement en l'absence d'écouteurs pour cet évènement.
		 * 
		 * @param	evt	objet évènement à diffuser
		 * @return	<code>true</code> si l'évènement a bien été diffusé, <code>false</code>
		 * 			en cas d'échec ou d'appel de la méthode <code>preventDefault</code>
		 * 			sur cet objet évènement
		 */
		override public function dispatchEvent( evt : Event ) : Boolean 
		{
		 	if (hasEventListener(evt.type) || evt.bubbles) 
		  		return super.dispatchEvent(evt);
		 	return true;
		}
	}
}
