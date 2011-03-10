/**
 * @license
 */
package abe.com.mon.utils
{
	import flash.system.ApplicationDomain;
	
	/**
	 * @param	query	<code>String</code> to be evaluated according to the rules below
	 * @param	domain	an <code>ApplicationDomain</code> used to retrieve
	 * 					references to the requested classes
	 * @return	the result of the evaluation according to the rules described in the
	 * 			<code>Reflection#get()</code> examples
	 * @copy Reflection#get()
	 * @see Reflection#get() Take a look to the Reflection.get() method for details about the syntax
	 */
	public function $ ( query : String, domain : ApplicationDomain ) : *
	{
		return Reflection.get( query, domain );
	}
}