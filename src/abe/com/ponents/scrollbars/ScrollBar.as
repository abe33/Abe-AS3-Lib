package abe.com.ponents.scrollbars
{
	import abe.com.mon.geom.Dimension;
	import abe.com.mon.utils.MathUtils;
	import abe.com.ponents.buttons.Button;
	import abe.com.ponents.buttons.ButtonDisplayModes;
	import abe.com.ponents.core.*;
	import abe.com.ponents.events.ComponentEvent;
	import abe.com.ponents.models.BoundedRangeModel;
	import abe.com.ponents.models.DefaultBoundedRangeModel;
	import abe.com.ponents.utils.Orientations;

	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import org.osflash.signals.Signal;

	[Skinable(skin="ScrollBar")]
	[Skin(define="ScrollBar",
		  inherit="EmptyComponent"
	)]
	[Skin(define="ScrollBar_UpButton",
		  inherit="ScrollBar_Button",
		  custom_icon="icon(abe.com.ponents.scrollbars::ScrollBar.SCROLL_UP_ICON)"
	)]
	[Skin(define="ScrollBar_DownButton",
		  inherit="ScrollBar_Button",
		  custom_icon="icon(abe.com.ponents.scrollbars::ScrollBar.SCROLL_DOWN_ICON)"
	)]
	[Skin(define="ScrollBar_LeftButton",
		  inherit="ScrollBar_Button",
		  custom_icon="icon(abe.com.ponents.scrollbars::ScrollBar.SCROLL_LEFT_ICON)"
	)]
	[Skin(define="ScrollBar_RightButton",
		  inherit="ScrollBar_Button",
		  custom_icon="icon(abe.com.ponents.scrollbars::ScrollBar.SCROLL_RIGHT_ICON)"
	)]
	[Skin(define="ScrollBar_HorizontalKnob",
		  inherit="ScrollBar_Button",
		  custom_icon="icon(abe.com.ponents.scrollbars::ScrollBar.HORIZONTAL_GRIP)"
	)]
	[Skin(define="ScrollBar_VerticalKnob",
		  inherit="ScrollBar_Button",
		  custom_icon="icon(abe.com.ponents.scrollbars::ScrollBar.VERTICAL_GRIP)"
	)]
	[Skin(define="ScrollBar_Button",
		  inherit="DefaultComponent",
		  state__all__insets="new cutils::Insets(0)",
		  state__all__corners="new cutils::Corners(2)"
	)]
	[Skin(define="ScrollBar_TrackHorizontal",
		  inherit="DefaultComponent",
		  state__all__background="new deco::SimpleFill( skin.containerBackgroundColor )",
		  state__all__borders="new cutils::Borders(0,1,0,1)"
	)]
	[Skin(define="ScrollBar_TrackVertical",
		  inherit="DefaultComponent",
		  state__all__background="new deco::SimpleFill( skin.containerBackgroundColor )",
		  state__all__borders="new cutils::Borders(1,0,1,0)"
	)]
	public class ScrollBar extends AbstractContainer
	{
		[Embed(source="../skinning/icons/scrollup.png")]
		static public var SCROLL_UP_ICON : Class;
		[Embed(source="../skinning/icons/scrolldown.png")]
		static public var SCROLL_DOWN_ICON : Class;
		[Embed(source="../skinning/icons/scrollleft.png")]
		static public var SCROLL_LEFT_ICON : Class;
		[Embed(source="../skinning/icons/scrollright.png")]
		static public var SCROLL_RIGHT_ICON : Class;
		[Embed(source="../skinning/icons/hgrip.png")]
		static public var HORIZONTAL_GRIP : Class;
		[Embed(source="../skinning/icons/vgrip.png")]
		static public var VERTICAL_GRIP : Class;
		static public var additionnalButton : Boolean = false;

		public var scrolled : Signal;

		public var scrollUpButton : Button;
		public var scrollDownButton : Button;
		public var scrollTrack : Button;
		public var scrollKnob : Button;
		public var additionnalScrollUpButton : Button;

		protected var scrollUpButtonController : ButtonController;
		protected var scrollDownButtonController : ButtonController;
		protected var scrollTrackController : TrackController;
		protected var scrollKnobController : KnobController;
		protected var additionnalScrollUpButtonController : ButtonController;

		protected var _unitIncrement : Number;
		protected var _blockIncrement : Number;

		protected var _model : BoundedRangeModel;

		protected var _orientation : uint;

		public function ScrollBar ( orientation : uint = 1, value : Number = 0, extent : Number = 10, min : Number = 0, max : Number = 100 )
		{
			super();
			model = new DefaultBoundedRangeModel( value, min, max, extent );
			_preferredSize = new Dimension( 16, 16 );
			_allowMask = false;
			_unitIncrement = 1;
			_blockIncrement = 10;
			draw();
			this.orientation = orientation;
			scrolled = new Signal();
		}

		override public function set styleKey (s : String) : void
		{
			super.styleKey = s;
			updateChildrenStyles();
		}

		public function get model () : BoundedRangeModel { return _model; }
		public function set model ( m : BoundedRangeModel ) : void
		{
			if( _model )
				_model.dataChanged.remove( dataChanged );

			_model = m;

			if( _model )
				_model.dataChanged.add( dataChanged );
		}
		public function get scroll () : Number { return _model.value; }
		public function set scroll ( scroll : Number ) : void
		{
			_model.value = scroll;
			if( !canScroll )
				_model.value = _model.minimum;
			fireScrolledSignal();
		}
		public function get extent () : Number { return _model.extent; }
		public function get maxScroll () : Number { return _model.maximum; }
		public function get minScroll () : Number { return _model.minimum; }
		public function get isVertical() : Boolean { return _orientation > 0; }

		public function get orientation () : uint { return _orientation; }
		public function set orientation (orientation : uint) : void
		{
			_orientation = orientation;
			updateChildrenStyles();
			invalidatePreferredSizeCache();
		}
		protected function updateChildrenStyles () : void
		{
			switch ( _orientation )
			{
				case Orientations.HORIZONTAL :
					scrollUpButton.styleKey = styleKey + "_LeftButton";
					scrollDownButton.styleKey =  styleKey + "_RightButton";
					scrollKnob.styleKey =  styleKey + "_HorizontalKnob";
					scrollTrack.styleKey = styleKey + "_TrackHorizontal";

					if( additionnalButton && additionnalScrollUpButton )
					{
						additionnalScrollUpButton.styleKey = styleKey + "_LeftButton";
					}
					break;
				case Orientations.VERTICAL :
				default :
					scrollUpButton.styleKey = styleKey + "_UpButton";
					scrollDownButton.styleKey =  styleKey + "_DownButton";
					scrollKnob.styleKey =  styleKey + "_VerticalKnob";
					scrollTrack.styleKey = styleKey + "_TrackVertical";

					if( additionnalButton && additionnalScrollUpButton )
					{
						additionnalScrollUpButton.styleKey = styleKey + "_UpButton";
					}
					break;
			}
		}

		public function getUnitIncrement ( direction : Number = 1 ) : Number { return _unitIncrement * direction; }
		public function getBlockIncrement ( direction : Number = 1 ) : Number { return _blockIncrement * direction; }

		public function get canScroll () : Boolean { return _model.maximum > _model.minimum; }

		public function scrollIncrement ( increment : Number ) : void
		{
			_model.value += increment;
			fireScrolledSignal();
		}
		public function scrollTo ( n : Number ) : void
		{
			_model.value = n;
		}
		/**
		 * Lorsque l'utilisateur utilise la molette de la souris
		 * au dessus de la scrollbar.
		 */
		override public function mouseWheel ( e : MouseEvent ) : void
		{
			if( canScroll && _enabled )
				scroll += getUnitIncrement( -e.delta / Math.abs(e.delta) ) * Math.abs( e.delta );
		}
		public function buttonMouseWheelRolled( c : Component, d : Number ) : void
		{
		    if( canScroll && _enabled )
				scroll += getUnitIncrement( -d / Math.abs(d) ) * Math.abs(d);
		}
		/*---------------------------------------------------------------
		 * DRAW AND UPDATE
		 *--------------------------------------------------------------*/

		private function setupButton ( bt : Button ) : void
		{
			 _childrenContainer.addChild( bt );
			 bt.label = "";
			 bt.buttonDisplayMode = ButtonDisplayModes.ICON_ONLY;
			 bt.preferredSize = new Dimension( 16, 16 );
			 bt.mouseWheelRolled.add( buttonMouseWheelRolled );
		}

		private function draw () : void
		{
			scrollUpButton   = new ScrollBarButton( styleKey + "_UpButton" );
			scrollDownButton = new ScrollBarButton( styleKey + "_DownButton" );
			scrollTrack 	 = new ScrollBarButton( styleKey + "_TrackVertical" );
			scrollKnob	 = new ScrollBarButton( styleKey + "_VerticalKnob" );

			setupButton( scrollUpButton );
			setupButton( scrollDownButton );
			setupButton( scrollTrack );
			setupButton( scrollKnob );

			// setup listeners for all entities
			scrollDownButtonController = new ButtonController( scrollDownButton,
															   scrollIncrement,
															   this,
															   1 );

			scrollUpButtonController = new ButtonController( scrollUpButton,
															 scrollIncrement,
															 this,
															 -1 );

			scrollTrackController = new TrackController( scrollTrack,
														 scrollKnob,
														 scrollIncrement,
														 this );

			scrollKnobController = new KnobController( scrollKnob,
														   updateContentFromKnob,
														   this );

			// Si l'on autorise le bouton supplémentaire sur les scrollbarss
			if( additionnalButton )
			{
				additionnalScrollUpButton = new ScrollBarButton( styleKey + "_UpButton" );
				setupButton( additionnalScrollUpButton );
				additionnalScrollUpButtonController = new ButtonController( additionnalScrollUpButton,
																			scrollIncrement,
																			this,
																			-1 );
			}
		}

		override public function repaint () : void
		{
			super.repaint();

			switch ( _orientation )
			{
				case Orientations.HORIZONTAL :
					var scrollTrackWidth : Number = additionnalButton ?
												width - scrollUpButton.width * 3 :
												width - scrollUpButton.width * 2 ;


					scrollTrack.width = scrollTrackWidth;
					scrollTrack.height = scrollTrack.preferredHeight;
					scrollTrack.x = scrollUpButton.width;
					scrollTrack.y = 0;
					if( additionnalButton )
					{
						additionnalScrollUpButton.x = scrollUpButton.width + scrollTrackWidth;
						additionnalScrollUpButton.y = 0;
						scrollDownButton.x = scrollUpButton.width * 2 + scrollTrackWidth;

					}
					else
						scrollDownButton.x = scrollUpButton.width + scrollTrackWidth;

					scrollDownButton.y = 0;
					break;

				case Orientations.VERTICAL :
				default :
					var scrollTrackHeight : Number = additionnalButton ?
												height - scrollUpButton.height * 3 :
												height - scrollUpButton.height * 2 ;

					scrollTrack.height = scrollTrackHeight;
					scrollTrack.width = scrollTrack.preferredWidth;
					scrollTrack.y = scrollUpButton.height;
					scrollTrack.x = 0;

					if( additionnalButton )
					{
						additionnalScrollUpButton.y = scrollUpButton.height + scrollTrackHeight;
						additionnalScrollUpButton.x = 0;
						scrollDownButton.y = scrollUpButton.height * 2 + scrollTrackHeight;
					}
					else
						scrollDownButton.y = scrollUpButton.height + scrollTrackHeight;
					scrollDownButton.x = 0;
					break;
			}

			updateKnob ();

			scrollDownButton.repaint();
			scrollUpButton.repaint();
			scrollTrack.repaint();
			scrollKnob.repaint();
			if( additionnalButton )
				additionnalScrollUpButton.repaint();

			invalidatePreferredSizeCache();
		}
		public function updateKnob () : void
		{
			/*
			 * Si on ne peut pas scroller, tout les boutons sont désactivés
			 * et le slider est masqué
			 */
			if( !canScroll )
			{
				scrollKnob.visible = false;

				scrollDownButton.enabled = false;
				scrollUpButton.enabled = false;
				scrollTrack.enabled = false;

				if( additionnalButton )
					additionnalScrollUpButton.enabled = false;

				return;
			}
			else
			{
				scrollKnob.visible = true && _enabled;
				scrollTrack.enabled = true && _enabled;
				scrollDownButton.enabled = true && _enabled;
				scrollUpButton.enabled = true && _enabled;

				if( additionnalButton )
					additionnalScrollUpButton.enabled = true && _enabled;
			}
			// on désactive le bouton de scroll vers le haut qd on atteint le haut
			if( _model.value == _model.minimum )
			{
				scrollUpButton.enabled = false;
				if( additionnalButton )
					additionnalScrollUpButton.enabled = false;
			}
			// on désactive le bouton de scroll vers le bas qd on atteint le bas
			else if(  _model.value == _model.maximum )
			{
				scrollDownButton.enabled = false;
			}
			// on active tout les boutons
			else
			{
				scrollDownButton.enabled = true && _enabled;
				scrollUpButton.enabled = true && _enabled;

				if( additionnalButton )
					additionnalScrollUpButton.enabled = true && _enabled;
			}
			switch ( _orientation )
			{
				case Orientations.HORIZONTAL :
					var oldw : Number = scrollKnob.width;
					var oldx : Number = scrollKnob.x;
					var w : Number = MathUtils.map( _model.extent,
													_model.minimum, _model.maximum + _model.extent,
													8, scrollTrack.width );

					scrollKnob.width = w;
					scrollKnob.x = scrollTrack.x + MathUtils.map( _model.value,
														_model.minimum, _model.maximum,
														0, scrollTrack.width - w );

					if( scrollKnob.width != oldw || scrollKnob.x != oldx )
						fireScrolledSignal();
					break;
				case Orientations.VERTICAL :
				default :
					var oldh : Number = scrollKnob.height;
					var oldy : Number = scrollKnob.y;
					var h : Number = MathUtils.map( _model.extent,
													_model.minimum, _model.maximum + _model.extent,
													8, scrollTrack.height );

					scrollKnob.height = h;
					scrollKnob.y = scrollTrack.y + MathUtils.map( _model.value,
														_model.minimum, _model.maximum,
														0, scrollTrack.height - h );

					if( scrollKnob.height != oldh || scrollKnob.y != oldy )
						fireScrolledSignal();
					break;
			}
		}

		public function updateContentFromKnob () : void
		{
			var scroll : Number;

			if( isVertical )
				scroll = MathUtils.map( scrollKnob.y - scrollTrack.y,
										0, scrollTrack.height - scrollKnob.height,
										minScroll, maxScroll );
			else
				scroll = MathUtils.map( scrollKnob.x - scrollTrack.x,
										0, scrollTrack.width - scrollKnob.width,
										minScroll, maxScroll );

			this.scroll = scroll;
			updateKnob();
		}

		/*--------------------------------------------------------------
		 * 	EVENT DISPATCHING
		 *-------------------------------------------------------------*/
		protected function dataChanged ( model : BoundedRangeModel, v : * ) : void
		{
			invalidate();
		}
		protected function fireScrolledSignal () : void
		{
			scrolled.dispatch( this );
		}
	}
}

import abe.com.ponents.actions.Action;
import abe.com.ponents.buttons.Button;
import abe.com.ponents.events.PropertyEvent;
import abe.com.ponents.scrollbars.ScrollBar;

import flash.events.Event;
import flash.events.MouseEvent;
import flash.utils.clearTimeout;
import flash.utils.setTimeout;

/*---------------------------------------------------------
 *	CONTROLLERS
 *
 *	Toutes les classes définissants les comportements de
 *	chaque composant de l'entité ScrollBar
 *--------------------------------------------------------*/
/**
 *
 */
internal class ButtonController
{
	public var button : Button;
	public var callback : Function;
	public var scrollBar : ScrollBar;

	private var timeout : Number;
	private var pressed : Boolean;
	private var direction : Number;

	public function ButtonController ( bt : Button, callback : Function, scrollBar : ScrollBar, direction : Number = 1 )
	{
		this.button = bt;
		this.callback = callback;
		this.scrollBar = scrollBar;
		this.pressed = false;
		this.direction = direction;
		this.button.mousePressed.add( mousePressed );
		this.button.mouseReleased.add( mouseReleased );
		this.button.mouseLeaved.add( mouseLeaved );
		this.button.mouseEntered.add( mouseEntered );
	}
	public function mousePressed ( btn : Button ) : void
	{
		if( button.enabled )
		{
			callback( scrollBar.getUnitIncrement(direction) );
			timeout = setTimeout( _callback, 200 );
			pressed = true;
		}
	}
	public function mouseReleased ( btn : Button ) : void
	{
		if( button.enabled )
		{
			pressed = false;
			clearTimeout( timeout );
		}
	}
	public function mouseUp( e : Event ): void
	{
	    mouseReleased(null);
	}
	public function mouseLeaved ( btn : Button ) : void
	{
		if( pressed )
		{
			button.stage.addEventListener( MouseEvent.MOUSE_UP, mouseUp );
		}
	}
	public function mouseEntered ( btn : Button ) : void
	{
		if( pressed )
		{
			button.stage.removeEventListener( MouseEvent.MOUSE_UP, mouseUp );
		}
	}
	protected function _callback() : void
	{
		if( button.enabled )
		{
			callback( scrollBar.getUnitIncrement(direction) );
			timeout = setTimeout( _callback, 200 );
		}
	}
}


/**
 *
 */
internal class TrackController
{
	public var button : Button;
	public var slider : Button;

	public var scrollBar : ScrollBar;

	private var timeout : Number;
	private var pressed : Boolean;
	private var callback : Function;
	private var direction : Number;

	public function TrackController ( bt : Button,
									  slider : Button,
									  callback : Function,
									  scrollBar : ScrollBar )
	{
		this.button = bt;
		this.slider = slider;
		this.callback = callback;
		this.scrollBar = scrollBar;
		this.pressed = false;
		this.button.mousePressed.add( mousePressed );
		this.button.mouseReleased.add( mouseReleased );
		this.button.mouseLeaved.add( mouseLeaved );
		this.button.mouseEntered.add( mouseEntered );
	}
	public function mousePressed ( btn : Button ) : void
	{
		if( button.enabled )
		{
			if( scrollBar.isVertical )
			{
				if( button.parent.mouseY < slider.y )
					direction = -1;
				else
					direction = 1;
			}
			else
			{
				if( button.parent.mouseX < slider.x )
					direction = -1;
				else
					direction = 1;
			}

			callback( scrollBar.getBlockIncrement(direction) );
			timeout = setTimeout( _callback, 250 );
			pressed = true;
		}
	}

	public function mouseReleased ( btn : Button ) : void
	{
		if( button.enabled )
		{
			pressed = false;
			clearTimeout( timeout );
		}
	}
	public function mouseUp( e : Event ): void
	{
	    mouseReleased(null);
	}
	public function mouseLeaved ( btn : Button ) : void
	{
		if( pressed )
		{
			button.stage.addEventListener( MouseEvent.MOUSE_UP, mouseUp );
		}
	}
	public function mouseEntered ( btn : Button ) : void
	{
		if( pressed )
		{
			button.stage.removeEventListener( MouseEvent.MOUSE_UP, mouseUp );
		}
	}

	public function _callback () : void
	{
		if( pressed && button.enabled )
		{
			callback( scrollBar.getBlockIncrement(direction) );
			timeout = setTimeout( _callback, 50 );
		}
	}
}
/**
 *
 */
internal class KnobController
{
	public var button : Button;
	public var callback : Function;

	private var offset : Number;

	private var pressed : Boolean;
	private var scrollbar : ScrollBar;

	public function KnobController ( bt : Button, callback : Function, scrollbar : ScrollBar )
	{
		this.button = bt;
		this.callback = callback;
		this.pressed = false;
		this.scrollbar = scrollbar;
		this.button.mousePressed.add( mousePressed );
		this.button.mouseReleased.add( mouseReleased );
		this.button.mouseLeaved.add( mouseLeaved );
		this.button.mouseEntered.add( mouseEntered );
	}
	public function mousePressed ( btn : Button ) : void
	{
		if( button.enabled )
		{
			pressed = true;

			offset = scrollbar.isVertical ?
						this.button.parent.mouseY - this.button.y :
						this.button.parent.mouseX - this.button.x;

			button.addEventListener( Event.ENTER_FRAME, enterFrame );
		}
	}
	public function mouseReleased ( btn : Button ) : void
	{
		if( button.enabled )
		{
			pressed = false;
			button.stage.removeEventListener( MouseEvent.MOUSE_UP, mouseUp );
		}
	}
	public function mouseUp( e : Event ): void
	{
	    mouseReleased(null);
	}
	public function mouseLeaved ( btn : Button ) : void
	{
		if( pressed )
		{
			button.stage.addEventListener( MouseEvent.MOUSE_UP, mouseUp );
		}
	}
	public function mouseEntered ( btn : Button ) : void
	{
		if( pressed )
		{
			button.stage.removeEventListener( MouseEvent.MOUSE_UP, mouseUp );
		}
	}

	public function enterFrame ( e : Event ) : void
	{
		if( pressed )
		{
			scrollbar.isVertical ?
				this.button.y = this.button.parent.mouseY - offset :
				this.button.x = this.button.parent.mouseX - offset;

			callback();
		}
	}
}


/*---------------------------------------------------------
 *	Custom UIS
 *
 *
 *--------------------------------------------------------*/
[Style(name="icon",type="abe.com.ponents.skinning.icons.Icon")]
internal class ScrollBarButton extends Button
{
	public function ScrollBarButton ( styleKey : String, action : Action = null )
	{
		super( action );
		this.styleKey = styleKey;
		buttonMode = false;
		_isComponentLeaf = false;
		//_allowFocus = false;
	}
	override public function set styleKey (s : String) : void
	{
		super.styleKey = s;

		if( _style.icon )
			this.icon = _style.icon.clone();
	}

	override protected function stylePropertyChanged ( propertyName : String, propertyValue : * ) : void
	{
		switch( propertyName )
		{
			case "icon" :
				icon = propertyValue.clone();
				break;
			default :
				super.stylePropertyChanged( propertyName, propertyValue );
				break;
		}
	}

	FEATURES::TOOLTIP { 
	override public function showToolTip (overlay : Boolean = false) : void	{}
	} 
}
