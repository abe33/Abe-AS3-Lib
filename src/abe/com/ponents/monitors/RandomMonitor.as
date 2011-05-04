package abe.com.ponents.monitors 
{
	import abe.com.patibility.humanize.capitalize;
	import abe.com.mon.colors.Color;
	import abe.com.mon.core.Suspendable;
	import abe.com.mon.geom.pt;
	import abe.com.mon.geom.rect;
	import abe.com.mon.randoms.RandomGenerator;
	import abe.com.mon.utils.Reflection;
	import abe.com.motion.Impulse;
	import abe.com.motion.ImpulseEvent;
	import abe.com.motion.ImpulseListener;
	import abe.com.patibility.humanize.spaceOut;
	import abe.com.patibility.lang._$;
	import abe.com.ponents.containers.Panel;
	import abe.com.ponents.core.SimpleDOContainer;
	import abe.com.ponents.layouts.components.BoxSettings;
	import abe.com.ponents.layouts.components.VBoxLayout;
	import abe.com.ponents.layouts.display.DOInlineLayout;
	import abe.com.ponents.text.Label;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.PixelSnapping;
	import flash.utils.getTimer;

	/**
	 * @author cedric
	 */
	[Skinable(skin="RandomMonitor")]
	[Skin(define="RandomMonitor",
			  inherit="DefaultComponent",
			  state__all__insets="new cutils::Insets(5)"
	)]
	public class RandomMonitor extends Panel implements ImpulseListener, Suspendable 
	{
		protected var _generator : RandomGenerator;
		protected var _isRunning : Boolean;
		
		protected var _typeLabel : Label;
		protected var _countLabel : Label;
		protected var _barGraph : VBarGraph;
		protected var _counter : int;
		private var _bitmapGraph : SimpleDOContainer;
		private var _bitmap : BitmapData;
		private var _graphColor : Color;
		private var _bench : int;		
		static private const BITMAP_SIZE : uint = 64;
		static private const BITMAP_WIDTH : uint = 165;
		static private const BENCHMARK_ITERATIONS : uint = 10000;

		public function RandomMonitor ( generator : RandomGenerator, graphColor : Color = null )
		{
			_counter = 0;
			_generator = generator;
			_graphColor = graphColor ? graphColor : Color.Crimson;
			super();
			allowMask = false;
			
			bench();
			
			_typeLabel = new Label( capitalize( spaceOut ( Reflection.getClassName( _generator ) ), true ) );
			_barGraph = new VBarGraph( 40, _graphColor);
			_countLabel = new Label( getCountLabel() );
			_bitmapGraph = new SimpleDOContainer();
			
			_bitmapGraph.styleKey = "EmptyComponent";
			_bitmapGraph.childrenLayout = new DOInlineLayout();
			_bitmap = new BitmapData( BITMAP_WIDTH, BITMAP_SIZE, false, 0 );
			_bitmap.fillRect(rect(BITMAP_SIZE,0,1,BITMAP_SIZE), 0xffffff );
			_bitmapGraph.addComponentChild( new Bitmap( _bitmap, PixelSnapping.ALWAYS, false ) );
			
			childrenLayout = new VBoxLayout(this, 3, 
									new BoxSettings(0,"left","center",_typeLabel,true),
									new BoxSettings(0,"left","center", _barGraph, true, true, true ),
									new BoxSettings(0, "left", "center", _countLabel, true ),									new BoxSettings(64, "left", "center", _bitmapGraph, true, true )
							 );
			
			addComponent( _typeLabel );
			addComponent( _barGraph );
			addComponent( _countLabel );
			addComponent( _bitmapGraph );
		}
		protected function getCountLabel () : String 
		{
			return _$("Bench ($2 loops) : <font color='#$3'><b>$1</b></font> ms\nGenerated : <font color='#$3'><b>$0</b></font>", 
					   _counter, 
					   _bench, 
					   BENCHMARK_ITERATIONS,
					   _graphColor.rgb );
		}
		protected function bench() : void
		{
			var ms : int = getTimer();
			var l : uint = BENCHMARK_ITERATIONS;
			while(l--)
				_generator.random();
			_bench = getTimer() - ms;
		}
		public function tick (e : ImpulseEvent) : void
		{
			var n1 : Number = _generator.random();			var n2 : Number = _generator.random();
			
			
			_counter += 2;
			
			_barGraph.appendValue( n1 );
			_barGraph.appendValue( n2 );
			
			_bitmap.copyPixels( _bitmap, 
								rect( BITMAP_SIZE + 3, 0, BITMAP_WIDTH - 2, BITMAP_SIZE), 
								pt(BITMAP_SIZE + 1,0) );
			
			_bitmap.fillRect( rect( BITMAP_WIDTH-2, 0, 2, BITMAP_SIZE ), 
							  0 );
						_bitmap.setPixel( Math.floor( BITMAP_WIDTH - 2 ), BITMAP_SIZE - Math.floor( n1 * BITMAP_SIZE ), _graphColor.hexa );			_bitmap.setPixel( Math.floor( BITMAP_WIDTH - 1 ), BITMAP_SIZE - Math.floor( n2 * BITMAP_SIZE ), _graphColor.hexa );						_bitmap.setPixel( Math.floor( n1 * BITMAP_SIZE ), 
							  Math.floor( n2 * BITMAP_SIZE ), 
							  _graphColor.hexa );
			
			_countLabel.value = getCountLabel();
		}
		public function start () : void
		{
			if( !_isRunning )
			{
				Impulse.register( tick );
				_isRunning = true;
			}
		}
		public function stop () : void
		{
			if( _isRunning )
			{
				Impulse.unregister( tick );
				_isRunning = false;
			}
		}
		public function isRunning () : Boolean { return _isRunning; 
		}
	}
}

import abe.com.mon.colors.Color;
import abe.com.mon.geom.Dimension;
import abe.com.mon.utils.MathUtils;
import abe.com.ponents.core.AbstractComponent;
import abe.com.ponents.utils.Insets;

[Skinable(skin="EmptyComponent")]
internal class VBarGraph extends AbstractComponent
{
	protected var _values : Array;
	protected var _maxValue : uint;
	protected var _numBars : uint;
	protected var _barColor : Color;
		
	public function VBarGraph ( numBars : uint = 40, barColor : Color = null ) 
	{
		_numBars = numBars;
		_maxValue = 1;
		_values = new Array( _numBars );
		_barColor = barColor ? barColor : Color.Crimson;
		
		for( var i : int = 0; i < _numBars; i++ )
			_values[i] = 0;
		
		super();
		allowMask = false;
		invalidatePreferredSizeCache();
	}
	override public function invalidatePreferredSizeCache () : void 
	{
		_preferredSizeCache = new Dimension(100,100);
		super.invalidatePreferredSizeCache();
	}
	public function appendValue ( n : Number ) : void
	{
		var i : int = Math.floor( MathUtils.map( n , 0, 1, 0, _numBars ) );
		if( i >= _numBars )
			i--;
		
		_values[i]++;
		_maxValue = Math.max( _values[i], _maxValue );
		
		updateGraph();
	}
	protected function updateGraph () : void 
	{
		_childrenContainer.graphics.clear();
		
		var insets : Insets =  _style.insets;
		var barWidth : Number = ( width - insets.horizontal ) / _numBars;
		var barHeight : Number = height - insets.vertical;
		var y : Number = height - insets.bottom;
		var x : Number = insets.left;
			
		for( var i : uint = 0; i< _numBars; i++ )
		{
			var v : uint = _values[i];
			var h : Number = ( v / _maxValue ) * barHeight;
			
			_childrenContainer.graphics.lineStyle( 0, _barColor.hexa );
			_childrenContainer.graphics.beginFill( _barColor.hexa, .5 );
			_childrenContainer.graphics.drawRect( x, y - h, barWidth, h );
			_childrenContainer.graphics.endFill();
			
			x += barWidth;
		}
	}
	override public function repaint () : void 
	{
		super.repaint();
		updateGraph();
	}
}
