/**
 * @license
 */
package abe.com.mon.geom 
{
    import flash.geom.Point;
	/**
	 * Returns a new instance of the class <code>Point</code> with the
	 * data passed as arguments.
	 * <fr>
	 * Renvoie une nouvelle instance de la classe <code>Point</code> aux
	 * coordonnées fournies en arguments.
	 * </fr>
	 * @param	x	X position of this point
	 * 				<fr>position en x de ce point</fr>
	 * @param	y	Y position of this point
	 * 				<fr>position en y de ce point</fr>
	 * @return	a new instance of the <code>Point</code> class
	 * 			<fr>une nouvelle instance de la classe <code>Point</code></fr>
	 * @author	Cédric Néhémie
	 */
	public function pt ( x : Number = 0, y : Number = 0) : Point
	{
		return new Point( x, y );
	}
}
