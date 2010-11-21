package aesia.com.mon.geom
{
	import flash.geom.Point;

	/**
	 * La classe <code>Triangulate</code> fournie des méthodes
	 * permettant de triangulé une géometrie, et d'obtenir l'ensemble
	 * des sous-triangles la constituant.
	 *
	 * @author	John W. Ratcliff
	 * @author	Zevan Rosser
	 */
	public class Triangulate
	{
		private const EPSILON : Number = 0.0000000001;

		/**
		 * Renvoie un tableau contenant les objets <code>Triangle</code>
		 * issus de la triangulation de la géométrie définie par le
		 * tableau de point <code>contour</code>.
		 *
		 * @param	contour un tanbleau contenant les points constituant
		 * 					la géometrie
		 * @return	un tableau contenant les objets <code>Triangle</code>
		 * 			issus de la triangulation de la géométrie
		 */
		public function toTriangles ( contour : Array ) : Array
		{
			var a : Array = process(contour);

			if( !a )
				return null;

			var b : Array = [];
			var tcount:int = a.length / 3;
			for ( var i : int = 0; i<tcount; i++)
			{
			    var index:int = i * 3;
			    var p1:Point=a[index];
			    var p2:Point=a[index+1];
			    var p3:Point=a[index+2];
			    b.push( new Triangle(p1, p2, p3) );
			}
			return b;
		}
		/**
		 * Renvoie un tableau de points contenant les coordonnées
		 * des triangles issus de la triangulation de la géométrie
		 * définie dans <code>contour</code>.
		 * <p>
		 * Les coordonnées des triangles sont donc regroupés par
		 * séries de trois points. Pour parcourir le tableau par
		 * triangle il suffit de procéder de la façon suivante :
		 * </p>
		 * <listing>
		 * var tcount:int = a.length / 3;
		 * for ( var i : int = 0 ; i &lt; tcount ; i++)
		 * {
		 * 	var index:int = i &#42; 3;
		 * 	var p1:Point=a[index];
		 * 	var p2:Point=a[index+1];
		 * 	var p3:Point=a[index+2];
		 *
		 * 	// faire quelque chose avec les coordonnées
		 * }</listing>
		 *
		 * @param	contour un tanbleau contenant les points constituant
		 * 					la géometrie
		 * @return	un tableau de points contenant les coordonnées
		 * 			des triangles issus de la triangulation
		 */
		public function process ( contour : Array ) : Array
		{
			var result:Array = [];
			var n:int = contour.length;

			if ( n < 3 ) return null;

			var verts:Array = [];

			/* we want a counter-clockwise polygon in verts */
			var v:int;

			if ( 0.0 < area(contour) )
                for (v=0; v<n; v++)
                	verts[v] = v;
            else
                for(v=0; v<n; v++)
                	verts[v] = (n-1)-v;

			var nv:int = n;

			/*  remove nv-2 vertsertices, creating 1 triangle every time */
			var count:int = 2*nv;   /* error detection */
			var m:int;
	        for(m=0, v=nv-1; nv>2; )
	        {
	            /* if we loop, it is probably a non-simple polygon */
	            if ( --count <= 0 )
					return null;

                /* three consecutive vertices in current polygon, <u,v,w> */
                var u:int = v;
                if (nv <= u)
                	u = 0;     /* previous */

                v = u+1;

                if (nv <= v)
                	v = 0;     /* new v    */
                var w:int = v+1;

                if (nv <= w)
                	w = 0;     /* next     */

                if ( snip(contour,u,v,w,nv,verts))
                {
                 	var a:int,b:int,c:int,s:int,t:int;

                	/* true names of the vertices */
                  	a = verts[u]; b = verts[v]; c = verts[w];

                  	/* output Triangle */
                  	result.push( contour[a] );
                  	result.push( contour[b] );
                  	result.push( contour[c] );

                  	m++;

                  	/* remove v from remaining polygon */
                  	for( s = v, t = v + 1 ; t < nv ; s++, t++ )
                  		verts[s] = verts[t];

                	nv--;

                  	/* resest error detection counter */
                  	count = 2 * nv;
                }
			}
			return result;
		}

        // calculate area of the contour polygon
        private function area(contour:Array):Number
        {
            var n:int = contour.length;
            var a:Number  = 0.0;

            for(var p:int=n-1, q:int=0; q<n; p=q++)
                a += contour[p].x * contour[q].y - contour[q].x * contour[p].y;

            return a * 0.5;
        }

        // see if p is inside triangle abc
        private function insideTriangle( ax:Number,
        								ay:Number,
        								bx:Number,
        								by:Number,
        								cx:Number,
        								cy:Number,
        								px:Number,
        								py:Number) : Boolean
        {
			var aX:Number, aY:Number, bX:Number, bY:Number;
			var cX:Number, cY:Number, apx:Number, apy:Number;
			var bpx:Number, bpy:Number, cpx:Number, cpy:Number;
			var cCROSSap:Number, bCROSScp:Number, aCROSSbp:Number;

			aX = cx - bx;  aY = cy - by;
			bX = ax - cx;  bY = ay - cy;
			cX = bx - ax;  cY = by - ay;
			apx= px  -ax;  apy= py - ay;
			bpx= px - bx;  bpy= py - by;
			cpx= px - cx;  cpy= py - cy;

			aCROSSbp = aX*bpy - aY*bpx;
			cCROSSap = cX*apy - cY*apx;
			bCROSScp = bX*cpy - bY*cpx;

			return ((aCROSSbp>= 0.0) && (bCROSScp>= 0.0) && (cCROSSap>= 0.0));
		}

       	private function snip( contour:Array,
        					   u:int,
        					   v:int,
        					   w:int,
        					   n:int,
        					   verts:Array ):Boolean
       	{
			var p:int;
			var ax:Number, ay:Number, bx:Number, by:Number;
			var cx:Number, cy:Number, px:Number, py:Number;

			ax = contour[verts[u]].x;
			ay = contour[verts[u]].y;

			bx = contour[verts[v]].x;
			by = contour[verts[v]].y;

			cx = contour[verts[w]].x;
			cy = contour[verts[w]].y;

			if ( EPSILON > (((bx-ax)*(cy-ay)) - ((by-ay)*(cx-ax))) )
					return false;

			for (p=0;p<n;p++)
			{
				if( (p == u) || (p == v) || (p == w) )
					continue;

				px = contour[verts[p]].x;
				py = contour[verts[p]].y;

				if (insideTriangle(ax,ay,bx,by,cx,cy,px,py))
					return false;
			}
			return true;
		}
	}
}
