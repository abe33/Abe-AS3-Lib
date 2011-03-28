/**
 * @license
 */
package abe.com.edia.fx.emitters
{
	import abe.com.mon.utils.Random;
	import abe.com.mon.utils.RandomUtils;

	import flash.geom.Point;
	/**
	 * La classe <code>PointEmitter</code> sert à la génération
	 * d'objet à partir de coordonnées spécifiques.
	 * 
	 * @author Cédric Néhémie
	 */
	public class PointEmitter implements Emitter
	{
		/**
		 * Les coordonnées de génération de cette instance.
		 */
		public var point : Point;
		protected var _randomSource : Random;

		/**
		 * Constructeur de la classe <code>PointEmitter</code>.
		 * 
		 * @param	point	les coordonnées d'emmission pour cette
		 * 					instance
		 */
		public function PointEmitter ( point : Point )
		{
			this.point = point;
			_randomSource = RandomUtils.RANDOM;
		}
		/**
		 * @inheritDoc
		 */
		public function get randomSource () : Random { return _randomSource; }
		public function set randomSource (randomSource : Random) : void
		{
			_randomSource = randomSource;
		}
		/**
		 * Renvoie les coordonnées d'emmision de cette instance.
		 * 
		 * @return	les coordonnées d'emmision de cette instance
		 */
		public function get ( n : Number = NaN ) : Point
		{
			return point;
		}
	}
}
