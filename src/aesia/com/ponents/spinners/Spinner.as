package aesia.com.ponents.spinners 
{
	import aesia.com.mands.ProxyCommand;
	import aesia.com.mon.core.IDisplayObject;
	import aesia.com.mon.core.IDisplayObjectContainer;
	import aesia.com.mon.core.IInteractiveObject;
	import aesia.com.mon.core.LayeredSprite;
	import aesia.com.mon.geom.Dimension;
	import aesia.com.mon.utils.KeyStroke;
	import aesia.com.mon.utils.Keys;
	import aesia.com.mon.utils.StageUtils;
	import aesia.com.ponents.buttons.Button;
	import aesia.com.ponents.buttons.ButtonDisplayModes;
	import aesia.com.ponents.containers.Panel;
	import aesia.com.ponents.core.AbstractContainer;
	import aesia.com.ponents.core.Component;
	import aesia.com.ponents.core.edit.Editable;
	import aesia.com.ponents.core.edit.Editor;
	import aesia.com.ponents.core.focus.Focusable;
	import aesia.com.ponents.dnd.DragSource;
	import aesia.com.ponents.events.ButtonEvent;
	import aesia.com.ponents.events.ComponentEvent;
	import aesia.com.ponents.events.PropertyEvent;
	import aesia.com.ponents.forms.FormComponent;
	import aesia.com.ponents.forms.FormComponentDisabledModes;
	import aesia.com.ponents.layouts.components.BorderLayout;
	import aesia.com.ponents.layouts.components.GridLayout;
	import aesia.com.ponents.models.SpinnerModel;
	import aesia.com.ponents.models.SpinnerNumberModel;
	import aesia.com.ponents.text.TextInput;
	import aesia.com.ponents.utils.ToolKit;

	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.utils.IExternalizable;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;

	[Style(name="inputWidth", type="Number")]	[Style(name="upIcon", type="aesia.com.ponents.skinning.icons.Icon")]	[Style(name="downIcon", type="aesia.com.ponents.skinning.icons.Icon")]
	[Event(name="dataChange", type="aesia.com.ponents.events.ComponentEvent")]
	[Skinable(skin="Spinner")]
	[Skin(define="Spinner",
		  inherit="NoDecorationComponent",
		  preview="aesia.com.ponents.spinners::Spinner.defaultSpinnerPreview",
		  
		  custom_upIcon="icon(aesia.com.ponents.spinners::Spinner.SPINNER_UP_ICON)",
		  custom_downIcon="icon(aesia.com.ponents.spinners::Spinner.SPINNER_DOWN_ICON)",
		  custom_inputWidth="75"
	)]
	[Skin(define="SpinnerUpButton",
		  inherit="Button",
		  preview="aesia.com.ponents.spinners::Spinner.defaultSpinnerPreview",
		  previewAcceptStyleSetup="false",
		  
		  state__all__insets="new aesia.com.ponents.utils::Insets( 4, 0, 4, 0 )",		  state__all__borders="new aesia.com.ponents.utils::Borders( 0,1,1,1 )",		  state__all__corners="new aesia.com.ponents.utils::Corners( 0, 6, 0, 0 )"
	)]
	[Skin(define="SpinnerDownButton",
		  inherit="Button",
		  preview="aesia.com.ponents.spinners::Spinner.defaultSpinnerPreview",
		  previewAcceptStyleSetup="false",
		  
		  state__all__insets="new aesia.com.ponents.utils::Insets( 4, 0, 4, 0 )",
		  state__all__borders="new aesia.com.ponents.utils::Borders( 0,0,1,1 )",
		  state__all__corners="new aesia.com.ponents.utils::Corners( 0, 0, 0, 6 )"
	)]
	[Skin(define="SpinnerInput",
		  inherit="Text",
		  preview="aesia.com.ponents.spinners::Spinner.defaultSpinnerPreview",
		  previewAcceptStyleSetup="false",
		  
		  state__all__background="new aesia.com.ponents.skinning.decorations::SimpleFill( color( White ) )",
		  state__all__insets="new aesia.com.ponents.utils::Insets( 5, 0, 0, 0 )",
		  state__all__corners="new aesia.com.ponents.utils::Corners(6,0,6,0 )"
	)]
	public class Spinner extends AbstractContainer implements Component, 
															  IDisplayObject, 
															  IInteractiveObject, 
															  IDisplayObjectContainer, 
															  Focusable,
															  LayeredSprite, 
															  IEventDispatcher, 
															  DragSource,
															  IExternalizable,
															  FormComponent,
															  Editor
	{
		/*FDT_IGNORE*/ FEATURES::BUILDER { /*FDT_IGNORE*/
		static public function defaultSpinnerPreview () : Spinner
		{
			return new Spinner(new SpinnerNumberModel(10, 0, 100, 1, false, 2));
		}
		/*FDT_IGNORE*/ } /*FDT_IGNORE*/
		
		[Embed(source="../skinning/icons/scrollup.png")]
		static public var SPINNER_UP_ICON : Class;
		[Embed(source="../skinning/icons/scrolldown.png")]
		static public var SPINNER_DOWN_ICON : Class;
		
		
		protected var _model : SpinnerModel;
		
		protected var _input : TextInput;
		protected var _buttonContainer : Panel;
		protected var _upButton : Button;
		protected var _downButton : Button;
		protected var _interval : Number;
		protected var _caller : Editable;

		public function Spinner ( model : SpinnerModel = null )
		{
			super( );
			_childrenContextEnabled = false;
			_input = new TextInput();
			_buttonContainer = new Panel();
			_upButton = new Button("");			_downButton = new Button("");
			
			_input.isComponentIndependent = false;
			_upButton.isComponentIndependent = false;
			_downButton.isComponentIndependent = false;
			_buttonContainer.isComponentIndependent = false;
			
			_input.styleKey = "SpinnerInput";
			_input.preferredWidth = _style.inputWidth;
			
			_upButton.icon = _style.upIcon.clone();
			_upButton.buttonDisplayMode = ButtonDisplayModes.ICON_ONLY;
			_upButton.styleKey = "SpinnerUpButton";			
			_downButton.icon = _style.downIcon.clone();
			_downButton.buttonDisplayMode = ButtonDisplayModes.ICON_ONLY;			_downButton.styleKey = "SpinnerDownButton";			
			addComponent( _input );
			addComponent( _buttonContainer );
			
			_buttonContainer.addComponent( _upButton );
			_buttonContainer.addComponent( _downButton );
			_buttonContainer.childrenLayout = new GridLayout( _buttonContainer, 2, 1, 0, 0 );

			var layout : BorderLayout = new BorderLayout( this );		
			
			layout.center = _input;
			layout.east = _buttonContainer;
			
			childrenLayout = layout;
			
			/*FDT_IGNORE*/ FEATURES::KEYBOARD_CONTEXT { /*FDT_IGNORE*/
				_keyboardContext[ KeyStroke.getKeyStroke( Keys.UP ) ] = new ProxyCommand( up );				_keyboardContext[ KeyStroke.getKeyStroke( Keys.DOWN ) ] = new ProxyCommand( down );				_keyboardContext[ KeyStroke.getKeyStroke( Keys.ENTER ) ] = new ProxyCommand( validateInput );
			/*FDT_IGNORE*/ } /*FDT_IGNORE*/
				
			this.model = model;
		}

		override protected function stylePropertyChanged (event : PropertyEvent) : void
		{
			switch( event.propertyName )
			{
				case "upIcon" :
					_upButton.icon = event.propertyValue.clone();
					break;
				case "downIcon" :
					_downButton.icon = event.propertyValue.clone();
					break;
				case "inputWidth" :
					_input.preferredWidth = event.propertyValue;
					break;
				default : 
					super.stylePropertyChanged( event );
					break;
			}
		}

		public function get disabledMode () : uint { return _input.disabledMode; }
		public function set disabledMode (b : uint) : void { _input.disabledMode = b; }

		public function get disabledValue () : * { return _input.disabledValue; }		
		public function set disabledValue (v : *) : void { _input.disabledValue = v; }
		
		public function get value () : * { return _model.value; }
		public function set value ( n : * ) : void
		{
			_model.value = n;
		}

		public function get model () : SpinnerModel	{ return _model; }		
		public function set model (model : SpinnerModel) : void
		{
			var hadModel : Boolean = false;
			if( _model )
			{
				_model.removeEventListener( ComponentEvent.DATA_CHANGE, dataChanged );				_model.removeEventListener( PropertyEvent.PROPERTY_CHANGE, modelPropertyChange );
				hadModel = true;
				
			}
			_model = model;
			
			if( _model )
			{
				_model.addEventListener( ComponentEvent.DATA_CHANGE, dataChanged );				_model.addEventListener( PropertyEvent.PROPERTY_CHANGE, modelPropertyChange );
				dataChanged(null);
				
				if(!hadModel)
				{
					disabledMode = 0;
					enabled = true;
				}
				/*FDT_IGNORE*/ FEATURES::MENU_CONTEXT { /*FDT_IGNORE*/
					_input.cleanContextMenuItemGroup("format");
					var l:int=_model.modelMenuContext.length;
					for (var i:uint = 0;i<l;i++) 
					    _input.addContextMenuItemForGroup( _model.modelMenuContext[i], "spinnerModelMenu" + i, "format" );
				/*FDT_IGNORE*/ } /*FDT_IGNORE*/
			}
			else
			{
				enabled = false;
				disabledMode = FormComponentDisabledModes.UNDEFINED;
			}
		}
		public function reset() : void
		{
			_model.reset();
		}

		protected function modelPropertyChange (event : PropertyEvent) : void
		{
			switch( event.propertyName )
			{
				case "displayValue" : 
					_input.value = event.propertyValue;
					invalidatePreferredSizeCache();
					break;
				case "modelMenuContext" : 
				/*FDT_IGNORE*/ FEATURES::MENU_CONTEXT { /*FDT_IGNORE*/
					_input.cleanContextMenuItemGroup("format");
					var l:int=_model.modelMenuContext.length;
					for (var i:uint = 0;i<l;i++) 
					    _input.addContextMenuItemForGroup( _model.modelMenuContext[i], "spinnerModelMenu" + i, "format" );
				/*FDT_IGNORE*/ } /*FDT_IGNORE*/
					break;
				default : 
					break;
			}
		}

		public function initEditState (caller : Editable, value : *, overlayTarget : DisplayObject = null) : void
		{
			this.caller = caller;
			this.value = value;
			
			var bb : Rectangle = ( _caller ).getBounds( StageUtils.root );
			
			ToolKit.popupLevel.addChild( this );
			position = bb.topLeft;
			_preferredSizeCache = new Dimension( bb.width, bb.height );
			
			StageUtils.stage.addEventListener(MouseEvent.MOUSE_UP, stageMouseUp );
			grabFocus( );		}

		public function get caller () : Editable { return _caller; }
		public function set caller (e : Editable) : void
		{
			_caller = e;
		}
		
		public function get input () : TextInput { return _input; }		
		public function get upButton () : Button { return _upButton; }		
		public function get downButton () : Button { return _downButton; }

		public function get allowInput () : Boolean { return _input.allowInput; }		
		public function set allowInput (allowInput : Boolean) : void
		{
			_input.allowInput = allowInput;
		}

		protected function up () : void
		{
			if( _enabled && _model && _model.hasNextValue() )
				_model.value = _model.getNextValue();
		}
		protected function down () : void
		{
			if( _enabled && _model && _model.hasPreviousValue() )
				_model.value = _model.getPreviousValue();
		}
		protected function validateInput() : void
		{
			if( !_model )
				return;

			if( _model.displayValue != _input.value )
				_model.value = _input.value;
			else
				_input.value = _model.displayValue;
				
			if( _caller )
				_caller.confirmEdit();
		}
		protected function mouseWheel ( e : MouseEvent ) : void
		{
			e.stopPropagation();
			if( _enabled )
			{
				if( e.delta > 0 )
					up();
				else
					down();
			}
		}
		protected function upMouseDown ( e : Event ) : void
		{
			if( _enabled )
			{
				_interval = setInterval( up, 250 );
				up();
			}
		}
		protected function upMouseUp ( e : Event ) : void
		{
			clearInterval( _interval );
		}
		protected function downMouseDown ( e : Event ) : void
		{
			if( _enabled )
			{
				_interval = setInterval( down, 250 );
				down();
			}
		}
		protected function downMouseUp ( e : Event ) : void
		{
			clearInterval( _interval );
		}

		protected function dataChanged ( e : Event ) : void
		{
			if( !_model )
				return;
			
			_input.value = _model.displayValue;
			_upButton.enabled = _model.hasNextValue() && _enabled;
			_downButton.enabled = _model.hasPreviousValue() && _enabled;
			_input.selectAll();
			
			fireDataChange();
		}
		override public function keyFocusChange (e : FocusEvent) : void
		{
			if( _caller )
			{
				e.preventDefault();
				e.stopImmediatePropagation();
				
				if( e.shiftKey )
					_caller.focusPrevious();
				else
					_caller.focusNext();
			}
			else
				super.keyFocusChange(e);
		}
		override public function focusIn (e : FocusEvent) : void
		{			_focusIn( e );
			
			if( !( e.target is TextField ) && e.target != _input )
			{
				StageUtils.stage.focus = _input;
				e.stopImmediatePropagation();
			}
		}

		override public function focusOut (e : FocusEvent) : void
		{
			super.focusOut( e );
			if( !_caller )
				validateInput();
		}
		protected function stageMouseUp (event : MouseEvent) : void 
		{		
			if( !isMouseOver )	
			{
				StageUtils.stage.removeEventListener(MouseEvent.MOUSE_UP, stageMouseUp );
				validateInput();
			}
		}
		override public function focusNextChild (child : Focusable) : void
		{
			focusNext();
		}
		override public function focusPreviousChild (child : Focusable) : void
		{
			focusPrevious();
		}
		override protected function registerToOnStageEvents () : void 
		{
			super.registerToOnStageEvents();
			
			_upButton.addWeakEventListener( MouseEvent.MOUSE_DOWN, upMouseDown );
			_upButton.addWeakEventListener( MouseEvent.MOUSE_UP, upMouseUp );
			_upButton.addWeakEventListener( ButtonEvent.BUTTON_RELEASE_OUTSIDE, upMouseUp );
			
			_downButton.addWeakEventListener( MouseEvent.MOUSE_DOWN, downMouseDown );
			_downButton.addWeakEventListener( MouseEvent.MOUSE_UP, downMouseUp );
			_downButton.addWeakEventListener( ButtonEvent.BUTTON_RELEASE_OUTSIDE, downMouseUp );
			
			addWeakEventListener( MouseEvent.MOUSE_WHEEL, mouseWheel );
		}

		override protected function unregisterFromOnStageEvents () : void 
		{
			super.unregisterFromOnStageEvents();
			
			_upButton.removeEventListener( MouseEvent.MOUSE_DOWN, upMouseDown );
			_upButton.removeEventListener( MouseEvent.MOUSE_UP, upMouseUp );
			_upButton.removeEventListener( ButtonEvent.BUTTON_RELEASE_OUTSIDE, upMouseUp );
			
			_downButton.removeEventListener( MouseEvent.MOUSE_DOWN, downMouseDown );
			_downButton.removeEventListener( MouseEvent.MOUSE_UP, downMouseUp );
			_downButton.removeEventListener( ButtonEvent.BUTTON_RELEASE_OUTSIDE, downMouseUp );
			
			removeEventListener( MouseEvent.MOUSE_WHEEL, mouseWheel );
		}
		protected function fireDataChange () : void 
		{
			dispatchEvent( new ComponentEvent( ComponentEvent.DATA_CHANGE ) );
		}
	}
}