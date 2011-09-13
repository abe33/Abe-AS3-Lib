/**
 * @license
 */
package abe.com.edia.particles.emitters
{
    import abe.com.mon.utils.magicClone;
    import abe.com.mon.geom.Surface;
    import abe.com.patibility.lang._$;

    import flash.geom.Point;
    import flash.utils.getQualifiedClassName;
	/**
	 * La classe <code>SurfaceEmitter</code> permet la génération
	 * d'objets au sein d'un objet <code>Surface</code>.
	 * 
	 * @author Cédric Néhémie
	 * @see	abe.com.mon.geom.Surface
	 */
    [Serialize(constructorArgs="surface")]
	public class SurfaceEmitter implements Emitter
	{
		/**
		 * L'objet <code>Surface</code> de référence de cette instance.
		 */
		public var surface : Surface;
		/**
		 * Constructeur de la classe <code>SurfaceEmitter</code>.
		 * 
		 * @param	surface	l'objet <code>Surface</code> de référence pour
		 * 					cette instance
		 */
		public function SurfaceEmitter ( surface : Surface )
		{
			this.surface = surface;
		}
		/**
		 * Renvoie des coordonnées choisies aléatoirement au sein de l'objet
		 * <code>Surface</code> de cette instance.
		 * 
		 * @return	des coordonnées choisies aléatoirement au sein de l'objet
		 * 			<code>Surface</code> de cette instance
		 */
		public function get ( n : Number = NaN ) : Point
		{
			return surface.getRandomPointInSurface();
        }

        public function clone () : *
        {
            return new SurfaceEmitter( magicClone( surface ) );
        }
	}
}
