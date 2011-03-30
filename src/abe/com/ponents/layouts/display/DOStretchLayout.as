/**
 * @license
 */
package abe.com.ponents.layouts.display
{
	import abe.com.mon.geom.Dimension;
	import abe.com.ponents.utils.Alignments;
	import abe.com.ponents.utils.Insets;

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Rectangle;
	/**
	 * @author Cédric Néhémie
	 */
	public class DOStretchLayout extends AbstractDisplayObjectLayout
	{
		protected var _refChildIndex : Number;		protected var _refChild : DisplayObject;
		protected var _keepRatio : Boolean;

		public function DOStretchLayout ( container : DisplayObjectContainer = null, ... arg )
		{
			super( container );
			var l : uint = arg.length;
			var childDone : Boolean = false;			var keepDone : Boolean = false;
			for( var i:uint =0;i<l;i++ )
			{
				var o : * = arg[i];
				if( o is DisplayObject && !childDone )
				{
					refChild = o;
					childDone = true;
				}
				else if( o is Number && !childDone )
				{
					refChildIndex = o;
					childDone = true;
				}
				else if( o is Boolean && !keepDone )
				{
					_keepRatio = o;
					keepDone = true;
				}
			}
		}
		public function get keepRatio () : Boolean { return _keepRatio;	}
		public function set keepRatio (keepRatio : Boolean) : void { _keepRatio = keepRatio; }
		
		public function get refChildIndex () : Number {	return _refChildIndex; }
		public function set refChildIndex (refChildIndex : Number) : void
		{
			if( !isNaN( refChildIndex ) &&
						refChildIndex >= 0 &&
						refChildIndex < _container.numChildren )
			{
				_refChildIndex = refChildIndex;
				_refChild = _container.getChildAt( refChildIndex );
			}
		}

		public function get refChild () : DisplayObject
		{
			return _refChild;
		}

		public function set refChild (refChild : DisplayObject) : void
		{
			if( refChild && _container.contains( refChild as DisplayObject ) )
			{
				_refChild = refChild;
				_refChildIndex = _container.getChildIndex( refChild );
			}
		}

		override public function get preferredSize () : Dimension { return estimateSize (); }

		override public function layout ( preferredSize : Dimension = null, insets : Insets = null ) : void
		{
			insets = insets ? insets : new Insets();
			var s : Dimension = preferredSize ? preferredSize.grow( -insets.horizontal, -insets.vertical ) : estimateSize();
			var c : DisplayObject;
			var bb : Rectangle;
			var i : Number;
			var l : Number = _container.numChildren;
			for(i=0;i<l;i++)
			{
				c = _container.getChildAt( i );
				c.x = c.y = 0;
				bb = c.getBounds(c.parent);
				
				if( _keepRatio )
				{
					var w:Number = c.width;					var h:Number = c.height;
					var ratio:Number = w/h;					var sw : Number = s.width;
					var sh : Number = s.height;					var ratio2:Number = sw/sh;

					if( w > sw )
					{
						if( h > sh && ratio < ratio2 )
						{
							c.height = sh;
							c.width = sh * ratio;
						}
						else
						{
							c.width = sw;
							c.height = sw / ratio;
						}
					}
					else if( h > sh )
					{
						if( w > sw && ratio > ratio2 )
						{
							c.width = sw;
							c.height = sw / ratio;
						}
						else
						{
							c.height = sh;
							c.width = sh * ratio;
						}
					}
					c.x = Alignments.alignHorizontal ( c.width, preferredSize.width, insets, "center" ) - bb.left;					c.y = Alignments.alignVertical ( c.height, preferredSize.height, insets, "center" ) - bb.top;
				}
				else
				{
					c.width = s.width;					c.height = s.height;
					c.x = insets.left - bb.left;
					c.y = insets.top - bb.top;
				}

			}
		}

		protected function estimateSize () : Dimension
		{
			if( _refChild )
				return new Dimension( _refChild.width, _refChild.height );

			var d : Dimension = new Dimension();
			var c : DisplayObject;
			var i : Number;
			var l : Number = _container.numChildren;

			for(i=0;i<l;i++)
			{
				c = _container.getChildAt( i );
				d.width = Math.max( d.width, c.width );				d.height = Math.max( d.height, c.height );
			}

			return d;
		}
	}
}
