/**
 * @license
 */
package abe.com.mon.geom 
{	
	/**
	 * Returns a new instance of the class <code>Dimension</code>
	 * to the dimensions of the supplied arguments.
	 * <fr>
	 * Renvoie une nouvelle instance de la classe <code>Dimension</code> aux
	 * dimensions fournies en arguments.
	 * </fr>
	 * @param	w	width of the <code>Dimension</code> object
	 * 				<fr>longueur de l'objet <code>Dimension</code></fr>	 * @param	h	height of the <code>Dimension</code> object
	 * 				<fr>hauteur de l'objet <code>Dimension</code></fr>
	 * @return	a new instance of the class <code>Dimension</code>
	 * 			<fr>une nouvelle instance de la classe <code>Dimension</code></fr>
	 * @author	Cédric Néhémie
	 */
	public function dm ( w: Number = 0, h : Number = 0) : Dimension
	{
		return new Dimension(w,h);
	}
}
