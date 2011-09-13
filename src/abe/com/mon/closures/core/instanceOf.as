package abe.com.mon.closures.core
{
    import abe.com.mon.utils.Reflection;
	/**
	 * @author cedric
	 */
	public function instanceOf ( cls : Class ) : Function 
	{
		return function ( o : *, ... args ) : Boolean
		{
			return Reflection.getClass(o) === cls;
		};
	}
}
