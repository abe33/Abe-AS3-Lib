package abe.com.ponents.factory
{
	/**
	 * Returns a <code>Function</code> to pass as the value for a <code>kwargs</code> property's value
	 * in the <code>ComponentFactory.build</code> method. The function will return the element stored
	 * in the context at the specified <code>key</code>.
	 * 
	 * @param	key	a string to use as the access key in the context object
	 * @return	a function that will return the element at <code>key</code> in the context
	 * @example 
	 * <listing>ComponentFactoryInstance.build( DefaultListModel, "model", ["item1","item2","item3"] );
	 * 
	 * // retreive the model from the context
	 * ComponentFactoryInstance.build( List, "list", null, {'model':contextKwargsArg("model"), 'allowEdit':false}) );</listing>
	 * @author Cédric Néhémie
	 */
	public function contextKwargsArg ( key : String ) : Function 
	{
		var kk : String = key;
		return function( o : *, k : String, context : Object ) : * { return context[ kk ]; };
	}
}
