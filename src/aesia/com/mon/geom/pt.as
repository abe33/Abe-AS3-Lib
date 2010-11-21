/**
 * @license
 */
package aesia.com.mon.geom 
{
	import flash.geom.Point;
	/**
	 * Renvoie une nouvelle instance de la classe <code>Point</code> aux
	 * coordonnées fournies en arguments.
	 * 
	 * @param	x	position en x de ce point
	 * @param	y	position en y de ce point
	 * @return	une nouvelle instance de la classe <code>Point</code>
	 * @author	Cédric Néhémie
	 */
	public function pt ( x : Number = 0, y : Number = 0) : Point
	{
		return new Point( x, y );
	}
}
