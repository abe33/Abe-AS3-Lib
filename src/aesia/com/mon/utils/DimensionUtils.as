/**
 * @license
 */
package aesia.com.mon.utils 
{
	import aesia.com.mon.geom.Dimension;

	/**
	 * Classe utilitaire fournissant des méthodes de traitement des objets
	 * <code>Dimension</code>.
	 * 
	 * @author Cédric Néhémie
	 */
	public class DimensionUtils 
	{
		/**
		 * Renvoie un objet <code>Dimension</code> dont la taille à été ajusté
		 * selon la valeur de <code>maxSize</code> tout en conservant les proportions
		 * d'origine.
		 * 
		 * @param	d		dimension d'origine
		 * @param	maxSize	taille maximum d'une des dimensions
		 * @return	un objet <code>Dimension</code> dont la taille à été ajusté
		 * 			selon la valeur de <code>maxSize</code>
		 */
		static public function fitDimension( d : Dimension, maxSize : Number ) : Dimension
		{
			var r : Number;
			if( d.width > d.height )
			{
				r = d.width / d.height;
				return new Dimension( maxSize, maxSize / r );
			}
			else if( d.width < d.height )
			{
				r = d.width / d.height;
				return new Dimension( maxSize * r , maxSize );
			}
			else return new Dimension( maxSize, maxSize );
		}
	}
}
