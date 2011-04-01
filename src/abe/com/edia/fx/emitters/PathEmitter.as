/**
 * @license
 */
package abe.com.edia.fx.emitters
{
	import abe.com.mon.core.Randomizable;
	import abe.com.mon.geom.Path;
	import abe.com.mon.geom.pt;
	import abe.com.mon.utils.PointUtils;
	import abe.com.mon.utils.Random;
	import abe.com.mon.utils.RandomUtils;
	import abe.com.motion.easing.Constant;

	import flash.geom.Point;
	/**
	 * La classe <code>PathEmitter</code> permet la génération d'objet
	 * le long d'un objet <code>Path</code>.
	 * 
	 * @author Cédric Néhémie
	 * @see	abe.com.mon.geom.Path
	 */
	public class PathEmitter implements Emitter, Randomizable
	{
		/**
		 * L'objet <code>Path</code> de référence pour cet émetteur.
		 */
		public var path : Path;
		/**
		 * L'épaisseur de la zone de pathDistribution.
		 */
		public var thickness : Number;
				
		/**
		 * Un fonction de variation de l'épaisseur de la zone de ditribution.
		 * <p>
		 * N'importe quelle fonction peut faire l'affaire, il suffit
		 * qu'elle possède la signature suivante : 
		 * </p>
		 * <listing>function thicknessEasing ( t : Number,  b : Number,  c : Number, d : Number ) : Number;</listing>
		 * <p>
		 * Il s'agit de la même signature que les fonctions utilisées avec les 
		 * classes implémentant l'interface <code>Tween</code>. 
		 * </p>
		 */
		public var thicknessEasing : Function;
		
		/**
		 * Une fonction de variation de la pathDistribution le long du chemin.
		 * <p>
		 * La fonction doit avoir la signature suivante : 
		 * </p>
		 * <listing>function pathDistribution ( n : Number ) : Number;</listing>
		 * <p>
		 * Elle recoit une valeur aléatoire comprise entre <code>0</code> et <code>1</code>
		 * et doit renvoyer une valeur elle aussi comprise entre <code>0</code> et <code>1</code>
		 * qui sera utilisée comme position dans le chemin.
		 * </p>
		 */
		public var pathDistribution : Function;		public var sizeDistribution : Function;
		public var minThickness : Number;
		
		protected var _randomSource : Random;

		/**
		 * Constructeur de la classe <code>PathEmitter</code>.
		 * 
		 * @param	path		l'objet <code>Path</code> de référence
		 * 						pour cette instance
		 * @param	thickness	épaisseur de la zone de pathDistribution
		 * @param	thicknessEasing		une fonction de variation de l'épaisseur
		 */
		public function PathEmitter ( path : Path, 
									  thickness : Number = 1, 
									  thicknessEasing : Function = null,
									  pathDistribution : Function = null,									  sizeDistribution : Function = null,
									  minThicness : Number = 0 )
		{
			this.path = path;
			this.thickness = thickness;
			this.thicknessEasing = thicknessEasing != null ? thicknessEasing : Constant.easeOne;
			this.pathDistribution = pathDistribution != null ? pathDistribution : Distributions.constant;			this.sizeDistribution = sizeDistribution != null ? sizeDistribution : Distributions.constant;
			this.minThickness = minThicness;
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
		 * Renvoie des coordonnées définies aléatoirement au sein du chemin
		 * défini par l'objet <code>Path</code> de cette instance.
		 * 
		 * @return	des coordonnées définies aléatoirement au sein du chemin
		 */
		public function get ( n : Number = NaN ) : Point
		{
			var r : Number = pathDistribution( isNaN( n ) ? RandomUtils.random() : n );
			var s : Number = sizeDistribution( RandomUtils.random() ); 
			var p : Point = path.getPathPoint( r );
			var a : Number = path.getPathOrientation( r );
			var p2 : Point = pt(0,1);
			p2 = PointUtils.rotate(p2, a);
			p2.normalize( thicknessEasing( r, minThickness, thickness-minThickness, 1 ) * RandomUtils.sign() * s );
			return p.add( p2 );
		}
	}
}
