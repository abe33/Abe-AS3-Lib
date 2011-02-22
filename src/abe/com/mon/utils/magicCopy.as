package abe.com.mon.utils
{
	import abe.com.mon.core.Copyable;
	/**
	 * @author cedric
	 */
	public function magicCopy ( a : Object, b : Object ) : void 
	{
		if( a is Copyable && b is Copyable )
			( b as Copyable ).copyFrom( a );		else if( b is Copyable )
			( b as Copyable ).copyFrom( a );
		else if( a is Copyable )
			( a as Copyable ).copyTo( b );
		else
		{
			var i : String;
			if( Reflection.isObject( a ) )
			{
				for( i in a )
					if( b.hasOwnProperty(i) )
						b[i] = a[i];
			}
			else if( Reflection.isObject( b ) )
			{
				for( i in b )
					if( a.hasOwnProperty(i) )
						b[i] = a[i];
			}
			else
			{
				var o : Object = Reflection.asAnonymousObject( a, false );
				for( i in o )
					if( b.hasOwnProperty(i) )
						b[i] = o[i];
			}
		}
	}
}
