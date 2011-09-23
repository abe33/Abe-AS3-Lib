package abe.com.ponents.spinners 
{
    import abe.com.mands.ProxyCommand;
    import abe.com.mon.core.IDisplayObject;
    import abe.com.mon.core.IDisplayObjectContainer;
    import abe.com.mon.core.IInteractiveObject;
    import abe.com.mon.core.LayeredSprite;
    import abe.com.mon.geom.Dimension;
    import abe.com.mon.utils.KeyStroke;
    import abe.com.mon.utils.Keys;
    import abe.com.mon.utils.StageUtils;
    import abe.com.ponents.buttons.Button;
    import abe.com.ponents.buttons.ButtonDisplayModes;
    import abe.com.ponents.containers.Panel;
    import abe.com.ponents.core.AbstractContainer;
    import abe.com.ponents.core.Component;
    import abe.com.ponents.core.edit.Editable;
    import abe.com.ponents.core.edit.Editor;
    import abe.com.ponents.core.focus.Focusable;
    import abe.com.ponents.dnd.DragSource;
    import abe.com.ponents.forms.FormComponent;
    import abe.com.ponents.forms.FormComponentDisabledModes;
    import abe.com.ponents.layouts.components.BorderLayout;
    import abe.com.ponents.layouts.components.InlineLayout;
    import abe.com.ponents.models.SpinnerModel;
    import abe.com.ponents.models.SpinnerNumberModel;
    import abe.com.ponents.text.TextInput;
    import abe.com.ponents.utils.ToolKit;

    import org.osflash.signals.Signal;

    import flash.display.DisplayObject;
    import flash.events.FocusEvent;
    import flash.events.IEventDispatcher;
    import flash.events.MouseEvent;
    import flash.geom.Rectangle;
    import flash.text.TextField;
    import flash.utils.clearInterval;
    import flash.utils.setInterval;

	[Style(name="inputWidth", type="Number")]
	[Style(name="upIcon", type="abe.com.ponents.skinning.icons.Icon")]
	[Style(name="downIcon", type="abe.com.ponents.skinning.icons.Icon")]
	[Skinable(skin="Spinner")]
	[Skin(define="Spinner",
		  inherit="NoDecorationComponent",
		  preview="abe.com.ponents.spinners::Spinner.defaultSpinnerPreview",
		  
		  custom_upIcon="icon(abe.com.ponents.spinners::Spinner.SPINNER_UP_ICON)",
		  custom_downIcon="icon(abe.com.ponents.spinners::Spinner.SPINNER_DOWN_ICON)",
		  custom_inputWidth="75"
	)]
	[Skin(define="SpinnerUpButton",
		  inherit="Button",
		  preview="abe.com.ponents.spinners::Spinner.defaultSpinnerPreview",
		  previewAcceptStyleSetup="false",
		  
		  state__all__insets="new cutils::Insets( 3, 2, 4, 2 )",
		  state__all__borders="new cutils::Borders( 0,1,1,1 )",
		  state__all__corners="new cutils::Corners( 0, 6, 0, 0 )"
	)]
	[Skin(define="SpinnerDownButton",
		  inherit="Button",
		  preview="abe.com.ponents.spinners::Spinner.defaultSpinnerPreview",
		  previewAcceptStyleSetup="false",
		  
		  state__all__insets="new cutils::Insets( 3, 1, 4, 2 )",
		  state__all__borders="new cutils::Borders( 0,0,1,1 )",
		  state__all__corners="new cutils::Corners( 0, 0, 0, 6 )"
	)]
	[Skin(define="SpinnerInput",
		  inherit="Text",
		  preview="abe.com.ponents.spinners::Spinner.defaultSpinnerPreview",
		  previewAcceptStyleSetup="false",
		  
		  state__all__background="skin.textBackgroundColor",
		  state__all__insets="new cutils::Insets(5,0,0,0 )",
		  state__all__corners="new cutils::Corners(6,0,6,0 )"
	)]
	public class Spinner extends AbstractContainer implements Component, 
															  IDisplayObject, 
															  IInteractiveObject, 
															  IDisplayObjectContainer, 
															  Focusable,
															  LayeredSprite, 
															  IEventDispatcher, 
															  DragSource,
															  FormComponent,
															  Editor
	{
		FEATURES::BUILDER { 
		    static public function defaultSpinnerPreview () : Spinner
		    {
			    return new Spinner(new SpinnerNumberModel(10, 0, 100, 1, false, 2));
		    }
		} 
		
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
		protected var _dataChanged : Signal;

		public function Spinner ( model : SpinnerModel = null )
		{
			super( );
			_dataChanged = new Signal();
			_childrenContextEnabled = false;
			_input = new TextInput();
			_buttonContainer = new Panel();
			_upButton = new Button("");
			_downButton = new Button("");
			
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
			_downButton.buttonDisplayMode = ButtonDisplayModes.ICON_ONLY;
			_downButton.styleKey = "SpinnerDownButton";
			
			addComponent( _input );
			addComponent( _buttonContainer );
			
			_buttonContainer.addComponent( _upButton );
			_buttonContainer.addComponent( _downButton );
			_buttonContainer.childrenLayout = new InlineLayout( _buttonContainer, 0, "left", "center", "topToBottom" );

			var layout : BorderLayout = new BorderLayout( this );		
			
			layout.center = _input;
			layout.east = _buttonContainer;
			
			childrenLayout = layout;
			
			FEATURES::KEYBOARD_CONTEXT { 
				_keyboardContext[ KeyStroke.getKeyStroke( Keys.UP ) ] = new ProxyCommand( up );
				_keyboardContext[ KeyStroke.getKeyStroke( Keys.DOWN ) ] = new ProxyCommand( down );
				_keyboardContext[ KeyStroke.getKeyStroke( Keys.ENTER ) ] = new ProxyCommand( validateInput );
			} 
				
			this.model = model;
		}

		override protected function stylePropertyChanged ( propertyName : String, propertyValue : * ) : void
		{
			switch( propertyName )
			{
				case "upIcon" :
					_upButton.icon = propertyValue.clone();
					break;
				case "downIcon" :
					_downButton.icon = propertyValue.clone();
					break;
				case "inputWidth" :
					_input.preferredWidth = propertyValue;
					break;
				default : 
					super.stylePropertyChanged( propertyName, propertyValue );
					break;
			}
		}
        public function get dataChanged() : Signal { return _dataChanged; }
		public function get disabledMode () : uint { return _input.disabledMode; }
		public function set disabledMode (b : uint) : void { _input.disabledMode = b; }

		public function get disabledValue () : * { return _input.disabledValue; }		
		public function set disabledValue (v : *) : void { _input.disabledValue = v; }
		
		public function get value () : * { return _model.value; }
		public function set value ( n : * ) : void
		{
			_model.value = n;
        }
		public function get canValidateForm () : Boolean { return false; }
        public function get formValidated() : Signal { return null; }
		public function get model () : SpinnerModel	{ return _model; }		
		public function set model (model : SpinnerModel) : void
		{
			var hadModel : Boolean = false;
			if( _model )
			{
				_model.dataChanged.remove( modelDataChanged );
				_model.propertyChanged.remove( modelPropertyChanged );
				hadModel = true;
			}
			_model = model;
			
			if( _model )
			{
				_model.dataChanged.add( modelDataChanged );
				_model.propertyChanged.add( modelPropertyChanged );
				modelDataChanged( _model, _model.value );
				
				if(!hadModel)
				{
					disabledMode = 0;
					enabled = true;
				}
				FEATURES::MENU_CONTEXT { 
					_input.cleanContextMenuItemGroup("format");
					var l:int=_model.modelMenuContext.length;
					for (var i:uint = 0;i < l;i++) 
					    _input.addContextMenuItemForGroup( _model.modelMenuContext[i], "spinnerModelMenu" + i, "format" );
				} 
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

		protected function modelPropertyChanged ( propertyName : String, propertyValue : * ) : void
		{
			switch( propertyName )
			{
				case "displayValue" : 
					_input.value = propertyValue;
					invalidatePreferredSizeCache();
					break;
				case "modelMenuContext" : 
				FEATURES::MENU_CONTEXT { 
					_input.cleanContextMenuItemGroup("format");
					var l:int=_model.modelMenuContext.length;
					for (var i:uint = 0;i < l;i++) 
					    _input.addContextMenuItemForGroup( _model.modelMenuContext[i], "spinnerModelMenu" + i, "format" );
				} 
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
			grabFocus( );
		}

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
		public function childrenMouseWheelRolled ( c : Component, d : Number ) : void
		{
			if( _enabled )
			{
				if( d > 0 )
					up();
				else
					down();
			}
		}
		protected function upMouseDown ( c : Component ) : void
		{
			if( _enabled )
			{
				_interval = setInterval( up, 250 );
				up();
			}
		}
		protected function upMouseUp ( c : Component ) : void
		{
			clearInterval( _interval );
		}
		protected function downMouseDown ( c : Component ) : void
		{
			if( _enabled )
			{
				_interval = setInterval( down, 250 );
				down();
			}
		}
		protected function downMouseUp ( c : Component ) : void
		{
			clearInterval( _interval );
		}

		protected function modelDataChanged ( m : SpinnerModel, v : * ) : void
		{
			if( !_model )
				return;
			
			_input.value = _model.displayValue;
			_upButton.enabled = _model.hasNextValue() && _enabled;
			_downButton.enabled = _model.hasPreviousValue() && _enabled;
			_input.selectAll();
			
			fireDataChangedSignal();
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
		{
			_focusIn( e );
			
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
			
			_input.mouseWheelRolled.add( childrenMouseWheelRolled )
			
			_upButton.mousePressed.add( upMouseDown );
			_upButton.mouseReleased.add( upMouseUp );
			_upButton.mouseReleasedOutside.add( upMouseUp );
			_upButton.mouseWheelRolled.add( childrenMouseWheelRolled );
			
			_downButton.mousePressed.add( downMouseDown );
			_downButton.mouseReleased.add( downMouseUp );
			_downButton.mouseReleasedOutside.add( downMouseUp );
			_downButton.mouseWheelRolled.add( childrenMouseWheelRolled );
		}

		override protected function unregisterFromOnStageEvents () : void 
		{
			super.unregisterFromOnStageEvents();
			
			_upButton.mousePressed.remove( upMouseDown );
			_upButton.mouseReleased.remove( upMouseUp );
			_upButton.mouseReleasedOutside.remove( upMouseUp );
			
			_downButton.mousePressed.remove( downMouseDown );
			_downButton.mouseReleased.remove( downMouseUp );
			_downButton.mouseReleasedOutside.remove( downMouseUp );
		}
		protected function fireDataChangedSignal () : void 
		{
			_dataChanged.dispatch( this, value );
		}
	}
}
