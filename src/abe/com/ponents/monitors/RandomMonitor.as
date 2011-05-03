package abe.com.ponents.monitors 
{
	import abe.com.mon.utils.Reflection;
	import abe.com.ponents.text.Label;
	import abe.com.mon.core.Suspendable;
	import abe.com.mon.randoms.RandomGenerator;
	import abe.com.motion.Impulse;
	import abe.com.motion.ImpulseEvent;
	import abe.com.motion.ImpulseListener;
	import abe.com.ponents.containers.Panel;
	import abe.com.ponents.layouts.components.InlineLayout;

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
		
		protected var _barGraph : VBarGraph; 

		public function RandomMonitor ( generator : RandomGenerator )
		{
			_childrenLayout = new InlineLayout(this, 5, "left", "top", "topToBottom", true );
			_generator = generator;
			super();
			allowMask = false;
			
			
			_barGraph = new VBarGraph();
			
			addComponent( new Label( Reflection.getClassName( _generator ) ) );
			addComponent( _barGraph );
		}
		public function tick (e : ImpulseEvent) : void
		{
			var n1 : Number = _generator.random();			var n2 : Number = _generator.random();
			
			_barGraph.appendValue( n1 );			_barGraph.appendValue( n2 );
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
		public function isRunning () : Boolean { return _isRunning; }
	}
}

import abe.com.mon.logs.Log;
import abe.com.ponents.utils.Insets;
import abe.com.mon.colors.Color;
import abe.com.mon.geom.Dimension;
import abe.com.mon.utils.MathUtils;
import abe.com.ponents.core.AbstractComponent;

[Skinable(skin="EmptyComponent")]
internal class VBarGraph extends AbstractComponent
{
	protected var _values : Array;
	protected var _maxValue : uint;
	protected var _numBars : uint;
	protected var _barColor : Color;
		
	public function VBarGraph ( numBars : uint = 20, barColor : Color = null ) 
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
