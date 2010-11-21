package aesia.com.ponents.lists 
{
	import aesia.com.mon.geom.Dimension;
	import aesia.com.ponents.containers.AbstractScrollContainer;
	import aesia.com.ponents.containers.ScrollPane;
	import aesia.com.ponents.containers.Viewport;
	import aesia.com.ponents.core.Container;
	import aesia.com.ponents.events.ComponentEvent;
	import aesia.com.ponents.events.ListEvent;
	import aesia.com.ponents.events.PropertyEvent;
	import aesia.com.ponents.skinning.cursors.Cursor;

	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 * @author Cédric Néhémie
	 */
	[Skinable(skin="ListLineRuler")]
	[Skin(define="ListLineRuler",
		  inherit="EmptyComponent",
		  preview="aesia.com.ponents.lists::ListLineRuler.defaultListLineRulerPreview",
		  previewAcceptStyleSetup="false",
		  
		  state__all__background="new aesia.com.ponents.skinning.decorations::SimpleFill( color(LightGrey) )",
		  state__all__insets="new aesia.com.ponents.utils::Insets(3,0,3,0)"
	)]
	public class ListLineRuler extends List 
	{
		/*FDT_IGNORE*/ FEATURES::BUILDER { /*FDT_IGNORE*/
		static public function defaultListLineRulerPreview () : ScrollPane
		{
			var scp : ScrollPane = new ScrollPane();
			scp.view = List.defaultListPreview();
			scp.rowHead = new ListLineRuler(scp.view as List);
			
			return scp;
		}
		/*FDT_IGNORE*/ } /*FDT_IGNORE*/
		
		protected var _list : List;
		protected var _lastY : Number;
		protected var _dragging : Boolean;
		protected var _indexStartAt0 : Boolean;
		
		public function ListLineRuler ( list : List, indexStartAt0 : Boolean = false )
		{
			_listCellClass = ListLineRulerCell;
			_list = list;
			_indexStartAt0 = indexStartAt0;
			_modelHasChanged = true;
			super( new ListLineRulerModel() );
			_list.model.addEventListener(ComponentEvent.DATA_CHANGE, listDataChanged, false, 0, true );			_list.addEventListener(ComponentEvent.MODEL_CHANGE, listModelChanged );			_list.addEventListener(PropertyEvent.PROPERTY_CHANGE, listPropertyChanged );
			editEnabled = false;
			listDataChanged(null);
			listLayout.fixedHeight = true;
			
			addEventListener( MouseEvent.MOUSE_WHEEL, mouseWheel );
			
			/*FDT_IGNORE*/ FEATURES::CURSOR { /*FDT_IGNORE*/
			cursor = Cursor.get( Cursor.DRAG_V );
			/*FDT_IGNORE*/ } /*FDT_IGNORE*/
			
			/*FDT_IGNORE*/ FEATURES::DND { /*FDT_IGNORE*/
			dndEnabled = false;				
			/*FDT_IGNORE*/ } /*FDT_IGNORE*/
			
			mouseChildren = false;
		}
		
		protected function listPropertyChanged (event : PropertyEvent) : void
		{
			if( event.propertyName == "listCellClass" )
			{
				//this.listLayout.lastPreferredCellHeight = _list.listLayout.lastPreferredCellHeight;
				this.listLayout.clearEstimatedSize();
				invalidate(true);
			}
		}

		override public function addedToStage (e : Event) : void
		{
			super.addedToStage( e );
			var p : Container = parentContainer;
			if( p is Viewport )
				p.parentContainer.addEventListener( ComponentEvent.COMPONENT_RESIZE, resize );		}

		override public function removeFromStage (e : Event) : void
		{
			var p : Container = parentContainer;
			if( p is Viewport )
				p.parentContainer.removeEventListener( ComponentEvent.COMPONENT_RESIZE, resize );
			super.removeFromStage( e );
		}

		private function resize (event : Event) : void
		{
			invalidatePreferredSizeCache();
		}

		protected function mouseWheel ( e : MouseEvent ) : void
		{
			var p : Container = parentContainer;
			if( p && p is Viewport )
			{
				var pp : AbstractScrollContainer = parentContainer.parentContainer as AbstractScrollContainer;
				
				if( e.delta > 0 )
					pp.scrollUp();
				else
					pp.scrollDown();
			}
		}

		override public function mouseDown (e : MouseEvent) : void
		{
			super.mouseDown( e );
			var p : Container = parentContainer;
			if( p && p is Viewport )
			{
				_dragging = true;
				_lastY = stage.mouseY;
				stage.addEventListener( MouseEvent.MOUSE_MOVE, stageMouseMove );
			}
		}

		override public function mouseUp (e : MouseEvent) : void
		{
			super.mouseUp( e );
			_dragging = false;
			if( stage )
				stage.removeEventListener( MouseEvent.MOUSE_MOVE, stageMouseMove );
		}

		public function stageMouseMove (e : MouseEvent) : void
		{
			super.mouseMove( e );
			if( _dragging )
			{
				var p : AbstractScrollContainer = parentContainer.parentContainer as AbstractScrollContainer;
				
				var y : Number = stage.mouseY;
				p.scrollV -= y - _lastY;
				_lastY = y;
			}
		}

		override public function releaseOutside (e : MouseEvent = null) : void
		{
			_dragging = false;
			if( stage )
				stage.removeEventListener( MouseEvent.MOUSE_MOVE, stageMouseMove );
		}
		private function listDataChanged (event : ListEvent) : void
		{
			removeAllComponents();
			( _model as ListLineRulerModel ).size = _list.model.size;
			_list.model.addEventListener( ComponentEvent.DATA_CHANGE, listDataChanged, false, 0, true );
			invalidatePreferredSizeCache();
			dataChanged(event);
			//( _model as ListLineRulerModel ).size = _list.model.size;
		}
		
		protected function listModelChanged (event : ComponentEvent) : void 
		{
			( _model as ListLineRulerModel ).size = _list.model.size;
			_list.model.addEventListener( ComponentEvent.DATA_CHANGE, listDataChanged, false, 0, true );
			invalidatePreferredSizeCache();
		}
		
		override public function invalidatePreferredSizeCache () : void
		{
			super.invalidatePreferredSizeCache();
			
			if( !_model || _model.size == 0 )
				_preferredSizeCache = new Dimension();
			
			if( _model && _model.size > 0 && _preferredSizeCache )
				_preferredSizeCache.width = getItemPreferredSize( 0 ).width + _style.insets.horizontal;
			
			var p : Container = parentContainer;
			if( p && p is Viewport && p.parentContainer.height > _preferredSizeCache.height )
				_preferredSizeCache.height = p.parentContainer.height;
		}

		override public function get tracksViewportV () : Boolean
		{
			return true;
		}

		override protected function getCell (itemIndex : int = 0, childIndex : int = 0) : ListCell
		{
			var c : ListLineRulerCell = super.getCell( itemIndex, childIndex ) as ListLineRulerCell;
			
			if( c )
				c.indexStartAt0 = _indexStartAt0;
			
			return c;
		}

		public function get indexStartAt0 () : Boolean { return _indexStartAt0; }	
		public function set indexStartAt0 (indexStartAt0 : Boolean) : void
		{
			_indexStartAt0 = indexStartAt0;
			var l : uint = _children.length;
			for( var i : int = 0;i<l;i++)
			{
				( _children[i] as ListLineRulerCell ).indexStartAt0 = indexStartAt0;
			}
		}
		
		public function get list () : List {
			return _list;
		}
		
		public function set list (list : List) : void
		{
			_list = list;
		}
	}
}

import aesia.com.ponents.models.DefaultListModel;

internal class ListLineRulerModel extends DefaultListModel
{
	protected var _size : uint;
	
	override public function get size () : uint { return _size; }	
	public function set size (size : uint) : void
	{
		_size = size;
	}	
}



