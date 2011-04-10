package abe.com.mon.utils 
{
	import org.hamcrest.assertThat;
	import org.hamcrest.object.equalTo;
	/**
	 * @author cedric
	 */
	[TestCase(description="These tests verify the StringUtils methods.")]
	public class StringUtilsTest 
	{
		[Test(description="This test test verify that the tokenReplace method works with both positional and keyword arguments.")]
		public function tokenReplace () : void
		{	
			// handle only positionnal arguments
			assertThat( StringUtils.tokenReplace( "$0", "foo" ), 
						equalTo( "foo" ) );
						assertThat( StringUtils.tokenReplace( "$0$1$2 is $0 $1itch", "a", "b", "e" ), 
						equalTo( "abe is a bitch" ) );
			
			// handle only keyword arguments
			assertThat( StringUtils.tokenReplace( "${foo}" , {'foo':"foo"}), 
						equalTo( "foo" ) );
			
			assertThat( StringUtils.tokenReplace( "${bar}${foo}${bar}" , {'foo':"foo",'bar':"bar"}), 
						equalTo( "barfoobar" ) );
			
			// handle both positionnal and keyword arguments
			assertThat( StringUtils.tokenReplace( "${name} is a $0 $1" , {'name':"abe"}, "fucking", "bitch" ), 
						equalTo( "abe is a fucking bitch" ) );
			
			// handle missing arguments or missing key
			assertThat( StringUtils.tokenReplace( "${}" ), equalTo( "${}" ) );
			assertThat( StringUtils.tokenReplace( "${}", {'foo':"bar"} ), equalTo( "${}" ) );			assertThat( StringUtils.tokenReplace( "${}", "foo" ), equalTo( "${}" ) );						assertThat( StringUtils.tokenReplace( "$0" ), equalTo( "$0" ) );
			assertThat( StringUtils.tokenReplace( "$0", {'foo':"bar"} ), equalTo( "$0" ) );
		}
	}
}
