/**
 * @license
 */
package abe.com.mon.geom
{
	import abe.com.mon.geom.Rectangle2;
	/**
	 * Returns a new instance of the class <code>Rectangle2</code>
	 * according to data supplied as arguments.
	 * <fr>
	 * Renvoie une nouvelle instance de la classe <code>Rectangle2</code>
	 * selon les données fournies en arguments.
	 * </fr>
	 * @param	x			X position of the rectangle
	 * 						<fr>position en x du rectangle</fr>
	 * @param	y			Y position of the rectangle
	 * 						<fr>position en y du rectangle</fr>
	 * @param	width		width of the rectangle
	 * 						<fr>longueur du rectangle</fr>
	 * @param	height		height of the rectangle
	 * 						<fr>hauteur du rectangles</fr>
	 * @param	rotation	rotation of the rectangle
	 * 						<fr>rotation du rectangles</fr>
	 * @return	a new instance of the class <code>Rectangle2</code>
	 * 			according to data supplied as arguments
	 * 			<fr>une nouvelle instance de la classe <code>Rectangle2 </code> 
	 * 			selon les données fournies en arguments</fr>
	 * @author	Cédric Néhémie
	 */
	public function rect2 ( x : Number = 0, 
							y : Number = 0, 
							width : Number = 0, 
							height : Number = 0, 
							rotation : Number = 0 ) : Rectangle2
	{
		return new Rectangle2( x, y, width, height, rotation );
	}
}
