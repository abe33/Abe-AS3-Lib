package abe.com.ponents.models 
{
	import abe.com.patibility.lang._;
	import abe.com.patibility.lang._$;
	import abe.com.ponents.events.ComponentEvent;
	import abe.com.ponents.events.ListEvent;

	import flash.events.Event;
	import org.osflash.signals.Signal;

	/**
	 * @author Cédric Néhémie
	 */
	public class DefaultListModel implements ListModel 
	{
	    static public const ADD : uint = 0;
		static public const SET : uint = 1;
		static public const MOVE : uint = 2;
		static public const REMOVE : uint = 3;
		static public const CLEAR : uint = 4;
		static public const SORT : uint = 5;
		static public const REBUILD : uint = 6;
	
		protected var _datas : Array;
		protected var _immutable : Boolean;
		protected var _contentType : Class;
		
		protected var _dataChanged : Signal;
		
		public function DefaultListModel ( initialData : Array = null )
		{
			_datas = initialData ? initialData : [];
			_dataChanged = new Signal();
		}
		
		/*-----------------------------------------------------------------
		 * 	GETTERS / SETTERS
		 *----------------------------------------------------------------*/
		public function get dataChanged() : Signal { return _dataChanged; }
		
		public function get contentType () : Class { return _contentType; }	
		public function set contentType (contentType : Class) : void
		{
			_contentType = contentType;
			checkContentType( _datas );
		}
		public function get size () : uint { return _datas.length; }		 
		public function get firstElement () : *	{  return get( 0 ); }
		public function get lastElement () : * { return get( size - 1 ); }
		
		public function get immutable () : Boolean { return _immutable; }		
		public function set immutable (immutable : Boolean) : void
		{
			_immutable = immutable;
		}
		/*-----------------------------------------------------------------
		 * 	MODELS MANIPULATION METHODS
		 *----------------------------------------------------------------*/
		
		public function get (id : uint) : *
		{
			if( id < _datas.length )
				return _datas[ id ];
			else
				return null;
		}
		public function set ( id : uint, el : * ) : void
		{
			if( !_immutable && id < _datas.length )
			{
				if( _contentType == null || el is _contentType )
				{
					_datas[ id ] = el;
					fireDataChangedSignal( SET, [id], [el] ); 
				}
				else
				{
					throw new TypeError( _$( _( "Can't set item at $0 with $1 in this model with contentType set to $2." ), id, el, _contentType ) );
				}
			}
		}
		public function add ( id : uint, el : * ) : void
		{
			if( !_immutable  )
			{
				if( _contentType == null || el is _contentType )
				{
					if( id < _datas.length )
					{
						_datas.splice( id, 0, el );
						fireDataChangedSignal( ADD, [id], [el]); 
					}
					else
					{
						_datas.push( el );
						fireDataChangedSignal( ADD, [_datas.length-1], [el]); 
					}
				}
				else
				{
					throw new TypeError( _$( _( "Can't add $0 in this model with contentType set to $1." ), el, _contentType ) );
				}
			}
		}
		public function addMany ( id : uint, els : Array ) : void
		{
			if( !_immutable  )
			{
				var l : int = _datas.length;
				var l2 : int;
				var indices : Array = [];
				var i : int;
				
				checkContentType( els );
							
				if( id < l )
				{
					_datas.splice.apply( _datas, [ id, 0 ].concat(els) );
					
					l2 = id + els.length;
					for( i = id ; i < l2 ; i++ )
						indices.push(i);
					
					fireDataChangedSignal( ADD, indices, els); 
				}
				else
				{
					_datas.push.apply( _datas, els );
					
					l2 = id + els.length;
					for( i = l ; i < l2 ; i++ )
						indices.push(i);
					
					fireDataChangedSignal( ADD, indices, els); 
				}
			}
		}

		public function remove ( id : uint ) : void
		{
			if( !_immutable && id < _datas.length )
			{
				var el : Array = _datas.splice( id, 1 );
				fireDataChangedSignal( REMOVE, [id], el ); 
			}
		}
		public function clear() : void
		{
			if( !_immutable )
			{
				var a : Array = _datas.map( function( it : *,i : int,... args):*{ return i; } );
				var b : Array = _datas.concat();
				
				_datas = [];
				fireDataChangedSignal( CLEAR, a, b );
			} 
		}
		public function contains ( el : * ) : Boolean
		{
			return _datas.indexOf( el ) != -1;
		}
		public function getElementAt (id : uint) : *
		{
			return get( id ); 
		}
		public function setElementAt (id : uint, el : *) : void
		{
			set( id, el ); 
		}		
		public function addElement ( el : * ) : void
		{
			if( !_immutable )
				add( _datas.length, el ); 
		}
		public function addElementAt ( el : *, id : uint ) : void
		{
			add(id, el);
		}		
		public function removeElement ( el : * ) : void
		{
			if( contains( el ) )
				remove( indexOf( el ) );
		}
		public function removeElementAt ( id : uint ) : void
		{
			remove( id );
		}		
		public function removeAllElements () : void
		{
			clear();
		}
		public function removeRange ( from : uint, to : uint ) : void
		{
			if( !_immutable && 
				from < _datas.length &&
				to < _datas.length &&
				from < to )
			{
				var a : Array = [];
				for(var i : Number = from; i< to;i++)
					a.push(i);
					
				var els : Array = _datas.splice( from, to - from );
				
				fireDataChangedSignal( REMOVE, a, els ); 
			}
		}
		public function setElementIndex (el : *, id : uint) : void
		{
			var index : int = indexOf( el );
			
			if( _contentType != null && !(el is _contentType) )
				throw new TypeError(_$(_( "The element $0 don't match the content type $1 of this model" ), el, _contentType ) );
			
			if( id > 0 && id > index )
				id--;
			
			_datas.splice( index, 1 );
			_datas.splice( id, 0, el );
			fireDataChangedSignal( MOVE, [id], [el] );
		}
		public function indexOf ( el : * ) : int
		{
			return _datas.indexOf( el );
		}
		public function lastIndexOf ( el : * ) : int
		{
			return _datas.lastIndexOf( el );
		}	
		public function sort (...args : *) :Array
		{
			_datas.sort.apply( _datas, args );
			fireDataChangedSignal( SORT );
			return _datas;
		}
		public function sortOn (fieldName : Object, options : Object = null) : Array
		{
			_datas.sortOn.call( _datas, fieldName, options );
			fireDataChangedSignal( SORT );
			return _datas;
		}
		public function toArray () : Array
		{
			return _datas.concat();
		}
		protected function checkContentType (els : Array) : void 
		{
			if( _contentType )
			{
				var l : int = els.length;
				var i : int;
				for(i=0;i < l;i++)
					if( !( els[i] is _contentType ) )
						throw new TypeError( _$( _( "The type of $0 don't match the contentType $1 for this model." ), els[i], _contentType ) );
			}
		}
		/*-----------------------------------------------------------------
		 * 	EVENTS METHODS
		 *----------------------------------------------------------------*/

		public function fireDataChangedSignal ( action : uint = 0, indices : Array = null, values : Array = null ) : void
		{
			dataChanged.dispatch( action, indices, values );
		}

	}
}
