package abe.com.ponents.containers 
{
    import abe.com.mon.geom.Dimension;
    import abe.com.ponents.core.AbstractContainer;
    import abe.com.ponents.core.Component;
    import abe.com.ponents.core.Container;
    import abe.com.ponents.core.focus.Focusable;
    import abe.com.ponents.events.ComponentSignalEvent;
    import abe.com.ponents.scrollbars.Scrollable;

    import org.osflash.signals.events.IBubbleEventHandler;
    import org.osflash.signals.events.IEvent;

    import flash.geom.Rectangle;

	/**
	 * @author Cédric Néhémie
	 */
	[Skinable(skin="EmptyComponent")]
	public class Viewport extends AbstractContainer implements IBubbleEventHandler
	{
		protected var _view : Component;
		
		public function Viewport ()
		{
			super( );
			_allowFocus = false;
			invalidatePreferredSizeCache();
		}

		public function get view () : Component	{ return _view;	}
		public function set view ( c : Component ) : void
		{
			if( _view )
				super.removeComponent(_view);
			
			_view = c;
			
			if( _view )
				super.addComponent(_view);
			
			invalidatePreferredSizeCache();
		}
		
		override public function addComponent (c : Component) : void {}
		override public function addComponents (...args : *) : void	{}
		override public function removeComponent (c : Component) : void {}
		
		override public function focusNextChild (child : Focusable) : void
		{
			focusNext();
		}
		override public function focusPreviousChild (child : Focusable) : void
		{
			focusPrevious();
		}
		override public function focusFirstChild () : void
		{
			if( _view )
				_view.grabFocus();
		}
		override public function focusLastChild () : void
		{
			if( _view )
				_view.grabFocus();
		}
		
		public function getUnitIncrementV ( direction : Number = 1 ) : Number 
		{ 
			if( _view && _view is Scrollable )
				return ( _view as Scrollable ).getScrollableUnitIncrementV( getViewVisibleArea (), direction );
			else
				return 20 * direction; 
				//return _view.height * direction / 100; 
		}
		public function getUnitIncrementH ( direction : Number = 1 ) : Number 
		{ 
			if( _view && _view is Scrollable )
				return ( _view as Scrollable ).getScrollableUnitIncrementH( getViewVisibleArea (), direction );
			else
				return 20 * direction; 
				//return _view.width * direction / 100; 
		}
		public function getBlockIncrementV ( direction : Number = 1 ) : Number 
		{ 
			if( _view && _view is Scrollable )
				return ( _view as Scrollable ).getScrollableBlockIncrementV( getViewVisibleArea (), direction );
			else
				return 10 * direction; 
				//return _view.height * direction / 10; 
		}
		public function getBlockIncrementH ( direction : Number = 1 ) : Number 
		{ 
			if( _view && _view is Scrollable )
				return ( _view as Scrollable ).getScrollableBlockIncrementH( getViewVisibleArea (), direction );
			else
				return 20 * direction; 
				//return _view.width * direction / 10; 
		}
		protected function getViewVisibleArea () : Rectangle
		{
			return _view.screenVisibleArea;
			return  new Rectangle( -_view.x, -_view.y, width - _style.insets.horizontal, height - _style.insets.vertical );
		}
		override public function get maximumContentSize () : Dimension 
		{
			var p : Container = parentContainer;
			if( p && p is AbstractScrollContainer )
				return ( p as AbstractScrollContainer ).contentSize;
			else
				return super.maximumSize;
		}
        public function onEventBubbled ( event : IEvent ) : Boolean
        {
            switch( ( event as ComponentSignalEvent ).signalName )
            {
                case "mouseWheelRolled":
                	mouseWheelRolled.dispatch( this, ( event as ComponentSignalEvent ).args[1] );
                	break;
                default : 
                	break;
            }
            return true;
        }
	}
}
