package aesia.com.ponents.layouts.components 
{
	import aesia.com.mon.geom.Dimension;
	import aesia.com.ponents.core.Component;
	import aesia.com.ponents.core.Container;
	import aesia.com.ponents.utils.Alignments;
	import aesia.com.ponents.utils.Insets;

	/**
	 * @author Cédric Néhémie
	 */
	public class HBoxLayout extends AbstractComponentLayout
	{
		protected var _boxes : Vector.<BoxSettings>;
		protected var _gap : Number;
		protected var _align : String;
		
		public function HBoxLayout ( container : Container, gap : Number = 3, ... boxes )
		{
			super( container );
			_gap = gap;
			_boxes = boxes ? Vector.<BoxSettings> ( boxes ) : new Vector.<BoxSettings> ();
		}
		public function setObjectForBox( object : Component, id : uint = 0 ) : void
		{
			_boxes[ id ].object = object;
		}
		public function get gap () : Number { return _gap; }		
		public function set gap (gap : Number) : void
		{
			_gap = gap;
		}
		
		public function get boxes () : Vector.<BoxSettings>	{ return _boxes; }		
		public function set boxes (boxes : Vector.<BoxSettings>) : void
		{
			_boxes = boxes;
		}
		public function get align () : String { return _align; }	
		public function set align (align : String) : void 
		{
			_align = align; 
		}
		public function get columnsSizes () : Array
		{
			var a : Array = [];
			var l : Number = _boxes.length;
			var i : Number;
			
			for(i=0;i<l;i++)
			{
				var box : BoxSettings = _boxes[ i ];
				var o : Component = box.object;
				var s : Number = box.size;
				
				if( o )
					a[ i ] = Math.max( o.preferredSize.width, s );
				else
					a[ i ] = s;
			}
			return a;
		}
		override public function get preferredSize () : Dimension { return estimatedSize(); }

		override public function layout ( preferredSize : Dimension = null, insets : Insets = null ) : void
		{
			insets = insets ? insets : new Insets();
			
			var innerPref : Dimension = estimatedSize();
			var prefDim : Dimension = preferredSize ? preferredSize.grow( -insets.horizontal, -insets.vertical ) : innerPref;
			
			var l : Number = _boxes.length;
			var i : Number = 0;
			var x : Number = insets.left;
			var numStretch : Number = 0;
			var box : BoxSettings;
			for(i=0;i<l;i++)
			{
				box = _boxes[ i ];
				if( box.stretch )
					numStretch++;
			}
			var compensate : Number = numStretch != 0 ? ( prefDim.width - innerPref.width ) / numStretch : 0;			for(i=0;i<l;i++)
			{
				box = _boxes[ i ];
				var o : Component = box.object;
				var s : Number = box.size;
				
				if( o )
				{
					if( s < o.preferredSize.width && ( !box.fitW || box.stretch ) )
						s = o.preferredSize.width;
						
					if( box.stretch )
						s += compensate;
						
					if( box.fitW )
						o.width = s;
						
					if( box.fitH )
						o.height = prefDim.height;
					
					o.x = x + Alignments.alignHorizontal( o.width, s, new Insets(), box.halign );
					o.y = insets.top + Alignments.alignVertical( o.height, prefDim.height, new Insets(), box.valign );
				}
				x += s;
				if( i != l-1 )					x += _gap;
			}
			super.layout( preferredSize, insets );
		}

		protected function estimatedSize () : Dimension
		{
			var l : Number = _boxes.length;
			var w : Number = 0;
			var h : Number = 0;
			var i : Number;
			
			for(i=0;i<l;i++)
			{
				var box : BoxSettings = _boxes[ i ];
				var o : Component = box.object;
				var s : Number = box.size;
				
				if( o && s < o.preferredSize.width && ( !box.fitW || box.stretch ) )
					s = o.preferredSize.width;
				
				if( s != 0 )
					w += s + ( i != l-1 ? _gap : 0 );
				else if( !isNaN( s ) && s == 0 && o )
					w += o.preferredSize.width + ( i != l-1 ? _gap : 0 );
				else if( o )
					w += o.preferredSize.width + ( i != l-1 ? _gap : 0 );
				
				if( o )
					h = Math.max( h, o.preferredSize.height ); 
			}
			
			return new Dimension( w, h );
		}
	}
}
