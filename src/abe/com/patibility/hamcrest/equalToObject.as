package abe.com.patibility.hamcrest
{
	import org.hamcrest.Matcher;
	
	/**
	 * Provides deep equality comparison using the <code>magicEquals</code> function for testing.
	 * 
	 * @author Cédric Néhémie
	 */
	public function equalToObject (value : Object ) : Matcher
    {
        return new IsEqualObjectMatcher( value );
    }
}
