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

	[Event (name="toolSelected", type="events.ToolEvent")]
	public class ToolManager extends EventDispatcher
	{
		static private const NULL_TOOL : NullTool = new NullTool();

		protected var _oCanvas : CameraCanvas;
		protected var _oCurrentTool : Tool;
		protected var _oSafeTool : Tool;
		protected var _oLastObjectUnderTheMouse : DisplayObject;
		
		protected var _bInAlternateToolMode : Boolean;		
		protected var _bMouseDown : Boolean;
		protected var _bMouseOver : Boolean;
		protected var _bCtrlPressed : Boolean;
		protected var _bShiftPressed : Boolean;
		protected var _bAltPressed : Boolean;
		
		public function ToolManager ( canvas : CameraCanvas )
		{
			_oCurrentTool = NULL_TOOL;
			_oCanvas = canvas;
			
			registerToCanvasEvents( _oCanvas );
		}
				
		public function get tool () : Tool
		{
			return _oCurrentTool;
		}
		public function set tool ( tool : Tool ) : void
		{
			if( _oCurrentTool )
				_oCurrentTool.toolUnselected( getEvent () );
				
			_oCurrentTool = tool;
			_oCurrentTool.toolSelected( getEvent () );
			
			if( _oCurrentTool.hasCustomCursor ()  )
				_oCanvas.cursor = _oCurrentTool.cursor;
			else 
				_oCanvas.cursor = null;
			
			fireToolSelected();
		}
		
		public function get canvas () : CameraCanvas
		{
			return _oCanvas;
		}

		public function clearTool () : void
		{
			if( _oCurrentTool.hasCustomCursor () )
				_oCanvas.cursor = null;
			
			_oCurrentTool = NULL_TOOL;
			
			fireToolSelected();
		}
		
		public function get inAlternateToolMode () : Boolean
		{
			return _bInAlternateToolMode;
		}

		public function get canvasChildUnderTheMouse () : DisplayObject
		{
			return _oLastObjectUnderTheMouse;
		}

		protected function mouseDown ( e : MouseEvent ) : void
		{
			solveModalKeys ( e );
			_bMouseDown = true;
			_oCurrentTool.actionStarted ( getEvent () );
			fireToolUsed ();
		}
		protected function mouseUp ( e : MouseEvent ) : void
		{
			solveModalKeys ( e );
			_bMouseDown = false;
			_oCurrentTool.actionFinished ( getEvent () );
			fireToolUsed ();
		}
		protected function mouseUpOutside ( e : MouseEvent ) : void
		{
			solveModalKeys ( e );
			_bMouseDown = false;
			
			if( !_bMouseOver )
			{
				_oCurrentTool.actionAborted ( getEvent () );
				fireToolUsed ();
			}
			
		}
		
		protected function mouseMove  ( e : MouseEvent ) : void
		{
			solveModalKeys ( e );
			
			var obj : DisplayObject = getCanvasChildUnderTheMouse();
			
			if( obj != _oLastObjectUnderTheMouse )
			{
				_oLastObjectUnderTheMouse = obj;
				_oCurrentTool.objectUnderTheMouseChanged( getEvent() ); 
			}
	
			if( _bMouseDown )
			{
				_oCurrentTool.mousePositionChanged ( getEvent () );
				fireToolUsed ();
			}
			_oCurrentTool.mouseMove( getEvent() );
		}
		
		protected function mouseOver ( e : MouseEvent ) : void
		{
			solveModalKeys ( e );
			
			_bMouseOver = true;
			if( _bMouseDown )
			{
				_oCurrentTool.actionResumed ( getEvent() );
			}
			else
			{
				if( _oCurrentTool.hasCustomCursor () )
					_oCanvas.cursor = _oCurrentTool.cursor;
			}
		}
		
		protected function mouseOut  ( e : MouseEvent ) : void
		{
			solveModalKeys ( e );
			
			_bMouseOver = false;
			if( _bMouseDown )
			{
				_oCurrentTool.actionPaused ( getEvent() );
			}
			else
			{
				if( _oCurrentTool.hasCustomCursor () )
					_oCanvas.cursor = null;
			}
		}
		
		protected function keyDown ( e : KeyboardEvent ) : void
		{
			solveModalKeys ( e );
			
			var k : KeyStroke = KeyStroke.getKeyStroke( e.keyCode, KeyStroke.getModifiers( e.ctrlKey, e.shiftKey, e.altKey ) );
			
			// si on est pas dans un mode d'outil alternatif, on procède de façon classique à la recherche d'outil alternatif 
			if( !_bInAlternateToolMode) 
			{
				// on ne procède que si un outil alternatif existe pour cet outil, 
				// avec cette combinaison de touche, qu'il ne pointe pas vers l'outil 
				// courant et qu'une touche combinaison n'a pas été précédemment
				// déclenché
				if( _oCurrentTool.hasAlternateTools() )
				if( _oCurrentTool.alterternateTools[ k ] != null &&
					_oCurrentTool.alterternateTools[ k ] != _oCurrentTool )
				{
					// on annule l'action en court
					_oCurrentTool.actionAborted ( getEvent () );
					
					// on sauvegarde l'outil parent
					_oSafeTool = _oCurrentTool;
					
					// on définit le nouvel outil
					_oCurrentTool =  _oCurrentTool.alterternateTools[ k ] as Tool;
					
					// ce nouvel outil est un outil alternatif
					_oCurrentTool.setAsAlternateTool ( true );
					
					// définit le curseur, si un curseur est défini
					if ( _oCurrentTool.hasCustomCursor () )
						Cursor.setCursor ( _oCurrentTool.cursor );
					else
						Cursor.restoreCursor();
					
					// et si la souris à été enfoncée précedemment
					if( _bMouseDown )
					{
						_oCurrentTool.actionStarted ( getEvent () );
						fireToolUsed ();
					}
					
					// on marque qu'on est bien dans un mode alternatif
					_bInAlternateToolMode = true;
				}
			}
			// si on est déjà dans un mode alternatif, on regarde
			// si une combinaison plus complèxe éxiste
			else
			{
				if( _oSafeTool.alterternateTools[ k ] != null &&
					_oSafeTool.alterternateTools[ k ] != _oCurrentTool )
				{
					// on annule l'action en court
					_oCurrentTool.actionAborted ( getEvent () );
					_oCurrentTool.setAsAlternateTool ( false );
					
					// on définit le nouvel outil
					_oCurrentTool = _oSafeTool.alterternateTools[ k ] as Tool;
					
					// ce nouvel outil est un outil alternatif
					_oCurrentTool.setAsAlternateTool ( true );
					
					// définit le curseur, si un curseur est défini
					if ( _oCurrentTool.hasCustomCursor () )
						Cursor.setCursor ( _oCurrentTool.cursor );
					else
						Cursor.restoreCursor();
					
					// et si la souris à été enfoncée précedemment
					if( _bMouseDown )
					{
						_oCurrentTool.actionStarted ( getEvent () );
						fireToolUsed ();
					}
				}
			}
		}
		
		protected function keyUp ( e : KeyboardEvent ) : void
		{
			if( _oSafeTool != null && _bInAlternateToolMode )
			{
				_oCurrentTool.actionAborted ( getEvent () );
				_oCurrentTool.setAsAlternateTool ( false );
				_oCurrentTool = _oSafeTool;
				_oSafeTool = null;
				
				if ( _oCurrentTool.hasCustomCursor () )
					Cursor.setCursor ( _oCurrentTool.cursor );
				else
					Cursor.restoreCursor();
				
				if( _bMouseDown )
				{
					_oCurrentTool.actionStarted ( getEvent () );
					fireToolUsed ();
				}
				_bInAlternateToolMode = false;
			}
		}
		
		protected function getCanvasChildUnderTheMouse () : DisplayObject
		{
			return _oCanvas.getObjectUnderTheMouse();
		}
		protected function getEvent ( type : String = "" ) : ToolEvent
		{
			var event : ToolEvent = new ToolEvent( type, this );
			event.altPressed = _bAltPressed;
			event.ctrlPressed = _bCtrlPressed;
			event.shiftPressed = _bShiftPressed;
	
			event.mousePosition = new Point( _oCanvas.mouseX, _oCanvas.mouseY );
			
			return event;
		}
		protected function solveModalKeys ( e : Event ) : void
		{
			if( e is KeyboardEvent )
			{
				var ke : KeyboardEvent = e as KeyboardEvent;
				_bShiftPressed = ke.shiftKey;
				_bCtrlPressed = ke.ctrlKey;
				_bAltPressed = ke.altKey;
			}
			else if( e is MouseEvent )
			{
				var me : MouseEvent = e as MouseEvent;
				_bShiftPressed = me.shiftKey;
				_bCtrlPressed = me.ctrlKey;
				_bAltPressed = me.altKey;
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
			dispatchEvent( getEvent( ToolEvent.TOOL_USED  ) );
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
