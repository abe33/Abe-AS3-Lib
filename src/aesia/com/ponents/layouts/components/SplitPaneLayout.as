package aesia.com.ponents.layouts.components 
{
	import aesia.com.mon.geom.Dimension;
	import aesia.com.ponents.containers.SplitPane;
	import aesia.com.ponents.core.Component;
	import aesia.com.ponents.core.Container;
	import aesia.com.ponents.utils.Insets;

	/**
	 * @author Cédric Néhémie
	 */
	public class SplitPaneLayout extends AbstractComponentLayout 
	{
		protected var _direction : uint;
		protected var _divider : Component;		protected var _expander : Component;
		protected var _firstComponent : Component;
		protected var _secondComponent : Component;
		
		protected var _resizeWeight : Number;
		protected var _dividerLocation : Number;
		protected var _usePreferredSize : Boolean;
		
		public function SplitPaneLayout (container : Container = null)
		{
			super( container );
			_usePreferredSize = true;
		}
		public function get expander () : Component { return _expander; }		
		public function set expander (expander : Component) : void
		{
			_expander = expander;
		}
		public function get direction () : uint { return _direction; }		
		public function set direction (direction : uint) : void
		{
			_direction = direction;
		}
		public function get firstComponent () : Component { return _firstComponent; }		
		public function set firstComponent ( firstComponent : Component ) : void
		{
			_firstComponent = firstComponent;
		}
		public function get secondComponent () : Component { return _secondComponent; }		
		public function set secondComponent ( secondComponent : Component ) : void
		{
			_secondComponent = secondComponent;
		}
		public function get resizeWeight () : Number { return _resizeWeight; }		
		public function set resizeWeight (resizeWeight : Number) : void
		{
			_resizeWeight = resizeWeight;
		}
		public function get divider () : Component { return _divider; }		
		public function set divider (divider : Component) : void
		{
			_divider = divider;
		}
		public function get dividerLocation () : Number { return _dividerLocation; }		
		public function set dividerLocation (dividerLocation : Number) : void
		{
			if( dividerLocation < 0 )
				dividerLocation = 0;
			
			_dividerLocation = dividerLocation;
			usePreferredSize = false;
		}
		public function get usePreferredSize () : Boolean { return _usePreferredSize; }		
		public function set usePreferredSize (usePreferredSize : Boolean) : void
		{
			_usePreferredSize = usePreferredSize;
		}
		
		override public function get preferredSize () : Dimension
		{
			return estimatedSize();
		}

		override public function layout (preferredSize : Dimension = null, insets : Insets = null) : void
		{
			insets = insets ? insets : new Insets();
			
			var innerPref : Dimension = estimatedSize();
			var prefDim : Dimension = preferredSize ? preferredSize.grow( -insets.horizontal, -insets.vertical ) : innerPref;
			
			var x : Number = insets.left;
			var y : Number = insets.top;
			var fw : Number;			var sw : Number;			var fh : Number;			var sh : Number;
			var refh : Number;			var refw : Number;
			// si on utilise les taille préferré des composants et
			// que la taille du tout est égale a l'estimation faite a partir des parties
			if( _usePreferredSize && prefDim.equals( innerPref ) )
			{
				if( _direction == SplitPane.HORIZONTAL_SPLIT )
				{
					if( _firstComponent )
					{
						_firstComponent.x = x;						_firstComponent.y = y;
						
						x += _firstComponent.preferredSize.width;						
						_firstComponent.height = prefDim.height;
					}
					if( _expander )
					{
						_expander.x = x;
						_expander.y = y + ( prefDim.height - _expander.preferredHeight )/2;
					}
					
					if( _divider )
					{
						_divider.x = x;
						_divider.y = y;
						
						x += _divider.preferredSize.width;						
						_divider.height = prefDim.height;
					}
					
					
					if( _secondComponent )
					{
						_secondComponent.x = x;
						_secondComponent.y = y;
						
						_secondComponent.height = prefDim.height;
					}
				}
				else
				{
					if( _firstComponent )
					{
						_firstComponent.x = x;
						_firstComponent.y = y;
						
						y += _firstComponent.preferredSize.height;						
						_firstComponent.width = prefDim.width;
					}
					
					if( _expander )
					{
						_expander.x = x +  ( prefDim.width - _expander.preferredWidth )/2;
						_expander.y = y;
					}
					
					if( _divider )
					{
						_divider.x = x;
						_divider.y = y;
						
						y += _divider.preferredSize.height;						
						_divider.width = prefDim.width;
					}
					
					
					if( _secondComponent )
					{
						_secondComponent.x = x;
						_secondComponent.y = y;
						
						_secondComponent.width = prefDim.width;
					}
				}
			}
			else
			{
				// si la position du divider n'a pas été déterminé, 
				// on va faire le layout en se basant sur les poids
				if( isNaN( _dividerLocation ) )
				{
					if( _direction == SplitPane.HORIZONTAL_SPLIT )
					{
						refw = prefDim.width - _divider.preferredSize.width;

						fw = refw * _resizeWeight;
						sw = refw * (1 - _resizeWeight);
						
						if( _firstComponent )
						{
							_firstComponent.x = x;
							_firstComponent.y = y;
							_firstComponent.height = prefDim.height;							_firstComponent.width = fw;
						}
						x += fw;

						if( _expander )
						{
							_expander.x = x;
							_expander.y = y + ( prefDim.height - _expander.preferredHeight )/2;
						}
												_divider.x = x;						_divider.y = y;
						_divider.height = prefDim.height;
						x += _divider.preferredSize.width;
						
						
						if( _secondComponent )
						{
							_secondComponent.x = x;
							_secondComponent.y = y;
							_secondComponent.height = prefDim.height;
							_secondComponent.width = sw;
						}
					}
					else
					{
						refh = prefDim.height - _divider.preferredSize.height;
						
						fh = refh * _resizeWeight;
						sh = refh * (1 - _resizeWeight);
						
						if( _firstComponent )
						{
							_firstComponent.x = x;
							_firstComponent.y = y;
							_firstComponent.width = prefDim.width;
							_firstComponent.height = fh;
						}
						y += fh;
						
						if( _expander )
						{
							_expander.x = x +  ( prefDim.width - _expander.preferredWidth )/2;
							_expander.y = y;
						}
												_divider.x = x;
						_divider.y = y;
						_divider.width = prefDim.width;
						y += _divider.preferredSize.height;
						
						
						if( _secondComponent )
						{
							_secondComponent.x = x;
							_secondComponent.y = y;
							_secondComponent.width = prefDim.width;
							_secondComponent.height = sh;
						}
					}
				}
				else
				{
					if( _direction == SplitPane.HORIZONTAL_SPLIT )
					{
						
						refw = prefDim.width - _divider.preferredSize.width;
						
						if( _dividerLocation > refw )
							_dividerLocation = refw;
							
						fw = _dividerLocation;
						sw = refw - _dividerLocation;
						
						if( _firstComponent )
						{
							_firstComponent.x = x;
							_firstComponent.y = y;
							_firstComponent.height = prefDim.height;
							_firstComponent.width = fw;
						}
						x += fw;
						
						if( _expander )
						{
							_expander.x = x;
							_expander.y = y + ( prefDim.height - _expander.preferredHeight )/2;
						}
						
						_divider.x = x;
						_divider.y = y;
						_divider.height = prefDim.height;
						x += _divider.preferredSize.width;
						
						if( _secondComponent )
						{
							_secondComponent.x = x;
							_secondComponent.y = y;
							_secondComponent.height = prefDim.height;
							_secondComponent.width = sw;
						}
					}
					else
					{
						refh = prefDim.height - _divider.preferredSize.height;
						
						if( _dividerLocation > refh )
							_dividerLocation = refh;
						
						fh = _dividerLocation;
						sh = refh - _dividerLocation;
						
						if( _firstComponent )
						{
							_firstComponent.x = x;
							_firstComponent.y = y;
							_firstComponent.width = prefDim.width;
							_firstComponent.height = fh;
						}
						y += fh;
						
						if( _expander )
						{
							_expander.x = x +  ( prefDim.width - _expander.preferredWidth )/2;
							_expander.y = y;
						}
						
						_divider.x = x;
						_divider.y = y;
						_divider.width = prefDim.width;
						y += _divider.preferredSize.height;
						
						if( _secondComponent )
						{
							_secondComponent.x = x;
							_secondComponent.y = y;
							_secondComponent.width = prefDim.width;
							_secondComponent.height = sh;
						}
					}
				}
			}
			super.layout( preferredSize, insets );
		}
		
		protected function estimatedSize () : Dimension
		{
			var w : Number = 0;
			var h : Number = 0;
						
			if( _direction == SplitPane.HORIZONTAL_SPLIT )
			{
				if( _firstComponent )
				{
					w += _firstComponent.preferredSize.width;
					h = Math.max( h, _firstComponent.preferredSize.height );
				}
				
				if( _divider )
					w += _divider.preferredSize.width;
					
				if( _secondComponent )
				{
					w += _secondComponent.preferredSize.width;
					h = Math.max( h, _secondComponent.preferredSize.height );
				}
			}
			else
			{
				if( _firstComponent )
				{
					h += _firstComponent.preferredSize.height;
					w = Math.max( w, _firstComponent.preferredSize.width );
				}
				
				if( _divider )
					h += _divider.preferredSize.height;
					
				if( _secondComponent )
				{
					h += _secondComponent.preferredSize.height;
					w = Math.max( w, _secondComponent.preferredSize.width );
				}
			}
			
			return new Dimension( w, h );
		}
	}
}
