/**
 * @license
 */
package abe.com.mon.geom 
{
	import flash.display.DisplayObject;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	/**
	 * Réalise la transformation de l'objet <code>o</code> par
	 * la matrice de transformation <code>m</code>.
	 * <p>
	 * La fonction se comporte différemment selon la nature de 
	 * <code>o</code> : 
	 * </p>
	 * <ul>
	 * <li>Si <code>o</code> est un <code>DisplayObject</code> la
	 * matrice est affectée à sa propriété <code>transform.matrix</code>
	 * et <code>o</code> est renvoyé.</li>
	 * <li>Si <code>o</code> est un <code>Point</code> la méthode
	 * <code>Matrix.transformPoint</code> est utilisée pour transformer
	 * l'objet et le résultat de l'appel est renvoyé.</li>
	 * </ul>
	 * 
	 * @param	o	objet à trasformer
	 * @param	m	matrice de transformation
	 * @return	le résultat de la transformation selon les cas
	 */
	public function magicTransform( o : *, m : Matrix ) : *
	{
		if( o is DisplayObject )
		{
		  ( o as DisplayObject ).transform.matrix = m;
		  return o;
		}
		else if( o is Point )
		  return ( m.transformPoint( o as Point ) );
	}
}
