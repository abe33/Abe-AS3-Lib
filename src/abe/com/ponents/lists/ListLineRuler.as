package abe.com.ponents.lists 
{
    import abe.com.mon.geom.*;
    import abe.com.ponents.containers.*;
    import abe.com.ponents.core.*;
    import abe.com.ponents.skinning.cursors.Cursor;

    import flash.events.*;

    /**
     * @author Cédric Néhémie
     */
    [Skinable(skin="ListLineRuler")]
    [Skin(define="ListLineRuler",
          inherit="EmptyComponent",
          preview="abe.com.ponents.lists::ListLineRuler.defaultListLineRulerPreview",
          previewAcceptStyleSetup="false",
          
          state__all__background="skin.rulerBackgroundColor",
          state__all__insets="new cutils::Insets(0)"
    )]
    public class ListLineRuler extends List 
    {	
        FEATURES::BUILDER { 
        static public function defaultListLineRulerPreview () : ScrollPane
        {
            var scp : ScrollPane = new ScrollPane();
            scp.view = List.defaultListPreview();
            scp.rowHead = new ListLineRuler(scp.view as List);
            
            return scp;
        }
        } 
        
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
            
            _list.model.dataChanged.addOnce( listDataChanged );
            _list.modelChanged.add(listModelChanged );
            _list.propertyChanged.add( listPropertyChanged );
            
            editEnabled = false;
            listDataChanged();
            listLayout.fixedHeight = true;
            
            FEATURES::CURSOR { 
                cursor = Cursor.get( Cursor.DRAG_V );
            } 
            
            FEATURES::DND { 
                dndEnabled = false;                
            } 
            
            mouseChildren = false;
        }
        
        protected function listPropertyChanged ( propertyName : String, propertyValue : * ) : void
        {
            if( propertyName )
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
                p.parentContainer.componentResized.add( parentResized );
        }

        override public function removeFromStage (e : Event) : void
        {
            var p : Container = parentContainer;
            if( p is Viewport )
                p.parentContainer.componentResized.remove( parentResized );
            super.removeFromStage( e );
        }

        private function parentResized ( p : Component, d : Dimension ) : void
        {
            invalidatePreferredSizeCache();
        }

        override public function mouseWheel ( e : MouseEvent ) : void
        {
            super.mouseWheel( e );
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

        override public function releaseOutside ( context : UserActionContext ) : void
        {
            _dragging = false;
            if( stage )
                stage.removeEventListener( MouseEvent.MOUSE_MOVE, stageMouseMove );
        }
        private function listDataChanged ( action : uint = 0, indices : Array = null, values : Array = null ) : void
        {
            removeAllComponents();
            ( _model as ListLineRulerModel ).size = _list.model.size;
            _list.model.dataChanged.addOnce( listDataChanged );
            invalidatePreferredSizeCache();
        }
        
        protected function listModelChanged ( ... args ) : void 
        {
            ( _model as ListLineRulerModel ).size = _list.model.size;
            _list.model.dataChanged.addOnce( listDataChanged );
            invalidatePreferredSizeCache();
            listDataChanged();
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
            {
                c.indexStartAt0 = _indexStartAt0;
            }
            
            return c;
        }

        public function get indexStartAt0 () : Boolean { return _indexStartAt0; }    
        public function set indexStartAt0 (indexStartAt0 : Boolean) : void
        {
            _indexStartAt0 = indexStartAt0;
            var l : uint = _children.length;
            for( var i : int = 0;i< l;i++)
            {
                ( _children[i] as ListLineRulerCell ).indexStartAt0 = indexStartAt0;
            }
        }
        
        public function get list () : List { return _list; }
        public function set list (list : List) : void { _list = list; }
    }
}
import abe.com.ponents.models.DefaultListModel;

internal class ListLineRulerModel extends DefaultListModel
{
    protected var _size : uint;
    
    override public function get size () : uint { return _size; }    
    public function set size (size : uint) : void
    {
        _size = size;
    }    
}



