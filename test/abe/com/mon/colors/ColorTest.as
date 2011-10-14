package abe.com.mon.colors 
{
	import abe.com.mon.utils.MathUtils;
	import abe.com.patibility.hamcrest.equalToObject;
	import abe.com.patibility.hamcrest.propertiesCount;

	import org.hamcrest.assertThat;
	import org.hamcrest.collection.array;
	import org.hamcrest.core.allOf;
	import org.hamcrest.object.equalTo;
	import org.hamcrest.object.hasProperties;
	import org.hamcrest.object.hasProperty;
	import org.hamcrest.object.notNullValue;
	import org.hamcrest.object.sameInstance;

	import flash.geom.ColorTransform;

	/**
	 * @author cedric
	 */
	[Test(description="These tests verify the Color methods.")]
	public class ColorTest 
	{
		static private var colors : Array = [ Color.Green, 
								   Color.AliceBlue, 
								   Color.Khaki, 
								   Color.Purple, 
								   Color.NavajoWhite, 
								   Color.BlueViolet, 
								   Color.HotPink ];
		
		[Test(description="This test verify that the Color constructor handle correctly all the differents cases.")]
		public function __constructor__() : void
		{
			var c : Color;
			
			c = new Color();
			assertThat( c, allOf( notNullValue(), 
						   hasProperties({'red':0,'green':0,'blue':0,'alpha':255})));
			
			c = new Color( 255, 127, 63, 40 );
			assertThat( c, allOf( notNullValue(), 
						   hasProperties({'red':255,'green':127,'blue':63,'alpha':40})));
			
			c = new Color( 0xf5e6a8b4 );
			assertThat( c, allOf( notNullValue(), 
						   hasProperties({'red':0xe6,'green':0xa8,'blue':0xb4,'alpha':0xf5})));
				
			// string form	   
			c = new Color( "0xf5e6a8b4" );
			assertThat( c, allOf( notNullValue(), 
						   hasProperties({'red':0xe6,'green':0xa8,'blue':0xb4,'alpha':0xf5})));			 
						   
			c = new Color( "#f5e6a8b4" );
			assertThat( c, allOf( notNullValue(), 
						   hasProperties({'red':0xe6,'green':0xa8,'blue':0xb4,'alpha':0xf5})));
			
			c = new Color( "0xfab" );
			assertThat( c, allOf( notNullValue(), 
						   hasProperties({'red':0xff,'green':0xaa,'blue':0xbb,'alpha':0xff})));
			
			c = new Color( "#cfab" );
			assertThat( c, allOf( notNullValue(), 
						   hasProperties({'red':0xff,'green':0xaa,'blue':0xbb,'alpha':0xcc})));
			
			c = new Color( "0xfabec4" );
			assertThat( c, allOf( notNullValue(), 
						   hasProperties({'red':0xfa,'green':0xbe,'blue':0xc4,'alpha':0xff})));
			
			// color naming
			c = new Color( 255, 127, 63, 40, "color1" );
			assertThat( c, hasProperty( "name", "color1") );			assertThat( Color.get( "color1" ), sameInstance( c ) );			
			c = new Color( 0xf5e6a8b4, "color2" );
			assertThat( c, hasProperty( "name", "color2") );			assertThat( Color.get( "color2" ), sameInstance( c ) );
			
			c = new Color( "0xf5e6a8b4", "color3" );
			assertThat( c, hasProperty( "name", "color3") );
			assertThat( Color.get( "color3" ), sameInstance( c ) );
		}
		[Test(description="This test verify the rgb property.")]
		public function rgb () : void
		{
			var c : Color = new Color( 0xf5e6a8b4 );
			assertThat( c, hasProperty( "rgb", equalTo( "e6a8b4" )));
		}
		[Test(description="This test verify the rgba property.")]
		public function rgba () : void
		{
			var c : Color = new Color( 0xf5e6a8b4 );
			assertThat( c, hasProperty( "rgba", equalTo( "f5e6a8b4" )));
		}
		[Test(description="This test verify the html property.")]
		public function html () : void
		{
			var c : Color = new Color( 0xf5e6a8b4 );
			assertThat( c, hasProperty( "html", equalTo( "#e6a8b4" )));
		}
		[Test(description="This test verify the htmlRGBA property.")]
		public function htmlRGBA () : void
		{
			var c : Color = new Color( 0xf5e6a8b4 );
			assertThat( c, hasProperty( "htmlRGBA", equalTo( "#f5e6a8b4" )));
		}
		[Test(description="This test verify the hexa property.")]
		public function hexa () : void
		{
			var c : Color = new Color( 0xf5e6a8b4 );
			assertThat( c, hasProperty( "hexa", equalTo( 0xe6a8b4 )));
		}
		[Test(description="This test verify the hexaRGBA property.")]
		public function hexaRGBA () : void
		{
			var c : Color = new Color( 0xf5e6a8b4 );
			assertThat( c, hasProperty( "hexaRGBA", equalTo( 0xf5e6a8b4 )));
		}
		[Test(description="This test verify the float3 property.")]
		public function float3 () : void
		{
			var c : Color = new Color( 0xf5e6a8b4 );
			assertThat( c, hasProperty( "float3", array( 0xe6 / 255, 
														  0xa8 / 255, 
														  0xb4 / 255 )));
		}
		[Test(description="This test verify the float4 property.")]
		public function float4 () : void
		{
			var c : Color = new Color( 0xf5e6a8b4 );
			assertThat( c, hasProperty( "float4", array( 0xe6 / 255, 
														  0xa8 / 255, 
														  0xb4 / 255, 
														  0xf5 / 255 )));
		}
		[Test(description="This test verify the negative method.")]
		public function negative () : void
		{
			var c : Color;
			
			c = new Color( 0xf5e6a8b4 );
			/*
			c.negative();			
			assertThat( c, allOf( notNullValue(), 
						   hasProperties({'red':255 - 0xe6,
						   				  'green':255 - 0xa8,
						   				  'blue':255 - 0xb4,
						   				  'alpha':0xf5})));
			
			c = new Color();
			
			c.negative();			
			assertThat( c, allOf( notNullValue(), 
						   hasProperties({'red':255,
						   				  'green':255,
						   				  'blue':255,
						   				  'alpha':255})));
			
			c.negative();			
			assertThat( c, allOf( notNullValue(), 
						   hasProperties({'red':0,
						   				  'green':0,
						   				  'blue':0,
						   				  'alpha':255})));*/
		}
		
		[Test(description="This test verify the interpolate method.")]
		public function interpolate() : void
		{
			assertThat( Color.Red.interpolate(null, 0), equalToObject( Color.Red ) );
			
			colors.forEach( function ( c1 : Color, ... args ) : void
			{
				for each (var c2 : Color in colors) 
					testInterpolate(c1, c2, Math.random() );
			});
		}
		private function testInterpolate( c1 : Color, c2 : Color, r : Number ) : void
		{
			var ir : Number = 1-r;
			var floor : Function = Math.floor;
			var c3 : Color = new Color( floor( c1.red * ir + c2.red * r ),
										floor( c1.green * ir + c2.green * r ),
										floor( c1.blue * ir + c2.blue * r ),
										c1.alpha );
									   
			var c4 : Color = new Color( floor( c1.red * ir + c2.red * r ),										floor( c1.green * ir + c2.green * r ),										floor( c1.blue * ir + c2.blue * r ),										floor( c1.alpha * ir + c2.alpha * r ) );
			
			assertThat( c1.interpolate(c2, r ), equalToObject( c3 ) );			assertThat( c1.interpolate(c2, r, false ), equalToObject( c4 ) );
		}
		[Test(description="This test verify the subtract method")]
		public function subtract () : void
		{
			assertThat( Color.Red.subtract(null, 0), equalToObject( Color.Red ) );
			
			colors.forEach( function ( c1 : Color, ... args ) : void
			{
				for each (var c2 : Color in colors) 
					testSubtract(c1, c2, Math.random() );
			} );
		}
		private function testSubtract (c1 : Color, c2 : Color, r : Number) : void 
		{
			var floor : Function = Math.floor;
			var restrict : Function = MathUtils.restrict;
			
			var c3 : Color = new Color( floor( restrict( c1.red	- c2.red * r, 0, 255 ) ),
										floor( restrict( c1.green - c2.green * r, 0, 255 ) ),
										floor( restrict( c1.blue - c2.blue * r, 0, 255 ) ),
										c1.alpha );
									   
			var c4 : Color = new Color( floor( restrict( c1.red	- c2.red * r, 0, 255 ) ),
										floor( restrict( c1.green - c2.green * r, 0, 255 ) ),
										floor( restrict( c1.blue - c2.blue * r, 0, 255 ) ),
										floor( restrict( c1.alpha - c2.alpha * r, 0, 255 ) ) );
			
			assertThat( c1.subtract(c2, r ), equalToObject( c3 ) );
			assertThat( c1.subtract(c2, r, false ), equalToObject( c4 ) );
		}
		[Test(description="This test verify the add method")]
		public function add () : void
		{
			assertThat( Color.Red.add(null, 0), equalToObject( Color.Red ) );
			
			colors.forEach( function ( c1 : Color, ... args ) : void
			{
				for each (var c2 : Color in colors) 
					testAdd(c1, c2, Math.random() );
			} );
		}
		private function testAdd (c1 : Color, c2 : Color, r : Number) : void 
		{
			var floor : Function = Math.floor;
			var restrict : Function = MathUtils.restrict;
			
			var c3 : Color = new Color( floor( restrict( c1.red	+ c2.red * r, 0, 255 ) ),
										floor( restrict( c1.green + c2.green * r, 0, 255 ) ),
										floor( restrict( c1.blue + c2.blue * r, 0, 255 ) ),
										c1.alpha );
									   
			var c4 : Color = new Color( floor( restrict( c1.red	+ c2.red * r, 0, 255 ) ),
										floor( restrict( c1.green + c2.green * r, 0, 255 ) ),
										floor( restrict( c1.blue + c2.blue * r, 0, 255 ) ),
										floor( restrict( c1.alpha + c2.alpha * r, 0, 255 ) ) );
			
			assertThat( c1.add(c2, r ), equalToObject( c3 ) );
			assertThat( c1.add(c2, r, false ), equalToObject( c4 ) );
		}
		[Test]
		public function toColorTransform():void
		{
			var c : Color = new Color(0xfab5ae41);
			var ct : ColorTransform = c.toColorTransform(.4);
			assertThat( ct, allOf( notNullValue(), hasProperties({	'redMultiplier':.6,
																	'greenMultiplier':.6,																	'blueMultiplier':.6,																	'alphaMultiplier':1,
																	'redOffset':int(0xb5 * .4),																	'greenOffset':int(0xae * .4),																	'blueOffset':int(0x41 * .4),																	'alphaOffset':0
																})));
		}
		[Test]
		public function toString() : void
		{
			var c : Color = new Color(0xfab5ae41);
			
			assertThat( c.toString(), equalTo("[object Color(rgba='0xfab5ae41')]"));			assertThat( Color.Red.toString(), equalTo("[object Color(name='Red', rgba='0xffff0000')]"));
        }		[Test]
		public function clone(): void
		{
			var c1 : Color = Color.YellowGreen;
			var c2 : Color = c1.clone();
			
			assertThat( c2, allOf( notNullValue(),  
								   hasProperties({	'red':c1.red,
													'green':c1.green,
													'blue':c1.blue,
													'alpha':c1.alpha } ))); 
		}		[Test]
		public function alphaClone(): void
		{
			var c1 : Color = Color.YellowGreen;
			var c2 : Color = c1.alphaClone(0x66);
			
			assertThat( c2, allOf( notNullValue(),  
								   hasProperties({	'red':c1.red,
													'green':c1.green,
													'blue':c1.blue,
													'alpha':0x66 } ))); 
		}		[Test]
		public function brighterClone(): void
		{
			var c1 : Color = Color.YellowGreen;
			var c2 : Color = c1.brighterClone(20);
			
			assertThat( c2, allOf( notNullValue(),  
								   hasProperties({	'red':Math.min( c1.red+20, 255 ),
													'green':Math.min( c1.green+20, 255 ),
													'blue':Math.min( c1.blue+20, 255 ),
													'alpha':c1.alpha } ))); 
		}		[Test]
		public function darkerClone(): void
		{
			var c1 : Color = Color.YellowGreen;
			var c2 : Color = c1.darkerClone(20);
			
			assertThat( c2, allOf( notNullValue(),  
								   hasProperties({	'red':Math.max( c1.red-20, 0 ),
													'green':Math.max( c1.green-20, 0 ),
													'blue':Math.max( c1.blue-20, 0 ),
													'alpha':c1.alpha } ))); 
		}		[Test]
		public function equals(): void
		{
			var c1 : Color = new Color(0xff146876);			var c2 : Color = new Color(0xfaddf454);			var c3 : Color = new Color(0xfaddf454);
			
			assertThat( c1.equals(c2), equalTo( false ) );			assertThat( c1.equals(c3), equalTo( false ) );			assertThat( c2.equals(c3), equalTo( true ) );
		}		[Test]
		public function copyTo(): void
		{
			var o : Object = {};
			
			var c1 : Color = new Color(0xff146876);
			
			c1.copyTo( o );
			assertThat( o, allOf( propertiesCount( equalTo( 4 )),
								  hasProperties( {	'red':c1.red,
													'green':c1.green,
													'blue':c1.blue,
													'alpha':c1.alpha } )));
			c1 = Color.YellowGreen;
			c1.copyTo(o);
			assertThat( o, allOf( propertiesCount( equalTo( 5 )),
								  hasProperties( {	'red':c1.red,
													'green':c1.green,
													'blue':c1.blue,
													'alpha':c1.alpha,
													'name':"YellowGreen" } )));
		}		[Test]
		public function copyFrom(): void
		{
			var c1 : Color = new Color(0xff146876);
			var o : Object = {};
			c1.copyTo( o );
						c1.copyFrom( Color.YellowGreen );
			assertThat( c1, hasProperties( {'red':Color.YellowGreen.red,
											'green':Color.YellowGreen.green,
											'blue':Color.YellowGreen.blue,
											'alpha':Color.YellowGreen.alpha } ));
			
			c1.copyFrom( o );
			assertThat( c1, hasProperties( {'red':o.red,
											'green':o.green,
											'blue':o.blue,
											'alpha':o.alpha } ));
			
			o = {'blue':120, 'alpha':54};
			c1 = new Color();
			
			c1.copyFrom(o);
			assertThat( c1, hasProperties( {'red':0,
											'green':0,
											'blue':o.blue,
											'alpha':o.alpha } ));
			
		}
	}
}
