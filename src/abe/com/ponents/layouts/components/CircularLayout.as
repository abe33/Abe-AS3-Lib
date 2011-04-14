package abe.com.ponents.layouts.components 
{
	import abe.com.mon.geom.Dimension;
	import abe.com.mon.geom.dm;
	import abe.com.ponents.core.Component;
	import abe.com.ponents.core.Container;
	import abe.com.ponents.utils.Insets;

	import flash.geom.Rectangle;
	/**
	 * @author Cédric Néhémie
	 */
	public class CircularLayout extends AbstractComponentLayout 
	{
		protected var _radius : Number;
		protected var _angleInterval : Number;
		protected var _angleStart : Number;
		protected var _forceLayoutAroundCenter : Boolean;
		protected var _counterClockWise : Boolean;

		public function CircularLayout ( container : Container = null, 
										 radius : Number = 10,
										 angleInterval : Number = 0.15,
										 angleStart : Number = 0,
										 counterClockWise : Boolean = false,
										 forceLayoutAroundCenter : Boolean = false )
		{
			super( container );
			_radius = radius;
			_angleInterval = angleInterval;
			_angleStart = angleStart;
			_counterClockWise = counterClockWise;
			_forceLayoutAroundCenter = forceLayoutAroundCenter;
		}

		override public function layout (preferredSize : Dimension = null, insets : Insets = null) : void 
		{
			insets = insets ? insets : new Insets( );
			preferredSize = preferredSize ? preferredSize : computeSize().grow( insets.horizontal, insets.vertical );
			
			var n : uint = _container.childrenCount;
			var astart : Number;
			
			if( _counterClockWise )
				astart = _angleStart - ( _angleInterval * ( n-1 ) / 2 );			else
				astart = _angleStart + ( _angleInterval * ( n-1 ) / 2 );
			
			var d : Dimension;
			var x : Number;
			var y : Number;
			var a : Number = astart;
			var cx : Number = preferredSize.width / 2;			var cy : Number = preferredSize.height / 2;
			var c : Component;
			
			for( var i : uint = 0; i<n; i++ )
			{
				c = _container.children[i];
				d = c.preferredSize;
				x = Math.sin( a ) * _radius;
				y = Math.cos( a ) * _radius;
				if( _forceLayoutAroundCenter )
				{
					c.x = x - d.width / 2;					c.y = y - d.height / 2;
				}
				else
				{					c.x = cx + x - d.width / 2;					c.y = cy + y - d.height / 2;
				}
				if( _counterClockWise )
					a += _angleInterval;				else
					a -= _angleInterval;
					
			}
		}

		override public function get preferredSize () : Dimension { return computeSize( ); }

		protected function computeSize () : Dimension 
		{
			var n : uint = _container.childrenCount;
			var astart : Number;
			
			if( _counterClockWise )
				astart = _angleStart - ( _angleInterval * ( n-1 ) / 2 );
			else
				astart = _angleStart + ( _angleInterval * ( n-1 ) / 2 );
				
			var r : Rectangle = new Rectangle(0, 0, 0, 0);			var r2 : Rectangle;
			var d : Dimension;
			var x : Number;			var y : Number;
			var a : Number = astart;
			for( var i : uint = 0; i < n; i++ )
			{
				d = _container.children[i].preferredSize;
				x = Math.sin( a ) * _radius;
				y = Math.cos( a ) * _radius;
				r2 = new Rectangle( x - d.width / 2, y - d.height / 2, d.width, d.height);
				
				r = r.union(r2);
				
				if( _counterClockWise )
					a += _angleInterval;
				else
					a -= _angleInterval;
			}
			
			return dm( r.width, r.height );
		}
	}
}
