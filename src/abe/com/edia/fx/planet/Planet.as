package abe.com.edia.fx.planet 
{
	import abe.com.mon.colors.Color;
	import abe.com.mon.geom.Range;
	import abe.com.mon.randoms.MTRandom;
	import abe.com.mon.randoms.Random;

	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.GradientType;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.filters.GlowFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	/**
	 * @author Cédric Néhémie
	 */
	public class Planet extends Sprite 
	{
		/*
		 * Athmosphere settings
		 */
		[Inspectable(type="uintSlider", label="Size", range="0,500", step="1", category="Athmosphere", order="0")]
		public var athmosphereSize : Number = 20;
		
		[Inspectable(type="color", label="Color #1", category="Athmosphere",order="1")]		public var athmosphereColor1 : Color = Color.DarkTurquoise;
		
		[Inspectable(type="color", label="Color #2", category="Athmosphere",order="2")]
		public var athmosphereColor2 : Color = Color.DodgerBlue;
		
		/*
		 * Clouds settings
		 */		
		[Inspectable(type="uintSpinner", label="Seed", category="Clouds", order="0")]
		public var cloudSeed : uint;
		
		[Inspectable(type="uintSlider", label="Clusters", range="0,50", category="Clouds",order="2")]		public var cloudsGroupNum : Number = 8;
		
		[Inspectable(type="floatSpinner", label="Speed", range="0,4", step="0.01", category="Clouds",order="1")]
		public var cloudsSpeed : Number = 0.004;
		
		[Inspectable(type="uintSlider", label="Height", range="0,50", category="Clouds",order="3")]
		public var cloudHeight : Number = 5;
		
		[Inspectable(type="color", label="Color", category="Clouds",order="4")]		public var cloudColor : Color = Color.White;
		
		[Inspectable(type="color", label="Shadow Color", category="Clouds",order="5")]
		public var cloudShadowColor : Color = Color.Black;
		
		/*
		 * Planet settings
		 */
		[Inspectable(type="uintSpinner", label="Seed", category="Planet", order="0")]
		public var planetSeed : uint;
		
		[Inspectable(type="uintSlider", label="Size", range="0,200", step="1", category="Planet", order="1")]
		public var planetSize : Number = 50;
		
		[Inspectable(type="uintSlider", label="Axis angle", range="0,360", category="Planet", order="2")]
		public var planetAxis : Number = 17;
		
		[Inspectable(type="floatSpinner", label="Rotation Speed", range="0,4", step="0.01", category="Planet",order="3")]
		public var planetRotationSpeed : Number = 0.2;
		
		[Inspectable(type="color", label="Ground Color", category="Planet",order="4")]
		public var groundColor : Color = Color.YellowGreen;
		
		[Inspectable(type="color", label="Ocean Color", category="Planet",order="5")]
		public var oceanColor : Color = Color.DeepSkyBlue;
		
		[Inspectable(type="uintSpinner", label="Ocean Level", range="0,256", step="10", category="Planet", order="6")]
		public var oceanLevel : Number = 0x88;
		
		
		[Inspectable(type="color", label="Ice Color", category="Glaciation",order="2")]
		public var polesColor : Color = Color.Snow;
		
		[Inspectable(type="floatSpinner", label="Floe size", step="0.1", range="0,1", category="Glaciation",order="0")]		public var polesSize : Number = .15;
		
		[Inspectable(type="uintSpinner", label="Inlandsis size", range="0,256", step="10", category="Glaciation",order="1")]
		public var polesThreshold : Number = 0x88;
		
		[Inspectable(type="color", label="Scatter Color")]
		public var scatterColor : Color = Color.White;
		
		public var satelites : Vector;
		public var planetObjects : Vector.<PlanetObject>;
		
		/*
		 * Planet structure
		 */		public var objects : Sprite;
		protected var background : Sprite;
		protected var foreground : Sprite;
		
		protected var athmosphere : Sprite;				protected var planetGround : Sprite;
		protected var planetGroundRot : Number;
		protected var planetGroundMap : BitmapData;
		
		protected var carroussel : SphericCarrousel;
				protected var cl : Vector.<Cloud>;
		protected var cls : Vector.<CloudShadow>;
		
		protected var planetRandom : Random;		protected var cloudRandom : Random;
		public function Planet ( seed : Number = 0 )	
		{
			planetObjects = new Vector.<PlanetObject>();
			athmosphere = new Sprite();
			background = new Sprite();
			planetGround = new Sprite();
			objects = new Sprite();
			foreground = new Sprite();
			planetSeed = seed;
			cloudSeed = seed;
			planetGroundRot = 0;
			
			draw();
			
			addChild( athmosphere );
			addChild( background );
			addChild( planetGround );			addChild( objects );
			addChild( foreground );
		}
		public function get planetMap () : BitmapData
		{
			return planetGroundMap;
		}
		public function get planetRotation () : Number
		{
			return planetGroundRot;
		}
		public function get planetVisibleAreaCenter () : Point
		{
			if( planetGroundRot <= 0 )
				return new Point( -planetGroundRot % planetGroundMap.width, planetSize );
			else
				return new Point(  planetGroundMap.width + ( -planetGroundRot % planetGroundMap.width ), planetSize );
		}
		public function handlePlanetObject ( o : PlanetObject, c : Point, c2 : Point ) : void
		{
			var p : Point = new Point( o.long, o.lat );
			
			var l1 : Number = Point.distance( c , p );			var l2 : Number = Point.distance( c2 , p );
			
			var b1 : Boolean = l1 <= planetSize;
			var b2 : Boolean = l2 <= planetSize;
			
			o.visible = b1 || b2;
			
			if( b1 )
			{
				o.x = o.long - c.x;
				o.y = o.lat - c.y;
			}
			else if( b2 )
			{
				o.x = o.long - c2.x;
				o.y = o.lat - c2.y;
			}
		}

		public function draw () : void
		{
			planetRandom = new Random( new MTRandom( planetSeed ) );			cloudRandom = new Random( new MTRandom( cloudSeed ) );
			
			objects.rotation = planetGround.rotation = background.rotation = foreground.rotation = planetAxis;
			
			createPlanetGround();
			createPlanetPoles();
			
			drawAthmosphere();
			//drawPlanetGround();
			drawClouds();
			
			update();
		}
		public function animate () : void
		{
			for each( var c : Cloud in cl )
			{
				c.long += c.longSpeed;
				c.lat += c.latSpeed;
			}
			var center : Point = planetVisibleAreaCenter;
			var center2 : Point = new Point( center.x > planetSize*2 ? center.x - planetSize*4 : center.x + planetSize*4, center.y );
			if( planetObjects.length != 0 )
			{
				for each( var po : PlanetObject in planetObjects )
					handlePlanetObject( po, center, center2 );
			}
			planetGroundRot -= planetRotationSpeed;
		}
		public function update() : void
		{
			drawPlanetGround();
			carroussel.update();
			for each( var cs : CloudShadow in cls )
			{
				cs.update();
			}
		}
		public function createPlanetGround () : void
		{
			var r : Rectangle = new Rectangle(0,0, planetSize * 4, planetSize * 2 );
			var o : Point = new Point();

			if( !planetGroundMap )			
				planetGroundMap = new BitmapData( r.width, r.height, false, oceanColor.hexa );
			else if( planetGroundMap.width == r.width ) 
				planetGroundMap.fillRect( r, oceanColor.hexa );
			else if( planetGroundMap )
			{
				planetGroundMap.dispose();
				planetGroundMap = new BitmapData( r.width, r.height, false, oceanColor.hexa );
			}

			var bmp1 : BitmapData = new BitmapData( r.width, r.height, true, 0x00000000 );			
			bmp1.perlinNoise( r.width, r.height, 6, planetRandom.irandom( uint.MAX_VALUE ), true, true, 8, true );
			planetGroundMap.threshold( bmp1, r, o, ">=", oceanLevel << 24, groundColor.hexaRGBA, 0xff000000, false );
			
			bmp1.dispose();
		}
		public function createPlanetPoles() : void
		{	
			var r : Rectangle = new Rectangle(0,0, planetSize * 4, planetSize * 2 );
			// la seed est générée systématiquement, afin de ne pas perturber les autres générations
			var seed : Number = planetRandom.irandom( uint.MAX_VALUE );
			if( polesSize > 0 && polesSize < 1 )
			{
				var o : Point = new Point();
	
				var bmp1 : BitmapData = new BitmapData( r.width, r.height, true, 0x00000000 );
				var bmp2 : BitmapData = new BitmapData( r.width, r.height, true, 0x00000000 );
				var shape : Shape = new Shape();
				
				var m : Matrix = new Matrix();
				m.createGradientBox( r.width, r.height, Math.PI/2, 0, 0 );
				
				shape.graphics.clear();
				shape.graphics.beginGradientFill( GradientType.LINEAR, 
											[ 0xffffff, 0x000000, 0x000000, 0xffffff ],
											[ .5, .5, .5, .5 ],
											[ int( 128 * polesSize * polesSize * polesSize  ),
											  int( 128 * polesSize ), 
											  255-int( 128 * polesSize ), 
											  255-int( 128 * polesSize * polesSize * polesSize  )
											], 
											m );
				shape.graphics.drawRect( 0, 0, r.width, r.height );
				shape.graphics.endFill();
				
				bmp1.perlinNoise( r.width/2, r.height, 5, seed, true, true, 7, true );			
				bmp1.draw( shape, null, null, BlendMode.HARDLIGHT );
				bmp2.threshold( bmp1, r, o, ">=", polesThreshold << 16, polesColor.hexaRGBA, 0x00ff0000, false );
	
				planetGroundMap.copyPixels( bmp2, r, o, null, null, true );
	
				bmp1.dispose();				bmp2.dispose();
			}
			else if( polesSize == 1 )
			{
				planetGroundMap.fillRect( r, polesColor.hexaRGBA );
			}
		}

		public function drawPlanetGround () : void
		{
			var m : Matrix = new Matrix();
			m.createBox(1, 1, 0, planetGroundRot % planetGroundMap.width, -planetSize );
			
			planetGround.graphics.clear();
			/*
			planetGround.graphics.beginFill( oceanColor.hexa );
			planetGround.graphics.drawCircle( 0, 0, planetSize );
			planetGround.graphics.endFill();
			*/
			planetGround.graphics.beginBitmapFill( planetGroundMap, m, true, true );
			planetGround.graphics.drawCircle( 0, 0, planetSize );
			planetGround.graphics.endFill();
			
			planetGround.filters = [ new GlowFilter( scatterColor.hexa, .5, 8, 8, 1, 3, true ) ];
		}

		public function drawAthmosphere () : void
		{
			var m : Matrix = new Matrix();
			var r : Number = planetSize + athmosphereSize;
			m.createGradientBox( r*2, r*2, 0, -r, -r );
			
			athmosphere.graphics.clear();
			athmosphere.graphics.beginGradientFill( GradientType.RADIAL, 
													[ athmosphereColor1.hexa, athmosphereColor2.hexa, 0 ],
													[ .9, .1, 0 ], [ planetSize / r * 250, 250, 255 ], 
													m );
			athmosphere.graphics.drawCircle( 0, 0, r );
			athmosphere.graphics.endFill();
		}
		
		public function clearClouds () : void
		{
			for each ( var cs : CloudShadow in cls )
			{
				planetGround.removeChild( cs );
			}
			var fl : Number = foreground.numChildren;			var bl : Number = background.numChildren;
			
			while( --fl -(-1) )
			{
				foreground.removeChildAt( fl );
			}
			while( --bl -(-1) )
			{
				background.removeChildAt( bl );
			}
		}

		public function drawClouds () : void
		{
			clearClouds();
			
			carroussel = new SphericCarrousel();
			carroussel.rayon = planetSize + cloudHeight;
			carroussel.background = background;
			carroussel.foreground = foreground;
			
			//background.filters = [ FilterUtils.getShadow( athmosphereColor1, .5, 0, true ) ];			//foreground.filters = [ FilterUtils.getShadow( athmosphereColor1, .5, 0, true ) ];
			
			cl = new Vector.<Cloud> ();			cls = new Vector.<CloudShadow>();
			
			var i : Number;			
			
			for( i = 0; i < cloudsGroupNum; i++ )
			{
				drawCloudLine( 	cloudRandom.range( new Range( 0, Math.PI * 2 ) ), 
								cloudRandom.random( Math.PI * 4 ), 
								2 + cloudRandom.random( 6 ), 
								new Range( 	6 + cloudRandom.balance( 6 ) ,
											9 + cloudRandom.balance( 6 ) ) );
			}
		}

		public function drawCloudLine ( lat : Number, long : Number, length : Number, sizeRange : Range ) : void
		{
			var i : Number;
			var c : Cloud;
			for( i = 0; i < length; i++ )
			{
				c = new Cloud( cloudRandom.range( sizeRange ), cloudColor );
				c.lat = lat + cloudRandom.balance( .4 );
				c.long = long + i / 15 * sizeRange.min / 4;
				c.longSpeed = cloudsSpeed;
				
				var cs : CloudShadow = new CloudShadow( c, cloudShadowColor );
				
				planetGround.addChild( cs );
					
				foreground.addChild( c );
				cl.push( c );				cls.push( cs );
			}
		}
	}
}
