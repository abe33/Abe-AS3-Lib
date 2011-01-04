package aesia.com.ponents.layouts.display
{
	import aesia.com.mon.geom.Dimension;
	import aesia.com.ponents.utils.Alignments;
	import aesia.com.ponents.utils.Insets;

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;

	/**
	 * @author Cédric Néhémie
	 */
	public class DOHBoxLayout extends AbstractDisplayObjectLayout
	{
		/*FDT_IGNORE*/
		TARGET::FLASH_9
		protected var _boxes : Array;
		
		TARGET::FLASH_10
		protected var _boxes : Vector.<DOBoxSettings>;
		
		TARGET::FLASH_10_1 /*FDT_IGNORE*/
		protected var _boxes : Vector.<DOBoxSettings>;
		
		protected var _gap : Number;
		protected var _adjustLastBoxToRest : Boolean;

		public function DOHBoxLayout ( container : DisplayObjectContainer, gap : Number = 3, ... boxes )
		{
			super( container );
			_gap = gap;
			_adjustLastBoxToRest = false;
			
			/*FDT_IGNORE*/
			TARGET::FLASH_9 { _boxes = boxes ? boxes : []; }
			TARGET::FLASH_10 { _boxes = boxes ? Vector.<DOBoxSettings> ( boxes ) : new Vector.<DOBoxSettings> (); }
			TARGET::FLASH_10_1 { /*FDT_IGNORE*/
			_boxes = boxes ? Vector.<DOBoxSettings> ( boxes ) : new Vector.<DOBoxSettings> (); /*FDT_IGNORE*/ } /*FDT_IGNORE*/
		}

		public function setObjectForBox( object : DisplayObject, id : uint = 0 ) : void
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
		public function get boxes () : Array { return _boxes; }
		public function set boxes ( o : Array ) : void { _boxes = o; }
		}
		TARGET::FLASH_10 {
		public function get boxes () : Vector.<DOBoxSettings> { return _boxes; }
		public function set boxes ( o : Vector.<DOBoxSettings> ) : void { _boxes = o; }
		}
		TARGET::FLASH_10_1 { /*FDT_IGNORE*/
		public function get boxes () : Vector.<DOBoxSettings> { return _boxes; }
		public function set boxes ( o : Vector.<DOBoxSettings> ) : void { _boxes = o; }
		/*FDT_IGNORE*/}/*FDT_IGNORE*/

		public function get columnsSizes () : Array
		{
			var a : Array = [];
			var l : Number = _boxes.length;
			var i : Number;

			for(i=0;i<l;i++)
			{
				var box : DOBoxSettings = _boxes[ i ];
				var o : DisplayObject = box.object;
				var s : Number = box.size;

				if( o )
					a[ i ] = Math.max( o.width, s );
				else
					a[ i ] = s;
			}

			return a;
		}
		public function get adjustLastBoxToRest () : Boolean { return _adjustLastBoxToRest; }
		public function set adjustLastBoxToRest ( adjustLastBoxToRest : Boolean) : void
		{
			_adjustLastBoxToRest = adjustLastBoxToRest;
		}

		override public function get preferredSize () : Dimension { return estimatedSize( ); }

		override public function layout ( preferredSize : Dimension = null, insets : Insets = null ) : void
		{
			insets = insets ? insets : new Insets();

			var prefDim : Dimension = preferredSize ? preferredSize : estimatedSize().grow( insets.horizontal, insets.vertical );
			var l : Number = _boxes.length;
			var i : Number = 0;
			var x : Number = insets.left;
			var stretchable : Array = [];
			var sizes : Array = [];
			var sum : Number= 0;
			var dif : Number;
			var perComp : Number;
			var box : DOBoxSettings;
			var o : DisplayObject;
			var s : Number;

			for( var j : int = 0; j < l; j++ )
			{
				box = _boxes[ j ];
				o = box.object;
				s = box.size;
				if( o && ( ( s < o.width && !box.stretch ) || isNaN ( s ) ) )
					sizes[j] = o.width;
				else
					sizes[j] = box.size;

				sum += sizes[j] + _gap;

				if( box.stretch )
					stretchable.push( box );
			}

			dif = prefDim.width - sum -_gap - insets.horizontal;
			if( dif != 0 && stretchable.length )
				perComp = dif / stretchable.length;
			else
				perComp = 0;

			for(;i<l;i++)
			{
				box = _boxes[ i ];
				o = box.object;
				s = sizes[i];

				if( s == 0 && (!box.fitW && !box.stretch) && o )
					s = o.width;

				if( box.stretch )
					s += perComp;

				if( o )
				{
					if( box.fitW )
						o.width = s;
					if( box.fitH )
						o.height = prefDim.height;

					o.x = x + Alignments.alignHorizontal( o.width , s, new Insets(), box.halign );
					o.y = Alignments.alignVertical( o.height, prefDim.height, new Insets(), box.valign );
				}

				x += s + _gap;
			}

		}

		protected function estimatedSize () : Dimension
		{
			var l : Number = _boxes.length;
			var w : Number = 0;
			var h : Number = 0;
			var i : Number;

			for(i=0;i<l;i++)
			{
				var box : DOBoxSettings = _boxes[ i ];
				var o : DisplayObject = box.object;
				var s : Number = box.size;

				if( o && s < o.width && ( !box.fitW || box.stretch ) )
					s = o.width;

				if( s != 0 )
					w += s + ( i != l-1 ? _gap : 0 );
				else if( !isNaN( s ) && s == 0 && o )
					w += o.width + ( i != l-1 ? _gap : 0 );
				else if( o )
					w += o.width + ( i != l-1 ? _gap : 0 );

				if( o )
					h = Math.max( h, o.height );
			}

			return new Dimension( w, h );
		}
	}
}
