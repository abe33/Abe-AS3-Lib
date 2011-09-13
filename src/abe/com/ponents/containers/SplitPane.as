package abe.com.ponents.containers 
{
    import abe.com.ponents.core.*;
    import abe.com.ponents.layouts.components.SplitPaneLayout;
    import abe.com.ponents.skinning.cursors.Cursor;
    import abe.com.ponents.utils.CardinalPoints;

    import flash.events.MouseEvent;

	/**
	 * @author Cédric Néhémie
	 */
	[Skinable(skin="EmptyComponent")]
	public class SplitPane extends AbstractContainer 
	{
		[Embed(source="../skinning/icons/scrollup.png")]
		static public var EXPAND_UP_ICON : Class;		
		[Embed(source="../skinning/icons/scrolldown.png")]
		static public var EXPAND_DOWN_ICON : Class;		
		[Embed(source="../skinning/icons/scrollleft.png")]
		static public var EXPAND_LEFT_ICON : Class;		
		[Embed(source="../skinning/icons/scrollright.png")]
		static public var EXPAND_RIGHT_ICON : Class;		
		
		static public const HORIZONTAL_SPLIT : uint = 0;
		static public const VERTICAL_SPLIT : uint = 1;
		
		protected var _divider : Divider;
		protected var _firstComponent : Component;
		protected var _secondComponent : Component;
		protected var _allowResize : Boolean;
		protected var _dragging : Boolean;
		protected var _pressedX : Number;
		protected var _pressedY : Number;
		protected var _oneTouchExpandable : Boolean;
		protected var _oneTouchExpandFirstComponent : Boolean;
		protected var _expander : Expander;
		protected var _expanded : Boolean;
		protected var _safeDividerLocation : Number;

		public function SplitPane ( direction : uint = 0, first : Component = null, second : Component = null )
		{
			super();
			_childrenLayout = new SplitPaneLayout( this );
			_oneTouchExpandFirstComponent = true;
			_allowFocus = false;
			_allowResize = true;
			_expanded = false;
			_divider = new Divider();
			_divider.mousePressed.add( dragStart );
			_divider.mouseReleased.add( dragEnd );
			_divider.mouseReleasedOutside.add( dragEnd );
			addComponent( _divider );
			
			
			( _childrenLayout as SplitPaneLayout ).divider = _divider;
			this.resizeWeight = .5;
			this.direction = direction;
			this.firstComponent = first;
			this.secondComponent = second;
	
			oneTouchExpandable = true;		
		}
		public function get allowResize () : Boolean { return _allowResize; }		
		public function set allowResize (allowResize : Boolean) : void
		{
			_allowResize = allowResize;
		}
		public function get direction () : uint { return ( _childrenLayout as SplitPaneLayout ).direction; }		
		public function set direction (direction : uint) : void
		{
			( _childrenLayout as SplitPaneLayout ).direction = direction;
			FEATURES::CURSOR { 
			    switch ( direction )
			    {
				    case HORIZONTAL_SPLIT : 
					    _divider.cursor = Cursor.get( Cursor.DRAG_H );
					    break;
				    case VERTICAL_SPLIT :
				    default :  
					    _divider.cursor = Cursor.get( Cursor.DRAG_V );
					    break;
			    }
			} 
			checkExpanderOrientation();
		}
		public function get dividerLocation () : Number { return ( _childrenLayout as SplitPaneLayout ).dividerLocation; }		
		public function set dividerLocation (dividerLocation : Number) : void
		{   
		    ( _firstComponent as AbstractComponent ).invalidatePreferredSizeCache();
		    ( _secondComponent as AbstractComponent ).invalidatePreferredSizeCache();
			( _childrenLayout as SplitPaneLayout ).dividerLocation = dividerLocation;
		}
		public function get oneTouchExpandable () : Boolean { return _oneTouchExpandable; }		
		public function set oneTouchExpandable ( oneTouchExpandable : Boolean ) : void
		{
			if( _oneTouchExpandable == oneTouchExpandable )
				return;
			
			_oneTouchExpandable = oneTouchExpandable;
			
			if( _oneTouchExpandable )
			{
				_expander = new Expander();
				checkExpanderOrientation();
				addComponent( _expander );
				_expander.buttonClicked.add( expanderClicked );
				
				( _childrenLayout as SplitPaneLayout ).expander = _expander;
			}
			else
			{
				removeComponent( _expander );
				_expander.buttonClicked.remove ( expanderClicked );
				( _childrenLayout as SplitPaneLayout ).expander = _expander = null;
			}
		}
		public function get oneTouchExpandFirstComponent () : Boolean { return _oneTouchExpandFirstComponent; }		
		public function set oneTouchExpandFirstComponent (oneTouchExpandFirstComponent : Boolean) : void
		{
			_oneTouchExpandFirstComponent = oneTouchExpandFirstComponent;
			checkExpanderOrientation();
		}
		
		public function get firstComponent () : Component { return _firstComponent; }		
		public function set firstComponent ( firstComponent : Component ) : void
		{
			if( _firstComponent )
				removeComponent( _firstComponent );
			
			( _childrenLayout as SplitPaneLayout ).firstComponent = _firstComponent = firstComponent;
			
			if( _firstComponent )
				addComponent( _firstComponent );
			
			invalidatePreferredSizeCache();	
			invalidate();
		}
		public function get secondComponent () : Component { return _secondComponent; }		
		public function set secondComponent ( secondComponent : Component ) : void
		{
			if( _secondComponent )
				removeComponent( _secondComponent );
			
			( _childrenLayout as SplitPaneLayout ).secondComponent = _secondComponent = secondComponent;
			
			if( _secondComponent )
				addComponent( _secondComponent );
			
			invalidatePreferredSizeCache();	
			invalidate();
		}
		public function get resizeWeight () : Number { return ( _childrenLayout as SplitPaneLayout ).resizeWeight; }		
		public function set resizeWeight (resizeWeight : Number) : void
		{
			( _childrenLayout as SplitPaneLayout ).resizeWeight = resizeWeight;
			invalidate();
		}
		
		override public function isValidateRoot () : Boolean
		{
			return true;
		}
		
		protected function checkExpanderOrientation () : void
		{
			if( _expander )
			{
				switch ( direction )
				{
					case HORIZONTAL_SPLIT : 
						if( _oneTouchExpandFirstComponent )
						{
							if(!_expanded)
								_expander.orientation = CardinalPoints.EAST;
							else
								_expander.orientation = CardinalPoints.WEST;
						}
						else
						{
							if(!_expanded)
								_expander.orientation = CardinalPoints.WEST;							
							else
								_expander.orientation = CardinalPoints.EAST;
						}
						break;
					case VERTICAL_SPLIT :
					default :  
						if( _oneTouchExpandFirstComponent )
						{
							if( !_expanded )
								_expander.orientation = CardinalPoints.SOUTH;
							else
								_expander.orientation = CardinalPoints.NORTH;
						}
						else
						{
							if( !_expanded )
								_expander.orientation = CardinalPoints.NORTH;
							else
								_expander.orientation = CardinalPoints.SOUTH;
						}
						break;
				}
			}
		}

		protected function expanderClicked ( b : Component ) : void 
		{
			_expanded = !_expanded;
			
			if( _expanded )
			{
				_divider.enabled = false;
				_safeDividerLocation = dividerLocation;
				switch ( direction )
				{
					case HORIZONTAL_SPLIT : 
						dividerLocation = _oneTouchExpandFirstComponent ? width : 0;
						break;
					case VERTICAL_SPLIT :
					default :
						dividerLocation = _oneTouchExpandFirstComponent ? height : 0;
						break;
				}
			}
			else
			{
				_divider.enabled = true;
				dividerLocation = _safeDividerLocation;
			}

			checkExpanderOrientation();
		}
		
		protected function dragStart ( c : Component ) : void
		{
			if( _enabled && _allowResize )
			{
				_dragging = true;
				_pressedX = _divider.mouseX;
				_pressedY = _divider.mouseY;
				drag ( null );
				stage.addEventListener( MouseEvent.MOUSE_MOVE, drag );
			}
		}
		protected function dragEnd ( c : Component ) : void
		{
			if( _enabled && _allowResize && _dragging )
			{
				drag ( null );
				_dragging = false;
				stage.removeEventListener( MouseEvent.MOUSE_MOVE, drag );
			}			
		}
		protected function drag ( e : MouseEvent ) : void
		{
			if( _dragging )
			{
				if( direction == 0 )
					dividerLocation = this.mouseX - _pressedX;
				else
					dividerLocation = this.mouseY - _pressedY;
				
				invalidate();					
			}
		}
	}
}
import abe.com.mon.geom.Dimension;
import abe.com.ponents.buttons.Button;
import abe.com.ponents.core.AbstractComponent;
import abe.com.ponents.utils.CardinalPoints;

[Skinable(skin="SplitPane_Divider")]
[Skin(define="SplitPane_Divider",
      inherit="EmptyComponent",
      state__all__background="skin.rulerBackgroundColor"
)]
internal class Divider extends AbstractComponent
{
	public function Divider ()
	{
		super();
		_allowOver = false;
		_allowPressed = false;
		_allowFocus = false;
		preferredSize = new Dimension(5,5);
	}
}
[Skinable(skin="SplitPane_Expander")]
[Skin(define="SplitPane_Expander_Vertical",
		  inherit="SplitPane_Expander",
		  
		  state__all__borders="new cutils::Borders(1,0,1,0)"
)]
[Skin(define="SplitPane_Expander_Horizontal",
		  inherit="SplitPane_Expander",
		  
		  state__all__borders="new cutils::Borders(0,1,0,1)"
)]
[Skin(define="SplitPane_Expander",
		  inherit="DefaultComponent",
		  custom_upIcon="icon(abe.com.ponents.containers::SplitPane.EXPAND_UP_ICON)",
		  custom_downIcon="icon(abe.com.ponents.containers::SplitPane.EXPAND_DOWN_ICON)",
		  custom_leftIcon="icon(abe.com.ponents.containers::SplitPane.EXPAND_LEFT_ICON)",
		  custom_rightIcon="icon(abe.com.ponents.containers::SplitPane.EXPAND_RIGHT_ICON)"
)]
internal class Expander extends Button
{
	protected var _orientation : String;	
	
	public function Expander ()
	{
		super( "", null );
	}
	
	public function get orientation () : String {
		return _orientation;
	}
	
	public function set orientation (orientation : String) : void
	{
		_orientation = orientation;
		switch(_orientation)
		{
			case CardinalPoints.NORTH :
				icon = _style.upIcon.clone();
				preferredSize = new Dimension( 25 , 5 );
				styleKey = "SplitPane_Expander_Vertical";
				break;
			case CardinalPoints.SOUTH :
				icon = _style.downIcon.clone();
				preferredSize = new Dimension( 25 , 5 );
				styleKey = "SplitPane_Expander_Vertical";
				break;
			case CardinalPoints.EAST :
				icon = _style.rightIcon.clone();
				preferredSize = new Dimension( 5, 25 );
				styleKey = "SplitPane_Expander_Horizontal";
				break;
			case CardinalPoints.WEST :
			default : 
				icon = _style.leftIcon.clone();
				preferredSize = new Dimension( 5, 25 );
				styleKey = "SplitPane_Expander_Horizontal";
				break;
		}
	}

	override protected function stylePropertyChanged ( propertyName :String, propertyValue : * ) : void
	{
		switch(propertyName)
		{
			case "upIcon" : 
			case "downIcon" : 
			case "leftIcon":
			case "rightIcon" : 
				orientation = orientation;
				break;
			default : 
				super.stylePropertyChanged( propertyName, propertyValue );
				break;
		}
	}
}

