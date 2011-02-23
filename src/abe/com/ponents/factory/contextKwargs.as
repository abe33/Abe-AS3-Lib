package abe.com.ponents.factory
{
	/**
	 * Returns a <code>Function</code> to pass as the <code>kwargs</code> argument in the
	 * <code>ComponentFactory.build</code> method. The function will use the <code>fromContext</code>
	 * argument passed to the <code>contextKwargs</code> to build the <code>Object</code> to return.
	 * <p>
	 * The extra <code>kwargs</code> let you define a base object to decorate
	 * with the datas from the context.
	 * </p>
	 * @param	fromContext	an object that will define which data to get from the context
	 * 						and in which property storing the data in the returned object.
	 * 						The object must take the following form : 
	 * 						<listing>{ 
	 * 	'outputPropertyName1' : 'contextPropertyName1', 	 * 	'outputPropertyName2' : 'contextPropertyName2', 
	 * 	...	 * 	'outputPropertyNameN' : 'contextPropertyNameN'
	 * }</listing> 
	 * @param	kwargs		an object that will serve as the base object to decorate
	 * 						and to return
	 * @return	a function that will build an object according to the structure defined in
	 * 			the arguments
	 * @example 
	 * <listing>ComponentFactoryInstance.build( DefaultListModel, "model", ["item1","item2","item3"] );
	 * 
	 * // when the following build will be performed, the function returned
	 * // by contextKwargs will be called, and an object with the previously 
	 * // built model will be returned
	 * ComponentFactoryInstance.build( List, "list", null, contextKwargs({'model':"model"}) );</listing>
	 * 
	 * <listing>ComponentFactoryInstance.build( DefaultListModel, "model", ["item1","item2","item3"] );
	 * 
	 * // The same as above, but with an extra kwargs object
	 * ComponentFactoryInstance.build( List, "list", null, contextKwargs({'model':"model"},{'allowEdit':false}) );</listing>
	 * @author Cédric Néhémie
	 */
	public function contextKwargs ( fromContext : Object, kwargs : Object = null ) : Function 
	{
		var a : Object = kwargs ? kwargs : {};
		var b : Object = fromContext;
		return function( o : *, context : Object ) : Object 
		{
			for( var i : String in b )
				a[i] = context[ b[ i ] ];

			return a;
		};
	}
}
