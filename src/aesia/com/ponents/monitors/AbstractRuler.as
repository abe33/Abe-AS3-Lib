package aesia.com.ponents.monitors 
{
	import aesia.com.mon.geom.Dimension;
	import aesia.com.ponents.containers.AbstractScrollContainer;
	import aesia.com.ponents.containers.Viewport;
	import aesia.com.ponents.core.AbstractContainer;
	import aesia.com.ponents.core.Component;
	import aesia.com.ponents.core.Container;
	import aesia.com.ponents.skinning.cursors.Cursor;
	import aesia.com.ponents.utils.Orientations;

	import flash.events.MouseEvent;

	/**
	 * @author Cédric Néhémie
	 */
	[Skinable(skin="Ruler")]
	[Skin(define="Ruler",
		  inherit="DefaultComponent",
		  
		  state__all__format="new flash.text::TextFormat('Verdana',8)",
		  state__all__textColor="aesia.com.mon.utils::Color.DimGray",
		  state__all__background="new aesia.com.ponents.skinning.decorations::SimpleFill( aesia.com.mon.utils::Color.Gainsboro )",
		  state__all__foreground="new aesia.com.ponents.skinning.decorations::NoDecoration()"
	)]
	public class AbstractRuler extends AbstractContainer
	{
		static public var rulerSize : Number = 24;
		
		protected var _target : Component;
		protected var _direction : uint;
		
		protected var _lastX : Number;
		protected var _lastY : Number;
		protected var _dragging : Boolean;
		
		public function AbstractRuler ( target : Component, direction : uint = 0 )
		{
			super();
			this.target = target;
			this.direction = direction;
			addEventListener( MouseEvent.MOUSE_WHEEL, mouseWheel );
		}
		protected function mouseWheel ( e : MouseEvent ) : void
		{
			var p : Container = parentContainer;
			if( p && p is Viewport )
			{
				var pp : AbstractScrollContainer = parentContainer.parentContainer as AbstractScrollContainer;
				
				switch ( _direction )
				{
					case Orientations.VERTICAL : 
						if( e.delta > 0 )
							pp.scrollUp();
						else
							pp.scrollDown();
						break;	
					case Orientations.HORIZONTAL : 
					default :
						if( e.delta > 0 )
							pp.scrollLeft();
						else
							pp.scrollRight();
						break;
				}
			}
		}

		override public function mouseDown (e : MouseEvent) : void
		{
			super.mouseDown( e );
			var p : Container = parentContainer;
			if( p && p is Viewport )
			{
				_dragging = true;
				_lastX = stage.mouseX;
				_lastY = stage.mouseY;
				stage.addEventListener( MouseEvent.MOUSE_MOVE, stageMouseMove );
			}
		}

		override public function mouseUp (e : MouseEvent) : void
		{
			super.mouseUp( e );
			_dragging = false;
			stage.removeEventListener( MouseEvent.MOUSE_MOVE, stageMouseMove );
		}

		public function stageMouseMove (e : MouseEvent) : void
		{
			super.mouseMove( e );
			if( _dragging )
			{
				var p : AbstractScrollContainer = parentContainer.parentContainer as AbstractScrollContainer;
				
				switch ( _direction )
				{
					case Orientations.VERTICAL : 
						var y : Number = stage.mouseY;
						
						p.scrollV -= y - _lastY;
				
						_lastY = y;
						break;	
					case Orientations.HORIZONTAL : 
					default :
						var x : Number = stage.mouseX;
						p.scrollH -= x - _lastX;
						
						_lastX = x
						break;
				}
			}
		}

		override public function releaseOutside (e : MouseEvent = null) : void
		{
			super.releaseOutside( e );
			_dragging = false;
			stage.removeEventListener( MouseEvent.MOUSE_MOVE, stageMouseMove );
		}
		
		public function get target () : Component { return _target; }		
		public function set target (target : Component) : void
		{
			_target = target;
			invalidatePreferredSizeCache();
		}
		
		public function get direction () : uint { return _direction; }		
		public function set direction (direction : uint) : void
		{
			_direction = direction;
			/*FDT_IGNORE*/ FEATURES::CURSOR { /*FDT_IGNORE*/
			cursor = Cursor.get( _direction == Orientations.HORIZONTAL ? Cursor.DRAG_H : Cursor.DRAG_V );
			/*FDT_IGNORE*/ } /*FDT_IGNORE*/
			invalidatePreferredSizeCache();
		}
		override public function invalidatePreferredSizeCache () : void
		{
			if( _target )
			{
				switch ( _direction ) 
				{
					case Orientations.HORIZONTAL : 
						_preferredSizeCache = new Dimension( Math.max( _target.preferredSize.width, _target.parentContainer.width ), rulerSize );
						break;
					case Orientations.VERTICAL : 
						_preferredSizeCache = new Dimension( rulerSize, Math.max( _target.preferredSize.height, _target.parentContainer.height ) );
						break;
				}
			}
			else 
				_preferredSizeCache = new Dimension(  rulerSize, rulerSize );
		}
	}
}
