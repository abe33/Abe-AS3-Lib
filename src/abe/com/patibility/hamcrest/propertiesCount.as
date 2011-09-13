package abe.com.patibility.hamcrest
{
    import org.hamcrest.Matcher;
	/**
	 * @author cedric
	 */
	public function propertiesCount (value : Object ) : Matcher 
	{
		return new PropertiesCountMatcher(value);
	}
}
