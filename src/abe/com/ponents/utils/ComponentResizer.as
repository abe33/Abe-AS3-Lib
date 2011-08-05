package abe.com.ponents.utils 
{
    import abe.com.mon.utils.StageUtils;
    import abe.com.ponents.core.*;
    import abe.com.ponents.skinning.cursors.Cursor;

    import org.osflash.signals.Signal;

    import flash.display.DisplayObjectContainer;
    import flash.events.EventDispatcher;
    import flash.events.MouseEvent;

	/**
	 * @author Cédric Néhémie
	 */
	public class ComponentResizer extends EventDispatcher
	{
		static public const TOP_RESIZE_POLICY : uint = 0;
		static public const BOTTOM_RESIZE_POLICY : uint = 1;
		static public const LEFT_RESIZE_POLICY : uint = 2;
		static public const RIGHT_RESIZE_POLICY : uint = 3;
		static public const HORIZONTAL_RESIZE_POLICY : uint = 4;
		static public const VERTICAL_RESIZE_POLICY : uint = 5;
		static public const BOTH_RESIZE_POLICY : uint = 6;
		
		static public var RESIZER_SIZE : Number = 5;
		static public var RESIZER_PAD_SIZE : Number = 12;
		
		FEATURES::CURSOR { 
			static public var CURSOR_MAPPING : Object = {
															'north':Cursor.RESIZE_N,
															'south':Cursor.RESIZE_S,
															'west':Cursor.RESIZE_W,
															'east':Cursor.RESIZE_E,
															'north-west':Cursor.RESIZE_NW,
															'north-east':Cursor.RESIZE_NE,
															'south-west':Cursor.RESIZE_SW,
															'south-east':Cursor.RESIZE_SE
														};
		} 
		
		protected var _component : Component;
		protected var _policy : uint;
		protected var _pressed : Boolean;
		protected var _isResizing : Boolean;
		protected var _enabled : Boolean;
		
		protected var _resizeMode : String;
		protected var _safeX : Number;
		protected var _safeY : Number;
		protected var _safeWidth : Number;
		protected var _safeHeight : Number;
		protected var _mouseX : Number;
		protected var _mouseY : Number;
		protected var _localOffsetY : Number;
		protected var _localOffsetX : Number;
		protected var _offsetY : Number;
		protected var _offsetX : Number;
		
		public var componentResized : Signal;

		public function ComponentResizer ( c : Component, policy : uint = 6 ) 
		{
		    componentResized = new Signal();
			_component = c;
			_policy = policy;
			
			registerToComponentEvents( _component );
		}
		public function get policy () : uint { return _policy; }		
		public function set policy (policy : uint) : void
		{
			_policy = policy;
		}
		public function get enabled () : Boolean { return _enabled; }		
		public function set enabled (enabled : Boolean) : void
		{
			_enabled = enabled;
			if( _enabled )
				registerToComponentEvents( _component );
			else
				unregisterFromComponentEvents( _component );
		}

		public function release () : void 
		{
			unregisterFromComponentEvents( _component );
		}
		
		protected function isAboveResizer () : String
		{
			switch( _policy )
			{
				case TOP_RESIZE_POLICY : 
					if( _component.mouseY < RESIZER_SIZE )
						return CardinalPoints.NORTH;	
					else
						return null;
					break;
					
				case BOTTOM_RESIZE_POLICY : 
					if( _component.mouseY > _component.height - RESIZER_SIZE )
						return CardinalPoints.SOUTH;
					else
						return null;
					break;
					
				case LEFT_RESIZE_POLICY : 
					if( _component.mouseX < RESIZER_SIZE )
						return CardinalPoints.WEST;
					else
						return null;
					break;
					
				case RIGHT_RESIZE_POLICY : 	
					if( _component.mouseX > _component.width - RESIZER_SIZE )
						return CardinalPoints.EAST;	
					else
						return null;			
					break;
					
				case HORIZONTAL_RESIZE_POLICY : 
					if( _component.mouseX < RESIZER_SIZE )
						return CardinalPoints.WEST;
					else if( _component.mouseX > _component.width - RESIZER_SIZE )
						return CardinalPoints.EAST;
					else
						return null;
					break;
				
				case VERTICAL_RESIZE_POLICY : 
					if( _component.mouseY < RESIZER_SIZE )
						return CardinalPoints.NORTH;
					else if( _component.mouseY > _component.height - RESIZER_SIZE )
						return CardinalPoints.SOUTH;
					else
						return null;
					break;
				
				case BOTH_RESIZE_POLICY : 
				default : 
					// first case is special, it match for a larger square at the bottom right
					if( _component.mouseX > _component.width - RESIZER_PAD_SIZE && 
						_component.mouseY > _component.height - RESIZER_PAD_SIZE )
						return CardinalPoints.SOUTH_EAST;
					
					else if( _component.mouseX > _component.width - RESIZER_SIZE )
					{
						if( _component.mouseY < RESIZER_SIZE )
							return CardinalPoints.NORTH_EAST;
						else if( _component.mouseY > _component.height - RESIZER_SIZE )
							return CardinalPoints.SOUTH_EAST;
						else
							return CardinalPoints.EAST;
					}
					else if( _component.mouseX < RESIZER_SIZE )
					{
						if( _component.mouseY < RESIZER_SIZE )
							return CardinalPoints.NORTH_WEST;
						else if( _component.mouseY > _component.height - RESIZER_SIZE )
							return CardinalPoints.SOUTH_WEST;
						else
							return CardinalPoints.WEST;
					}
					else
					{
						if( _component.mouseY < RESIZER_SIZE )
							return CardinalPoints.NORTH;
						else if( _component.mouseY > _component.height - RESIZER_SIZE )
							return CardinalPoints.SOUTH;
						else
							return null;
					}
					break;
			}		
		}
		protected function isAboveComponent () : Boolean
		{
			return	_component.visible && 
					_component.isMouseOver &&
					_component.mouseX >= 0 &&
					_component.mouseX <= _component.width && 
					_component.mouseY >= 0 &&
					_component.mouseY <= _component.height;
		}
		
		protected function registerToComponentEvents (c : Component) : void 
		{
			c.mousePressed.add( mousePressed );
			c.mouseEntered.add( mouseEntered );
			c.mouseLeaved.add( mouseLeaved );
			
			StageUtils.stage.addEventListener( MouseEvent.MOUSE_UP, mouseUp, false, 1 );
			StageUtils.stage.addEventListener( MouseEvent.MOUSE_MOVE, mouseMove, false, 1 );
		}
		protected function unregisterFromComponentEvents (c : Component) : void 
		{
			c.mousePressed.remove( mousePressed );
			c.mouseEntered.remove( mouseEntered );
			c.mouseLeaved.remove( mouseLeaved );
			
			StageUtils.stage.removeEventListener( MouseEvent.MOUSE_UP, mouseUp );
			StageUtils.stage.removeEventListener( MouseEvent.MOUSE_MOVE, mouseMove );
		}
		
		protected function mouseEntered ( c : Component ) : void
		{
		}
		protected function mouseLeaved ( c : Component ) : void
		{
			if( !_isResizing )
			{
				FEATURES::CURSOR { 
					Cursor.restoreCursor();
				} 
			}
		}
		protected function mousePressed ( c : Component ) : void 
		{
			if( isAboveComponent() )
			{
				var resizer : String = isAboveResizer();
				_resizeMode = resizer;
				
				if( _resizeMode )
				{
					_isResizing = true;
//					_safeX = _component.screenVisibleArea.x;
//					_safeY = _component.screenVisibleArea.y;
					
					_safeX = _component.x;
					_safeY = _component.y;
					
					_safeWidth = _component.width;
					_safeHeight = _component.height;
					_offsetX = _component.mouseX;
					_offsetY = _component.mouseY;
//					_mouseX = StageUtils.stage.mouseX;
//					_mouseY = StageUtils.stage.mouseY;
					var p : DisplayObjectContainer = _component.parent;
					_mouseX = p.mouseX;
					_mouseY = p.mouseY;
					
					preventToolOperation = true;
				}
			}
		}
		protected function mouseUp (event : MouseEvent) : void 
		{
			if(_isResizing)
			{
				_isResizing = false;
				preventToolOperation = false;
			}
		}

		protected function mouseMove (event : MouseEvent) : void 
		{
			if( _isResizing )
			{
				resizeComponent( _resizeMode );
				FEATURES::CURSOR { 
					Cursor.setCursorWithLabel( CURSOR_MAPPING[ _resizeMode ] );
				} 
			}
			else if( isAboveComponent() )
			{
				var resizer : String = isAboveResizer();
				if( resizer )
				{
					FEATURES::CURSOR { 
						Cursor.setCursorWithLabel( CURSOR_MAPPING[ resizer ] );
					} 
					_component.mouseChildren = false;
				}
				else
				{
					_component.mouseChildren = true;
					FEATURES::CURSOR { 
						//Cursor.setCursor( _component.cursor );
						return;
					} 
				}
			}
		}
		
		protected function resizeComponent (resizeMode : String) : void
		{
			
			if( _component.size )
				_component.size = null;
			
			var p : DisplayObjectContainer = _component.parent;
			var mouseX : Number = p.mouseX;
			var mouseY : Number = p.mouseY;
//			var mouseX : Number = StageUtils.stage.mouseX;
//			var mouseY : Number = StageUtils.stage.mouseY;
			var offsetX2 : Number = _safeWidth - _offsetX;
			var offsetY2 : Number = _safeHeight - _offsetY;
			
			if( resizeMode == CardinalPoints.NORTH || 
				resizeMode == CardinalPoints.NORTH_EAST ||
				resizeMode == CardinalPoints.NORTH_WEST )
			{ 
					_component.y = mouseY - _offsetY;
					_component.preferredHeight = Math.max( ( _safeY + _safeHeight ) - mouseY - _offsetY, 10 );
			}
			else if( resizeMode == CardinalPoints.SOUTH || 
					 resizeMode == CardinalPoints.SOUTH_EAST ||
					 resizeMode == CardinalPoints.SOUTH_WEST )
					_component.preferredHeight = Math.max( mouseY - _safeY + offsetY2, 10 );
			
			if( resizeMode == CardinalPoints.WEST || 
				resizeMode == CardinalPoints.SOUTH_WEST ||
				resizeMode == CardinalPoints.NORTH_WEST )
			{ 
					_component.x = mouseX - _offsetX;
					_component.preferredWidth = Math.max( ( _safeX + _safeWidth ) - mouseX - _offsetX, 10 );
			}
			else if( resizeMode == CardinalPoints.EAST || 
					 resizeMode == CardinalPoints.SOUTH_EAST ||
					 resizeMode == CardinalPoints.NORTH_EAST ) 
					_component.preferredWidth = Math.max( mouseX - _safeX + offsetX2, 10 );

			componentResized.dispatch( this );
		}
	}
}
