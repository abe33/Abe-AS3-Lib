package abe.com.ponents.tools.canvas.dummies
{
    import abe.com.mon.colors.Color;
    import abe.com.mon.geom.Dimension;
    import abe.com.mon.geom.dm;
    import abe.com.mon.utils.StageUtils;

    import flash.filters.DropShadowFilter;

    /**
     * @author cedric
     */
    public class SceneDummy extends AbstractDummy
    {
        private var _sceneSize : Dimension;
        private var _color : Color;
        
        public function SceneDummy ( sceneSize : Dimension = null, color : Color = null )
        {
            _sceneSize = sceneSize ? sceneSize : dm(StageUtils.stage.stageWidth, StageUtils.stage.stageHeight );
            _color = color ? color : Color.White;
            init();
        }
		override public function get isMovable () : Boolean { return false; }
        public function get sceneSize () : Dimension { return _sceneSize; }
        public function set sceneSize ( sceneSize : Dimension ) : void {
            _sceneSize = sceneSize;
            draw ();
        }
        override public function clear () : void
        {
            graphics.clear();
            filters = [];
        }
		override public function draw():void
        {
            graphics.clear();
            graphics.beginFill(_color.hexa, _color.alpha/255);
            graphics.drawRect(0, 0, _sceneSize.width, _sceneSize.height );
            graphics.endFill();
            
            filters = [new DropShadowFilter(1, 45, 0, .3, 4, 4,1,3)];
        }
    }
}
