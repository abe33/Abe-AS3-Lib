package aesia.com.ponents.monitors
{
	import aesia.com.mon.core.Suspendable;
	import aesia.com.mon.geom.Dimension;
	import aesia.com.mon.geom.Range;
	import aesia.com.mon.logs.Log;
	import aesia.com.motion.Impulse;
	import aesia.com.motion.ImpulseEvent;
	import aesia.com.motion.ImpulseListener;
	import aesia.com.ponents.core.AbstractComponent;
	import aesia.com.ponents.monitors.recorders.Recorder;
	import aesia.com.ponents.skinning.decorations.GraphMonitorBorder;
	import aesia.com.ponents.utils.ContextMenuItemUtils;
	import aesia.com.ponents.utils.Insets;

	import flash.display.Graphics;
	import flash.events.ContextMenuEvent;
	import flash.events.Event;
	import flash.ui.ContextMenuItem;
	import flash.utils.Dictionary;

	/**
	 * @author Cédric Néhémie
	 */
	[Skinable(skin="GraphMonitor")]
	[Skin(define="GraphMonitor",
		  inherit="EmptyComponent",

		  state__all__foreground="new deco::GraphMonitorBorder( skin.borderColor )",		  state__all__background="new deco::SimpleFill( skin.containerBackgroundColor )"
		  )]
	public class GraphMonitor extends AbstractComponent implements ImpulseListener, Suspendable
	{
		static private const SKIN_DEPENDENCIES : Array = [ GraphMonitorBorder ];

		/*FDT_IGNORE*/
		TARGET::FLASH_9
		protected var _recorders : Array;
		TARGET::FLASH_10
		protected var _recorders : Vector.<Recorder>;
		TARGET::FLASH_10_1 /*FDT_IGNORE*/
		protected var _recorders : Vector.<Recorder>;
		
		protected var _playing : Boolean;

		public function GraphMonitor ()
		{
			super();
			/*FDT_IGNORE*/
			TARGET::FLASH_9 { _recorders = []; }
			TARGET::FLASH_10 { _recorders = new Vector.<Recorder>(); }
			TARGET::FLASH_10_1 { /*FDT_IGNORE*/
			_recorders = new Vector.<Recorder>(); /*FDT_IGNORE*/ } /*FDT_IGNORE*/
			
			_playing = true;
			allowMask = false;
			invalidatePreferredSizeCache();

			/*FDT_IGNORE*/ FEATURES::MENU_CONTEXT { /*FDT_IGNORE*/
			_contextMap = new Dictionary(true);
			/*FDT_IGNORE*/ } /*FDT_IGNORE*/
		}
		
		/*FDT_IGNORE*/
		TARGET::FLASH_9
		public function get recorders () : Array { return _recorders; }
		TARGET::FLASH_10
		public function get recorders () : Vector.<Recorder> { return _recorders; }
		TARGET::FLASH_10_1 /*FDT_IGNORE*/
		public function get recorders () : Vector.<Recorder> { return _recorders; }
		
		public function get length () : uint { return _recorders.length; }

		/*FDT_IGNORE*/ FEATURES::MENU_CONTEXT { /*FDT_IGNORE*/
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
		/*FDT_IGNORE*/ } /*FDT_IGNORE*/

		public function addRecorder ( o : Recorder ) : void
		{
			if( !containsRecorder( o ) )
			{
				_recorders.push( o );
				/*FDT_IGNORE*/ FEATURES::MENU_CONTEXT { /*FDT_IGNORE*/
				var cmi : ContextMenuItem = addNewContextMenuItemForGroup( getContextLabel( o ), o.curveSettings.name, contextMenuClick, "recorders" );
				_contextMap[ cmi ] = o;
				/*FDT_IGNORE*/ } /*FDT_IGNORE*/
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
				_recorders.splice(  _recorders.indexOf( o ), 1 );
				/*FDT_IGNORE*/ FEATURES::MENU_CONTEXT { /*FDT_IGNORE*/
				removeContextMenuItem( o.curveSettings.name );
				var cmi : ContextMenuItem = getContextMenuItemForRecorder( o );
				delete _contextMap[ cmi ];
				/*FDT_IGNORE*/ } /*FDT_IGNORE*/
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
		public function tick ( e : ImpulseEvent ) : void
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
