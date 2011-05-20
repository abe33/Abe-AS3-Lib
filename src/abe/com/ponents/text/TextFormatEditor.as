package abe.com.ponents.text 
{
	import abe.com.mon.colors.Color;
	import abe.com.patibility.lang._;
	import abe.com.ponents.buttons.ColorPicker;
	import abe.com.ponents.buttons.ToggleButton;
	import abe.com.ponents.containers.ToolBar;
	import abe.com.ponents.core.*;
	import abe.com.ponents.core.edit.Editable;
	import abe.com.ponents.core.edit.Editor;
	import abe.com.ponents.events.ComponentEvent;
	import abe.com.ponents.forms.FormComponent;
	import abe.com.ponents.layouts.components.BoxSettings;
	import abe.com.ponents.layouts.components.VBoxLayout;
	import abe.com.ponents.menus.FontListComboBox;
	import abe.com.ponents.models.SpinnerNumberModel;
	import abe.com.ponents.skinning.DefaultSkin;
	import abe.com.ponents.skinning.decorations.SimpleFill;
	import abe.com.ponents.spinners.Spinner;
	import abe.com.ponents.utils.Insets;

	import flash.display.DisplayObject;
	import flash.text.Font;
	import flash.text.FontType;
	import flash.text.TextFormat;

    import org.osflash.signals.Signal;
	/**
	 * @author cedric
	 */
	[Event(name="dataChange",type="abe.com.ponents.events.ComponentEvent")]
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
		protected var _boldButton : ToggleButton;
		protected var _italicButton : ToggleButton;
		protected var _colorPicker : ColorPicker;
		protected var _underlineButton : ToggleButton;
		protected var _sizeSpinner : Spinner;
		
		protected var _dataChanged : Signal;
		public function get dataChanged () : Signal { return _dataChanged; }
		
		public function TextFormatEditor ( tf : TextFormat = null )
		{
			super();
			_dataChanged = new Signal();
			_preview = new PreviewLabel();
			_preview.style.setForAllStates("insets", new Insets( 4 ) );
						
			_boldButton = new ToggleButton(_("<b>B</b>") );
			_italicButton = new ToggleButton(_("<i>I</i>") );
			_underlineButton = new ToggleButton(_("<u>U</u>") );
			_sizeSpinner = new Spinner( new SpinnerNumberModel( 12, 1, 500, 1, true ) );
			_colorPicker = new ColorPicker( Color.Black );
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
			
			p.addComponent( _boldButton );
			p.addComponent( _italicButton );
			p.addComponent( _underlineButton );
			p.addSeparator();
			p.addComponent( _colorPicker );
			p.addComponent( _sizeSpinner );
			p.addComponent( _fontList );
			
			_boldButton.styleKey = _italicButton.styleKey = _underlineButton.styleKey = _colorPicker.styleKey = "ToolBar_Button";
			
			addComponent( _preview );
			addComponent( p );
			
			childrenLayout = l;
			
			if( tf )
				initEditState( null, tf );
		}
		
		protected function colorDataChanged ( c : Component, v : * ) : void
		{
			_format.color = _colorPicker.value.hexa;
			updatePreviewFormat();
			fireDataChangedSignal();
		}

		protected function boldDataChanged ( c : Component, v : * ) : void 
		{
			_format.bold = _boldButton.selected;
			updatePreviewFormat();
			fireDataChangedSignal();
		}

		protected function italicDataChanged ( c : Component, v : * ) : void 
		{
			_format.italic = _italicButton.selected;
			updatePreviewFormat();
			fireDataChangedSignal();
		}
		protected function underlineDataChanged ( c : Component, v : * ) : void 
		{
			_format.underline = _underlineButton.selected;
			updatePreviewFormat();
			fireDataChangedSignal();
		}

		protected function sizeDataChanged ( c : Component, v : * ) : void 
		{
			_format.size = _sizeSpinner.value;
			updatePreviewFormat();
			fireDataChangedSignal();
		}
		protected function fontDataChanged ( c : Component, v : * ) : void 
		{
			var f : Font = _fontList.value;
			_format.font = f.fontName;
			_preview.textField.embedFonts = f.fontType == FontType.EMBEDDED;
			updatePreviewFormat();
			fireDataChangedSignal();
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
			_italicButton.selected = Boolean(_format.italic);
			_underlineButton.selected = Boolean(_format.underline );
			_sizeSpinner.value = uint( _format.size );
			_fontList.value = _format.font;
			_colorPicker.value = new Color( 0xff000000 + uint(_format.color) );
			updatePreviewFormat();
			
			registerToSubComponentsEvents();
		}

		protected function unregisterFromSubComponentsEvents () : void 
		{
			_fontList.dataChanged.add( fontDataChanged );
			_sizeSpinner.dataChanged.add( sizeDataChanged );
			_boldButton.dataChanged.add(  boldDataChanged );
			_italicButton.dataChanged.add(italicDataChanged );
			_underlineButton.dataChanged.add( underlineDataChanged );
			_colorPicker.dataChanged.add( colorDataChanged );
			
		}
		protected function registerToSubComponentsEvents () : void 
		{
			_fontList.dataChanged.remove( fontDataChanged );
			_sizeSpinner.dataChanged.remove( sizeDataChanged );
			_boldButton.dataChanged.remove(  boldDataChanged );
			_italicButton.dataChanged.remove(italicDataChanged );
			_underlineButton.dataChanged.remove( underlineDataChanged );
			_colorPicker.dataChanged.remove( colorDataChanged );
			
		}

		protected function updatePreviewFormat () : void 
		{
			_preview.textField.defaultTextFormat = _format;
			_preview.textField.text = _("The quick brown fox jumps over the lazy dog");
			invalidatePreferredSizeCache();
		}
		protected function fireDataChangedSignal () : void 
		{
			_dataChanged.dispatch( this, value );
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

import abe.com.ponents.core.AbstractComponent;
import abe.com.ponents.layouts.display.DOStretchLayout;

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
