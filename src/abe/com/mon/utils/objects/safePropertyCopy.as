package abe.com.mon.utils.objects
{
	/**
	 * @author cedric
	 */
	public function safePropertyCopy ( fromObject : Object, 
									   fromProperty : String, 
									   toObject : Object, 
									   toProperty : String ) : void 
	{
		if( !fromObject.hasOwnProperty( fromProperty ) ||
			!toObject.hasOwnProperty( toProperty ) )
			return;
		
		try
		{
			toObject[ toProperty ] = fromObject[ fromProperty ];
		}
		catch( e : Error )
		{
			return;
		}
	}
}
