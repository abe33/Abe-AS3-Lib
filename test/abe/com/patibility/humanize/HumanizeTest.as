package abe.com.patibility.humanize 
{
	import org.hamcrest.assertThat;
	import org.hamcrest.object.equalTo;
	import abe.com.patibility.humanize.*;
	/**
	 * @author cedric
	 */
	[TestCase(description="Tests the whole set of functions available in the humanize package.",order=2)]
	public class HumanizeTest 
	{
		[Test]
		public function spaceOut() : void
		{
			assertThat( abe.com.patibility.humanize.spaceOut( "hello-world" ), equalTo( "hello world" ) );			assertThat( abe.com.patibility.humanize.spaceOut( "hello_world" ), equalTo( "hello world" ) );			assertThat( abe.com.patibility.humanize.spaceOut( "HelloWorld" ), equalTo( "hello world" ) );			assertThat( abe.com.patibility.humanize.spaceOut( "ImAnObjectA" ), equalTo( "im an object a" ) );			assertThat( abe.com.patibility.humanize.spaceOut( "ImAn_object-a" ), equalTo( "im an object a" ) );
		}
		[Test(description="This test verify that the capitalize function works properly.")]
		public function plural () : void
		{
			assertThat( abe.com.patibility.humanize.plural( 0, 		"singular", "plural" ), "singular" );			assertThat( abe.com.patibility.humanize.plural( 1, 		"singular", "plural" ), "singular" );			assertThat( abe.com.patibility.humanize.plural( -1, 	"singular", "plural" ), "singular" );			assertThat( abe.com.patibility.humanize.plural( NaN, 	"singular", "plural" ), "singular" );
						assertThat( abe.com.patibility.humanize.plural( 1.5, 	"singular", "plural" ), "plural" );			assertThat( abe.com.patibility.humanize.plural( 2, 		"singular", "plural" ), "plural" );			assertThat( abe.com.patibility.humanize.plural( -1.5, 	"singular", "plural" ), "plural" );			assertThat( abe.com.patibility.humanize.plural( -2, 	"singular", "plural" ), "plural" );
		}
		[Test(description="This test verify that the capitalize function works properly.")]
		public function capitalize () : void
		{
			var s1 : String = "foo";			var s2 : String = "hello world";			var s3 : String = "hello World";
			
			assertThat( abe.com.patibility.humanize.capitalize(s1), "Foo" );			assertThat( abe.com.patibility.humanize.capitalize(s2), "Hello world" );			assertThat( abe.com.patibility.humanize.capitalize(s3), "Hello World" );
		}
		[Test(description="This test verify that the intcomma function correctly split integers.")]
		public function intcomma() : void
		{
			assertThat( abe.com.patibility.humanize.intcomma( 4500 ), 		"4,500" );			assertThat( abe.com.patibility.humanize.intcomma( 45000 ), 		"45,000" );			assertThat( abe.com.patibility.humanize.intcomma( 450000 ), 	"450,000" );			assertThat( abe.com.patibility.humanize.intcomma( 4500000 ), 	"4,500,000" );			assertThat( abe.com.patibility.humanize.intcomma( 45000000 ), 	"45,000,000" );			assertThat( abe.com.patibility.humanize.intcomma( 450000000 ), 	"450,000,000" );			assertThat( abe.com.patibility.humanize.intcomma( 4500000000 ),	"4,500,000,000" );
		}
		[Test(description="This test verify that all the apnumber cases are handled correctly.")]
		public function apnumber() : void
		{
			// pure integer
			assertThat( abe.com.patibility.humanize.apnumber( 0 ), "0" );				assertThat( abe.com.patibility.humanize.apnumber( 1 ), "one" );				assertThat( abe.com.patibility.humanize.apnumber( 2 ), "two" );				assertThat( abe.com.patibility.humanize.apnumber( 3 ), "three" );				assertThat( abe.com.patibility.humanize.apnumber( 4 ), "four" );				assertThat( abe.com.patibility.humanize.apnumber( 5 ), "five" );				assertThat( abe.com.patibility.humanize.apnumber( 6 ), "six" );				assertThat( abe.com.patibility.humanize.apnumber( 7 ), "seven" );				assertThat( abe.com.patibility.humanize.apnumber( 8 ), "eight" );				assertThat( abe.com.patibility.humanize.apnumber( 9 ), "nine" );				assertThat( abe.com.patibility.humanize.apnumber( 10), "10" );	
			
			// integer representation
			assertThat( abe.com.patibility.humanize.apnumber( "0" ), "0" );	
			assertThat( abe.com.patibility.humanize.apnumber( "1" ), "one" );	
			assertThat( abe.com.patibility.humanize.apnumber( "2" ), "two" );	
			assertThat( abe.com.patibility.humanize.apnumber( "3" ), "three" );	
			assertThat( abe.com.patibility.humanize.apnumber( "4" ), "four" );	
			assertThat( abe.com.patibility.humanize.apnumber( "5" ), "five" );	
			assertThat( abe.com.patibility.humanize.apnumber( "6" ), "six" );	
			assertThat( abe.com.patibility.humanize.apnumber( "7" ), "seven" );	
			assertThat( abe.com.patibility.humanize.apnumber( "8" ), "eight" );	
			assertThat( abe.com.patibility.humanize.apnumber( "9" ), "nine" );	
			assertThat( abe.com.patibility.humanize.apnumber( "10"), "10" );	
			
			// float handling
			assertThat( abe.com.patibility.humanize.apnumber( 0.5 ), 		"0" );	
			assertThat( abe.com.patibility.humanize.apnumber( 1.1 ), 		"one" );	
			assertThat( abe.com.patibility.humanize.apnumber( 2.45 ), 		"two" );	
			assertThat( abe.com.patibility.humanize.apnumber( 3.58 ), 		"three" );	
			assertThat( abe.com.patibility.humanize.apnumber( 4.54686 ), 	"four" );	
			assertThat( abe.com.patibility.humanize.apnumber( 5.12 ),		"five" );	
			assertThat( abe.com.patibility.humanize.apnumber( 6.04 ), 		"six" );	
			assertThat( abe.com.patibility.humanize.apnumber( 7.5646 ), 	"seven" );	
			assertThat( abe.com.patibility.humanize.apnumber( 8.213 ), 		"eight" );	
			assertThat( abe.com.patibility.humanize.apnumber( 9.1568 ), 	"nine" );	
			assertThat( abe.com.patibility.humanize.apnumber( 10.1231 ), 	"10" );	
		}
		
		[Test(description="This test verify all the special cases of the ordinal function.")]
		public function ordinal () : void
		{
			assertThat( abe.com.patibility.humanize.ordinal(0), "0th" );			assertThat( abe.com.patibility.humanize.ordinal(1), "1st" );			assertThat( abe.com.patibility.humanize.ordinal(2), "2nd" );			assertThat( abe.com.patibility.humanize.ordinal(3), "3rd" );			assertThat( abe.com.patibility.humanize.ordinal(4), "4th" );			assertThat( abe.com.patibility.humanize.ordinal(11), "11th" );			assertThat( abe.com.patibility.humanize.ordinal(12), "12th" );			assertThat( abe.com.patibility.humanize.ordinal(13), "13th" );			assertThat( abe.com.patibility.humanize.ordinal(21), "21st" );			assertThat( abe.com.patibility.humanize.ordinal(22), "22nd" );			assertThat( abe.com.patibility.humanize.ordinal(23), "23rd" );			assertThat( abe.com.patibility.humanize.ordinal(201), "201st" );			assertThat( abe.com.patibility.humanize.ordinal(211), "211th" );
		}
		[Test(description="This test verify all the cases of the intword function")] 
		public function intword() : void
		{
			assertThat( abe.com.patibility.humanize.intword(4), "4" );			assertThat( abe.com.patibility.humanize.intword(1232), "1232" );			assertThat( abe.com.patibility.humanize.intword(100000), "100000" );			assertThat( abe.com.patibility.humanize.intword(1000000), "1.0 million" );			assertThat( abe.com.patibility.humanize.intword(1200000), "1.2 millions" );			assertThat( abe.com.patibility.humanize.intword(1000000000), "1.0 billion" );			assertThat( abe.com.patibility.humanize.intword(7567000000), "7.5 billions" );			assertThat( abe.com.patibility.humanize.intword(1000000000000), "1.0 trillion" );			assertThat( abe.com.patibility.humanize.intword(8500000000000), "8.5 trillions" );
		}
		[Test(description="This test verify the different cases of the naturalday function")]
		public function naturalday ():void
		{
			var today : Date = new Date();
			var yesterday : Date = new Date( today.getFullYear(), today.getMonth(), today.getDate() - 1 ); 				var tomorrow : Date = new Date( today.getFullYear(), today.getMonth(), today.getDate() + 1 );
			var anotherDay : Date = new Date( 2002, 12, 12 );
			
			assertThat( abe.com.patibility.humanize.naturalday(today), 				"today" ); 			assertThat( abe.com.patibility.humanize.naturalday(yesterday), 			"yesterday" ); 			assertThat( abe.com.patibility.humanize.naturalday(tomorrow), 			"tomorrow" ); 			assertThat( abe.com.patibility.humanize.naturalday(tomorrow, "Y-m-d"), 	"2002-12-12" ); 
		}
	}
}
