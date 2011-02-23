package abe.com.ponents.factory
{
	/**
	 * @author cedric
	 */
	public function contextKwargsArgs ( ... keys ) : Function 
	{
		var kk : Array = keys;
		return function( o : *, k : String, context : Object ) : * 
		{ 
			var a : Array = [];
			for each( var s : String in kk )
				a.push( context[ s ] );

			return a;
		};
	}
}
