package abe.com.ponents.factory
{
	/**
	 * Returns a <code>Function</code> to pass as the value for a <code>kwargs</code> property's value
	 * in the <code>ComponentFactory.build</code> method. The function will return an array of elements
	 * stored in the context at the specified <code>keys</code>.
	 * 
	 * @param	keys	a list of strings to use as the access keys in the context object
	 * @return	a function that will return an array of the elements at <code>keys</code> in the context
	 * @example 
	 * <listing>ComponentFactoryInstance.build( Button, "button1" );
	 * ComponentFactoryInstance.build( Button, "button2" );
	 * 
	 * // add the buttons in the panel using a kwargs
	 * ComponentFactoryInstance.build( Panel, "panel", null, {'addComponents':contextKwargsArgs("button1","button2")}) );</listing>
	 * @author Cédric Néhémie
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
