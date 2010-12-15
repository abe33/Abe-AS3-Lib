package aesia.com.ponents.containers 
{
	import aesia.com.mon.geom.Dimension;
	import aesia.com.mon.logs.Log;
	import aesia.com.ponents.core.Component;
	import aesia.com.ponents.core.focus.Focusable;
	import aesia.com.ponents.events.ComponentEvent;
	import aesia.com.ponents.layouts.components.ScrollPaneLayout;
	import aesia.com.ponents.scrollbars.ScrollBar;

	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 * @author Cédric Néhémie
	 */
	[Skinable(skin="ScrollPane")]
	[Skin(define="ScrollPane",
		  inherit="DefaultComponent"
	)]
	[Skin(define="Viewport",
		  inherit="DefaultComponent",
		  
		  state__all__background="new aesia.com.ponents.skinning.decorations::SimpleFill( color(White) )",
		  state__all__foreground="new aesia.com.ponents.skinning.decorations::SimpleBorders( color(DimGray) )"
	)]
	public class ScrollPane extends AbstractScrollContainer 
	{
		protected var _rowHeader : Viewport;
		protected var _colHeader : Viewport;
		protected var _vscrollbar : ScrollPane_ScrollBar;
		protected var _hscrollbar : ScrollPane_ScrollBar;

		public function ScrollPane ( policy : String = "auto" )
		{
			super();
			
			_allowOver = false;
			_allowPressed = false;
			_allowSelected = false;
			childrenLayout = new ScrollPaneLayout( this, policy );
			
			layout.viewport = _viewport;
			_viewport.styleKey = "Viewport";
			_viewport.addEventListener( MouseEvent.MOUSE_WHEEL, mouseWheel );
			
			_rowHeader = new Viewport();
			addComponent( _rowHeader );
			layout.rowHead = _rowHeader;
			
			_colHeader = new Viewport();
			addComponent( _colHeader );
			layout.colHead = _colHeader;
			
			_vscrollbar = new ScrollPane_ScrollBar( viewport, 1, 0, 1, 0, 10 );
			_vscrollbar.model = _vmodel;
			addComponent( _vscrollbar );
			layout.vscrollbar = _vscrollbar;
			_vscrollbar.addWeakEventListener( ComponentEvent.SCROLL, vscrollOccured );
						_hscrollbar = new ScrollPane_ScrollBar( viewport, 0, 0, 1, 0, 10 );
			_hscrollbar.model = _hmodel;
			addComponent( _hscrollbar );
			layout.hscrollbar = _hscrollbar;
			_hscrollbar.addWeakEventListener( ComponentEvent.SCROLL, hscrollOccured );
		}
		
		protected function mouseWheel (event : MouseEvent) : void
		{
			var willScroll : Boolean = layout.vscrollbar.canScroll && 
									   event.delta < 0 ? 
									   	   layout.vscrollbar.scroll < layout.vscrollbar.maxScroll : 
									   	   layout.vscrollbar.scroll > layout.vscrollbar.minScroll;
			
			if( willScroll )
			{
				event.stopPropagation();
				layout.vscrollbar.mouseWheel( event );
			}
		}
		
		override public function get contentSize () : Dimension
		{
			var d : Dimension = new Dimension(width, height);
			
			if( _colHeader )
				d.height -= _colHeader.height;
			
			if( hscrollbar.visible )
				d.height -= hscrollbar.height;	
			
			if( _rowHeader )
				d.width -= _rowHeader.width;
			
			if( vscrollbar.visible )
				d.width -= vscrollbar.width;	
			
			return d;
		}
		
		public function get layout () : ScrollPaneLayout { return childrenLayout as ScrollPaneLayout; }
		
		override public function get scrollPolicy () : String { return layout.scrollPolicy; }		override public function set scrollPolicy ( s : String ) : void { layout.scrollPolicy = s; }
		
		public function get vscrollbar () : ScrollBar { return _vscrollbar; }		
		public function get hscrollbar () : ScrollBar { return _hscrollbar; }		
		
		public function get colHead () : Component { return layout.colHead.view; }	
		public function set colHead (colHead : Component) : void 
		{
			layout.colHead.view = colHead;
			invalidatePreferredSizeCache();
		}
		
		public function get rowHead () : Component { return layout.rowHead.view; }		
		public function set rowHead (rowHead : Component) : void 
		{
			layout.rowHead.view = rowHead;
			invalidatePreferredSizeCache();
		}
		
		public function get lowerLeft () : Component { return layout.lowerLeft; }		
		public function set lowerLeft (lowerLeft : Component) : void 
		{ 
			if( layout.lowerLeft )
				removeComponent( layout.lowerLeft );
			
			addComponent( lowerLeft );
			layout.lowerLeft = lowerLeft; 
		}
		
		public function get lowerRight () : Component { return layout.lowerRight;	}		
		public function set lowerRight (lowerRight : Component) : void 
		{ 
			if( layout.lowerRight )
				removeComponent( layout.lowerRight );
			
			addComponent( lowerRight );
			layout.lowerRight = lowerRight;
		}
				
		public function get upperLeft () : Component { return layout.upperLeft; }		
		public function set upperLeft (upperLeft : Component) : void 
		{ 
			if( layout.upperLeft )
				removeComponent( layout.upperLeft );
			
			addComponent( upperLeft );
			layout.upperLeft = upperLeft; 
		}
		
		public function get upperRight () : Component {	return layout.upperRight; }		
		public function set upperRight (upperRight : Component) : void 
		{ 
			if( layout.upperRight )
				removeComponent( layout.upperRight );
			
			addComponent( upperRight );
			layout.upperRight = upperRight; 
		}
		
		override public function focusNextChild (child : Focusable) : void
		{
			focusNext();
		}
		override public function focusPreviousChild (child : Focusable) : void
		{
			focusPrevious();
		}
		override public function focusLastChild () : void
		{
			layout.viewport.focusFirstChild();
		}
		override public function focusFirstChild () : void
		{
			layout.viewport.focusFirstChild();
		}

		override protected function hscrollOccured ( e : Event ) : void
		{
			if( layout.colHead.view )
				layout.colHead.view.x = -_hmodel.value;
				
			super.hscrollOccured(e);
		}
		override protected function vscrollOccured ( e : Event ) : void
		{
			if( layout.rowHead.view )
				layout.rowHead.view.y = -_vmodel.value;
				
			super.vscrollOccured(e);
		}
	}
}
import aesia.com.ponents.containers.Viewport;
import aesia.com.ponents.scrollbars.ScrollBar;

internal class ScrollPane_ScrollBar extends ScrollBar
{
	
	private var _viewport : Viewport;
	
	public function ScrollPane_ScrollBar ( viewport : Viewport, orientation : uint = 1, value : Number = 0, extent : Number = 10, min : Number = 0, max : Number = 10 )
	{
		super( orientation, value, extent, min, max );
		_viewport = viewport;
	}

	override public function getUnitIncrement ( direction : Number = 1 ) : Number
	{
		return isVertical ?
					_viewport.getUnitIncrementV ( direction ) : 					_viewport.getUnitIncrementH ( direction );
	}

	override public function getBlockIncrement ( direction : Number = 1 ) : Number
	{
		return isVertical ?
					_viewport.getBlockIncrementV ( direction ) : 
					_viewport.getBlockIncrementH ( direction );
	}
}
