package abe.com.ponents.layouts.components 
{
	import abe.com.mon.geom.Dimension;
	import abe.com.ponents.core.Component;
	import abe.com.ponents.core.Container;
	import abe.com.ponents.utils.Alignments;
	import abe.com.ponents.utils.Insets;

	/**
	 * @author Cédric Néhémie
	 */
	public class VBoxLayout extends AbstractComponentLayout
	{
		/*FDT_IGNORE*/
		TARGET::FLASH_9 
		protected var _boxes : Array;
		
		TARGET::FLASH_10
		protected var _boxes : Vector.<BoxSettings>;
		
		TARGET::FLASH_10_1 /*FDT_IGNORE*/
		protected var _boxes : Vector.<BoxSettings>;
		
		protected var _gap : Number;
		protected var _align : String;
		protected var _adjustLastBoxToRest : Boolean;
		
		public function VBoxLayout ( container : Container, gap : Number = 3, ... boxes )
		{
			super( container );
			_gap = gap;
			
			/*FDT_IGNORE*/
			TARGET::FLASH_9 { _boxes = boxes ? boxes : []; }
			TARGET::FLASH_10 { _boxes = boxes ? Vector.<BoxSettings> ( boxes ) : new Vector.<BoxSettings> (); }
			TARGET::FLASH_10_1 { /*FDT_IGNORE*/
			_boxes = boxes ? Vector.<BoxSettings> ( boxes ) : new Vector.<BoxSettings> (); /*FDT_IGNORE*/ } /*FDT_IGNORE*/
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
		
		/*FDT_IGNORE*/
		TARGET::FLASH_9 {
			public function get boxes () : Array	{ return _boxes; }		
			public function set boxes (boxes : Array ) : void { _boxes = boxes; }
		}
		TARGET::FLASH_10 {
			public function get boxes () : Vector.<BoxSettings>	{ return _boxes; }		
			public function set boxes (boxes : Vector.<BoxSettings>) : void { _boxes = boxes; }	
		}
		TARGET::FLASH_10_1 {
		/*FDT_IGNORE*/
		public function get boxes () : Vector.<BoxSettings>	{ return _boxes; }		
		public function set boxes (boxes : Vector.<BoxSettings>) : void { _boxes = boxes; }
		/*FDT_IGNORE*/ } /*FDT_IGNORE*/
		
		public function get align () : String { return _align; }	
		public function set align (align : String) : void 
		{
			_align = align; 
		}
		public function get adjustLastBoxToRest () : Boolean { return _adjustLastBoxToRest;	}		
		public function set adjustLastBoxToRest (adjustLastBoxToRest : Boolean) : void
		{
			_adjustLastBoxToRest = adjustLastBoxToRest;
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
					a[ i ] = Math.max( o.preferredSize.height, s );
				else
					a[ i ] = s;
			}
			return a;
		}
		
		override public function get preferredSize () : Dimension { return estimatedSize( ); }

		override public function layout ( preferredSize : Dimension = null, insets : Insets = null ) : void
		{
			insets = insets ? insets : new Insets();
			
			var innerPref : Dimension = estimatedSize();
			var prefDim : Dimension = preferredSize ? preferredSize.grow( -insets.horizontal, -insets.vertical ) : innerPref;
			
			var l : Number = _boxes.length;
			var i : Number = 0;
			var y : Number = insets.top;
			var numStretch : Number = 0;
			var box : BoxSettings;
			for(i=0;i<l;i++)
			{
				box = _boxes[ i ];
				if( box.stretch )
					numStretch++;
			}
			var compensate : Number = numStretch != 0 ? ( prefDim.height - innerPref.height ) / numStretch : 0;
			for(i=0;i<l;i++)
			{
				box = _boxes[ i ];
				var o : Component = box.object;
				var s : Number = box.size;
				
				if( o )
				{
					if( s < o.preferredSize.height && ( box.stretch || !box.fitH ) )
						s = o.preferredSize.height;
						
					if( box.stretch )
						s += compensate;
						
					if( box.fitH )
						o.height = s;
						
					if( box.fitW )
						o.width = prefDim.width;
					
					o.x = insets.left + Alignments.alignHorizontal( o.width , prefDim.width, new Insets(), box.halign );
					o.y = y + Alignments.alignVertical( o.height, s, new Insets(), box.valign );
				}
				if( s != 0 )
					y += s + _gap;
			}
			super.layout( preferredSize, insets );
		}

		protected function estimatedSize () : Dimension
		{
			var l : Number = _boxes.length;
			var i : Number = 0;
			var w : Number = 0;
			var h : Number = 0;
			
			for(;i<l;i++)
			{
				var box : BoxSettings = _boxes[ i ];
				var o : Component = box.object;
				var s : Number = box.size;
				
				if( s != 0 )
					h += s + _gap;
				else if( s == 0 && o )
					h += o.preferredSize.height + _gap;
				
				if( o )
					w = Math.max( w, o.preferredSize.width ); 
			}
			
			return new Dimension( w, h );
		}
	}
}
