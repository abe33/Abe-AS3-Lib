package abe.com.ponents.layouts.components 
{
    import abe.com.mon.geom.Dimension;
    import abe.com.mon.geom.dm;
    import abe.com.ponents.containers.AbstractScrollContainer;
    import abe.com.ponents.core.Component;
    import abe.com.ponents.core.Container;
    import abe.com.ponents.utils.Alignments;
    import abe.com.ponents.utils.Insets;
	/**
	 * @author cedric
	 */
	public class FlowLayout extends AbstractComponentLayout 
	{
		protected var _hgap : Number;
		protected var _vgap : Number;
		protected var _align : String;
		protected var _gapAtExtremity : Boolean;
		protected var _adjustToScrollContainer : Boolean;
		
		private var _tmpWidthRest : Number;

		public function FlowLayout ( container : Container = null, 
									 hgap : Number = 0, 
									 vgap : Number = 0, 
									 align : String = "left",
									 gapAtExtremity : Boolean = false,
									 adjustToScrollContainer : Boolean = false )
		{
			super( container );
			_hgap = hgap;
			_vgap = vgap;
			_align = align;
			_gapAtExtremity = gapAtExtremity;
			_adjustToScrollContainer = adjustToScrollContainer;
		}

		override public function get preferredSize () : Dimension 
		{
			return estimateSize();
		}
		
		public function get gapAtExtremity () : Boolean { return _gapAtExtremity; }		
		public function set gapAtExtremity (gapAtExtremity : Boolean) : void
		{
			_gapAtExtremity = gapAtExtremity;
		}
		
		public function get adjustToScrollContainer () : Boolean { return _adjustToScrollContainer; }		
		public function set adjustToScrollContainer (adjustToScrollContainer : Boolean) : void
		{
			_adjustToScrollContainer = adjustToScrollContainer;
		}
		
		public function get align () : String { return _align; }		
		public function set align (align : String) : void
		{
			_align = align;
		}

		override public function layout ( preferredSize : Dimension = null, insets : Insets = null ) : void 
		{
			insets = insets ? insets : new Insets();
			
			var prefDim : Dimension = preferredSize ? preferredSize.grow( -insets.horizontal, -insets.vertical ) : estimateSize();
			var x : Number = insets.left + (_gapAtExtremity ? _hgap : 0 );
			var y : Number = insets.top + (_gapAtExtremity ? _vgap : 0 );
			var l : Number = _container.childrenCount;
			var i : Number = 0;
			var c : Component;
			var h : Number = 0;
			var line : Array = [];
			
			for( i = 0; i < l; i++ )
			{
				c = _container.children[i];
				if( c.visible )
				{
					if ( x + c.preferredWidth > prefDim.width )
					{
						y += h + _vgap;
						_tmpWidthRest = prefDim.width - ( x - _hgap );
						x = insets.left + (_gapAtExtremity ? _hgap : 0 );
						alignLine ( line );
						line = [];
					}
					
					c.x = x;
					c.y = y;
					h = Math.max( h, c.preferredHeight );
					line.push( c );
					x += c.preferredWidth + _hgap;
				}
			}
			_tmpWidthRest = prefDim.width - ( x - _hgap );
			alignLine ( line );
			line = [];
						
			_tmpWidthRest = NaN;
			
			super.layout();
		}

		protected function alignLine (line : Array) : void 
		{
			var d : Number;
			var l : uint = line.length;
			var i : uint;
			var c : Component;
			
			switch( _align )
			{
				case Alignments.CENTER : 
					d = _tmpWidthRest/2;	
					break;
				case Alignments.RIGHT : 
					d = _tmpWidthRest;
					break;
				case Alignments.LEFT : 
				default : 
					d = 0;
					break;
			}
			for( i = 0; i < l; i++ )
			{
				c = line[i];
				c.x += d;	
			}
		}

		protected function estimateSize ( d : Dimension = null ) : Dimension
		{
			var w : Number = 0;
			var h : Number = 0;
			var l : uint = _container.childrenCount;
			var i : uint;
			var c : Component;
			var lh : Number = _gapAtExtremity ? _vgap*2 : 0;
			var lw : Number = _gapAtExtremity ? _hgap*2 : 0;
			var p : Container;
			var sc : AbstractScrollContainer;
			var d2 : Dimension;
			p = _container.parentContainer;
			if( p && p.size )
				d2 = dm( p.width+16, p.height ).grow( -_container.style.insets.horizontal, -_container.style.insets.vertical );
			for( i = 0; i < l; i++ )
			{
				var isFirstComponent : Boolean = i == 0;
				var g : Number = ( isFirstComponent && !_gapAtExtremity ) ? 0 : _hgap;
				c = _container.children[i];
				if( c.visible )
				{
					//if( sc )
					if( d2 )
					{
						//if( lw + c.preferredSize.width > sc.contentSize.width )
						if( lw + c.preferredSize.width > d2.width )
						{
							h += lh + _hgap;
							w = Math.max(w, lw);
							lw = c.preferredSize.width + (_gapAtExtremity ? _hgap : 0);
							lh = c.preferredSize.height;
                            
						}
						else
						{
							lw += c.preferredSize.width + g;
							lh = Math.max( lh , c.preferredSize.height );
						}
					}
					else
					{
						if( d && lw + c.preferredSize.width > d.width )
						{
							h += lh + _hgap;
							w = Math.max(w, lw);
							lw = c.preferredSize.width + (_gapAtExtremity ? _hgap : 0);
							lh = c.preferredSize.height;
						}
						else
						{
							lw += c.preferredSize.width + g;
							lh = Math.max( h , c.preferredSize.height + (_gapAtExtremity ? _vgap : 0 ) );
						}
					}
				}
			}
			h += lh;
			w = Math.max(w, lw);
			
			if( _gapAtExtremity )
			{
				h += _vgap*2;
			}
			
			return new Dimension( w, h );
		}
	}
}
