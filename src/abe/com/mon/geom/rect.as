package abe.com.mon.geom
{
	import flash.geom.Rectangle;

	/**
	 * Renvoie une nouvelle instance de la classe <code>Rectangle</code> selon
	 * les données fournies en arguments.
	 * 
	 * @param	x		position en x du rectangle
	 * @param	y		position en y du rectangle
	 * @param	width	longueur du rectangle
	 * @param	height	hauteur du rectangles
	 * @return	une nouvelle instance de la classe <code>Rectangle</code> selon
	 * 			les données fournies en arguments
	 * @author	Cédric Néhémie
	 */
	public function rect (x : Number = 0, y : Number = 0, width : Number = 0, height : Number = 0 ) : Rectangle
	{
		return new Rectangle( x, y, width, height );
	}
}
