package abe.com.mon.utils.objects 
{
	import org.hamcrest.assertThat;
	import org.hamcrest.core.not;
	import org.hamcrest.object.equalTo;
	import org.hamcrest.object.hasProperty;

	import flash.geom.Point;

	/**
	 * @author cedric
	 */
	[TestCase(description="These tests verify that the objects related function works as expected.")]
	public class ObjectTest 
	{
		[Test(description="This test verify that the hasOwnProperties succeed in testing the existence of properties on an object.")]
		public function hasOwnProperties () : void
		{
			var o : Object;
			
			o = {'foo':10,'bar':20};
			
			assertThat( abe.com.mon.utils.objects.hasOwnProperties( o, "foo", "bar" ), 
						equalTo(true) );
						
			assertThat( abe.com.mon.utils.objects.hasOwnProperties( o, "foo", "bar", "pop" ), 
						equalTo(false) );
						
			assertThat( abe.com.mon.utils.objects.hasOwnProperties( o ),
						equalTo( true ) );
						
			o = {};
			
			assertThat( abe.com.mon.utils.objects.hasOwnProperties( o, "foo", "bar" ), 
						equalTo(false) );
		}
		[Test(description="This test verify that the safe")]
		public function safePropertyCopy () : void
		{
			var a : Object = {'x':15,'y':25};
			var b : Object = {'x':45,'y':65};
			var p : Point = new Point(45,50);
			
			abe.com.mon.utils.objects.safePropertyCopy( a, "x", b, "x" );			abe.com.mon.utils.objects.safePropertyCopy( b, "y", a, "y" );			
			assertThat( b, hasProperty( "x", equalTo( 15 ) ) );			assertThat( a, hasProperty( "y", equalTo( 65 ) ) );
						abe.com.mon.utils.objects.safePropertyCopy( b, "y", b, "x" );
			assertThat( b, hasProperty( "x", equalTo( 65 ) ) );			
			abe.com.mon.utils.objects.safePropertyCopy( p, "length", a, "length" );			assertThat( a, not( hasProperty( "length" ) ) );			
			var l : Number = p.length;
			abe.com.mon.utils.objects.safePropertyCopy( a, "x", p, "length" );
			assertThat( p, hasProperty( "length", equalTo( l ) ) );
		}
	}
}
