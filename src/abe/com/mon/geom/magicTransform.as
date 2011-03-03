/**
 * @license
 */
package abe.com.mon.geom 
{
	import flash.display.DisplayObject;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	/**
	 * Realizes the transformation of <code>o</code> with
	 * the transformation matrix <code>m</code>.
	 * <p>
	 * The function behaves differently depending 
	 * of the nature of <code>o</code>:
	 * </p>
	 * <ul>
	 * <li>If <code>o</code> is a <code>DisplayObject</code>
	 * the matrix is assigned to his property <code>transform.matrix</code>
	 * and <code>o</code> is returned.</li>
	 * <li>If <code>o</code> is a <code>Point</code>, the method 
	 * <code>Matrix.transformPoint</code> is used to transform 
	 * the object and the outcome is returned.</li>
	 * </ul>
	 * <fr>
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
	 * </fr>
	 * @param	o	object to transform
	 * 				<fr>objet à transformer</fr>
	 * @param	m	transformation matrix
	 * 				<fr>matrice de transformation</fr>
	 * @return	the transformation result depending of the type of <code>o</code>
	 * 			<fr>le résultat de la transformation selon les cas</fr>
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
