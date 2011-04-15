package abe.com.ponents.sliders 
{
	import abe.com.mands.ProxyCommand;
	import abe.com.mon.colors.Color;
	import abe.com.mon.utils.KeyStroke;
	import abe.com.mon.utils.Keys;
	import abe.com.mon.utils.MathUtils;
	import abe.com.mon.utils.StageUtils;
	import abe.com.ponents.buttons.Button;
	import abe.com.ponents.buttons.ButtonDisplayModes;
	import abe.com.ponents.core.AbstractContainer;
	import abe.com.ponents.core.Component;
	import abe.com.ponents.core.focus.Focusable;
	import abe.com.ponents.events.ComponentEvent;
	import abe.com.ponents.forms.FormComponent;
	import abe.com.ponents.layouts.components.BoxSettings;
	import abe.com.ponents.layouts.components.VBoxLayout;
	import abe.com.ponents.models.BoundedRangeModel;
	import abe.com.ponents.models.DefaultBoundedRangeModel;
	import abe.com.ponents.skinning.decorations.VSliderTrackFill;
	import abe.com.ponents.text.TextInput;
	import abe.com.ponents.utils.Alignments;

	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	[Event(name="dataChange", type="abe.com.ponents.events.ComponentEvent")]
	[Style(name="inputWidth", type="Number")]
	[Style(name="buttonSize", type="Number")]
	[Style(name="trackSize", type="Number")]
	[Style(name="tickSize", type="Number")]
	[Style(name="tickMargin", type="Number")]
	[Style(name="tickColor", type="abe.com.mon.colors.Color")]
	[Style(name="icon", type="abe.com.ponents.skinning.icons.Icon")]
	[Skinable(skin="VSlider")]
	[Skin(define="VSlider",
		  inherit="EmptyComponent",
		  preview="abe.com.ponents.sliders::VSlider.defaultVSliderPreview",
		  
		  custom_inputWidth="30",
		  custom_buttonSize="20",		  custom_trackSize="150",		  custom_tickSize="8",		  custom_tickMargin="5",
		  custom_tickColor="skin.sliderTickColor",
		  custom_icon="icon(abe.com.ponents.sliders::VSlider.SLIDER_ICON)"
	)]
	[Skin(define="VSliderButton",
		  inherit="Button",
		  shortcuts="cutils=abe.com.ponents.utils",
		  preview="abe.com.ponents.sliders::VSlider.defaultVSliderPreview",
		  previewAcceptStyleSetup="false",
		  
		  state__all__corners="new cutils::Corners(3)",
		  state__all__insets="new cutils::Insets(5)"
	)]
	[Skin(define="VSliderInput",
		  inherit="Text",
		  preview="abe.com.ponents.sliders::VSlider.defaultVSliderPreview",
		  previewAcceptStyleSetup="false"
	)]
	[Skin(define="VSliderTrack",
		  inherit="EmptyComponent",
		  shortcuts="sliders=abe.com.ponents.sliders",
		  preview="abe.com.ponents.sliders::VSlider.defaultVSliderPreview",
		  previewAcceptStyleSetup="false",
		  
		  state__all__background="new deco::VSliderTrackFill( skin.sliderTrackBackgroundColor1, skin.sliderTrackBackgroundColor2, 4, 10)",		  state__1_5_9_13__background="new deco::VSliderTrackFill( skin.sliderTrackDisabledBackgroundColor1, skin.sliderTrackDisabledBackgroundColor2, 4, 10)",
		  state__all__corners="new cutils::Corners(2)",		  state__all__insets="new cutils::Insets(2,10,2,10)"
	)]
	public class VSlider extends AbstractContainer implements FormComponent
	{
		/*FDT_IGNORE*/ FEATURES::BUILDER { /*FDT_IGNORE*/
		static public function defaultVSliderPreview () : VSlider
		{
			return new VSlider(new DefaultBoundedRangeModel(10, 0, 100, 1), 5, 10, true, true, true );
		}
		/*FDT_IGNORE*/ } /*FDT_IGNORE*/
		
		static private const DEPENDENCIES : Array = [VSliderTrackFill];
		
		[Embed(source="../skinning/icons/vgrip.png")]
		static public var SLIDER_ICON : Class;
		
		protected var _input : TextInput;
		protected var _track : Button;
		protected var _knob : Button;
		protected var _model : BoundedRangeModel;
		
		protected var _dragging : Boolean;
		protected var _pressedX : Number;
		protected var _pressedY : Number;
		
		protected var _minorTickSpacing : Number;
		protected var _majorTickSpacing : Number;
		protected var _displayTicks : Boolean;
		protected var _snapToTicks : Boolean;
		
		protected var _preComponent : Component; 
		protected var _postComponent : Component; 
		
		protected var _tickColor : Color;
		
		protected var _displayInput : Boolean;
		
		public function VSlider ( model : BoundedRangeModel, 
								 majorTickSpacing : Number = 10, 
								 minorTickSpacing : Number = 5, 
								 displayTicks : Boolean = false, 
								 snapToTicks : Boolean = false,
								 displayInput : Boolean = true,
								 preComp : Component = null,
								 postComp : Component = null )
		{
			super();
			
			_childrenContextEnabled = false;
			_minorTickSpacing = minorTickSpacing;
			_majorTickSpacing = majorTickSpacing;
			_displayTicks = displayTicks;
			_snapToTicks = snapToTicks;
			_displayInput = displayInput;
			
			_input = new TextInput();
			_input.styleKey = "VSliderInput";
			_input.preferredWidth = _style.inputWidth;
			_input.isComponentIndependent = false;
			
			_knob = new Button("");
			_knob.styleKey = "VSliderButton";
			_knob.icon = _style.icon.clone();
			_knob.buttonDisplayMode = ButtonDisplayModes.ICON_ONLY;
			_knob.preferredHeight = _style.buttonSize;
			_knob.isComponentIndependent = false;
			
			_track = new Button("");
			_track.styleKey = "VSliderTrack";
			_track.label = "";
			_track.allowFocus = false;
			_track.allowOver = false;
			_track.allowPressed = false;
			_track.isComponentIndependent = false;
			_track.preferredWidth = 20;
			
			_tickColor = _style.tickColor;
			
			addComponent( _track );
			
			if( _displayInput )
				addComponent( _input );
			
			addComponent( _knob );
			
			var layout : VBoxLayout = new VBoxLayout( this, 3, 
											new BoxSettings( 0, "center", "center", null ),
											new BoxSettings( _style.trackSize, "center", "center", _track, true, true, true ),
											new BoxSettings( 0, "center", "center", null ),
											new BoxSettings( 0, "left", "center", _displayInput ? _input : null )
											 );
			childrenLayout = layout;
			
			/*FDT_IGNORE*/ FEATURES::KEYBOARD_CONTEXT { /*FDT_IGNORE*/
				_keyboardContext[ KeyStroke.getKeyStroke( Keys.UP ) ] = new ProxyCommand( up );
				_keyboardContext[ KeyStroke.getKeyStroke( Keys.LEFT ) ] = new ProxyCommand( down );
				_keyboardContext[ KeyStroke.getKeyStroke( Keys.DOWN ) ] = new ProxyCommand( down );
				_keyboardContext[ KeyStroke.getKeyStroke( Keys.RIGHT ) ] = new ProxyCommand( up );
				_keyboardContext[ KeyStroke.getKeyStroke( Keys.ENTER ) ] = new ProxyCommand( validateInput );
			/*FDT_IGNORE*/ } /*FDT_IGNORE*/
			
			this.model = model;
		}
		
		public function get disabledMode () : uint { return _input.disabledMode; }		
		public function set disabledMode (b : uint) : void
		{
			_input.disabledMode = b;
		}

		public function get disabledValue () : * { return _input.disabledValue; }
		public function set disabledValue (v : *) : void
		{
			_input.disabledValue;
		}
		
		public function get input () : TextInput { return _input; }		
		public function get track () : Button { return _track; }	
		public function get knob () : Button { return _knob; }
		
		public function get value () : * { return _model.value; }
		public function set value ( n : * ) : void
		{
			_model.value = n;
		}
		
		public function get model () : BoundedRangeModel { return _model; } 		
		public function set model (model : BoundedRangeModel) : void
		{
			if( !model )
				return;
			
			if( _model )
				_model.removeEventListener( ComponentEvent.DATA_CHANGE, dataChanged );
			
			_model = model;
			if( _model )
			{
				_model.addEventListener( ComponentEvent.DATA_CHANGE, dataChanged );
				dataChanged(null);
			}
		}
		public function get minorTickSpacing () : Number { return _minorTickSpacing; }		
		public function set minorTickSpacing (minorTickSpacing : Number) : void
		{
			_minorTickSpacing = minorTickSpacing;
			invalidate( true );
		}
		public function get majorTickSpacing () : Number { return _majorTickSpacing; }		
		public function set majorTickSpacing (majorTickSpacing : Number) : void
		{
			_majorTickSpacing = majorTickSpacing;
			invalidate( true );
		}
		public function get displayTicks () : Boolean { return _displayTicks; }		
		public function set displayTicks (displayTicks : Boolean) : void
		{
			_displayTicks = displayTicks;
			this.graphics.clear();
			invalidate( true );
		}
		public function get snapToTicks () : Boolean { return _snapToTicks; }		
		public function set snapToTicks (snapToTicks : Boolean) : void
		{
			_snapToTicks = snapToTicks;
		}
		
		public function get preComponent () : Component { return _preComponent; }		
		public function set preComponent (preComponent : Component) : void
		{
			if( _preComponent )
			{
				removeComponent( _preComponent );
				(childrenLayout as VBoxLayout).setObjectForBox( null, 2 );
			}
			
			_preComponent = preComponent;
			if( _preComponent )
			{
				_preComponent.isComponentIndependent = false;
				addComponent( _preComponent );
				(childrenLayout as VBoxLayout).setObjectForBox( _preComponent, 2 );
			}
		}
		public function get postComponent () : Component { return _postComponent; }	
		public function set postComponent (postComponent : Component) : void
		{
			if( _postComponent )
			{
				removeComponent( _postComponent );
				(childrenLayout as VBoxLayout).setObjectForBox( null, 0 );
			}
			
			_postComponent = postComponent;
			if( _postComponent )
			{
				_postComponent.isComponentIndependent = false;
				addComponent( _postComponent );
				(childrenLayout as VBoxLayout).setObjectForBox( _postComponent, 0 );
			}
		}
		override protected function registerToOnStageEvents () : void 
		{
			super.registerToOnStageEvents( );
			
			_knob.mousePressed.add( dragStart );
			_knob.mouseReleased.add( dragEnd );
			_knob.mouseReleasedOutside.add( dragEnd );
			_track.mousePressed.add( trackDragStart );
			_track.mouseReleased.add( dragEnd );
			_track.mouseReleasedOutside.add( dragEnd );	
			
			mouseWheelRolled.add( onMouseWheelRolled );
		}

		override protected function unregisterFromOnStageEvents () : void 
		{
			super.unregisterFromOnStageEvents( );
			
			_knob.mousePressed.remove( dragStart );
			_knob.mouseReleased.remove( dragEnd );
			_knob.mouseReleasedOutside.remove( dragEnd );
			_track.mousePressed.remove( trackDragStart );
			_track.mouseReleased.remove( dragEnd );
			_track.mouseReleasedOutside.remove( dragEnd );	
			
			mouseWheelRolled.add( onMouseWheelRolled );
		}
		
		
		protected function getTransformedValue ( n : Number ) : Number
		{
			if( _snapToTicks )
				return n - ( n % _minorTickSpacing );
			else
				return n;
		}
		
		private function trackDragStart ( c : Component ) : void
		{
			if( _enabled )
			{
				//_slider.y = mouseY - _slider.height / 2;
				dragStart ( c );
			}
		}

		protected function dragStart ( c : Component ) : void
		{
			if( _enabled )
			{
				_dragging = true;
				_pressedX = 0;
				_pressedY = 0;
				drag ( null );
				if( stage )
					stage.addEventListener( MouseEvent.MOUSE_MOVE, drag );
			}
		}
		protected function dragEnd ( c : Component ) : void
		{
			drag ( null );
			_dragging = false;
			if( stage )
				stage.removeEventListener( MouseEvent.MOUSE_MOVE, drag );
		}
		protected function drag ( c : Component ) : void
		{
			if( _dragging )
			{
				//_slider.y = MathUtils.restrict( mouseY - _pressedY, _track.y, _track.y + _track.height - _slider.height );
				var v : Number = MathUtils.map( _track.mouseY - _pressedY, _knob.height/2, _track.height - _knob.height/2, _model.maximum, _model.minimum );
				_model.value = getTransformedValue( v );
			}
		}
		protected function up () : void
		{
			if( _enabled )
			{
				if( _snapToTicks )
					_model.value = getTransformedValue( _model.value + _minorTickSpacing );
				else
					_model.value = getTransformedValue( _model.value + _model.extent );
			}
		}
		protected function down () : void
		{
			if( _enabled )
			{
				if( _snapToTicks )
					_model.value = getTransformedValue( _model.value - _minorTickSpacing );
				else
					_model.value = getTransformedValue( _model.value - _model.extent );
			}
		}
		protected function validateInput() : void
		{
			var n : Number = parseFloat(_input.value);
			if( !isNaN( n ) )
				_model.value = getTransformedValue (n);
			else
				_input.value = _model.displayValue;
		}
		override public function repaint () : void
		{
			super.repaint();
			placeSlider();
			if( _displayTicks )
				paintTicks();
		}

		protected function placeSlider () : void
		{
			_knob.y = _track.y + MathUtils.map( _model.value , _model.minimum, _model.maximum, _track.height - _knob.height, 0 );
			_knob.x = Alignments.alignHorizontal( _knob.width , width, _style.insets, "center" );
		}
		protected function paintTicks () : void
		{
			var y : Number;
			var i : Number;
			var w : Number = _style.tickSize;
			var x : Number = _track.x + _track.width/2 - _style.tickMargin;
			_background.graphics.lineStyle( 0, _tickColor.hexa, _tickColor.alpha / 255 );
			for( i = _model.minimum; i <= _model.maximum; i += _majorTickSpacing )
			{
				y = _track.y + _knob.height/2 + MathUtils.map( i , _model.minimum, _model.maximum, _track.height - _knob.height, 0 );
				_background.graphics.moveTo( x - w, y );
				_background.graphics.lineTo( x, y );
			}
			_background.graphics.lineStyle( 0, _tickColor.hexa, _tickColor.alpha / 500 );
			for( i = _model.minimum; i <= _model.maximum; i += _minorTickSpacing )
			{
				y = _track.y + _knob.height/2 + MathUtils.map( i , _model.minimum, _model.maximum, _track.height - _knob.height, 0 );
				_background.graphics.moveTo( x - w/4, y );
				_background.graphics.lineTo( x - w*0.75, y );
			}
			_background.graphics.lineStyle();
		}

		override public function focusIn (e : FocusEvent) : void
		{
			_focusIn( e );
			if( _displayInput && !( e.target is TextField ) && e.target != _input )
				StageUtils.stage.focus = _input;
		}

		override public function focusOut (e : FocusEvent) : void
		{
			super.focusOut( e );
			validateInput();
		}

		override public function focusNextChild (child : Focusable) : void
		{
			focusNext();
		}
		override public function focusPreviousChild (child : Focusable) : void
		{
			focusPrevious();
		}
		protected function onMouseWheelRolled ( c : Component, delta : Number ) : void
		{
			if( _enabled )
			{
				if( delta > 0 )
					up();
				else
					down();
			}
		}
		protected function dataChanged (event : ComponentEvent) : void
		{			
			_input.value = _model.displayValue;
			invalidate( true );
			_input.selectAll( );
			_input.textfield.scrollH = 0;
			
			fireDataChange();
		}
		
		public function get displayInput () : Boolean { return _displayInput; }		
		public function set displayInput (displayInput : Boolean) : void
		{
			_displayInput = displayInput;
			
			var b : BoxSettings = (_childrenLayout as VBoxLayout).boxes[3];
			
			b.object = _displayInput ? _input : null;
			
			if( !_displayInput && containsComponent( _input ) )
				removeComponent( _input );
			else if( _displayInput && !containsComponent( _input ) )
				addComponent( _input );
				
		}
		override protected function stylePropertyChanged ( propertyName : String, propertyValue : * ) : void
		{
			switch( propertyName )
			{
				case "icon" :
					_knob.icon = _style.icon.clone();
					break;
				case "buttonSize" :
					_knob.preferredHeight = propertyValue;
					break;
				case "inputWidth" :
					_input.preferredWidth = propertyValue;
					break;
				case "tickSize" : 
				case "tickMargin" : 
					invalidate();
					break;
				case "tickColor" : 
					_tickColor = propertyValue;
					invalidatePreferredSizeCache();
					break;
				case "trackSize" : 
					(_childrenLayout as VBoxLayout).boxes[1].size = propertyValue;
					invalidatePreferredSizeCache();
					break;
				default : 
					super.stylePropertyChanged( propertyName, propertyValue  );
					break;
			}
		}
		protected function fireDataChange () : void 
		{
			dispatchEvent( new ComponentEvent( ComponentEvent.DATA_CHANGE ) );
		}
	}
}
