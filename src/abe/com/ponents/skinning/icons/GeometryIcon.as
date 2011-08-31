package abe.com.ponents.skinning.icons
{
    import abe.com.mon.geom.Dimension;
    import abe.com.mon.geom.Geometry;

    import flash.display.Graphics;
    import flash.display.Shape;

    /**
     * @author cedric
     */
    [Skinable(skin="GeometryIcon")]
	[Skin(define="GeometryIcon",
			  inherit="EmptyComponent",
              state__all__background="color(White)",
			  state__all__foreground="skin.borderColor",
              custom_geometryColor="color(Black)"
	)]
    public class GeometryIcon extends Icon
    {
        protected var _geometry : Geometry;
        protected var _sceneSize : Dimension;
        protected var _geomShape : Shape;
        
        public function GeometryIcon ( geometry : Geometry, sceneSize : Dimension = null )
        {
            super ();
            _contentType = "Geometry";
			_allowFocus = false;
			_allowFocusTraversing = false;
            
            _geometry = geometry;
            _sceneSize = sceneSize;
            _geomShape = new Shape();
            _integerForSpatialInformations = true;
            
            addComponentChild(_geomShape);
            invalidatePreferredSizeCache();
        }
        public function get geometry () : Geometry { return _geometry; }
        public function set geometry ( geometry : Geometry ) : void { _geometry = geometry; }
        
        override public function init () : void
		{
			super.init();
			repaint();
        }

        override public function repaint () : void
        {
            super.repaint ();
            var g : Graphics = _geomShape.graphics;
            g.clear();
            if( _sceneSize )
            {
	            g.beginFill( 0,0 );
				g.drawRect( 0,0,_sceneSize.width, _sceneSize.height );
				g.endFill();
            }
            _geometry.fill(g, _style.geometryColor.alphaClone(0x66));
            _geometry.draw(g, _style.geometryColor);
            
            _geomShape.width = width;
            _geomShape.height = height;
        }
        
        override public function invalidatePreferredSizeCache () : void
		{
            if( _sceneSize )
            {
                var ratio : Number = _sceneSize.width / _sceneSize.height;
                
                if( ratio > 1 )
                	_preferredSizeCache = new Dimension(40,40/ratio);
                else
                	_preferredSizeCache = new Dimension(40*ratio,40);
            }
            else
				_preferredSizeCache = new Dimension(40,40);
			invalidate( false );
		}

		override public function clone () : *
		{
			return new GeometryIcon( _geometry, _sceneSize );
		}
    }
}
