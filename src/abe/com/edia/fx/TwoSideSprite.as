package abe.com.edia.fx
{
    import abe.com.mon.core.Allocable;
    import flash.display.DisplayObject;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.geom.Point;
    import flash.geom.Rectangle;

    public class TwoSideSprite extends Sprite implements Allocable
	{
		protected static const POINT_A:Point = new Point(0,   0);
		protected static const POINT_B:Point = new Point(100, 0);
		protected static const POINT_C:Point = new Point(0, 100);
		
		protected var _isFrontFacing:Boolean = true;
		protected var _autoUpdate:Boolean = true;
		protected var _pivot:Point = new Point(0.5,0.5);
		
		protected var _front:DisplayObject;
		protected var _back:DisplayObject;
		
		protected var _p1:Point;
		protected var _p2:Point;
		protected var _p3:Point;
        
        public function TwoSideSprite ( f : DisplayObject = null, b : DisplayObject = null ) 
		{
			if ( f )
				front = f;
			
			if ( b )
				back = b;
			
			addEventListener( Event.RENDER, update );
		}
		
		/**
		 * A Point Object used to determine the pivot, or registration point of the 
		 * PaperSprite. The values should be between 0 and 1 and are relative to the 
		 * dimensions of each face, 0 being far left (on the x axis) or top (y axis) 
		 * and 1 being the far right (x axis) or bottom (y axis).
		 * 
		 * The default value is { x:0.5, y:0.5 } meaning that both faces will pivot
		 * around their respective centres
		 * 
		 * Examples:
		 * 
		 * To pivot from the centre use: new Point( 0.5, 0.5 );
		 * To pivot from the top left use: new Point( 0.0, 0.0 );
		 * To Pivot from the bottom right use: new Point( 1.0, 1.0 );
		 * 
		 */
		
		public function get pivot():Point { return _pivot; }
		public function set pivot( value:Point ):void { _pivot = value; alignFaces(); }
		
		/**
		 * Whether or not the PaperSprite is front facing
		 */
		
		public function get isFrontFacing():Boolean { return _isFrontFacing; }
		
		/**
		 * The DisplayObject which will serve as the front face of this 
		 * double sided Sprite
		 */
		
		public function get front():DisplayObject { return _front; }
		public function set front( value:DisplayObject ):void
        {
			if ( _front && contains( _front ) )
				removeChild( _front );
			
			_front = addChild( value );
			alignFaces();
		}
		
		/**
		 * The DisplayObject which will serve as the back face of this 
		 * double sided Sprite
		 */
		public function get back():DisplayObject { return _back; }		
		public function set back( value:DisplayObject ):void
		{
			if ( _back && contains( _back ) )
			{
				removeChild( _back );
			}
			
			_back = addChild( value );
			_back.scaleX = -1;
			alignFaces();
		}
		
		/**
		 * Indicates whether the PaperSprite has a front face. This method will 
		 * return false if the front face is either null or has been removed 
		 * from the display list
		 */
		
		public function get hasFront():Boolean { return _front && contains( _front ); }
		
		/**
		 * Indicates whether the PaperSprite has a back face. This method will 
		 * return false if the back face is either null or has been removed 
		 * from the display list
		 */
		
		public function get hasBack():Boolean { return _back && contains( _back ); }
		
		/**
		 * Thanks to Jesse Freeman for suggesting a method to limit unnecessary 
		 * calls to the update method. By overriding the setters for the x, y, z, 
		 * rotationX, rotationY and rotationZ properties, and listening for the 
		 * render event (Event.RENDER), the calculations needed to determine the 
		 * visible face of the PaperSprite need only be made if one or more 
		 * properties have changed
		 */
		
		override public function set x( value:Number ):void 
		{
			super.x = value;
			
			if ( stage )
			{
				stage.invalidate();
			}
		}
		override public function set y( value:Number ):void 
		{
			super.y = value;
			
			if ( stage )
			{
				stage.invalidate();
			}
		}
		
		override public function set z( value:Number ):void 
		{
			super.z = value;
			
			if ( stage )
			{
				stage.invalidate();
			}
		}
		override public function set rotationX( value:Number ):void 
		{
			super.rotationX = value;
			
			if ( stage )
			{
				stage.invalidate();
			}
		}
		
		override public function set rotationY( value:Number ):void 
		{
			super.rotationY = value;
			
			if ( stage )
			{
				stage.invalidate();
			}
		}
		
		override public function set rotationZ( value:Number ):void 
		{
			super.rotationZ = value;
			
			if ( stage )
			{
				stage.invalidate();
			}
		}
        
        public function frontUp ():void
        {
            rotationY = 0;
            update();
        }
        public function backUp ():void
        {
            rotationY = 180;
            update();
        }
		
        public function init () : void
        {
        }

        public function dispose () : void
        {
        }
        
		protected function alignFaces():void
		{
			var position:Point;
			var registration:Point;
			var bounds:Rectangle;
			
			if( _front )
			{
				_front.x = 0;
				_front.y = 0;
				
				registration = new Point( _front.width * _pivot.x, _front.height * _pivot.y );
				
				bounds = _front.getBounds( this );
				registration.x += bounds.x;
				registration.y += bounds.y;
				
				position = globalToLocal( _front.localToGlobal( registration ) );
				
				_front.x -= position.x;
				_front.y -= position.y;
			}
			
			if( _back )
			{
				_back.x = 0;
				_back.y = 0;
				
				registration = new Point( _back.width * _pivot.x, _back.height * _pivot.y );
				
				bounds = _back.getBounds( this );
				registration.x += bounds.x;
				registration.y += bounds.y;
				
				position = globalToLocal( _back.localToGlobal( registration ) );
				
				_back.x -= position.x * _back.scaleX;
				_back.y -= position.y;
			}
			
			if ( stage )
			{
				stage.invalidate();
			}
		}

		protected function update( event:Event = null ):void
		{
			if ( !hasFront && !hasBack )
			{
				return;
			}
			else if ( hasFront && !hasBack )
			{
				_front.visible = _isFrontFacing = true;
				return;
			}
			else if( hasBack && !hasFront )
			{
				_back.visible = true;
				_isFrontFacing = false;
				return;
			}
			
			_p1 = localToGlobal( POINT_A );
			_p2 = localToGlobal( POINT_B );
			_p3 = localToGlobal( POINT_C );
			
			_isFrontFacing = (_p2.x-_p1.x)*(_p3.y-_p1.y)-(_p2.y-_p1.y)*(_p3.x-_p1.x) > 0;
			_front.visible = _isFrontFacing;
			_back.visible = !_isFrontFacing;
        }		
	}
}
