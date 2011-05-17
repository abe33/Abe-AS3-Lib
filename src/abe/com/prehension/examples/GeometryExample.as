package abe.com.prehension.examples
{
	import abe.com.edia.fx.emitters.Distributions;
	import abe.com.edia.fx.emitters.Emitter;
	import abe.com.edia.fx.emitters.PathEmitter;
	import abe.com.mon.colors.Color;
	import abe.com.mon.geom.Circle;
	import abe.com.mon.geom.CubicBezier;
	import abe.com.mon.geom.Ellipsis;
	import abe.com.mon.geom.LinearSpline;
	import abe.com.mon.geom.Polygon;
	import abe.com.mon.geom.Rectangle2;
	import abe.com.mon.geom.RoundRectangle;
	import abe.com.mon.geom.SmoothSpline;
	import abe.com.mon.geom.Spiral;
	import abe.com.mon.geom.Spline;
	import abe.com.mon.geom.Triangle;
	import abe.com.mon.geom.pt;
	import abe.com.mon.logs.Log;
	import abe.com.mon.utils.GeometryUtils;
	import abe.com.mon.utils.MathUtils;
	import abe.com.mon.utils.StageUtils;
	import abe.com.motion.PathTween;
	import abe.com.motion.TweenEvent;
	import abe.com.motion.easing.Constant;
	import abe.com.motion.easing.Cubic;
	import abe.com.motion.easing.Easing;
	import abe.com.motion.easing.Linear;
	import abe.com.ponents.tools.DebugPanel;
	import abe.com.ponents.utils.KeyboardControllerInstance;
	import abe.com.ponents.utils.ToolKit;

	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	[SWF(backgroundColor="#333333",width="650",height="400")]
	/**
	 * @author Cédric Néhémie
	 */
	public class GeometryExample extends Sprite
	{
		public var tweens : Array;
		private var r : Rectangle2;
		private var t : Triangle;
		private var e : Ellipsis;
		private var pg : Polygon;
		private var c : Circle;
		private var rr : RoundRectangle;

		public function GeometryExample ()
		{
			ToolKit.initializeToolKit( this, false );

			tweens = [];

			stage.addEventListener(MouseEvent.CLICK, click);

			try
			{
				var g : Graphics = ToolKit.mainLevel.graphics;
				var p : Point;
				var i : int;
				var l : uint = 700;
				var s : Shape;
				var ps : PathTween;

				r = new Rectangle2( 70, 30, 100, 50, Math.PI/3 );
				r.draw( g, Color.Red );
				
				for( i = 0; i< l; i++ )
				{
					p = r.getRandomPointInSurface();
					g.beginFill( Color.White.hexa );
					g.drawRect(p.x, p.y, 1, 1);
					g.endFill();
				}
				s = getShape();
				ps = new PathTween( s, r, 10000 );
				ps.addEventListener(TweenEvent.TWEEN_END, tend );
				ps.execute( );
				tweens.push(ps);
				ToolKit.mainLevel.addChild(s);
				///////////////////////////////////////////////////////////////////////
				t = new Triangle( pt( 150, 20), pt( 200,35 ), pt( 180, 80 ) );
				t.draw( g, Color.Green );

				for( i = 0; i< l; i++ )
				{
					p = t.getRandomPointInSurface();
					g.beginFill( Color.White.hexa );
					g.drawRect(p.x, p.y, 1, 1);
					g.endFill();
				}
				s = getShape();
				ps = new PathTween( s, t, 10000 );
				ps.addEventListener(TweenEvent.TWEEN_END, tend );
				ps.execute( );
				tweens.push(ps);
				ToolKit.mainLevel.addChild(s);
				///////////////////////////////////////////////////////////////////////
				rr = new RoundRectangle(80, 320, 112, 76, 23, 13, true );
				rr.draw( g, Color.Crimson );

				for( i = 0; i< l; i++ )
				{
					p = rr.getRandomPointInSurface();
					g.beginFill( Color.White.hexa );
					g.drawRect(p.x, p.y, 1, 1);
					g.endFill();
				}
				s = getShape();
				ps = new PathTween( s, rr, 10000 );
				ps.addEventListener(TweenEvent.TWEEN_END, tend );
				ps.execute( );
				tweens.push(ps);
				ToolKit.mainLevel.addChild(s);
				///////////////////////////////////////////////////////////////////////
				e = new Ellipsis(280, 60, 65, 30, -Math.PI / 6 );
				e.draw( g, Color.Blue );

				for( i = 0; i< l; i++ )
				{
					p = e.getRandomPointInSurface();
					g.beginFill( Color.White.hexa );
					g.drawRect(p.x, p.y, 1, 1);
					g.endFill();
				}
				s = getShape();
				ps = new PathTween( s, e, 10000 );
				ps.addEventListener(TweenEvent.TWEEN_END, tend );
				ps.execute( );
				tweens.push(ps);
				ToolKit.mainLevel.addChild(s);

				///////////////////////////////////////////////////////////////////////
				c = new Circle(420, 70, 45 );
				c.draw( g, Color.Cyan );

				for( i = 0; i< l; i++ )
				{
					p = c.getRandomPointInSurface();
					g.beginFill( Color.White.hexa );
					g.drawRect(p.x, p.y, 1, 1);
					g.endFill();
				}
				s = getShape();
				ps = new PathTween( s, c, 10000 );
				ps.addEventListener(TweenEvent.TWEEN_END, tend );
				ps.execute( );
				tweens.push(ps);
				ToolKit.mainLevel.addChild(s);

				///////////////////////////////////////////////////////////////////////
				var sp : Spline = new LinearSpline( [ pt(230,160),
													  pt(280,180),
													  pt(290,130),
													  pt(320, 160)] );
				sp.draw( g, Color.Fuchsia );

				s = getShape();
				ps = new PathTween( s, sp, 10000 );
				ps.addEventListener(TweenEvent.TWEEN_END, tend );
				ps.execute();
				tweens.push(ps);
				
				var esp : Emitter = new PathEmitter( sp, 10, null, Distributions.firstHalf );
				for( i = 0; i< l; i++ )
				{
					p = esp.get();
					g.beginFill( Color.White.hexa );
					g.drawRect(p.x, p.y, 1, 1);
					g.endFill();
				}
				
				ToolKit.mainLevel.addChild(s);

				///////////////////////////////////////////////////////////////////////
				var csp : CubicBezier = new CubicBezier( [ pt(340,160),
														   pt(340,240),
														   pt(400,240),
														   pt(400,200),
														   pt(400,160),
														   pt(460,160),
														   pt(500,220)] );
				csp.drawVertices = true;
				csp.draw( g, Color.Fuchsia );

				s = getShape();
				ps = new PathTween( s, csp, 10000 );
				ps.addEventListener(TweenEvent.TWEEN_END, tend );
				ps.execute();
				tweens.push(ps);
				
				var ecsp : Emitter = new PathEmitter( csp, 10, Cubic.easeOut, Math.sqrt );
				for( i = 0; i< l; i++ )
				{
					p = ecsp.get();
					g.beginFill( Color.White.hexa );
					g.drawRect(p.x, p.y, 1, 1);
					g.endFill();
				}
				
				ToolKit.mainLevel.addChild(s);
				///////////////////////////////////////////////////////////////////////
				var ssp : SmoothSpline = new SmoothSpline( [ pt(400,300),
															 pt(340,340),
															 pt(400,340),
															 pt(400,260),
															 pt(460,260),
															 pt(400,300)] );
				ssp.drawVertices = true;
				//ssp.drawOnlySegmentVertices = true;
				ssp.draw( g, Color.Orange );

				s = getShape();
				ps = new PathTween( s, ssp, 10000 );
				ps.addEventListener(TweenEvent.TWEEN_END, tend );
				ps.execute();
				tweens.push(ps);
				
				var essp : Emitter = new PathEmitter( ssp, 10, Constant.easeAbsCos, Distributions.dashed(12) );
				for( i = 0; i< l; i++ )
				{
					p = essp.get();
					g.beginFill( Color.White.hexa );
					g.drawRect(p.x, p.y, 1, 1);
					g.endFill();
				}
				
				ToolKit.mainLevel.addChild(s);
				
				///////////////////////////////////////////////////////////////////////
				var spr : Spiral = new Spiral(530, 100, 75, 40, 3, Math.PI*-.25, 120 );
				spr.draw( g, Color.Orange );

				s = getShape();
				ps = new PathTween( s, spr, 10000 );
				ps.addEventListener(TweenEvent.TWEEN_END, tend );
				ps.execute();
				tweens.push(ps);
				
				var espr : Emitter = new PathEmitter( spr, 30, Easing.randomize(Easing.inv(Linear.easeIn),.3), null, null, 5 );
				for( i = 0; i< l*2; i++ )
				{
					p = espr.get();
					g.beginFill( Color.White.hexa );
					g.drawRect(p.x, p.y, 1, 1);
					g.endFill();
				}
				
				ToolKit.mainLevel.addChild(s);
				

				///////////////////////////////////////////////////////////////////////
				pg = new Polygon( [
									pt(110,150),
									pt(135,120),
									pt(180,160),
									pt(140,140),
									pt(120,170)
								] );
				//pg.drawTriangles = true;
				pg.draw(g, Color.Yellow );

				for( i = 0; i< l; i++ )
				{
					p = pg.getRandomPointInSurface();
					g.beginFill( Color.White.hexa );
					g.drawRect(p.x, p.y, 1, 1);
					g.endFill();
				}

				s = getShape();
				ps = new PathTween( s, pg, 10000 );
				ps.addEventListener(TweenEvent.TWEEN_END, tend );
				ps.execute();
				tweens.push(ps);
				ToolKit.mainLevel.addChild(s);


				var r1 : Rectangle2 = new Rectangle2(120, 240, 100, 60 );
				var r2 : Rectangle2 = new Rectangle2(140, 260, 100, 60, MathUtils.deg2rad( -30 ) );
				var r3 : Rectangle2 = new Rectangle2(150, 250, 20, 30, MathUtils.deg2rad( 45 ) );
				var t1 : Triangle = new Triangle( pt( 140, 220 ),
												  pt( 250, 320 ),
												  pt( 290, 270 ) );
				r1.draw ( g, Color.Green );
				r2.draw ( g, Color.Red );
				r3.draw ( g, Color.Cyan );
				t1.draw ( g, Color.Yellow );

				var a : Array;

				a = GeometryUtils.geometriesIntersections(r1, r2);
				if( a )
				{
					for each( p in a )
					{
						g.lineStyle( 0, Color.White.hexa );
						g.drawRect(p.x-2, p.y-2, 4, 4);
					}
				}
				a = GeometryUtils.geometriesIntersections(t1, r2);
				if( a )
				{
					for each( p in a )
					{
						g.lineStyle( 0, Color.White.hexa );
						g.drawRect(p.x-2, p.y-2, 4, 4);
					}
				}

				Log.debug( "r1 contains r2 : " + r1.containsGeometry(r2));
				Log.debug( "r1 contains r3 : " + r1.containsGeometry(r3));
				Log.debug( "r2 contains r3 : " + r2.containsGeometry(r3));
			}
			catch( e : Error )
			{
				Log.error( e.message + "\n" + e.getStackTrace() );
			}
		}

		protected function click (event : MouseEvent) : void
		{
			var p : Point = pt( stage.mouseX, stage.mouseY );

			if( r.containsPoint(p) )
				Log.info( "click within rectangle" );

			if( t.containsPoint(p) )
				Log.info( "click within triangle" );

			if( e.containsPoint(p) )
				Log.info( "click within ellipsis" );

			if( pg.containsPoint(p) )
				Log.info( "click within polygon" );

			if( c.containsPoint(p) )
				Log.info( "click within circle" );
			
			if( rr.containsPoint(p) )
				Log.info( "click within rounded rectangle" );
		}

		protected function tend (event : TweenEvent) : void
		{
			( event.target as PathTween ).execute();
		}

		public function getShape( ) : Shape
		{
			var s : Shape = new Shape();
			s.graphics.lineStyle(0, 0xffffff );
			s.graphics.drawRect(-3, -6, 6, 6);
			s.graphics.drawCircle(0, -6, 2);
			return s;
		}
	}
}
