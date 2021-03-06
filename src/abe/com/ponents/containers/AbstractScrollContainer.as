package abe.com.ponents.containers 
{
    import abe.com.mon.geom.Dimension;
    import abe.com.ponents.core.*;
    import abe.com.ponents.models.BoundedRangeModel;
    import abe.com.ponents.models.DefaultBoundedRangeModel;

    import org.osflash.signals.Signal;

    import flash.geom.Rectangle;

    /**
     * @author Cédric Néhémie
     */
    public class AbstractScrollContainer extends AbstractContainer
    {
        protected var _viewport : Viewport;
        
        protected var _hmodel : BoundedRangeModel;
        protected var _vmodel : BoundedRangeModel;
        protected var _isAlwaysValidateRoot : Boolean;
        
        public var scrolled : Signal;

        public function AbstractScrollContainer ()
        {
            scrolled = new Signal();
            _viewport = new Viewport();
            _hmodel = new DefaultBoundedRangeModel(0,0,0,0);
            _vmodel = new DefaultBoundedRangeModel(0,0,0,0);
            _isAlwaysValidateRoot = true;
            super();
            _hmodel.dataChanged.add( hscrollOccured );
            _vmodel.dataChanged.add( vscrollOccured );
            
            addComponent(viewport);
        }
        public function get viewport () : Viewport { return _viewport; }
        public function get view () : Component { return _viewport.view; }
        public function set view ( v : Component ) : void 
        { 
            if( _viewport.view )
            {
                _viewport.view.componentResized.remove( onComponentResized );
                _viewport.mouseWheelRolled.add( viewportMouseWheelRolled );
                _viewport.view.mouseWheelRolled.add( viewportMouseWheelRolled );
            }
            
            _viewport.view = v;
            
            if( _viewport.view )
            {
                _viewport.view.componentResized.add( onComponentResized );
                _viewport.mouseWheelRolled.add( viewportMouseWheelRolled );
                _viewport.view.mouseWheelRolled.add( viewportMouseWheelRolled );
            }
            invalidatePreferredSizeCache();
        }
        public function viewportMouseWheelRolled ( c : Component, d: Number ) : void {}
        override public function ensureRectIsVisible (r : Rectangle) : Component
        {
            if( r.y < _vmodel.value )
                _vmodel.value = r.y;
            else if( r.y + r.height > _vmodel.value + _vmodel.extent )
                _vmodel.value = r.y + r.height - _vmodel.extent ;
                
            if( r.x < _hmodel.value )
                _hmodel.value = r.x;
            else if( r.x + r.width > _hmodel.value + _hmodel.extent )
                _hmodel.value = r.x + r.width - _hmodel.extent;
            
            return this;
        }

        override public function set size (d : Dimension) : void
        {
            super.size = d;
            updateModelsAfterResize();
        }

        public function get scrollPolicy () : String { return null; }        
        public function set scrollPolicy (policy : String) : void {}
        
        public function scrollUp () : void
        {
            scrollV += _viewport.getUnitIncrementV ( -1 );
        }
        public function scrollDown () : void
        {
            scrollV += _viewport.getUnitIncrementV ( 1 );
        }
        public function scrollLeft () : void
        {
            scrollH += _viewport.getUnitIncrementH ( -1 );
        }
        public function scrollRight () : void
        {
            scrollH += _viewport.getUnitIncrementH ( 1 );
        }
        public function get scrollV () : Number { return _vmodel.value; }
        public function set scrollV ( scroll : Number ) : void 
        {
            if( _vmodel.value != scroll )
            {
                _vmodel.value = scroll;
                
                if( !canScrollV )
                    _vmodel.value = _vmodel.minimum;
            }
        }
        public function get maxScrollV () : Number 
        {
            return _vmodel.maximum;
        }
        public function get minScrollV () : Number 
        {
            return _vmodel.minimum;
        }
        public function get canScrollV () : Boolean
        {
            return _vmodel.maximum > _vmodel.minimum;
        }
        
        public function get contentSize () : Dimension
        {
            var d : Dimension = new Dimension(width, height);
            return d;
        }
        
        public function get scrollH () : Number { return _hmodel.value; }
        public function set scrollH ( scroll : Number ) : void 
        {
            if( _hmodel.value != scroll )
            {
                _hmodel.value = scroll;
                if( !canScrollH )
                    _hmodel.value = _hmodel.minimum;
            }
        }
        public function get maxScrollH () : Number 
        {
            return _hmodel.maximum;
        }
        public function get minScrollH () : Number 
        {
            return _hmodel.minimum;
        }
        public function get canScrollH () : Boolean
        {
            return _hmodel.maximum > _hmodel.minimum;
        }
        
        protected function hscrollOccured ( model : BoundedRangeModel, v : * ) : void
        {
            if( _viewport.view )
            {
                _viewport.view.x = -_hmodel.value;
                fireScrolledSignal ();
            }
        }
        protected function vscrollOccured ( model : BoundedRangeModel, v : * ) : void
        {
            if( _viewport.view )
            {
                _viewport.view.y = -_vmodel.value;
                fireScrolledSignal ();
            }
        }

        override public function repaint () : void
        {
            super.repaint();
            updateModelsAfterResize();
        }

        override public function invalidatePreferredSizeCache () : void
        {
            _preferredSizeCache = _viewport && _viewport.view ? _viewport.view.preferredSize : new Dimension(100,100);
            updateModelsAfterResize();
        }

        protected function updateModelsAfterResize () : void
        {
            if( _viewport.view )
            {
                _vmodel.maximum = Math.max( 0, _viewport.view.preferredSize.height - _viewport.height );
                _vmodel.extent = _viewport.height;
                _vmodel.minimum = 0;
                
                _hmodel.maximum = Math.max( 0, _viewport.view.preferredSize.width - _viewport.width );
                _hmodel.extent = _viewport.width;
                _hmodel.minimum = 0;
                
                if( !canScrollV )
                {
                    _vmodel.value = _vmodel.minimum;
                    vscrollOccured( _vmodel, _vmodel.value );
                }
            
                if( !canScrollH )
                {
                    _hmodel.value = _hmodel.minimum;
                    hscrollOccured( _hmodel, _hmodel.value);
                }
            }
            invalidate();
        }
        protected function onComponentResized ( c : Component, d : Dimension ) : void
        {
            updateModelsAfterResize();
        }
        override public function isValidateRoot () : Boolean
        {
            return _isAlwaysValidateRoot || _validateRoot;
        }
        protected function fireScrolledSignal () : void
        {
            scrolled.dispatch( this );
        }
        public function get isAlwaysValidateRoot () : Boolean
        {
            return _isAlwaysValidateRoot;
        }
        public function set isAlwaysValidateRoot (isAlwaysValidateRoot : Boolean) : void
        {
            _isAlwaysValidateRoot = isAlwaysValidateRoot;
        }
    }
}
