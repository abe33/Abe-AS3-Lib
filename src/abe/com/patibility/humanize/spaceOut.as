package abe.com.patibility.humanize
{
    import com.adobe.linguistics.spelling.core.utils.StringUtils;
	/**
	 * Returns a <code>String</code> spaced out such as a string 
	 * like <code>hello-world<code> will be returned as <code>hello world</code>.
	 * <p>The function will returns exactly the same output for all of
	 * these strings :</p>
	 * <ul>
	 * <li><listing>hello-world</listing></li>	 * <li><listing>hello_world</listing></li>	 * <li><listing>HelloWorld</listing></li></ul>
	 * @author cedric
	 */
	public function spaceOut ( s : String ) : String 
	{
		s = s.replace( /([A-Z]{1})([^A-Z]*)/g , " $1$2");
		s = s.replace( /_|-/g, " " );
		
		return StringUtils.trim( s.toLowerCase() );
	}
}
