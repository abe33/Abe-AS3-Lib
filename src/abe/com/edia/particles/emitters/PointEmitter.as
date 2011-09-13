/**
 * @license
 */
package abe.com.edia.particles.emitters
{
    import abe.com.mon.randoms.Random;
    import abe.com.mon.utils.RandomUtils;
    import abe.com.patibility.lang._$;

    import flash.geom.Point;
    import flash.utils.getQualifiedClassName;
	/**
	 * La classe <code>PointEmitter</code> sert à la génération
	 * d'objet à partir de coordonnées spécifiques.
	 * 
	 * @author Cédric Néhémie
	 */
    [Serialize(constructorArgs="point")]
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
			_randomSource = RandomUtils;
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
			return point.clone();
        }

        public function clone () : *
        {
        }

	}
}
