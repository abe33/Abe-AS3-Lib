package abe.com.patibility.humanize 
{
	import org.hamcrest.assertThat;

	/**
	 * @author cedric
	 */
	[TestCase(description="Tests the whole set of functions available in the humanize package.")]
	public class HumanizeTest 
	{
		[Test(description="This test verify that the capitalize function works properly.")]
		public function testPlural () : void
		{
			assertThat( plural( 0, 		"singular", "plural" ), "singular" );			assertThat( plural( 1, 		"singular", "plural" ), "singular" );			assertThat( plural( -1, 	"singular", "plural" ), "singular" );			assertThat( plural( NaN, 	"singular", "plural" ), "singular" );
						assertThat( plural( 1.5, 	"singular", "plural" ), "plural" );			assertThat( plural( 2, 		"singular", "plural" ), "plural" );			assertThat( plural( -1.5, 	"singular", "plural" ), "plural" );			assertThat( plural( -2, 	"singular", "plural" ), "plural" );
		}
		[Test(description="This test verify that the capitalize function works properly.")]
		public function testCapitalize () : void
		{
			var s1 : String = "foo";			var s2 : String = "hello world";			var s3 : String = "hello World";
			
			assertThat( capitalize(s1), "Foo" );			assertThat( capitalize(s2), "Hello world" );			assertThat( capitalize(s3), "Hello World" );
		}
		[Test(description="This test verify that the intcomma function correctly split integers.")]
		public function testIntcomma() : void
		{
			assertThat( intcomma( 4500 ), 		"4,500" );			assertThat( intcomma( 45000 ), 		"45,000" );			assertThat( intcomma( 450000 ), 	"450,000" );			assertThat( intcomma( 4500000 ), 	"4,500,000" );			assertThat( intcomma( 45000000 ), 	"45,000,000" );			assertThat( intcomma( 450000000 ), 	"450,000,000" );			assertThat( intcomma( 4500000000 ),	"4,500,000,000" );
		}
		[Test(description="This test verify that all the apnumber cases are handled correctly.")]
		public function testApnumber() : void
		{
			// pure integer
			assertThat( apnumber( 0 ), "0" );				assertThat( apnumber( 1 ), "one" );				assertThat( apnumber( 2 ), "two" );				assertThat( apnumber( 3 ), "three" );				assertThat( apnumber( 4 ), "four" );				assertThat( apnumber( 5 ), "five" );				assertThat( apnumber( 6 ), "six" );				assertThat( apnumber( 7 ), "seven" );				assertThat( apnumber( 8 ), "eight" );				assertThat( apnumber( 9 ), "nine" );				assertThat( apnumber( 10), "10" );	
			
			// integer representation
			assertThat( apnumber( "0" ), "0" );	
			assertThat( apnumber( "1" ), "one" );	
			assertThat( apnumber( "2" ), "two" );	
			assertThat( apnumber( "3" ), "three" );	
			assertThat( apnumber( "4" ), "four" );	
			assertThat( apnumber( "5" ), "five" );	
			assertThat( apnumber( "6" ), "six" );	
			assertThat( apnumber( "7" ), "seven" );	
			assertThat( apnumber( "8" ), "eight" );	
			assertThat( apnumber( "9" ), "nine" );	
			assertThat( apnumber( "10"), "10" );	
			
			// float handling
			assertThat( apnumber( 0.5 ), 		"0" );	
			assertThat( apnumber( 1.1 ), 		"one" );	
			assertThat( apnumber( 2.45 ), 		"two" );	
			assertThat( apnumber( 3.58 ), 		"three" );	
			assertThat( apnumber( 4.54686 ), 	"four" );	
			assertThat( apnumber( 5.12 ),		"five" );	
			assertThat( apnumber( 6.04 ), 		"six" );	
			assertThat( apnumber( 7.5646 ), 	"seven" );	
			assertThat( apnumber( 8.213 ), 		"eight" );	
			assertThat( apnumber( 9.1568 ), 	"nine" );	
			assertThat( apnumber( 10.1231 ), 	"10" );	
		}
		
		[Test(description="This test verify all the special cases of the ordinal function.")]
		public function testOrdinal () : void
		{
			assertThat( ordinal(0), "0th" );			assertThat( ordinal(1), "1st" );			assertThat( ordinal(2), "2nd" );			assertThat( ordinal(3), "3rd" );			assertThat( ordinal(4), "4th" );			assertThat( ordinal(11), "11th" );			assertThat( ordinal(12), "12th" );			assertThat( ordinal(13), "13th" );			assertThat( ordinal(21), "21st" );			assertThat( ordinal(22), "22nd" );			assertThat( ordinal(23), "23rd" );			assertThat( ordinal(201), "201st" );			assertThat( ordinal(211), "211th" );
		}
		[Test(description="This test verify all the cases of the intword function")] 
		public function testIntword() : void
		{
			assertThat( intword(4), "4" );			assertThat( intword(1232), "1232" );			assertThat( intword(100000), "100000" );			assertThat( intword(1000000), "1.0 million" );			assertThat( intword(1200000), "1.2 millions" );			assertThat( intword(1000000000), "1.0 billion" );			assertThat( intword(7567000000), "7.5 billions" );			assertThat( intword(1000000000000), "1.0 trillion" );			assertThat( intword(8500000000000), "8.5 trillions" );
		}
		[Test(description="This test verify the different cases of the naturalday function")]
		public function testNaturalday ():void
		{
			var today : Date = new Date();
			var yesterday : Date = new Date( today.getFullYear(), today.getMonth(), today.getDate() - 1 ); 				var tomorrow : Date = new Date( today.getFullYear(), today.getMonth(), today.getDate() + 1 );
			var anotherDay : Date = new Date( 2002, 12, 12 );
			
			assertThat( naturalday(today), 				"today" ); 			assertThat( naturalday(yesterday), 			"yesterday" ); 			assertThat( naturalday(tomorrow), 			"tomorrow" ); 			assertThat( naturalday(tomorrow, "Y-m-d"), 	"2002-12-12" ); 
		}
	}
}
