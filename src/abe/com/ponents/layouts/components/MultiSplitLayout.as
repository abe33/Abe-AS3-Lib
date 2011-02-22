package abe.com.ponents.layouts.components 
{
	import abe.com.mon.geom.Dimension;
	import abe.com.patibility.lang._;
	import abe.com.patibility.lang._$;
	import abe.com.ponents.core.Component;
	import abe.com.ponents.core.Container;
	import abe.com.ponents.events.SplitPaneEvent;
	import abe.com.ponents.layouts.components.splits.Divider;
	import abe.com.ponents.layouts.components.splits.Leaf;
	import abe.com.ponents.layouts.components.splits.Node;
	import abe.com.ponents.layouts.components.splits.Split;
	import abe.com.ponents.utils.Insets;

	import flash.geom.Rectangle;

	[Event(name="optimize", type="abe.com.ponents.events.SplitPaneEvent")]
	/**
	 * @author Cédric Néhémie
	 */
	public class MultiSplitLayout extends AbstractComponentLayout 
	{
		protected var _modelRoot : Node;
		protected var _dividerSize : Number;
		protected var _dividerFloating : Boolean;
			
		public function MultiSplitLayout (container : Container = null, model : Node = null)
		{
			super( container );
			_modelRoot = model ? model : new Split();
			_dividerSize = 5;
			_dividerFloating = true;
		}

		public function get modelRoot () : Node { return _modelRoot; }		
		public function set modelRoot (modelRoot : Node) : void
		{
			_modelRoot = modelRoot;
		}
		
		public function get dividerSize () : Number { return _dividerSize; }		
		public function set dividerSize (dividerSize : Number) : void
		{
			_dividerSize = dividerSize;
		}
		
		public function get dividerFloating () : Boolean { return _dividerFloating; }
		
		override public function get preferredSize () : Dimension
		{
			return estimatedSize();
		}

		override public function layout (preferredSize : Dimension = null, insets : Insets = null) : void
		{
			insets = insets ? insets : new Insets();
			
			var prefDim : Dimension = preferredSize ? preferredSize.grow( -insets.horizontal, -insets.vertical ) : estimatedSize();
			
			if( _modelRoot )
				layoutNode( _modelRoot, prefDim, insets.left, insets.top );
			super.layout( preferredSize, insets );
		}

		protected function layoutNode ( n : Node, size : Dimension, x : Number, y : Number ) : void
		{
			if( n is Leaf )
				layoutLeaf(n as Leaf, size, x, y);
			else if( n is Split )
				layoutChildren(n as Split, size, x, y);
		}

		protected function layoutChildren ( s : Split, size : Dimension, x : Number, y : Number ) : void
		{
			var c : Object = s.children;
			
			var l : Number = c.length;
			var oldBounds : Rectangle = s.bounds;
			var n : Node;
			var totalWeight : Number = 0;
			
			s.bounds = new Rectangle( x, y, size.width, size.height );
			
			for( i = 0; i < l; i += 2)
			{
				n = c[i];
				totalWeight += n.weight;
			}
			
			if( oldBounds )
			{
				var dif : Number;
				var difinc : Number = 0;
				var r : Number;
				var nn : Number = 0;
				if( s.rowLayout )
				{
					dif = size.width - oldBounds.width;
					if( dif != 0 )
						for( i = 0; i < l; i += 2)
						{
							n = c[i];
							d = ( i + 1 < l ) ? c[i+1] as Divider : null;
							nd = preferredNodeSize( n );
							
							if( d )
							{
								r = d.location / oldBounds.width;
								
								if( isNaN( d.location ) )
									d.location = nn + nd.width;
								
								difinc += dif * ( n.weight / totalWeight );
								d.location += difinc;								lockLocation(d);								//d.location = size.width * r;
								nn += d.location;
							} 
						}				}
				else
				{
					dif = size.height - oldBounds.height;	
					if( dif != 0 )
						for( i = 0; i < l; i += 2)
						{
							n = c[i];
							d = ( i + 1 < l ) ? c[i+1] as Divider : null;
							nd = preferredNodeSize( n );
							
							if( d )
							{
								if( isNaN( d.location ) )
									d.location = nn + nd.height;
								
								difinc += dif * ( n.weight / totalWeight );
								d.location += difinc;
								lockLocation(d);
								nn += d.location;
							} 
						}				
				}
				
			}
			if( l == 1 )
			{
				layoutNode( c[0], size, x, y );	
			}
			else if( l > 1 )
			{
				var w : Number = 0;				var h : Number = 0;
				var nd : Dimension;
				var d : Divider;
				var i : Number;
				
				if( s.rowLayout )
				{
					for( i = 0; i < l; i += 2)
					{
						n = c[i];
						d = ( i + 1 < l ) ? c[i+1] as Divider : null;
						
						if( d )
						{
							if( isNaN( d.location ) )
							{
								nd = preferredNodeSize( n );
								layoutNode(n, new Dimension( nd.width, size.height ), x, y );
								d.bounds = new Rectangle( x + nd.width, y, _dividerSize, size.height );								x += nd.width + _dividerSize;								w += nd.width + _dividerSize;
							}
							else
							{
								layoutNode(n, new Dimension( d.location-w, size.height ), x, y );
								x += d.location-w + _dividerSize;
								d.bounds = new Rectangle( x - _dividerSize, y, _dividerSize, size.height );
								w += d.location-w + _dividerSize;
							}
						}
						else
						{
							layoutNode(n, new Dimension( size.width - w, size.height ), x, y );
						}
					}
				}
				else
				{
					for( i = 0; i < l; i += 2)
					{
						n = c[i];
						d = ( i + 1 < l ) ? c[i+1] as Divider : null;
						
						if( d )
						{
							if( isNaN( d.location ) )
							{
								nd = preferredNodeSize( n );
								layoutNode(n, new Dimension( size.width, nd.height ), x, y );
								d.bounds = new Rectangle( x, y + nd.height, size.width, _dividerSize );								y += nd.height + _dividerSize;
								h += nd.height + _dividerSize;
							}
							else
							{
								layoutNode(n, new Dimension( size.width, d.location-h ), x, y );
								y += d.location-h + _dividerSize;
								d.bounds = new Rectangle( x, y - _dividerSize, size.width, _dividerSize );
								h += d.location-h + _dividerSize;
							}
						}
						else
						{
							layoutNode(n, new Dimension( size.width, size.height - h ), x, y );
						}
					}
				}
			}
		}
		
		protected function lockLocation ( d : Divider ) : void
		{
			var previous : Divider = d.siblingAtOffset(-2) as Divider;
			var next : Divider = d.siblingAtOffset(2) as Divider;
			var ds : Number = _dividerSize;
			var parentBounds : Rectangle = d.parent.bounds;
				
			if( d.isVertical() )
				{
					var y : Number = d.location;
					
					if( previous && y < previous.bounds.bottom )
						y = previous.bounds.bottom;
					else if( next && y + ds > next.bounds.top )
						y = next.bounds.top - ds;
					else if( parentBounds && y + ds > parentBounds.height )
						y = parentBounds.height - ds;
					else if( y < 0 )
						y = 0;
					
					d.location = y;
				}
				else
				{
					var x : Number = d.location;
						
					if( previous && x < previous.bounds.right )
						x = previous.bounds.right;
					else if( next && x + ds > next.bounds.left )
						x = next.bounds.left - ds;
					else if(parentBounds && x + ds > parentBounds.width )
						x = parentBounds.width - ds;
					else if( x < 0 )
						x = 0;
					
					d.location = x;
				}
		}

		protected function layoutLeaf ( l : Leaf, size : Dimension, x : Number, y : Number ) : void
		{
			l.component.x = x;
			l.component.y = y;
			l.component.size = new Dimension( Math.max( 0, size.width ), Math.max( 0, size.height ) );	
		}

		protected function estimatedSize () : Dimension
		{
			return preferredNodeSize( _modelRoot );
		}
		
		public function preferredNodeSize ( node : Node ) : Dimension
		{
			var d : Dimension;
			
			if( node is Divider )
			{
				d = new Dimension(_dividerSize,_dividerSize);
			}
			else if( node is Leaf )
			{
				d = (node as Leaf).component.preferredSize;
			}
			else if( node is Split )
			{
				var n : Node;
				var s : Split = node as Split;
				var w : Number = 0;				var h : Number = 0;
				var nd : Dimension;
				if( s.rowLayout )
				{
					for each( n in s.children )
					{
						nd = preferredNodeSize( n );
						w += nd.width;
						h = Math.max( h, nd.height );
					}
				}
				else
				{
					for each( n in s.children )
					{
						nd = preferredNodeSize( n );
						h += nd.height;
						w = Math.max( w, nd.width );
					}
				}
				d = new Dimension(w, h);
			}
			return d;
		}
		public function dividerAt( root : Node, x : Number, y : Number ) : Divider
		{
			if(!root)
				return null;
			
			if (root is Divider) 
			{
		        var divider : Divider = root as Divider;
		        
			    return divider.bounds.contains(x, y) ? divider : null;
			}
			else if (root is Split) 
			{
			    var split : Split = root as Split;
			    for each (var child : Node in split.children) 
					if (child.bounds.contains(x, y))
				    	return dividerAt(child, x, y);
			}
			return null;
	    }
	    public function disableFloating() : void
		{
			_dividerFloating = false;
			_disableFloating( _modelRoot );
		}

		protected function _disableFloating( n : Node ) : void
		{
			if( n is Divider )
			  ( n as Divider ).disableFloating();
			else if( n is Split )
			{
				for each ( var child : Node in ( n as Split ).children )
					_disableFloating( child );
			}
		}
		
		public function addSplitChild( parent : Split, child : Node, optimize : Boolean = true ) : void
		{
			if(!parent)
				throw new ReferenceError(_$(_("The parent can't be null while adding a child to a split node in $0.addSplitChild($1, $2, $3)"),
											this, parent, child, optimize));
			
			var c : Object = parent.children;
			
			if( c.length == 0 )
				c.push( child );
			else
			{
				var d : Divider = new Divider();
				d.parent = parent;
				c.push( d );
				c.push( child );
			}
			child.parent = parent;
			
			if( optimize )
				optimizeStructure ();
		}
		public function addSplitChildAfter( parent : Split, child : Node, after : Node, optimize : Boolean = true ) : void
		{
			if(!parent)
				throw new ReferenceError(_$(_("The parent can't be null while adding a child to a split node in $0.addSplitChildAfter($1, $2, $3, $4)"),
											this, parent, child, after, optimize));
			
			var c : Object = parent.children;
			var index : int = c.indexOf(after);
			if( index != -1 )
			{
				index++;
				var d : Divider = new Divider();
				d.parent = parent;
				if( index < c.length )
				{
					//if( after is Divider )
						c.splice(index, 0, d, child );
					/*else
						c.splice(index, 0, child, d );*/
				}
				else
				{
					c.push( d );
					c.push( child );
				}
			}
			child.parent = parent;
			
			if( optimize )
				optimizeStructure ();
		}
		public function addSplitChildBefore( parent : Split, child : Node, before : Node, optimize : Boolean = true ) : void
		{
			if(!parent)
				throw new ReferenceError(_$(_("The parent can't be null while adding a child to a split node in $0.addSplitChildBefore($1, $2, $3, $4)"),
											this, parent, child, before, optimize));
			
			var c : Object = parent.children;
			var index : int = c.indexOf(before);
			if( index != -1 )
			{
				var d : Divider = new Divider();
				d.parent = parent;
				if( before is Divider )
					c.splice(index, 0, d, child );
				else					c.splice(index, 0, child, d );
			}
			child.parent = parent;
			
			if( optimize )
				optimizeStructure ();
		}
		public function removeSplitChild( parent : Split, child : Node, optimize : Boolean = true ) : void
		{
			if(!parent)
				throw new ReferenceError(_$(_("The parent can't be null while removing a child from a split node in $0.removeSplitChild($1, $2, $3)"),
											this, parent, child, optimize));
			
			
			var c : Object = parent.children;
			var l : Number = c.length;
			
			if( l == 1 && c[0] == child )
				c.pop();
			else if( l > 1 )
			{
				var previous : Node = child.previousSiblings();
				if( !previous )
					c.splice( 0, 2 );
				else if( previous is Divider )
					c.splice( c.indexOf( previous ) , 2 );
			}
			
			if( optimize )
				optimizeStructure ();
		}
		public function replaceSplitChild ( parent : Split, replace : Node, by : Node, optimize : Boolean = true ) : void
		{
			if(!parent)
				throw new ReferenceError(_$(_("The parent can't be null while replacing a child from a split node in $0.replaceSplitChild($1, $2, $3, $4)"),
											this, parent, replace, by, optimize));

			var c : Object = parent.children;
			var index : int = c.indexOf(replace);
			if( index != -1 )
			{
				c.splice(index, 1, by);
				by.parent = parent;
			}
			
			if( optimize )
				optimizeStructure ();
		}
		public function mergeSplitWithParent( split : Split, optimize : Boolean = true ) : void
		{
			if( split.parent )
			{
				//Log.debug( next );
				for( var i : uint = 0; i < split.children.length; i++ )
				{
					var n : Node = split.children[i];
					if( !( n is Divider ) )
					{
						addSplitChildAfter( split.parent, n, split, false );
					}
				}
				removeSplitChild( split.parent, split, false );
			}
			//Log.debug( split.parent.children);
			
			if( optimize )
				optimizeStructure ();
		}
		public function getLeafParent ( comp : Component, root : Split = null ) : Leaf
		{
			if (!root)
				root = _modelRoot as Split;
				
			var l : Leaf;
			
			for each( var n : Node in root.children )
			{
				if( n is Leaf && ( n as Leaf ).component == comp )
					return ( n as Leaf );
				else if( n is Split )
				{
					l = getLeafParent( comp, n as Split );
					if( l )
						return l;
				}
			}
			return null;
		}
		public function optimizeStructure () : void
		{
			var root : Node = modelRoot;
			if( root is Split )
			{
				var split : Split = root as Split;
				_optimizeStructure(split, 0);
			}
			dispatchEvent( new SplitPaneEvent( SplitPaneEvent.OPTIMIZE ) );
		}
		protected function _optimizeStructure ( split : Split, d : Number = 0 ) : void
		{
			//var s : String = StringUtils.fill( "* ", d, "  ", false );
			//Log.debug( s + "enter optimize " + split );
			var l : uint = split.children.length;
			var n : Node; 
			
			if( split == modelRoot )
			{
				//Log.debug( s + "is root" );
				while( l-- )
				{
					n = split.children[l];
					if( n is Split )
						_optimizeStructure( n as Split, d + 1 );
				}
				//Log.debug( s + "after root, children = " + split.children.length );
			}
			else
			{
				if( l > 0 )
				{
					while( l-- )
					{
						n = split.children[l];
						if( n is Split )
							_optimizeStructure( n as Split, d + 1 );
					}
				}
				l = split.children.length;
				
				//Log.debug( s + "after optimize " + split + ", children = " + l );				
				if( l == 1 )
				{
					replaceSplitChild( split.parent, split, split.children[0], false );
					//Log.debug( s + "replaced split by its first child " + split.children[0] );
				}
				else if( l == 0 )
				{
					removeSplitChild( split.parent, split, false );
					//Log.debug( s + "removed split" );
				}
				else if( split.parent.rowLayout == split.rowLayout )
				{
					mergeSplitWithParent( split, false );
					//Log.debug( s + "merged split with parent" );
				}
			}
		}
	}
}
