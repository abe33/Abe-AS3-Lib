package abe.com.prehension.examples {
	import abe.com.edia.commands.ColorFlash;
	import abe.com.edia.commands.GradientTween;
	import abe.com.edia.fx.FireBall;
	import abe.com.edia.fx.Inspire;
	import abe.com.edia.fx.LightningBolt;
	import abe.com.edia.fx.ParticlesTwirl;
	import abe.com.edia.fx.RocksLiftUp;
	import abe.com.edia.fx.ShinyObject;
	import abe.com.edia.fx.SmokeRingGenerator;
	import abe.com.edia.fx.TwinklingObject;
	import abe.com.edia.fx.TwirlRibbons;
	import abe.com.edia.fx.WaterBall;
	import abe.com.edia.particles.emitters.PathEmitter;
	import abe.com.mon.colors.Color;
	import abe.com.mon.colors.Gradient;
	import abe.com.mon.core.impl.LayeredSpriteImpl;
	import abe.com.mon.geom.Circle;
	import abe.com.mon.geom.LinearSpline;
	import abe.com.mon.geom.Spline;
	import abe.com.mon.geom.pt;
	import abe.com.mon.logs.Log;
	import abe.com.ponents.utils.ToolKit;
	import flash.display.GradientType;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Matrix;


    /**
     * @author Cédric Néhémie
     */
    [SWF(backgroundColor="#666666", width="720")]
    public class ShinyObjectDemo extends Sprite
    {
        protected var shinyObject : ShinyObject;
        protected var waterBall : WaterBall;
        protected var fireBall : FireBall;
        protected var twirl : ParticlesTwirl;
        protected var sg : SmokeRingGenerator;
        protected var twirlRib : TwirlRibbons;
        protected var rocks : RocksLiftUp;
        protected var twinklingObj : TwinklingObject;
        protected var colorFlash : ColorFlash;
        protected var gradientTween : GradientTween;

        public function ShinyObjectDemo ()
        {
            ToolKit.initializeToolKit( this, false );

            stage.addEventListener( MouseEvent.CLICK, click );

            try
            {
                var spr :  LayeredSpriteImpl;

                ///////////////////////////////////////////////////////////////////////
                spr = getLayeredSprite( Color.Black );
                spr.x = 60;
                spr.y = 60;

                shinyObject = new ShinyObject( spr );
                shinyObject.init();

                ToolKit.mainLevel.addChild( spr );

                ///////////////////////////////////////////////////////////////////////
                spr = getLayeredSprite( Color.Black );
                spr.filters = [new GlowFilter( Color.DarkSlateGray.hexa, 1, 3, 3, 1, 2)];
                spr.x = 160;
                spr.y = 60;

                var inspire : Inspire = new Inspire( Color.Black, false, 20 );
                spr.background.addChild( inspire );
                inspire.init();

                ToolKit.mainLevel.addChild( spr );

                ///////////////////////////////////////////////////////////////////////
                spr = getLayeredSprite( Color.Black );
                spr.x = 260;
                spr.y = 60;
                spr.foreground.filters = [new GlowFilter( Color.Gold.hexa, 1, 6, 6, 2, 2)];
                spr.background.filters = [new GlowFilter( Color.Gold.hexa, 1, 6, 6, 2, 2)];

                twirl = new ParticlesTwirl( spr, Number.POSITIVE_INFINITY );
                twirl.init();

                ToolKit.mainLevel.addChild( spr );

                ///////////////////////////////////////////////////////////////////////
                spr = getLayeredSprite( Color.Black );
                spr.x = 360;
                spr.y = 60;

                waterBall = new WaterBall( spr, null, null, null, null, 10, 11, 10, 16, true, 30 );
                waterBall.init();

                ToolKit.mainLevel.addChild( spr );

                ///////////////////////////////////////////////////////////////////////
                spr = getLayeredSprite( Color.Black );
                spr.x = 460;
                spr.y = 60;

                fireBall = new FireBall( spr, null, .3, 24, 10, 16, 10 );
                fireBall.init();

                ToolKit.mainLevel.addChild( spr );
                ///////////////////////////////////////////////////////////////////////
                sg = new SmokeRingGenerator( ToolKit.mainLevel, pt(560,80), Number.POSITIVE_INFINITY );
                sg.init();

                ///////////////////////////////////////////////////////////////////////
                var circle : Circle = new Circle(0, 0, 30 );
                var bolt : LightningBolt = new LightningBolt( circle );
                bolt.x = 660;
                bolt.y = 60;
                bolt.init();
                bolt.filters = [new GlowFilter( Color.DeepSkyBlue.hexa, 1, 6, 6, 2, 2)];
                ToolKit.mainLevel.addChild( bolt );

                ///////////////////////////////////////////////////////////////////////
                spr = getLayeredSprite( Color.Black );
                spr.x = 60;
                spr.y = 160;
                spr.foreground.filters = [new GlowFilter( Color.Gold.hexa, 1, 6, 6, 2, 2)];
                spr.background.filters = [new GlowFilter( Color.Gold.hexa, 1, 6, 6, 2, 2)];

                twirlRib = new TwirlRibbons( spr, Number.POSITIVE_INFINITY );
                twirlRib.init();

                ToolKit.mainLevel.addChild( spr );

                ///////////////////////////////////////////////////////////////////////
                spr = getLayeredSprite( Color.Black );
                spr.x = 160;
                spr.y = 160;

                var spline : Spline = new LinearSpline( [pt(-20,15),pt(20,15)] );
                //spline.draw( spr.foreground.graphics , Color.Black );
                rocks = new RocksLiftUp( spr.foreground,
                                         new PathEmitter( spline ),
                                         Number.POSITIVE_INFINITY );
                rocks.init();

                ToolKit.mainLevel.addChild( spr );

                ///////////////////////////////////////////////////////////////////////
                spr = getLayeredSprite( Color.Black );
                spr.x = 260;
                spr.y = 160;

                twinklingObj = new TwinklingObject( spr, 3 );
                twinklingObj.init();

                ToolKit.mainLevel.addChild( spr );
				
				///////////////////////////////////////////////////////////////////////
				spr = getLayeredSprite( Color.Black );
                spr.x = 360;
                spr.y = 160;

                colorFlash = new ColorFlash( spr, Color.Orange, 400, null, true );
                colorFlash.execute();

                ToolKit.mainLevel.addChild( spr );
                
                ///////////////////////////////////////////////////////////////////////
				spr = getLayeredSprite( Color.Black );
                spr.x = 460;
                spr.y = 160;

                gradientTween = new GradientTween( spr, Gradient.COLOR_SPECTRUM, 2000, true );
				gradientTween.execute();

                ToolKit.mainLevel.addChild( spr );
            }
            catch( e : Error )
            {
                Log.error( e.message + "\n" + e.getStackTrace() );
            }
        }

        protected function click (event : MouseEvent) : void
        {
            
        }

        protected function getLayeredSprite ( c : Color ) : LayeredSpriteImpl
        {
            var o : Shape = new Shape();
            var m : Matrix = new Matrix();
//	        o.graphics.beginFill( c.hexa );
			m.createGradientBox(20, 20, 0, -10,-10);
            
			o.graphics.beginGradientFill( GradientType.RADIAL, [0x333333,0x000000], [1,1],[127,255], m );
            o.graphics.drawCircle(0, 0, 10);
            o.graphics.endFill();

            var spr : LayeredSpriteImpl = new LayeredSpriteImpl();
            ( spr.middle as Sprite ).addChild( o );

            return spr;
        }
    }
}
