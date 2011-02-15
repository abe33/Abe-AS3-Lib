package aesia.com.ponents.text 
{
	import aesia.com.ponents.skinning.DefaultSkin;
	import aesia.com.mon.logs.Log;
	import aesia.com.mon.utils.Color;
	import aesia.com.patibility.lang._;
	import aesia.com.ponents.buttons.ColorPicker;
	import aesia.com.ponents.buttons.ToggleButton;
	import aesia.com.ponents.containers.ToolBar;
	import aesia.com.ponents.core.AbstractContainer;
	import aesia.com.ponents.core.edit.Editable;
	import aesia.com.ponents.core.edit.Editor;
	import aesia.com.ponents.events.ComponentEvent;
	import aesia.com.ponents.forms.FormComponent;
	import aesia.com.ponents.layouts.components.BoxSettings;
	import aesia.com.ponents.layouts.components.VBoxLayout;
	import aesia.com.ponents.menus.FontListComboBox;
	import aesia.com.ponents.models.SpinnerNumberModel;
	import aesia.com.ponents.skinning.decorations.SimpleFill;
	import aesia.com.ponents.skinning.icons.ColorIcon;
	import aesia.com.ponents.spinners.Spinner;
	import aesia.com.ponents.utils.Insets;

	import flash.display.DisplayObject;
	import flash.text.TextFormat;

	/**
	 * @author cedric
	 */
	[Event(name="dataChange",type="aesia.com.ponents.events.ComponentEvent")]
	[Skinable(skin="TextFormatEditor")]
	[Skin(define="TextFormatEditor",
			  inherit="DefaultComponent",
			  state__all__background="new deco::SimpleFill(skin.containerBackgroundColor)"
			  
	)]
	public class TextFormatEditor extends AbstractContainer implements Editor, FormComponent
	{
		protected var _format : TextFormat;
		protected var _caller : Editable;
		
		protected var _preview : PreviewLabel;
		protected var _fontList : FontListComboBox;
		protected var _boldButton : ToggleButton;		protected var _italicButton : ToggleButton;
		protected var _colorPicker : ColorPicker;		protected var _underlineButton : ToggleButton;		protected var _sizeSpinner : Spinner;
		
		public function TextFormatEditor ( tf : TextFormat = null )
		{
			super();
			
			_preview = new PreviewLabel();
			_preview.style.setForAllStates("insets", new Insets( 4 ) );
						
			_boldButton = new ToggleButton(_("<b>B</b>") );
			_italicButton = new ToggleButton(_("<i>I</i>") );
			_underlineButton = new ToggleButton(_("<u>U</u>") );			_sizeSpinner = new Spinner( new SpinnerNumberModel( 12, 1, 500, 1, true ) );			_colorPicker = new ColorPicker( Color.Black );
			_fontList = new FontListComboBox();
			
			_fontList.isComponentIndependent = false;
			_boldButton.isComponentIndependent = false;
			_italicButton.isComponentIndependent = false;
			_underlineButton.isComponentIndependent = false;
			_sizeSpinner.isComponentIndependent = false;
			_preview.isComponentIndependent = false;
			_colorPicker.isComponentIndependent = false;
			
			_sizeSpinner.preferredWidth = 60;
			
			var p : ToolBar = new ToolBar(0,false,3);
			p.allowMask = false;
			p.style.setForAllStates("background", new SimpleFill( DefaultSkin.backgroundColor ) );
			var l : VBoxLayout = new VBoxLayout(this, 0, 
												 new BoxSettings(28, "center", "center" , p, true, true ),
												 new BoxSettings(50, "left", "center", _preview, true, true, false )
												 );
			
			p.addComponent( _boldButton );			p.addComponent( _italicButton );
			p.addComponent( _underlineButton );			p.addSeparator();
			p.addComponent( _colorPicker );			p.addComponent( _sizeSpinner );			p.addComponent( _fontList );
			
			_boldButton.styleKey = _italicButton.styleKey = _underlineButton.styleKey = _colorPicker.styleKey = "ToolBar_Button";
			
			addComponent( _preview );
			addComponent( p );
			
			childrenLayout = l;
			
			if( tf )
				initEditState( null, tf );
		}
		
		protected function colorDataChange (event : ComponentEvent) : void
		{
			_format.color = _colorPicker.value.hexa;
			Log.debug( uint(_format.color).toString(16) + ", " + _colorPicker.value + ", " + (_colorPicker.action.icon as ColorIcon).color );
			updatePreviewFormat();
			fireDataChange();
			event.stopImmediatePropagation();
		}

		protected function boldDataChange (event : ComponentEvent) : void 
		{
			_format.bold = _boldButton.selected;
			updatePreviewFormat();
			fireDataChange();
			event.stopImmediatePropagation();
		}

		protected function italicDataChange (event : ComponentEvent) : void 
		{
			_format.italic = _italicButton.selected;
			updatePreviewFormat();
			fireDataChange();
			event.stopImmediatePropagation();
		}
		protected function underlineDataChange (event : ComponentEvent) : void 
		{
			_format.underline = _underlineButton.selected;
			updatePreviewFormat();
			fireDataChange();
			event.stopImmediatePropagation();
		}

		protected function sizeDataChange (event : ComponentEvent) : void 
		{
			_format.size = _sizeSpinner.value;
			updatePreviewFormat();
			fireDataChange();
			event.stopImmediatePropagation();
		}

		protected function fontDataChange (event : ComponentEvent) : void 
		{
			_format.font = _fontList.value;
			updatePreviewFormat();
			fireDataChange();
			event.stopImmediatePropagation();
		}

		public function initEditState (caller : Editable, value : *, overlayTarget : DisplayObject = null) : void
		{
			this.caller = caller;
			this.value = value;
		}
		
		public function get caller () : Editable { return _caller; }
		public function set caller (e : Editable) : void
		{
			_caller = e;
		}

		public function get value () : * { return _format; }
		public function set value (v : *) : void
		{
			_format = v as TextFormat;
			
			unregisterFromSubComponentsEvents();			
			_boldButton.selected = Boolean(_format.bold);
			_italicButton.selected = Boolean(_format.italic);			_underlineButton.selected = Boolean(_format.underline );			_sizeSpinner.value = uint( _format.size );
			_fontList.value = _format.font;
			_colorPicker.value = new Color( 0xff000000 + uint(_format.color) );
			updatePreviewFormat();
			
			registerToSubComponentsEvents();
		}

		protected function unregisterFromSubComponentsEvents () : void 
		{
			_fontList.removeEventListener(ComponentEvent.DATA_CHANGE, fontDataChange );
			_sizeSpinner.removeEventListener(ComponentEvent.DATA_CHANGE, sizeDataChange );
			_boldButton.removeEventListener(ComponentEvent.DATA_CHANGE, boldDataChange );
			_italicButton.removeEventListener(ComponentEvent.DATA_CHANGE, italicDataChange );
			_underlineButton.removeEventListener(ComponentEvent.DATA_CHANGE, underlineDataChange );
			_colorPicker.removeEventListener(ComponentEvent.DATA_CHANGE, colorDataChange );
			
		}
		protected function registerToSubComponentsEvents () : void 
		{
			_fontList.addEventListener(ComponentEvent.DATA_CHANGE, fontDataChange );
			_sizeSpinner.addEventListener(ComponentEvent.DATA_CHANGE, sizeDataChange );
			_boldButton.addEventListener(ComponentEvent.DATA_CHANGE, boldDataChange );
			_italicButton.addEventListener(ComponentEvent.DATA_CHANGE, italicDataChange );
			_underlineButton.addEventListener(ComponentEvent.DATA_CHANGE, underlineDataChange );
			_colorPicker.addEventListener(ComponentEvent.DATA_CHANGE, colorDataChange );
			
		}

		protected function updatePreviewFormat () : void 
		{
			_preview.textField.defaultTextFormat = _format;
			_preview.textField.text = _("The quick brown fox jumps over the lazy dog");
			invalidatePreferredSizeCache();
		}
		protected function fireDataChange () : void 
		{
			dispatchEvent( new ComponentEvent( ComponentEvent.DATA_CHANGE ) );
		}
		
		public function get disabledMode () : uint { return _fontList.disabledMode;	}
		public function set disabledMode (b : uint) : void
		{
			_fontList.disabledMode = b;
		}
		
		public function get disabledValue () : * {}
		public function set disabledValue (v : *) : void
		{
		}
	}
}

import aesia.com.ponents.core.AbstractComponent;
import aesia.com.ponents.layouts.display.DOStretchLayout;

import flash.text.TextField;

[Skinable(skin="EmptyComponent")]
internal class PreviewLabel extends AbstractComponent
{
	protected var _textField : TextField;
	protected var _childrenLayout : DOStretchLayout;

	public function PreviewLabel () 
	{
		_textField = new TextField();
		_textField.selectable = false;
		_allowOver = _allowPressed = _allowSelected = _allowMask = _allowFocus = false;
		
		super( );
		addComponentChild( _textField );
		_childrenLayout = new DOStretchLayout( _childrenContainer, _textField );
	}

	override public function invalidatePreferredSizeCache () : void 
	{
		_preferredSizeCache = _childrenLayout.preferredSize;
		super.invalidatePreferredSizeCache();
	}

	override public function repaint () : void 
	{
		super.repaint( );
		_childrenLayout.layout(calculateComponentSize( ), _style.insets );
	}

	public function get textField () : TextField {
		return _textField;
	}
}
