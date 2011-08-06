package abe.com.ponents.layouts.components 
{
	import abe.com.mon.geom.Dimension;
	import abe.com.ponents.core.Component;
	import abe.com.ponents.core.Container;
	import abe.com.ponents.utils.Alignments;
	import abe.com.ponents.utils.Directions;
	import abe.com.ponents.utils.Insets;
	/**
	 * @author Cédric Néhémie
	 */
	public class InlineLayout extends AbstractComponentLayout 
	{
		protected var _halign : String;
		protected var _valign : String;
		protected var _direction : String;
		protected var _spacing : Number;
		protected var _fixedSize : Boolean;
		protected var _spacingAtExtremity : Boolean;
		
		public function InlineLayout (  container : Container = null, 
										 spacing : Number = 0,
										 halign : String = "center", 
										 valign : String = "center", 
										 direction : String = "leftToRight",
										 fixedSize : Boolean = false,
										 spacingAtExtremity : Boolean = false )
		{
			super( container );
			_spacing = spacing;
			_halign = halign;
			_valign = valign;
			_direction = direction;
			_fixedSize = fixedSize;
			_spacingAtExtremity = spacingAtExtremity;
		}

		public function get horizontalAlign () : String { return _halign; }		
		public function set horizontalAlign (halign : String) : void
		{
			_halign = halign;
		}
		
		public function get verticalAlign () : String { return _valign; }		
		public function set verticalAlign (valign : String) : void
		{
			_valign = valign;
		}
		
		public function get direction () : String { return _direction; }		
		public function set direction ( direction : String) : void
		{
			_direction =  direction;
		}
		
		public function get spacing () : Number { return _spacing; }		
		public function set spacing (spacing : Number) : void
		{
			_spacing = spacing;
		}
		public function get fixedSize () : Boolean { return _fixedSize; }		
		public function set fixedSize (fixedSize : Boolean) : void
		{
			_fixedSize = fixedSize;
		}
		
		public function get spacingAtExtremity () : Boolean { return _spacingAtExtremity; }	
		public function set spacingAtExtremity (spacingAtExtremity : Boolean) : void
		{
			_spacingAtExtremity = spacingAtExtremity;
		}
		
		override public function get preferredSize () : Dimension { return estimatedSize (); }
		
		override public function layout ( preferredSize : Dimension = null, insets : Insets = null ) : void
		{
			insets = insets ? insets : new Insets();
			
			var innerPref : Dimension = estimatedContentSize();
			var prefDim : Dimension = preferredSize ? preferredSize : innerPref.grow( insets.horizontal, insets.vertical );
			var x : Number = 0;
			var y : Number = 0;
			var l : Number = _container.children.length;
			var i : Number = 0;
			var c : Component;
			
			_lastMaximumContentSize = prefDim.grow( -insets.horizontal, -insets.vertical )
			
			var xoffset : Number = _spacingAtExtremity ? _spacing : 0;			var yoffset : Number = _spacingAtExtremity ? _spacing : 0;
			
			switch( _direction )
			{
				case Directions.TOP_TO_BOTTOM :
					y = 0;
					for(i=0;i<l;i++)
					{
						c = _container.children[ i ];
						if(!c.visible)
                        	continue;
                        
						if( _fixedSize )
						{
							c.width = prefDim.width-insets.horizontal;
							c.height = c.preferredHeight;
						}
						
						c.x = Alignments.alignHorizontal( c.width, prefDim.width, insets, _halign );
						c.y = yoffset + y + Alignments.alignVertical( innerPref.height , prefDim.height, insets, _valign );
						
						y += c.preferredHeight + _spacing; 
					}					
					break;
				case Directions.BOTTOM_TO_TOP : 
					y = innerPref.height;
					for(i=0;i<l;i++)
					{
						c = _container.children[ i ];
						if(!c.visible)
                        	continue;
                        
						if( _fixedSize )
						{
							c.width = prefDim.width-insets.horizontal;
							c.height = c.preferredHeight;
						}
						c.x = Alignments.alignHorizontal( c.width, prefDim.width, insets, _halign );
						c.y = yoffset + y - c.height + Alignments.alignVertical( innerPref.height, prefDim.height, insets, _valign );
											
						y -= c.preferredHeight + _spacing; 
					}					
					break;
				case Directions.RIGHT_TO_LEFT : 
					x = innerPref.width;
					for(i=0;i<l;i++)
					{
						c = _container.children[ i ];
                        if(!c.visible)
                        	continue;
                        
						if( _fixedSize )
						{
							c.height = prefDim.height-insets.vertical;
							c.width = c.preferredWidth;
						}
						c.x = xoffset + x - c.width + Alignments.alignHorizontal( innerPref.width, prefDim.width, insets, _halign );
						c.y = Alignments.alignVertical( c.height, prefDim.height, insets, _valign );
						
						x -= c.width + _spacing; 
					}					
					break;
				case Directions.LEFT_TO_RIGHT :
				default :
					x = 0;
					for(i=0;i<l;i++)
					{
						c = _container.children[ i ];
                        if(!c.visible)
                        	continue;
                        
						if( _fixedSize )
						{
							c.height = prefDim.height-insets.vertical;
							c.width = c.preferredWidth;
						}
						c.x = xoffset + x + Alignments.alignHorizontal( innerPref.width , prefDim.width, insets, _halign );
						c.y = Alignments.alignVertical( c.height, prefDim.height, insets, _valign );
						
						x += c.width + _spacing; 
					}					
					break;
			}
			super.layout( preferredSize, insets );
		}
		protected function estimatedSize () : Dimension
		{
			return estimatedContentSize();
		}

		protected function estimatedContentSize () : Dimension
		{
			var w : Number = 0;
			var h : Number = 0;
			var l : Number = _container.children.length;
			var i : Number = 0;
			var c : Component;
			switch( _direction )
			{
				case Directions.TOP_TO_BOTTOM :
				case Directions.BOTTOM_TO_TOP :
					 
					for(i=0;i<l;i++)
					{
						c = _container.children[ i ];
                        if(!c.visible)
                        	continue;
                        
						w = Math.max(w,c.preferredSize.width );
						h += c.preferredSize.height;
						
						if( i>0 )
							h += _spacing;	
					}
					if( _spacingAtExtremity )
						h += _spacing * 2;					
					break;
				case Directions.LEFT_TO_RIGHT :
				case Directions.RIGHT_TO_LEFT : 
				default :
					for(i=0;i<l;i++)
					{
						c = _container.children[ i ];
                        if(!c.visible)
                        	continue;
                        
						h = Math.max(h,c.preferredSize.height);
						w += c.preferredSize.width;
						
						if( i>0 )
							w += _spacing;	
					}
					if( _spacingAtExtremity )
						w += _spacing * 2;
					break;
			}
			
			return new Dimension( w, h );
		}
	}
}
