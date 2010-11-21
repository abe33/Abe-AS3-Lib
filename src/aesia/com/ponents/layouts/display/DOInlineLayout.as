/**
 * @license
 */
package aesia.com.ponents.layouts.display 
{
	import aesia.com.mon.geom.Dimension;
	import aesia.com.ponents.utils.Alignments;
	import aesia.com.ponents.utils.Directions;
	import aesia.com.ponents.utils.Insets;

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Rectangle;

	/**
	 * @author Cédric Néhémie
	 */
	public class DOInlineLayout extends AbstractDisplayObjectLayout 
	{
		protected var _halign : String;		protected var _valign : String;
		protected var _direction : String;		protected var _spacing : Number;
		protected var _fixedSize : Boolean;
		protected var _spacingAtExtremity : Boolean;
		
		public function DOInlineLayout ( container : DisplayObjectContainer = null, 
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
			var l : Number = _container.numChildren;
			var i : Number = 0;
			var c : DisplayObject;
			var bb : Rectangle;
			var xoffset : Number = _spacingAtExtremity ? _spacing : 0;
			var yoffset : Number = _spacingAtExtremity ? _spacing : 0;
			switch( _direction )
			{
				case Directions.TOP_TO_BOTTOM :
					y = 0;
					for(i=0;i<l;i++)
					{
						c = _container.getChildAt(i);
						if( _fixedSize )
							c.width = prefDim.width - insets.horizontal;
							
						c.x = c.y = 0;
						bb = c.getBounds(c.parent);
						c.x = Alignments.alignHorizontal( c.width, prefDim.width, insets, _halign ) - bb.left;
						c.y = yoffset + y + Alignments.alignVertical( innerPref.height , prefDim.height, insets, _valign ) - bb.top;
						
						y += c.height + _spacing; 
					}					
					break;
				case Directions.BOTTOM_TO_TOP : 
					y = innerPref.height;
					for(i=0;i<l;i++)
					{
						c = _container.getChildAt(i);
						if( _fixedSize )
							c.width = prefDim.width - insets.horizontal;
							
						c.x = c.y = 0;
						bb = c.getBounds(c.parent);
						c.x = Alignments.alignHorizontal( c.width, prefDim.width, insets, _halign ) - bb.left;
						c.y = yoffset + y - c.height + Alignments.alignVertical( innerPref.height, prefDim.height, insets, _valign ) - bb.top;
						
						y -= c.height + _spacing; 
					}					
					break;
				case Directions.RIGHT_TO_LEFT : 
					x = innerPref.width;
					for(i=0;i<l;i++)
					{
						c = _container.getChildAt(i);
						if( _fixedSize )
							c.height = prefDim.height - insets.vertical;
							
						c.x = c.y = 0;
						bb = c.getBounds(c.parent);
						c.x = xoffset + x - c.width + Alignments.alignHorizontal( innerPref.width, prefDim.width, insets, _halign ) - bb.left;
						c.y = Alignments.alignVertical( c.height, prefDim.height, insets, _valign ) - bb.top;
						
						x -= c.width + _spacing; 
					}					
					break;
				case Directions.LEFT_TO_RIGHT :
				default :
					x = 0;
					for(i=0;i<l;i++)
					{
						c = _container.getChildAt(i);
						if( _fixedSize )
							c.height = prefDim.height - insets.vertical;
						
						c.x = c.y = 0;
						bb = c.getBounds(c.parent);
						c.x = xoffset + x + Alignments.alignHorizontal( innerPref.width , prefDim.width, insets, _halign ) - bb.left;
						c.y = Alignments.alignVertical( c.height, prefDim.height, insets, _valign ) - bb.top;
						x += c.width + _spacing; 
					}					
					break;
			}
		}
		protected function estimatedSize () : Dimension
		{
			return estimatedContentSize();
		}

		protected function estimatedContentSize () : Dimension
		{
			var w : Number = 0;
			var h : Number = 0;
			var l : Number = _container.numChildren;
			var i : Number = 0;
			var c : DisplayObject;
			var bb : Rectangle;
			switch( _direction )
			{
				case Directions.TOP_TO_BOTTOM :
				case Directions.BOTTOM_TO_TOP : 
					for(i=0;i<l;i++)
					{
						c = _container.getChildAt(i);
						bb = c.getBounds(c.parent);
						w = Math.max(w,bb.width);
						h += bb.height;
						if( i>0 )
							h += _spacing;	
					}		
					break;
				case Directions.LEFT_TO_RIGHT :
				case Directions.RIGHT_TO_LEFT : 
				default :
					for(i=0;i<l;i++)
					{
						c = _container.getChildAt(i);
						bb = c.getBounds(c.parent);
						h = Math.max(h,bb.height);
						w += bb.width;
						if( i>0 )
							w += _spacing;	
					}
					break;
			}
			
			if( _spacingAtExtremity )
				w += _spacing * 2;
			
			return new Dimension( w, h );
		}
	}
}
