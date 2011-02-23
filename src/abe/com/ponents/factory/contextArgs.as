package abe.com.ponents.factory
{
	/**
	 * Returns a <code>Function</code> to pass as the <code>args</code> argument in the
	 * <code>ComponentFactory.build</code> method. The function will use the arguments
	 * passed to the <code>contextArgs</code> function as keys to retreive datas from 
	 * the context.
	 * <p>
	 * You can pass as many arguments as you wish, the datas order will be the same as
	 * the arguments one. 
	 * </p>
	 * 
	 * @param	args	a list of context keys
	 * @return	a function which will construct an array from the context using
	 * 			the passed-in arguments as keys
	 * @example 
	 * <listing>ComponentFactoryInstance.build( DefaultListModel, "model", ["item1","item2","item3"] );
	 * 
	 * // when the following build will be performed, the function returned
	 * // by contextArgs will be called, and an array with the previously 
	 * // built model will be returned
	 * ComponentFactoryInstance.build( List, "list", contextArgs("model") );</listing>
	 * @author Cédric Néhémie
	 */
	public function contextArgs ( ... args ) : Function 
	{
		var b : Array = args;
		return function( context : Object ) : Array 
		{
			var a : Array = [];
			for each( var s : String in b )
				a.push( context[ s ] );

			return a;
		};
	}
}
