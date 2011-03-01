package abe.com.ponents.sliders 
{
	import abe.com.mon.geom.Range;
	import abe.com.mon.utils.Color;
	import abe.com.mon.utils.MathUtils;
	import abe.com.ponents.buttons.Button;
	import abe.com.ponents.buttons.ButtonDisplayModes;
	import abe.com.ponents.core.AbstractContainer;
	import abe.com.ponents.core.Component;
	import abe.com.ponents.events.ButtonEvent;
	import abe.com.ponents.events.ComponentEvent;
	import abe.com.ponents.events.PropertyEvent;
	import abe.com.ponents.forms.FormComponent;
	import abe.com.ponents.layouts.components.BoxSettings;
	import abe.com.ponents.layouts.components.VBoxLayout;
	import abe.com.ponents.models.BoundedRangeModel;
	import abe.com.ponents.models.RangeBoundedRangeModel;
	import abe.com.ponents.skinning.decorations.VRangeSliderTrackFill;
	import abe.com.ponents.text.TextInput;
	import abe.com.ponents.utils.Alignments;

	import flash.events.Event;
	import flash.events.MouseEvent;

	[Event(name="dataChange", type="abe.com.ponents.events.ComponentEvent")]
	[Style(name="inputWidth", type="Number")]
	[Style(name="buttonSize", type="Number")]
	[Style(name="trackSize", type="Number")]
	[Style(name="tickSize", type="Number")]
	[Style(name="tickMargin", type="Number")]
	[Style(name="tickColor", type="abe.com.mon.utils.Color")]
	[Style(name="icon", type="abe.com.ponents.skinning.icons.Icon")]
	[Skinable(skin="VRangeSlider")]
	[Skin(define="VRangeSlider",
		  inherit="EmptyComponent",
		  preview="abe.com.ponents.sliders::VRangeSlider.defaultVRangeSliderPreview",
		  
		  custom_inputWidth="30",
		  custom_buttonSize="20",
		  custom_trackSize="150",
		  custom_tickSize="8",
		  custom_tickMargin="5",
		  custom_tickColor="skin.sliderTickColor",
		  custom_icon="icon(abe.com.ponents.sliders::VRangeSlider.SLIDER_ICON)"
	)]
	[Skin(define="VRangeSliderButton",
		  inherit="Button",
		  preview="abe.com.ponents.sliders::VRangeSlider.defaultVRangeSliderPreview",
		  previewAcceptStyleSetup="false",
		  
		  state__all__corners="new cutils::Corners(3)",
		  state__all__insets="new cutils::Insets(5)"
	)]
	[Skin(define="VRangeSliderInput",
		  inherit="Text",
		  preview="abe.com.ponents.sliders::VRangeSlider.defaultVRangeSliderPreview",
		  previewAcceptStyleSetup="false"
	)]
	[Skin(define="VRangeSliderTrack",
		  inherit="EmptyComponent",
		  shortcuts="sliders=abe.com.ponents.sliders",
		  preview="abe.com.ponents.sliders::VRangeSlider.defaultVRangeSliderPreview",
		  previewAcceptStyleSetup="false",
		  
		  state__all__background="new deco::VRangeSliderTrackFill( skin.sliderTrackBackgroundColor1, skin.sliderTrackBackgroundColor2, skin.sliderRangeBackgroundColor, 4, 10)",
		  state__1_5_9_13__background="new deco::VRangeSliderTrackFill( skin.sliderTrackDisabledBackgroundColor1, skin.sliderTrackDisabledBackgroundColor2, skin.sliderDisabledRangeBackgroundColor, 4, 10)",
		  state__all__corners="new cutils::Corners(2)",
		  state__all__insets="new cutils::Insets(2,10,2,10)"
	)]
	public class VRangeSlider extends AbstractContainer implements FormComponent
	{
/*----------------------------------------------------------------------------------*
 *  CLASS MEMBERS
 *----------------------------------------------------------------------------------*/
		/*FDT_IGNORE*/ FEATURES::BUILDER { /*FDT_IGNORE*/
		static public function defaultVRangeSliderPreview () : VRangeSlider
		{
			return new VRangeSlider(new RangeBoundedRangeModel(new Range( 20, 50 ), 0, 100 ), 5, 10, true, true, true );
		}
		/*FDT_IGNORE*/ } /*FDT_IGNORE*/
		
		static private const DEPENDENCIES : Array = [VRangeSliderTrackFill];
		[Embed(source="../skinning/icons/vgrip.png")]
		static public var SLIDER_ICON : Class;
		
/*----------------------------------------------------------------------------------*
 * 	INSTANCE MEMBERS
 *----------------------------------------------------------------------------------*/
		protected var _inputLeft : TextInput;
		protected var _inputRight : TextInput;
		protected var _track : Button;
		
		protected var _knobLeft : Button;
		protected var _knobRight : Button;
		
		protected var _model : BoundedRangeModel;
		
		protected var _minorTickSpacing : Number;
		protected var _majorTickSpacing : Number;
		protected var _displayTicks : Boolean;
		protected var _snapToTicks : Boolean;
		protected var _displayInput : Boolean;
		protected var _tickColor : Color;
		
		protected var _preComponent : Component; 
		protected var _postComponent : Component; 
		
		protected var _dragTarget : Button;
		protected var _dragging : Boolean;
		protected var _pressedX : Number;
		protected var _pressedY : Number;
		
		public function VRangeSlider ( model : BoundedRangeModel, 
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
			_tickColor = _style.tickColor;
			
			buildChildren();
			
			preComponent = preComp;
			postComponent = postComp;
			
			this.model = model; 
		}
/*----------------------------------------------------------------------------------*
 * 	GETTER/SETTERS
 *----------------------------------------------------------------------------------*/
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
		public function get inputLeft () : TextInput { return _inputLeft; }
		public function get inputRight () : TextInput { return _inputRight; }
		public function get track () : Button { return _track; }
		public function get knobLeft () : Button { return _knobLeft; }
		public function get knobRight () : Button { return _knobRight; }
		
		public function get range() : Range { return new Range( _model.value, _model.value + _model.extent ); }
		
		public function get value () : * { return range; }
		public function set value (v : * ) : void 
		{
			if( v is Range )
			{
				var r : Range = v as Range;
				_model.value = r.min;
				_model.extent = r.size();
			}
		}
		
		public function get disabledMode () : uint { return _inputLeft.disabledMode; }
		public function set disabledMode (b : uint) : void 
		{
			_inputLeft.disabledMode = b;
			_inputRight.disabledMode = b;
		}
		
		public function get disabledValue () : * { return _inputLeft.disabledValue; }
		public function set disabledValue (v : *) : void 
		{
			_inputLeft.disabledValue = v;
			_inputRight.disabledValue = v;
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
				(childrenLayout as VBoxLayout).setObjectForBox( null, 1 );
			}
			
			_preComponent = preComponent;
			if( _preComponent )
			{
				_preComponent.isComponentIndependent = false;
				addComponent( _preComponent );
				(childrenLayout as VBoxLayout).setObjectForBox( _preComponent, 1 );
			}
		}
		public function get postComponent () : Component { return _postComponent; }	
		public function set postComponent (postComponent : Component) : void
		{
			if( _postComponent )
			{
				removeComponent( _postComponent );
				(childrenLayout as VBoxLayout).setObjectForBox( null, 3 );
			}
			
			_postComponent = postComponent;
			if( _postComponent )
			{
				_postComponent.isComponentIndependent = false;
				addComponent( _postComponent );
				(childrenLayout as VBoxLayout).setObjectForBox( _postComponent, 3 );
			}
		}
		public function get displayInput () : Boolean { return _displayInput; }		
		public function set displayInput (displayInput : Boolean) : void
		{
			_displayInput = displayInput;
			
			var b1 : BoxSettings = (_childrenLayout as VBoxLayout).boxes[4];
			var b2 : BoxSettings = (_childrenLayout as VBoxLayout).boxes[0];
			
			b1.object = _displayInput ? _inputLeft : null;
			b2.object = _displayInput ? _inputRight : null;
			
			if( !_displayInput && containsComponent( _inputLeft ) )
				removeComponent( _inputLeft );
			else if( _displayInput && !containsComponent( _inputLeft ) )
				addComponent( _inputLeft );
			
			if( !_displayInput && containsComponent( _inputRight ) )
				removeComponent( _inputRight );
			else if( _displayInput && !containsComponent( _inputRight ) )
				addComponent( _inputRight );
		}
/*----------------------------------------------------------------------------------*
 *  BUILD AND INIT
 *----------------------------------------------------------------------------------*/

		protected function buildChildren() : void
		{
			_inputLeft = new TextInput();
			_inputLeft.styleKey = "VRangeSliderInput";
			_inputLeft.preferredWidth = _style.inputWidth;
			_inputLeft.isComponentIndependent = false;
			
			_inputRight = new TextInput();
			_inputRight.styleKey = "VRangeSliderInput";
			_inputRight.preferredWidth = _style.inputWidth;
			_inputRight.isComponentIndependent = false;
			
			_knobLeft = new Button("");
			_knobLeft.styleKey = "VRangeSliderButton";
			_knobLeft.icon = _style.icon.clone();
			_knobLeft.buttonDisplayMode = ButtonDisplayModes.ICON_ONLY;
			_knobLeft.preferredHeight = _style.buttonSize;
			_knobLeft.isComponentIndependent = false;
			
			_knobRight = new Button("");
			_knobRight.styleKey = "VRangeSliderButton";
			_knobRight.icon = _style.icon.clone();
			_knobRight.buttonDisplayMode = ButtonDisplayModes.ICON_ONLY;
			_knobRight.preferredHeight = _style.buttonSize;
			_knobRight.isComponentIndependent = false;
			
			_track = new Button("");
			_track.styleKey = "VRangeSliderTrack";
			_track.label = "";
			_track.allowFocus = false;
			_track.allowOver = false;
			_track.allowPressed = false;
			_track.isComponentIndependent = false;
			_track.preferredWidth = 20;
			
			addComponent( _track );
			
			if( _displayInput )
			{
				addComponent( _inputLeft );
				addComponent( _inputRight );
			}
			addComponent( _knobLeft );
			addComponent( _knobRight );
			 
			var layout : VBoxLayout = new VBoxLayout( this, 3, 
											new BoxSettings( 0, "left", "center", _displayInput ? _inputRight : null ),
											new BoxSettings( 0, "right", "center", null ),
											new BoxSettings( _style.trackSize, "left", "center", _track, true, true, true ),
											new BoxSettings( 0, "left", "center", null ),
											new BoxSettings( 0, "left", "center", _displayInput ? _inputLeft : null ) );
			childrenLayout = layout;
		}
		protected function updateValue (v : Number) : void 
		{
			var n : Number = _model.value;
			var r : Number = _model.value + _model.extent;
			v = getTransformedValue( v );
			if( v <= r )
			{
				_model.value = v;
				_model.extent = _model.extent + ( n - _model.value );
			}
		}
		protected function updateExtent (v : Number) : void 
		{
			v = getTransformedValue( v );
					
			if( v > _model.maximum )
				v = _model.maximum;
			else if( v < _model.value )
				v = _model.value;
				
			_model.extent =  v - _model.value;
		}
		protected function getTransformedValue ( n : Number ) : Number
		{
			if( _snapToTicks )
				return n - ( n % _minorTickSpacing );
			else
				return n;
		}
		protected function getKnobValue( knob : Button ) : Number
		{
			return MathUtils.map( _track.mouseY - _pressedY, knob.height/2, _track.height - knob.height/2, _model.maximum, _model.minimum );
		}
		protected function upLeft () : void
		{
			if( _enabled )
			{
				if( _snapToTicks )
					updateValue( _model.value + _minorTickSpacing );
				else
					updateValue( _model.value + 1 );
			}
		}
		protected function downLeft () : void
		{
			if( _enabled )
			{
				if( _snapToTicks )
					updateValue( _model.value - _minorTickSpacing );
				else
					updateValue( _model.value - 1 );
			}
		}
		protected function upRight () : void
		{
			if( _enabled )
			{
				if( _snapToTicks )
					updateExtent( _model.extent + _model.value + _minorTickSpacing );
				else
					updateExtent( _model.extent + _model.value + 1 );
			}
		}
		protected function downRight () : void
		{
			if( _enabled )
			{
				if( _snapToTicks )
					updateExtent( _model.extent + _model.value - _minorTickSpacing );
				else
					updateExtent( _model.extent + _model.value - 1 );
			}
		}
/*----------------------------------------------------------------------------------*
 * 	REPAINT
 *----------------------------------------------------------------------------------*/			
		override public function repaint () : void
		{
			super.repaint();
			placeSlider();
			
			if( _displayTicks )
				paintTicks();
		}
		protected function placeSlider () : void
		{
			_knobLeft.y = _track.y + MathUtils.map( _model.value , _model.minimum, _model.maximum, _track.height - _knobLeft.height, 0 );
			_knobLeft.x = Alignments.alignHorizontal( _knobLeft.width , width, _style.insets, "center" );
			
			_knobRight.y = _track.y + MathUtils.map( _model.value + _model.extent, _model.minimum, _model.maximum, _track.height - _knobRight.height, 0 );
			_knobRight.x = Alignments.alignHorizontal( _knobRight.width , width, _style.insets, "center" );
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
				y = _track.y + _knobLeft.height /2 + MathUtils.map( i , _model.minimum, _model.maximum, 0, _track.height - _knobLeft.height );
				_background.graphics.moveTo( x - w, y );
				_background.graphics.lineTo( x, y );
			}
			_background.graphics.lineStyle( 0, _tickColor.hexa, _tickColor.alpha / 255 );
			for( i = _model.minimum; i <= _model.maximum; i += _minorTickSpacing )
			{
				y = _track.y + _knobLeft.height/2 + MathUtils.map( i , _model.minimum, _model.maximum, 0, _track.height - _knobLeft.height );
				_background.graphics.moveTo( x - w/4, y );
				_background.graphics.lineTo( x - w*0.75, y );
			}
			_background.graphics.lineStyle();
		}
/*----------------------------------------------------------------------------------*
 * 	EVENTS
 *----------------------------------------------------------------------------------*/	
 		override protected function stylePropertyChanged (event : PropertyEvent) : void
		{
			switch( event.propertyName )
			{
				case "icon" :
					_knobLeft.icon = _style.icon.clone();
					_knobRight.icon = _style.icon.clone();
					invalidatePreferredSizeCache();
					break;
				case "buttonSize" :
					_knobLeft.preferredHeight = event.propertyValue;
					_knobRight.preferredHeight = event.propertyValue;
					invalidatePreferredSizeCache();
					break;
				case "inputWidth" :
					_inputLeft.preferredWidth = event.propertyValue;
					_inputRight.preferredWidth = event.propertyValue;
					invalidatePreferredSizeCache();
					break;
				case "tickSize" : 
				case "tickMargin" : 
					invalidate();
					break;
				case "tickColor" : 
					_tickColor = event.propertyValue;
					invalidatePreferredSizeCache();
					break;
				case "trackSize" : 
					(_childrenLayout as VBoxLayout).boxes[2].size = event.propertyValue;
					invalidatePreferredSizeCache();
					break;
				default : 
					super.stylePropertyChanged( event );
					break;
			}
		}	
		override protected function registerToOnStageEvents () : void 
		{
			super.registerToOnStageEvents( );
			
			_knobLeft.addWeakEventListener( MouseEvent.MOUSE_DOWN, dragStart );
			_knobLeft.addWeakEventListener( MouseEvent.MOUSE_UP, dragEnd );
			_knobLeft.addWeakEventListener( ButtonEvent.BUTTON_RELEASE_OUTSIDE, dragEnd );
			
			_knobRight.addWeakEventListener( MouseEvent.MOUSE_DOWN, dragStart );
			_knobRight.addWeakEventListener( MouseEvent.MOUSE_UP, dragEnd );
			_knobRight.addWeakEventListener( ButtonEvent.BUTTON_RELEASE_OUTSIDE, dragEnd );
			/*
			_track.addWeakEventListener( MouseEvent.MOUSE_DOWN, trackDragStart );
			_track.addWeakEventListener( MouseEvent.MOUSE_UP, dragEnd );
			_track.addWeakEventListener( ButtonEvent.BUTTON_RELEASE_OUTSIDE, dragEnd );	*/
			
			_inputLeft.addWeakEventListener( MouseEvent.MOUSE_WHEEL, leftMouseWheel );
			_inputRight.addWeakEventListener( MouseEvent.MOUSE_WHEEL, rightMouseWheel );
		}

		override protected function unregisterFromOnStageEvents () : void 
		{
			super.unregisterFromOnStageEvents( );
			
			_knobLeft.removeEventListener( MouseEvent.MOUSE_DOWN, dragStart );
			_knobLeft.removeEventListener( MouseEvent.MOUSE_UP, dragEnd );
			_knobLeft.removeEventListener( ButtonEvent.BUTTON_RELEASE_OUTSIDE, dragEnd );
			
			_knobRight.removeEventListener( MouseEvent.MOUSE_DOWN, dragStart );
			_knobRight.removeEventListener( MouseEvent.MOUSE_UP, dragEnd );
			_knobRight.removeEventListener( ButtonEvent.BUTTON_RELEASE_OUTSIDE, dragEnd );
			
			/*
			_track.removeEventListener( MouseEvent.MOUSE_DOWN, trackDragStart );
			_track.removeEventListener( MouseEvent.MOUSE_UP, dragEnd );
			_track.removeEventListener( ButtonEvent.BUTTON_RELEASE_OUTSIDE, dragEnd );*/	
			
			_inputLeft.removeEventListener( MouseEvent.MOUSE_WHEEL, leftMouseWheel );
			_inputRight.removeEventListener( MouseEvent.MOUSE_WHEEL, rightMouseWheel );
			
			//removeEventListener( MouseEvent.MOUSE_WHEEL, mouseWheel );
		}
		protected function dragStart ( e : MouseEvent ) : void
		{
			if( _enabled )
			{
				_dragTarget = e.target as Button;
				_dragging = true;
				_pressedX = 0;
				_pressedY = 0;
				drag ( null );
				if( stage )
					stage.addEventListener( MouseEvent.MOUSE_MOVE, drag );
			}
		}
		protected function dragEnd ( e : Event ) : void
		{
			drag ( null );
			_dragging = false;
			if( stage )
				stage.removeEventListener( MouseEvent.MOUSE_MOVE, drag );
		}
		protected function drag ( e : MouseEvent ) : void
		{
			if( _dragging )
			{
				var v : Number = getKnobValue( _dragTarget );
				if( _dragTarget == _knobLeft )
					updateValue( v );
				else
					updateExtent( v );
			}
		}
		protected function leftMouseWheel ( e : MouseEvent ) : void
		{
			e.stopPropagation();
			if( _enabled )
			{
				if( e.delta > 0 )
					upLeft();
				else
					downLeft();
			}
			
		}
		protected function rightMouseWheel ( e : MouseEvent ) : void
		{
			e.stopPropagation();
			if( _enabled )
			{
				if( e.delta > 0 )
					upRight();
				else
					downRight();
			}
		}
		protected function dataChanged (event : ComponentEvent) : void 
		{
			_inputLeft.value = _model.displayValue;
			_inputRight.value = ( _model as RangeBoundedRangeModel ).displayRangeMax;
			invalidate( true );
			
			fireDataChange();
		}
		protected function fireDataChange () : void 
		{
			dispatchEvent( new ComponentEvent( ComponentEvent.DATA_CHANGE ) );
		}
	}
}