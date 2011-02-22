package abe.com.mon.grids 
{
	import abe.com.mon.core.Cloneable;
	import abe.com.mon.core.Equatable;
	import abe.com.mon.core.Serializable;
	import abe.com.mon.geom.Dimension;
	import abe.com.mon.utils.MathUtils;

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getQualifiedClassName;

	/**
	 * @author Cédric Néhémie
	 */
	public class UIntVectorGrid extends EventDispatcher implements Grid, UIntGrid, Cloneable, Equatable, Serializable
	{
		protected var _width : uint;
		protected var _height : uint;
		protected var _data : Vector.<Vector.<uint>>;
			
		public function UIntVectorGrid ( width : uint, height : uint, ... initialData ) 
		{
			_width = width;
			_height = height;
			var i : uint;
			var l : uint;
			var d : Dimension;
			var p : Point;
			// on a des données initiales
			if( initialData.length > 0 )
			{
				// cas d'un vecteur d'entier en 2 dimensions
				// les données sont le vecteur	 
				if( initialData[0] is Vector.<Vector.<uint>> &&
					initialData[0].length == _width && 
					initialData[0][0].length == _height )
				{
					_data = initialData[0];
				}
				// cas d'un vecteur ou d'un tableau en une dimension
				else if( ( initialData[0] is Vector.<uint> || 
						   initialData[0] is Array ) && 
						 initialData[0].length == _width * _height )
				{
					_data = new Vector.<Vector.<uint>>( _width );
				
					for( i = 0; i < _width; i++ )
						_data[i] = new Vector.<uint>( _height );
						
					l = initialData[0].length;
					d = new Dimension(_width,_height);
					for( i = 0; i < l; i++ )
					{
						p = MathUtils.id2pos( i, d );
						_data[p.x][p.y] = initialData[0][i];
					}
				}
				// cas d'une liste d'argument direct
				else if( initialData.length == _width * _height )
				{
					_data = new Vector.<Vector.<uint>>( _width );
				
					for( i = 0; i < _width; i++ )
						_data[i] = new Vector.<uint>( _height );
						
					l = initialData.length;
					d = new Dimension(_width,_height);
					for( i = 0; i < l; i++ )
					{
						p = MathUtils.id2pos( i, d );
						_data[p.x][p.y] = initialData[i];
					}
				}
				// données initiales non comformes
				else
				{
					_data = new Vector.<Vector.<uint>>( _width );
					
					for( i = 0; i < _width; i++ )
						_data[i] = new Vector.<uint>( _height );
				}
			}
			// aucune données initiale
			else
			{
				_data = new Vector.<Vector.<uint>>( _width );
				
				for( i = 0; i < _width; i++ )
					_data[i] = new Vector.<uint>( _height );
			}
		}
		/*---------------------------------------------------------*
		 * GETTER/SETTER
		 *---------------------------------------------------------*/
		public function get width () : uint { return _width; }
		public function get height () : uint { return _height; }
		public function get data () : Vector.<Vector.<uint>>
		{
			return _data;
		}
		/*---------------------------------------------------------*
		 * READ/WRITE
		 *---------------------------------------------------------*/
		public function get (x : uint, y : uint) : uint 
		{
			if( isValidCoordinates(x, y) )
				return _data[x][y];
			else throw new ArgumentError( "Arguments in get("+x+","+y+") are " +
										  "not valid coordinates for this "+_width+"x"+_height+" grid" );
										  
			return 0;
		}		
		public function set (x : uint, y : uint, v : uint) : void
		{
			if( isValidCoordinates(x, y) )
				_data[x][y] = v;
			else throw new ArgumentError( "Arguments in set("+x+","+y+") are " +
										  "not valid coordinates for this "+_width+"x"+_height+" grid" );
		}

		public function getPoint (pt : Point) : uint
		{
			if( isValidPoint( pt ) )
				return _data[pt.x][pt.y];
			else throw new ArgumentError( "Argument in getPoint("+pt+") are " +
										  "not valid coordinates for this "+_width+"x"+_height+" grid" );
			
			return 0;
		}	
			
		public function setPoint (pt : Point, v : uint) : void
		{
			if( isValidPoint( pt ) )
				_data[pt.x][pt.y] = v;
			else throw new ArgumentError( "Argument in setPoint("+pt+") are " +
										  "not valid coordinates for this "+_width+"x"+_height+" grid" );
		}
		/*---------------------------------------------------------*
		 * SWAPING DATA METHODS
		 *---------------------------------------------------------*/
		public function swap( x1 : uint, y1 : uint, x2 : uint, y2 : uint ) : void
		{
			if( isValidCoordinates(x1, y1) && isValidCoordinates(x2, y2) )	
			{
				var n : uint = _data[x1][y1];
				_data[x1][y1] = _data[x2][y2];
				_data[x2][y2] = n;
			}
			else throw new ArgumentError( "One (or many) of the arguments in swap("+x1+","+y1+","+x2+","+y2+") are " +
										  "not valid coordinates for this "+_width+"x"+_height+" grid" );
		}
		public function swapPoint( pt1 : Point, pt2 : Point ) : void
		{
			if( isValidPoint(pt1) && isValidPoint(pt2) )	
			{
				var n : uint = _data[pt1.x][pt1.y];
				_data[pt1.x][pt1.y] = _data[pt2.x][pt2.y];
				_data[pt2.x][pt2.y] = n;
			}
			else throw new ArgumentError( "One (or both) of the arguments in swapPoint("+pt1+","+pt2+") are " +
										  "not valid coordinates for this "+_width+"x"+_height+" grid" );
		}
		
		/*---------------------------------------------------------*
		 * ROW/COL PUSH
		 *---------------------------------------------------------*/
		public function pushRowToLeft (row : uint) : void
		{
			if( isValidRow( row ) )
			{
				var safe : uint = _data[0][row];
				var x : uint;
				for( x = 1; x < _width; x++ )
				{
					_data[x-1][row] = _data[x][row];
				}
				_data[_width-1][row] = safe;
			}
			else throw new ArgumentError( "There's no row at " + row +" for "+_width+"x"+_height+" grid" );
		}
		
		public function pushRowToRight (row : uint) : void
		{
			if( isValidRow( row ) )
			{
				var safe : uint = _data[_width-1][row];
				var x : uint;
				for( x = _width-1; x > 0; x-- )
				{
					_data[x][row] = _data[x-1][row];
				}
				_data[0][row] = safe;
			}
			else throw new ArgumentError( "There's no row at " + row +" for "+_width+"x"+_height+" grid" );
		}
		
		public function pushColToTop (col : uint) : void
		{
			if( isValidCol( col ) )
				_data[col].push( _data[col].shift() );
			else 
				throw new ArgumentError( "There's no colon at " + col +" for "+_width+"x"+_height+" grid" );
		}
		
		public function pushColToBottom (col : uint) : void
		{
			if( isValidCol( col ) )
				_data[col].unshift( _data[col].pop() );
			else 
				throw new ArgumentError( "There's no colon at " + col +" for "+_width+"x"+_height+" grid" );
		}
		/*---------------------------------------------------------*
		 * MATCH 3 METHODS
		 *---------------------------------------------------------*/
		
		
		 
		/*---------------------------------------------------------*
		 * VALIDATION METHODS
		 *---------------------------------------------------------*/
		public function isValidRow (row : uint) : Boolean
		{
			return row < height;
		}
		
		public function isValidCol (col : uint) : Boolean
		{
			return col < width;
		}
		public function isValidCoordinates (x : uint, y : uint) : Boolean
		{
			return x < _width && 
				   y < _height;
		}
		
		public function isValidPoint (pt : Point) : Boolean
		{
			return pt.x < _width &&
				   pt.y < _height;
		}
		
		/*---------------------------------------------------------*
		 * CLONING METHODS
		 *---------------------------------------------------------*/
		
		public function clone () : *
		{
			return new UIntVectorGrid(_width, _height, toArray() );
		}
		
		public function subGrid (r : Rectangle) : Grid
		{
			if( isValidCoordinates( r.x, r.y ) && 
				isValidCoordinates( r.bottom, r.right ) )
			{
				var nv : Vector.<Vector.<uint>> = new Vector.<Vector.<uint>>( r.width );
				for( var i : uint = 0 ; i < r.width ; i++ )
				{
					nv[i] = _data[r.x].slice(r.y,r.right);
				}
				return new UIntVectorGrid(r.width, r.height, nv );
			}
			else throw new ArgumentError( "Rectangle arguments in subGrid("+r+") isn't contained in " +
										  "this "+_width+"x"+_height+" grid" );
			return null;
		}
		
		
		/*---------------------------------------------------------*
		 * VARIOUS METHODS
		 *---------------------------------------------------------*/
		public function equals (o : *) : Boolean
		{
			if( o is UIntVectorGrid )
			{
				var g : UIntVectorGrid = o as UIntVectorGrid;
				if( g.width == _width && g.height == _height )
				{
					for( var i : uint = 0; i < _width; i++ )
					{
						if( String(g[i]) != String(_data[i]) )
							return false;	
					}
					return true;
				}
			}
			return false;
		}
		public function toSource () : String
		{
			return toReflectionSource().replace("::", ".");
		}
		public function toReflectionSource () : String
		{
			return "new "+getQualifiedClassName(this)+"( "+width+", "+ height+", [" + toArray() + "] )";
		}
		public function toArray () : Array
		{
			var a : Array = [];
			var x : uint;
			var y : uint;
			for(y=0;y<_height;y++)
			{
				
				for(x=0;x<_width;x++)
				{
					a.push( _data[x][y] );
				}
			}
			return a;
		}
		override public function toString() : String 
		{
			var s : String = "";
			var x : uint;
			var y : uint;
			for(y=0;y<_height;y++)
			{
				s+="|";				for(x=0;x<_width;x++)
				{
					s+= _data[x][y];
					if( x != _width-1 )
						s+=",";
				}
				s+="|\n";
			}

			return "[object UIntVectorGrid("+_width+","+_height+")]\n" + s;
		}
		
		override public function dispatchEvent( evt : Event) : Boolean 
		{
			if (hasEventListener(evt.type) || evt.bubbles) 
				return super.dispatchEvent(evt);
			return true;
		}
	}
}
