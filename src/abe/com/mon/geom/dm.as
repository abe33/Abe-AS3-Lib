/**
 * @license
 */
package abe.com.mon.geom 
{	
	/**
	 * Renvoie une nouvelle instance de la classe <code>Dimension</code> aux
	 * dimensions fournies en arguments.
	 * 
	 * @param	w	longueur de l'objet <code>Dimension</code>	 * @param	h	hauteur de l'objet <code>Dimension</code>
	 * @return	une nouvelle instance de la classe <code>Dimension</code>
	 * @author	Cédric Néhémie
	 */
	public function dm ( w: Number = 0, h : Number = 0) : Dimension
	{
		return new Dimension(w,h);
	}
}
