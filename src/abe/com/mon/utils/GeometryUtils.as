package abe.com.mon.utils
{
	import abe.com.mon.geom.Geometry;
	import abe.com.mon.geom.Surface;

	import flash.geom.Point;
	/**
	 * Classe utilitaire réalisant des calculs sur des objets géométriques.
	 *
	 * @author Cédric Néhémie
	 */
	public class GeometryUtils
	{
		/**
		 * Renvoie <code>true</code> si <code>geom</code> est contenu toute entière dans
		 * <code>surface</code>.
		 *
		 * @param	surface	la surface dont on souhaite savoir si elle contient la géométrie
		 * @param	geom	la géométrie à tester
		 * @return	<code>true</code> si la géométrie est contenu toute entière dans
		 * 			la surface
		 */
		static public function surfaceContainsGeometry ( surface : Surface, geom : Geometry ) : Boolean
		{
			var a : Array = geom.points;
			var l : uint = a.length;
			if( geom is Surface )
				l--;

			while( l-- )
				if( !surface.containsPoint ( a[l] ) )
					return false;

			return true;
		}
		/**
		 * Renvoie <code>true</code> si les deux géométries <code>geom1</code> et <code>geom2</code>
		 * s'entrecroisent.
		 * <p>
		 * Deux géométries s'entrecroise si au moins un de leurs vecteurs, définis à l'aide
		 * de la propriété <code>points</code>, se croisent.
		 * </p>
		 * <p>
		 * Cette méthode est en général plus rapide pour tester si deux géométries se croisent
		 * par rapport à la méthode <code>geometriesIntersection</code> car la première se
		 * termine dès qu'une intersection a été trouvée, là où la seconde continue afin de
		 * déterminer tout les points d'intersection.
		 * </p>
		 *
		 * @param	geom1	la première géométrie à tester
		 * @param	geom2	le seconde géométrie à tester
		 * @return	<code>true</code> si les deux géométries s'entrecroisent
		 */
		static public function geometriesIntersects ( geom1 : Geometry, geom2 : Geometry ) : Boolean
		{
			var a1 : Array = geom1.points;
			var a2 : Array = geom2.points;

			var l1 : uint = a1.length;
			var l2 : uint = a2.length;

			var sv1 : Point;			var bv1 : Point;
			var ev1 : Point;

			var sv2 : Point;			var ev2 : Point;			var bv2 : Point;

			var cross : Point;

			var d1 : Point;			var d2 : Point;			var d3 : Point;			var d4 : Point;

			for( var i : int = 0; i<l1-1; i++ )
			{
				sv1 = a1[i];
				ev1 = a1[i+1];
				bv1 = ev1.subtract(sv1);

				for( var j : int = 0; j<l2-1; j++ )
				{
					sv2 = a2[j];
					ev2 = a2[j+1];
					bv2 = ev2.subtract(sv2);

					cross = perCrossing(sv1, bv1, sv2, bv2);

					d1 = cross.subtract( ev1 );
					d2 = cross.subtract( sv1 );
					d3 = cross.subtract( ev2 );
					d4 = cross.subtract( sv2 );

					if( d1.length <= bv1.length &&
						d2.length <= bv1.length &&
						d3.length <= bv2.length &&
						d4.length <= bv2.length )
					{
						return true;
					}
				}
			}

			return false;
		}
		/**
		 * Renvoie un tableau contenant les points d'intersections entre les deux géométries
		 * <code>geom1</code> et <code>geom2</code>. Si aucune intersection n'est trouvée,
		 * la fonction renvoie <code>null</code>.
		 *
		 * @param	geom1	première géométrie à tester
		 * @param	geom2	seconde géométrie à tester
		 * @return	un tableau contenant les points d'intersections entre les deux géométries
		 */
		static public function geometriesIntersections ( geom1 : Geometry, geom2 : Geometry ) : Array
		{
			var a : Array = [];
			var a1 : Array = geom1.points;
			var a2 : Array = geom2.points;

			var l1 : uint = a1.length;
			var l2 : uint = a2.length;

			var sv1 : Point;
			var bv1 : Point;
			var ev1 : Point;

			var sv2 : Point;
			var ev2 : Point;
			var bv2 : Point;

			var cross : Point;

			var d1 : Point;
			var d2 : Point;			var d3 : Point;			var d4 : Point;

			for( var i : int = 0; i<l1-1; i++ )
			{
				sv1 = a1[i];
				ev1 = a1[i+1];
				bv1 = ev1.subtract(sv1);

				for( var j : int = 0; j<l2-1; j++ )
				{
					sv2 = a2[j];
					ev2 = a2[j+1];
					bv2 = ev2.subtract(sv2);

					cross = perCrossing(sv1, bv1, sv2, bv2);
					d1 = cross.subtract( ev1 );
					d2 = cross.subtract( sv1 );
					d3 = cross.subtract( ev2 );
					d4 = cross.subtract( sv2 );

					if( d1.length <= bv1.length &&
						d2.length <= bv1.length &&
						d3.length <= bv2.length &&
						d4.length <= bv2.length )
					{
						a.push( cross );
					}
				}
			}

			if( a.length > 0 )
				return a;
			else
				return null;
		}
		/**
		 * Renvoie les points d'intersections entre le vecteur définit
		 * par les deux points <code>sp</code> et <code>ep</code>
		 * et la géométrie <code>geom</code>.
		 *
		 * @param	sp		point de depart du vecteur
		 * @param	ep		point d'arrivée du vecteur
		 * @param	geom	géométrie avec laquelle tester les intersections
		 * @return	les points d'intersections entre le vecteur et la géométrie
		 */
		static public function vectorGeomIntersection ( sp : Point, ep : Point, geom : Geometry ) : Array
		{
			var a : Array = [];
			var a1 : Array = geom.points;

			var l1 : uint = a1.length;

			var sv1 : Point;
			var bv1 : Point;
			var ev1 : Point;

			var bvec : Point = ep.subtract(sp);

			var cross : Point;

			var d1 : Point;
			var d2 : Point;
			var d3 : Point;
			var d4 : Point;

			for( var i : int = 0; i<l1-1; i++ )
			{
				sv1 = a1[i];
				ev1 = a1[i+1];
				bv1 = ev1.subtract(sv1);

				cross = perCrossing(sv1, bv1, sp, bvec );

				d1 = cross.subtract( ev1 );
				d2 = cross.subtract( sv1 );
				d3 = cross.subtract( sp );
				d4 = cross.subtract( ep );

				if( d1.length <= bv1.length &&
					d2.length <= bv1.length &&
					d3.length <= bvec.length &&
					d4.length <= bvec.length )
				{
					a.push( cross );
				}
			}

			if( a.length > 0 )
				return a;
			else
				return null;
		}
		/**
		 * Renvoie un objet <code>Point</code> correspondant aux coordonnées auxquelles se croise les deux
		 * droites définies par les vecteurs <code>sv1-&gt;bv1</code> et <code>sv1-&gt;bv1</code>.
		 *
		 * @param	sv1	point de départ du premier vecteur
		 * @param	bv1	vecteur de direction de la première droite
		 * @param	sv2	point de départ du second vecteur
		 * @param	bv2	vecteur de direction de la seconde droite
		 * @return	un objet <code>Point</code> correspondant aux coordonnées auxquelles se croise les deux
		 * 			droites
		 */
		static public function lineCrossing ( sv1 : Point, bv1 : Point, sv2 : Point, bv2 : Point ) : Point
        {
            var m1:Number = bv1.y / bv1.x;
            var b1:Number = sv1.y - m1 * sv1.x;
            var m2:Number = bv2.y / bv2.x;
            var b2:Number = sv2.y - m2 * sv2.x;

            var cx:Number = ( b2 - b1 )/( m1 - m2 );
            var cy:Number = m1 * cx + b1;
            
            return new Point( cx , cy );
        }
        /**
		 * Renvoie un objet <code>Point</code> correspondant aux coordonnées auxquelles se croise les deux
		 * droites définies par les vecteurs <code>sv1-&gt;bv1</code> et <code>sv1-&gt;bv1</code>.
		 *
		 * @param	sv1	point de départ du premier vecteur
		 * @param	bv1	vecteur de direction de la première droite
		 * @param	sv2	point de départ du second vecteur
		 * @param	bv2	vecteur de direction de la seconde droite
		 * @return	un objet <code>Point</code> correspondant aux coordonnées auxquelles se croise les deux
		 * 			droites
		 */
        static public function perCrossing ( sv1 : Point, bv1 : Point, sv2 : Point, bv2 : Point ):Point
		{
			var v3bx:Number = sv2.x - sv1.x;
			var v3by:Number = sv2.y - sv1.y;
			var perP1:Number = v3bx*bv2.y - v3by*bv2.x;
			var perP2:Number = bv1.x*bv2.y - bv1.y*bv2.x;

			var t:Number = perP1/perP2;

			var cx:Number = sv1.x + bv1.x*t;
			var cy:Number = sv1.y + bv1.y*t;

			return new Point( cx , cy );
		}

	}
}
