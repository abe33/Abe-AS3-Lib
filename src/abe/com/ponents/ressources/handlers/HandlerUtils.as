package abe.com.ponents.ressources.handlers 
{
    import abe.com.mon.utils.objects.keys;
    import abe.com.patibility.lang._$;
	/**
	 * @author cedric
	 */
	public class HandlerUtils 
	{
		static public function getField( label : String, value : String ) : String
		{
			return _$("<font size='10'>$0 : <font color='#666666'>$1</font></font>", label, value );
		}
		static public function getList( ... args ) : String
		{
			var a : Array;
			if( args.length == 1 && args[0] is Array )
				a = args[0];
			else
				a = args;
							
			return a.join("\n");
		}
		public static function getFields ( o : Object ) : String 
		{
			var k : Array = keys( o );
			var a : Array = [];
			k.sort();
			
			for each( var key : String in k )
				a.push( getField( key, o[key] ) );
			
			return getList(a);
		}
	}
}
