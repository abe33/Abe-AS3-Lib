package abe.com.edia.particles.display
{
    import abe.com.edia.particles.core.Particle;
    import abe.com.mon.geom.Dimension;
    import abe.com.mon.geom.dm;
    import abe.com.mon.logs.Log;
    import abe.com.mon.randoms.Random;
    import abe.com.mon.utils.RandomUtils;
    import abe.com.motion.Impulse;

    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.Shape;
    import flash.events.Event;
    import flash.geom.Matrix;
    import flash.geom.Rectangle;
    /**
     * @author cedric
     */
    public function spritesheetShape ( 	bmp : *, 
    									frameSize : Dimension = null, 
                                        sourceRect : Rectangle = null,
                                        frameRate : Number = 24, 
                                        rotationSpeed:Number = 0,
                                        scale : Number = 1,
                                        random : Random = null ) : Function
    {
        if( bmp is Class )
            bmp = new bmp();
            
        if( bmp is Bitmap )
            bmp = bmp.bitmapData;
            
        if( !( bmp is BitmapData)  )
        	throw new Error( "bitmapShape only accept BitmapData instance, Bitmap instance or BitmapData Class as argument, was "+ bmp +"." );
        
        if( !frameSize )
        	frameSize = dm( bmp.width, bmp.height );
        
        if( !sourceRect )
        	sourceRect = bmp.rect;
        
        random = random ? random : RandomUtils;
        
            
        var cols : uint = Math.ceil( sourceRect.width / frameSize.width );
        var rows : uint = Math.ceil( sourceRect.height / frameSize.height );
        
        return function( p : Particle ) : Shape {
            
            var w : Number = frameSize.width;
            var h : Number = frameSize.height;

            var fy : int = random.irandom( rows-1 ) * h ;
            var fx : int = random.irandom( cols-1 ) * w;
            
            var s : Shape = new Shape();
            var time : Number = 0;
            var r : Number = 1000/frameRate;
	        var rot : Number = random.random( rotationSpeed ) * random.sign();
            s.scaleX = s.scaleY = scale;

            var animate : Function = function(b:Number, bs:Number,t:Number):void{
               
                time += b;
                if( time >= r )
                {
                    time -= r;
	                fx += w;
	                if( fx >= sourceRect.width )
	                	fx = 0;                    
                }
               
                var m : Matrix = new Matrix();
            	m.translate(-w/2 - fx, -h/2 + fy );
                
                s.graphics.clear();
	            s.graphics.beginBitmapFill(bmp, m, false, true );
	            s.graphics.drawRect(-w/2, -h/2, w, h);
	            s.graphics.endFill();
                
                s.rotation += rotationSpeed * bs;
            };     
            s.addEventListener( Event.ADDED, function(e:Event):void{
	            Impulse.register( animate );
            });
            s.addEventListener( Event.REMOVED, function(e:Event):void{
	            Impulse.unregister( animate );
            });
            
            return s;
        };
    }
}
