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
			assertThat( plural( 0, 		"singular", "plural" ), "singular" );
			
		}
		[Test(description="This test verify that the capitalize function works properly.")]
		public function testCapitalize () : void
		{
			var s1 : String = "foo";
			
			assertThat( capitalize(s1), "Foo" );
		}
		[Test(description="This test verify that the intcomma function correctly split integers.")]
		public function testIntcomma() : void
		{
			assertThat( intcomma( 4500 ), 		"4,500" );
		}
		[Test(description="This test verify that all the apnumber cases are handled correctly.")]
		public function testApnumber() : void
		{
			// pure integer
			assertThat( apnumber( 0 ), "0" );	
			
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
			assertThat( ordinal(0), "0th" );
		}
		[Test(description="This test verify all the cases of the intword function")] 
		public function testIntword() : void
		{
			assertThat( intword(4), "4" );
		}
		[Test(description="This test verify the different cases of the naturalday function")]
		public function testNaturalday ():void
		{
			var today : Date = new Date();
			var yesterday : Date = new Date( today.getFullYear(), today.getMonth(), today.getDate() - 1 ); 	
			var anotherDay : Date = new Date( 2002, 12, 12 );
			
			assertThat( naturalday(today), 				"today" ); 
		}
	}
}