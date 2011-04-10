package abe.com.ponents.tools
{
	import abe.com.mon.geom.Dimension;
	import abe.com.mon.colors.Color;
	import abe.com.mon.utils.Reflection;
	import abe.com.mon.utils.magicClone;
	import abe.com.patibility.lang._;
	import abe.com.ponents.allocators.EmbeddedBitmapAllocatorInstance;
	import abe.com.ponents.buttons.ButtonDisplayModes;
	import abe.com.ponents.buttons.ColorPicker;
	import abe.com.ponents.containers.Panel;
	import abe.com.ponents.containers.ScrollPane;
	import abe.com.ponents.containers.ToolBar;
	import abe.com.ponents.core.AbstractContainer;
	import abe.com.ponents.core.Component;
	import abe.com.ponents.events.ComponentEvent;
	import abe.com.ponents.forms.FormObject;
	import abe.com.ponents.forms.FormUtils;
	import abe.com.ponents.forms.managers.SimpleFormManager;
	import abe.com.ponents.forms.renderers.FieldSetFormRenderer;
	import abe.com.ponents.layouts.components.BorderLayout;
	import abe.com.ponents.layouts.components.InlineLayout;
	import abe.com.ponents.lists.ListEditor;
	import abe.com.ponents.menus.ComboBox;
	import abe.com.ponents.skinning.decorations.SimpleFill;
	import abe.com.ponents.text.Label;
	import abe.com.ponents.utils.Insets;

	import flash.display.Bitmap;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.filters.BevelFilter;
	import flash.filters.BitmapFilter;
	import flash.filters.BlurFilter;
	import flash.filters.ColorMatrixFilter;
	import flash.filters.ConvolutionFilter;
	import flash.filters.DisplacementMapFilter;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.filters.GradientBevelFilter;
	import flash.filters.GradientGlowFilter;
	import flash.text.TextField;
	import flash.text.TextFormat;
	/**
	 * @author cedric
	 */
	public class FilterEditorPane extends AbstractContainer
	{
		[Embed(source="../skinning/icons/flash-100x100.png")]
		private var flash : Class;

		protected var _listEdit : ListEditor;
		protected var _formPanel : Panel;
		protected var _previewShape : FilterPreview;
		protected var _simpleManager : SimpleFormManager;
		protected var _scrollPane : ScrollPane;
		protected var _previewToolBar : ToolBar;
		protected var _previewShapeCombo : ComboBox;
		protected var _previewColor : ColorPicker;
		protected var _previewBgColor : ColorPicker;

		public function FilterEditorPane ()
		{
			super();
			var l : BorderLayout = new BorderLayout(this);
			childrenLayout = l;

			_listEdit = new ListEditor();

			var combo : ComboBox =  new ComboBox(
													 new DropShadowFilter(),
													 new GlowFilter(),
													 new BlurFilter(),
													 new ConvolutionFilter(),
													 new BevelFilter(),
													 new ColorMatrixFilter(),
													 new DisplacementMapFilter(),
													 new GradientBevelFilter(4,45,[0x000000,0xffffff],[1,1],[0,255]),
													 new GradientGlowFilter(4,45,[0x000000,0xffffff],[1,1],[0,255])
												);
			combo.preferredWidth = 150;
			_listEdit.value = [];
			_listEdit.newValueProvider = combo;
			_listEdit.contentType = BitmapFilter;
			_listEdit.list.editEnabled = false;
			_listEdit.list.allowMultiSelection = false;
			_listEdit.list.loseSelectionOnFocusOut = false;
			_listEdit.list.itemFormatingFunction = combo.itemFormatingFunction = Reflection.getClassName;

			_listEdit.list.addEventListener(ComponentEvent.SELECTION_CHANGE, listSelectionChange );
			_listEdit.list.addEventListener(Event.CHANGE, formChange);


			_scrollPane = new ScrollPane();
			_formPanel = new Panel();
			_formPanel.childrenLayout = new InlineLayout(_formPanel, 0, "left", "top" );
			_formPanel.style.setForAllStates("insets", new Insets(5));
			_scrollPane.preferredSize = new Dimension(300, 350);
			_scrollPane.view = _formPanel;

			_previewToolBar = new ToolBar( ButtonDisplayModes.ICON_ONLY );
			_previewToolBar.childrenLayout = new InlineLayout( _previewToolBar, 3, "left", "center", "leftToRight", false );
			_previewToolBar.dndEnabled = false;
			_previewShape = new FilterPreview();
			_previewShape.preferredHeight = 120;

			_previewShapeCombo =  new ComboBox( "Circle", "Square", "Text", "Bitmap" );
			_previewShapeCombo.addEventListener(ComponentEvent.DATA_CHANGE, shapeComboDataChange );

			_previewColor = new ColorPicker(Color.Red.clone() );
			_previewColor.addEventListener(ComponentEvent.DATA_CHANGE, colorDataChange);

			_previewBgColor = new ColorPicker(Color.White.clone() );
			_previewBgColor.addEventListener(ComponentEvent.DATA_CHANGE, bgcolorDataChange);

			_previewToolBar.addComponent( new Label(_("Preview :")) );			_previewToolBar.addComponent( _previewShapeCombo );			_previewToolBar.addComponent( _previewColor );			_previewToolBar.addSeparator();
			_previewToolBar.addComponent( new Label(_("Background :")) );
			_previewToolBar.addComponent( _previewBgColor );
			var prevPanel : Panel = new Panel();
			var prevL : BorderLayout = new BorderLayout( prevPanel, true );

			prevPanel.childrenLayout = prevL;

			prevL.north = _previewToolBar;
			prevL.center = _previewShape;

			prevPanel.addComponents( _previewToolBar, _previewShape );

			l.west = _listEdit;
			l.south = prevPanel;
			l.center = _scrollPane;

			addComponent( _listEdit );
			addComponent( prevPanel );
			addComponent( _scrollPane );

			_simpleManager = new SimpleFormManager();
			_simpleManager.addEventListener(Event.CHANGE, formChange );

			_previewShapeCombo.model.selectedElement = "Bitmap";
		}

		protected function bgcolorDataChange (event : ComponentEvent) : void
		{
			_previewShape.style.setForAllStates("background", new SimpleFill( _previewBgColor.value as Color ) );
		}

		protected function colorDataChange (event : ComponentEvent) : void
		{
			updateShape();
		}
		protected function shapeComboDataChange (event : ComponentEvent) : void
		{
			updateShape();
		}

		protected function updateShape () : void
		{
			var c : uint = _previewColor.value.hexa;
			var s : Shape;
			switch( _previewShapeCombo.value )
			{
				case "Circle" :
					s = new Shape();
					s.graphics.beginFill(c);
					s.graphics.drawCircle(0, 0, 50);
					s.graphics.endFill();
					_previewShape.shape = s;
					break;
				case "Square" :
					s = new Shape();
					s.graphics.beginFill(c);
					s.graphics.drawRect(0, 0, 100,100);
					s.graphics.endFill();
					_previewShape.shape = s;
					break;
				case "Bitmap" :
					var b : Bitmap = EmbeddedBitmapAllocatorInstance.get(flash);
					_previewShape.shape = b;
					break;
				case "Text" :
				default :
					var txt : TextField = new TextField();
					txt.defaultTextFormat = new TextFormat("Verdana", 40, c);
					txt.selectable = false;
					txt.autoSize = "left";
					txt.text = "Sample";
					_previewShape.shape = txt;
					break;
			}
		}

		public function get value () : Array { return _listEdit.value; }		public function set value ( a : Array ) : void
		{
			if( _listEdit.list.selectedIndex != -1 )
				_listEdit.list.clearSelection();

			_listEdit.value = a;
		}

		protected function formChange (event : Event) : void
		{
			_previewShape.shape.filters = magicClone( _listEdit.value );
		}

		protected function listSelectionChange (event : ComponentEvent) : void
		{
			if( _formPanel.hasChildren )
			{
				_formPanel.removeAllComponents();
			}

			var filter : BitmapFilter = _listEdit.list.selectedValue as BitmapFilter;

			if( filter )
			{
				var fo : FormObject = FormUtils.createFormForPublicMembers( filter );

				fo.fields.sortOn("memberName");
				_simpleManager.formObject = fo;

				var p : Component = FieldSetFormRenderer.instance.render( fo );

				_formPanel.addComponent( p );
				_scrollPane.invalidate();
			}
		}
		override public function removeFromStage (e : Event) : void
		{
			super.removeFromStage( e );
			_listEdit.list.clearSelection();
		}
	}
}

import abe.com.mon.geom.Dimension;
import abe.com.mon.colors.Color;
import abe.com.ponents.core.AbstractComponent;
import abe.com.ponents.layouts.display.DOInlineLayout;
import abe.com.ponents.layouts.display.DisplayObjectLayout;

import flash.display.DisplayObject;
import flash.display.Shape;

[Skinable(skin="FilterPreview")]
[Skin(define="FilterPreview",
		  inherit="DefaultComponent",

		  state__all__insets="new abe.com.ponents.utils::Insets(20)",
		  state__all__background="new abe.com.ponents.skinning.decorations::SimpleFill(color(White))"
)]
internal class FilterPreview extends AbstractComponent
{
	protected var _shape : DisplayObject;
	protected var _childrenLayout : DisplayObjectLayout;
	public function FilterPreview ()
	{
		super();
		var s : Shape = new Shape();
		_shape = s;
		_childrenLayout = new DOInlineLayout( _childrenContainer );
		_childrenContainer.addChild(_shape );
		_allowMask = false;
		_allowFocus = false;
		_allowOver = false;
		_allowPressed = false;

		s.graphics.beginFill(Color.Red.hexa );
		s.graphics.drawCircle(0, 0, 50 );
		s.graphics.endFill();

		invalidatePreferredSizeCache();
	}

	override public function invalidatePreferredSizeCache () : void
	{
		_preferredSizeCache = _childrenLayout.preferredSize.grow(_style.insets.horizontal, _style.insets.vertical );
		super.invalidatePreferredSizeCache( );
	}

	override protected function _repaint (size : Dimension, forceClear : Boolean = true ) : void
	{
		super._repaint( size, forceClear );
		_childrenLayout.layout( size, _style.insets );
	}

	public function get shape () : DisplayObject { return _shape;}	public function set shape ( d : DisplayObject ) : void
	{
		var f : Array;
		if( _shape )
		{
			f = _shape.filters;
			_childrenContainer.removeChild( _shape );
		}
		_shape = d;
		if( _shape )
		{
			_shape.filters = f;
			_childrenContainer.addChild( _shape );
			invalidatePreferredSizeCache();
		}
	}
}

