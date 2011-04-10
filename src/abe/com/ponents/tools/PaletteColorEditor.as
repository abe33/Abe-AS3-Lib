package abe.com.ponents.tools 
{
	import abe.com.mon.colors.Color;
	import abe.com.mon.colors.Palette;
	import abe.com.patibility.lang._;
	import abe.com.ponents.buttons.Button;
	import abe.com.ponents.buttons.ButtonDisplayModes;
	import abe.com.ponents.containers.Panel;
	import abe.com.ponents.containers.ScrollPane;
	import abe.com.ponents.containers.SplitPane;
	import abe.com.ponents.containers.ToolBar;
	import abe.com.ponents.events.ComponentEvent;
	import abe.com.ponents.layouts.components.BorderLayout;
	import abe.com.ponents.lists.ColorListCell;
	import abe.com.ponents.lists.List;
	import abe.com.ponents.lists.PaletteListCell;
	import abe.com.ponents.models.DefaultListModel;
	import abe.com.ponents.skinning.icons.magicIconBuild;

	/**
	 * @author cedric
	 */
	[Event(name="dataChange",type="abe.com.ponents.events.ComponentEvent")]
	[Skinable(skin="PaletteColorEditor")]
	[Skin(define="PaletteColorEditor",
			  inherit="EmptyComponent",
			  state__all__insets="new cutils::Insets(5)"
	)]
	public class PaletteColorEditor extends Panel 
	{
		[Embed(source="../skinning/icons/color_swatch_add.png")]
		static private var PALETTE_ADD : Class;
		
		[Embed(source="../skinning/icons/color_swatch_delete.png")]
		static private var PALETTE_DELETE : Class;
		
		protected var _target : Color;
		protected var _paletteList : List;
		protected var _colorList : List;

		public function PaletteColorEditor ()
		{
			var l : BorderLayout = new BorderLayout( this );
			_childrenLayout = l;
			super();
			
			_paletteList = new List( PaletteListModelInstance );
			_paletteList.listCellClass = PaletteListCell;
			_paletteList.dndEnabled = false;
			_paletteList.editEnabled = false;			_paletteList.allowMultiSelection = false;			_paletteList.loseSelectionOnFocusOut = false;
			_paletteList.addEventListener(ComponentEvent.SELECTION_CHANGE, paletteSelectionChange );
			
			_colorList = new List();
			_colorList.dndEnabled = false;
			_colorList.allowMultiSelection = false;
			_colorList.editEnabled = false;
			_colorList.listCellClass = ColorListCell;
			_colorList.addEventListener(ComponentEvent.SELECTION_CHANGE, colorSelectionChange );
			
			var scpPalette : ScrollPane = new ScrollPane();
			scpPalette.view = _paletteList;
			
			var scpColor : ScrollPane = new ScrollPane();
			scpColor.view = _colorList;

			var split : SplitPane = new SplitPane ( SplitPane.VERTICAL_SPLIT, scpPalette, scpColor );
			split.oneTouchExpandFirstComponent = false;
			split.preferredHeight = 200;

			var paletteBar : ToolBar = new ToolBar(ButtonDisplayModes.ICON_ONLY, false );
			paletteBar.addComponent( 
					new Button( new OpenACOFile(  _paletteList, 
												  _("Open Palette File"), 
												  magicIconBuild(PALETTE_ADD), 
												  _("Load a color palette file (*.aco,*.gpl)\nfrom your hard disk and add it into\nthe palette list."))));

			l.north = paletteBar;
			l.center = split;
			addComponent( paletteBar );			addComponent( split );
		}
		protected function colorSelectionChange (event : ComponentEvent) : void 
		{
			var c : Color = _colorList.selectedValue as Color;
			if( c )
			{
				_target.red = c.red;
				_target.green = c.green;
				_target.blue = c.blue;
				_target.alpha = c.alpha;
				fireDataChange();
			}
		}
		protected function paletteSelectionChange (event : ComponentEvent) : void 
		{
			if( _paletteList.selectedValue )
				_colorList.model = new DefaultListModel( (_paletteList.selectedValue as Palette).colors );
		}

		public function get target () : Color { return _target; }	
		public function set target (target : Color) : void
		{
			_target = target;
		}
		
		protected function fireDataChange () : void 
		{
			dispatchEvent(new ComponentEvent(ComponentEvent.DATA_CHANGE));
		}
	}
}

import abe.com.mon.colors.Color;
import abe.com.mon.utils.KeyStroke;
import abe.com.mon.colors.Palette;
import abe.com.patibility.codecs.ACOCodec;
import abe.com.patibility.codecs.GPLCodec;
import abe.com.patibility.lang._;
import abe.com.ponents.actions.builtin.LoadFileAction;
import abe.com.ponents.lists.List;
import abe.com.ponents.models.DefaultListModel;
import abe.com.ponents.skinning.icons.Icon;

import flash.events.Event;
import flash.net.FileFilter;

internal class OpenACOFile extends LoadFileAction
{
	protected var _list : List;
	
	static private const map : Object = {
										aco:new ACOCodec(),
										gpl:new GPLCodec()
										};
	
	public function OpenACOFile ( list : List, name : String, icon : Icon = null, longDescription : String = null, accelerator : KeyStroke = null )
	{
		var filter : FileFilter = new FileFilter( _("Color Palette Files (*.aco, *.gpl)"), "*.aco;*.gpl" );
		super( name, icon, [filter], longDescription, accelerator );
		this._list = list;
	}
	override protected function complete (event : Event) : void 
	{
		var a : Array = _fileReference.name.split(".");
		var key : String = a[a.length-1];
		var palette : Palette = map[ key ].decode( _fileReference["data"] );
		
		if( !_list.model.toArray().some( 
			function ( p : Palette, ...args) : Boolean
			{
				return p.equals( palette );
			}))
		{
			_list.model.addElement( palette );
		}
		fireCommandEnd();
	}
}
internal var PaletteListModelInstance : DefaultListModel = new DefaultListModel();

PaletteListModelInstance.contentType = Palette;
PaletteListModelInstance.addElement( Color.PALETTE_SVG );	