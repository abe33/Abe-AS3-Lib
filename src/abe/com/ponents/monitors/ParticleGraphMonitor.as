package abe.com.ponents.monitors
{
    import abe.com.edia.particles.core.ParticleManagerInstance;
    import abe.com.edia.particles.recorders.EmissionsRecorder;
    import abe.com.edia.particles.recorders.ParticleRecorder;
    import abe.com.mon.colors.Color;
    import abe.com.mon.geom.Range;
    import abe.com.patibility.lang._;
    import abe.com.ponents.containers.Panel;
    import abe.com.ponents.containers.ToolBar;
    import abe.com.ponents.layouts.components.BorderLayout;

    /**
     * @author cedric
     */
    public class ParticleGraphMonitor extends Panel
    {
        [Embed(source="../skinning/icons/components/particles.png")]
        static public var ICON : Class;
        
        protected var _monitor : GraphMonitor;
        protected var _caption : GraphMonitorCaption;
        protected var _rulerLeft : GraphMonitorRuler;
        protected var _rulerRight : GraphMonitorRuler;
        protected var _toolbar : ToolBar;
        public function ParticleGraphMonitor ()
        {
            var l : BorderLayout = new BorderLayout(this);
            _childrenLayout = l;
            
            super();
            
            _monitor = new GraphMonitor();
            
            _monitor.addRecorder( new ParticleRecorder( ParticleManagerInstance, 
            											new Range(0,1000), 
                                                        new GraphCurveSettings( _("Particles"), 
                                                        						Color.Crimson ) ) );
            _monitor.addRecorder( new EmissionsRecorder( ParticleManagerInstance, 
            											new Range(0,100), 
                                                        new GraphCurveSettings( _("Emissions"), 
                                                        						Color.MediumOrchid ) ) );                                                                   
            _caption = new GraphMonitorCaption(_monitor, GraphMonitorCaption.LONG_LABEL_MODE, GraphMonitorCaption.COLUMN_2_LAYOUT_MODE );
            _rulerLeft = new GraphMonitorRuler( _monitor, _monitor.recorders[0], "right" );
            _rulerRight = new GraphMonitorRuler( _monitor, _monitor.recorders[1], "left" );
            
            _toolbar = new ToolBar();
            
            l.north = _toolbar;
            l.center = _monitor;
            l.south = _caption;
            l.west = _rulerLeft;
            l.east = _rulerRight;
            
            addComponents ( _monitor, _toolbar, _caption, _rulerLeft, _rulerRight );
        }

        public function get toolbar () : ToolBar {
            return _toolbar;
        }

        public function get monitor () : GraphMonitor {
            return _monitor;
        }

        public function get caption () : GraphMonitorCaption {
            return _caption;
        }


    }
}
