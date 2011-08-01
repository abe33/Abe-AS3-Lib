package abe.com.ponents.monitors
{
    import abe.com.mon.core.Suspendable;
    import abe.com.mon.geom.Dimension;
    import abe.com.mon.geom.Range;
    import abe.com.mon.logs.Log;
    import abe.com.motion.Impulse;
    import abe.com.motion.ImpulseListener;
    import abe.com.ponents.core.AbstractComponent;
    import abe.com.ponents.monitors.recorders.Recorder;
    import abe.com.ponents.skinning.decorations.GraphMonitorBorder;
    import abe.com.ponents.utils.ContextMenuItemUtils;
    import abe.com.ponents.utils.Insets;

    import flash.display.Graphics;
    import flash.events.ContextMenuEvent;
    import flash.events.Event;
    import flash.ui.ContextMenuItem;
    import flash.utils.Dictionary;
    
    import org.osflash.signals.Signal;

    [Skinable(skin="GraphMonitor")]
    [Skin(define="GraphMonitor",
          inherit="EmptyComponent",

          state__all__foreground="new deco::GraphMonitorBorder( skin.borderColor )",
          state__all__background="skin.containerBackgroundColor"
          )]
    /**
     * @author Cédric Néhémie
     */
    public class GraphMonitor extends AbstractComponent implements ImpulseListener, Suspendable
    {
        static private const SKIN_DEPENDENCIES : Array = [ GraphMonitorBorder ];

        TARGET::FLASH_9
        protected var _recorders : Array;
        TARGET::FLASH_10
        protected var _recorders : Vector.<Recorder>;
        TARGET::FLASH_10_1
        protected var _recorders : Vector.<Recorder>;
        
        protected var _playing : Boolean;
        
        public var recorderAdded : Signal;
        public var recorderRemoved : Signal;

        public function GraphMonitor ()
        {
            recorderAdded = new Signal();
            recorderRemoved = new Signal();
            super();
            TARGET::FLASH_9 { _recorders = []; }
            TARGET::FLASH_10 { _recorders = new Vector.<Recorder>(); }
            TARGET::FLASH_10_1 { _recorders = new Vector.<Recorder>(); }
            
            _playing = true;
            allowMask = false;
            invalidatePreferredSizeCache();

            FEATURES::MENU_CONTEXT { _contextMap = new Dictionary(true); }
        }
        
        TARGET::FLASH_9
        public function get recorders () : Array { return _recorders; }
        TARGET::FLASH_10
        public function get recorders () : Vector.<Recorder> { return _recorders; }
        TARGET::FLASH_10_1
        public function get recorders () : Vector.<Recorder> { return _recorders; }
        
        public function get length () : uint { return _recorders.length; }

        FEATURES::MENU_CONTEXT {
            protected var _contextMap : Dictionary;
            protected function getRecorderForContextMenuItem( c : ContextMenuItem ) : Recorder
            {
                return _contextMap[ c ] as Recorder;
            }
            protected function getContextMenuItemForRecorder( r : Recorder ) : ContextMenuItem
            {
                for ( var i : * in _contextMap )
                {
                    if( _contextMap[ i ] == r )
                        return i;
                }
                return null;
            }
            protected function getContextLabel ( c : Recorder ) : String
            {
                return ContextMenuItemUtils.getBooleanContextMenuItemCaption( c.curveSettings.name, c.curveSettings.visible );
            }
            protected function contextMenuClick ( e : ContextMenuEvent ) : void
            {
                var cmi : ContextMenuItem = e.target as ContextMenuItem;
                var r : Recorder = getRecorderForContextMenuItem(cmi);
                r.curveSettings.visible = !r.curveSettings.visible;
                cmi.caption = getContextLabel( r );
            }
        }

        public function addRecorder ( o : Recorder ) : void
        {
            if( !containsRecorder( o ) )
            {
                _recorders.push( o );
                FEATURES::MENU_CONTEXT {
                    var cmi : ContextMenuItem = addNewContextMenuItemForGroup( getContextLabel( o ), 
                                                                               o.curveSettings.name, 
                                                                               contextMenuClick, 
                                                                               "recorders" );
                    _contextMap[ cmi ] = o;
                }
                recorderAdded.dispatch( this, o, _recorders.indexOf(o) );
            }
        }
        public function addRecorders ( ... args ) : void
        {
            for each( var o : Recorder in args )
                if( o )
                    addRecorder ( o );
        }
        public function removeRecorder ( o : Recorder ) : void
        {
            if( containsRecorder( o ) )
            {
                var index : int = _recorders.indexOf( o );
                _recorders.splice( index, 1 );
                FEATURES::MENU_CONTEXT {
                    removeContextMenuItem( o.curveSettings.name );
                    var cmi : ContextMenuItem = getContextMenuItemForRecorder( o );
                    delete _contextMap[ cmi ];
                }
                recorderRemoved.dispatch( this, o, index );
            }
        }
        public function removeRecorders ( ... args ) : void
        {
            for each( var o : Recorder in args )
                if( o )
                    removeRecorder ( o );
        }
        public function containsRecorder ( o : Recorder ) : Boolean
        {
            return _recorders.indexOf( o ) != -1;
        }

        public function get isPlaying () : Boolean { return _playing; }
        public function isRunning () : Boolean { return _playing; }

        public function start () : void
        {
            if( !_playing )
            {
                _playing = true;
                if( _displayed )
                    Impulse.register(tick);
            }
        }

        public function stop () : void
        {
            if( _playing )
            {
                _playing = false;
                if( _displayed )
                    Impulse.unregister(tick);
            }
        }
        override public function addedToStage ( e : Event ) : void
        {
            super.addedToStage(e);
            if( _playing )
                Impulse.register(tick);
        }
        override public function removeFromStage ( e : Event ) : void
        {
            super.removeFromStage(e);
            if( _playing )
                Impulse.unregister(tick);
        }

        override public function invalidatePreferredSizeCache () : void
        {
            _preferredSizeCache = new Dimension(100,100);
            super.invalidatePreferredSizeCache();
        }
        public function tick ( bias : Number, biasInSeconds : Number, currentTime : Number ) : void
        {
            drawMonitorCurves();
        }

        override public function repaint () : void
        {
            super.repaint();
            drawMonitorCurves();
        }

        protected function drawMonitorCurves () : void
        {
            _childrenContainer.graphics.clear();
            var l : uint = _recorders.length;
            var s : Dimension = calculateComponentSize();
            for ( var i : uint=0;i<l;i++)
            {
                var recorder : Recorder = _recorders[i];
                if( recorder.curveSettings.visible )
                {
                    drawMonitorCurve( _childrenContainer.graphics,
                                      recorder.curveSettings,
                                      recorder.values,
                                      100,
                                      recorder.valuesRange,
                                      s );
                }
            }
            recorder = null;
        }

        protected function drawMonitorCurve ( g : Graphics,
                                              curve : GraphCurveSettings,
                                              values : Array,
                                              numValues : Number,
                                              valuesRange : Range,
                                              size : Dimension
                                             ) : void
        {
            // nettoie la courbe précédente
            try
            {
                var l : Number = values.length;
                var insets : Insets = _style.insets;
                //  on calcule le nombre d'étape à réaliser, soit la longueur - 1
                var xstep : Number = numValues - 1;
                // on calcule le pas horizontal, soit combien de pixel représente 1 étape en x
                var hstep : Number = ( size.width - insets.horizontal ) / xstep;
                // on calcule le pas vertical, soit combien de pixel représente 1 en y
                var vstep : Number = ( size.height - insets.vertical ) / ( valuesRange.size() )  ;

                g.lineStyle( curve.size, curve.color.hexa, curve.color.alpha/255 );

                // on peut remplir le bas de la courbe si besoin
                if( curve.filled )
                    g.beginFill( curve.color.hexa, curve.color.alpha/ ( 255 * 4 ) );

                // on parcourt depuis la fin du tableau
                while( l-- )
                {
                    // calcul de l'étape en x
                    var y : Number = size.height - ( ( values[ l ] - valuesRange.min ) * vstep ) - insets.bottom;
                    // calcul de l'étape en y
                    var x : Number = xstep * hstep + insets.left;

                    // si les valeurs sont incohérentes, ou en dehors de la plage
                    if( isNaN( y ) || y > size.height - insets.bottom )
                        y = size.height - insets.bottom;
                    else if ( y < insets.top )
                        y = insets.top ;

                    // si c'est la première étape, on place le pinceau
                    if( xstep == numValues - 1 )
                        g.moveTo( x, y );
                    // après on dessine les courbes
                    else
                        g.lineTo( x, y );

                    xstep--;
                }

                // on ferme le remplissage si il a été activé
                if( curve.filled )
                {
                    g.lineStyle();
                    g.lineTo( x, size.height - insets.bottom );
                    g.lineTo( size.width - insets.right, size.height - insets.bottom );
                    g.lineTo(size.width- insets.right, size.height - ( ( values[ values.length -1 ] - valuesRange.min ) * vstep ) - insets.bottom );
                    g.endFill();
                }
            }
            catch( e : Error )
            {
                Log.error( e.message + "\n" + e.getStackTrace() );
            }
        }
    }
}
