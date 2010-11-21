/**
 * @license
 */
package aesia.com.mon.utils
{
	import flash.geom.Matrix;

	/**
	 * Classe utilitaire contenant des méthodes opérant sur des objets
	 * <code>Matrix</code>.
	 *
	 * @author Cédric Néhémie
	 */
	public class MatrixUtils
	{
		/**
		 * Effectue une rotation et une mise à l'échelle de la matrice <code>m</code>
		 * autour du point définit par les coordonnées <code>x</code> et <code>y</code>.
		 *
		 * @param	m				la matrice à transformer
		 * @param	x				coordonnée en x du point de référence de la transformation
		 * @param	y				coordonnée en y du point de référence de la transformation
		 * @param	angleRadians	angle de rotation à appliquer
		 * @param	scalex			valeur de mise à l'échelle en x
		 * @param	scaley			valeur de mise à l'échelle en y
		 */
		static public function scaleAndRotateAroundExternalPoint ( m : Matrix,
															x : Number,
															y : Number,
															angleRadians : Number,
															scalex : Number,
															scaley : Number ) : void
		{
			m.tx -= x;
			m.ty -= y;
			m.rotate( angleRadians );
			m.scale( scalex, scaley );
			m.tx += x;
			m.ty += y;
		}
		/**
		 * Effectue une mise à l'échelle de la matrice <code>m</code>
		 * autour du point définit par les coordonnées <code>x</code> et <code>y</code>.
		 *
		 * @param	m				la matrice à transformer
		 * @param	x				coordonnée en x du point de référence de la transformation
		 * @param	y				coordonnée en y du point de référence de la transformation
		 * @param	scalex			valeur de mise à l'échelle en x
		 * @param	scaley			valeur de mise à l'échelle en y
		 */
		static public function scaleAroundExternalPoint (  m : Matrix,
													x : Number,
													y : Number,
													scalex : Number,
													scaley : Number ) : void
		{
			m.tx -= x;
			m.ty -= y;
			m.scale( scalex, scaley );
			m.tx += x;
			m.ty += y;
		}
		/**
		 * Effectue une rotation de la matrice <code>m</code>
		 * autour du point définit par les coordonnées <code>x</code> et <code>y</code>.
		 *
		 * @param	m				la matrice à transformer
		 * @param	x				coordonnée en x du point de référence de la transformation
		 * @param	y				coordonnée en y du point de référence de la transformation
		 * @param	angleRadians	angle de rotation à appliquer
		 */
		static public function rotateAroundExternalPoint ( m : Matrix,
													x : Number,
													y : Number,
													angleRadians : Number ) : void
		{
			m.tx -= x;
			m.ty -= y;
			m.rotate( angleRadians );
			m.tx += x;
			m.ty += y;
		}
	}
}