/**
 * @license 
 */
package  abe.com.mon.utils
{
	import abe.com.mon.colors.Color;
	import abe.com.mon.colors.Color;

	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;

	/**
	 * Classe utilitaire fournissant des filtres selon des pré-réglages.
	 * 
	 * @author Cédric Néhémie
	 */
	public class FilterUtils
	{		
		/**
		 * Renvoie un objet <code>DropShadowFilter</code> utilisable 
		 * pour créer des ombres simple sur des objets graphiques.
		 * 
		 * @param	color	couleur de l'ombre
		 * @param	alpha	transparence de l'ombre
		 * @param	dist	distance de l'ombre
		 * @param	inner	l'ombre est-elle à l'intérieur
		 * @return	un objet <code>DropShadowFilter</code>
		 */
		static public function getShadow ( color : Color, 
										   alpha : Number, 
										   dist : Number = 1, 
										   inner : Boolean = false ) : DropShadowFilter
		{
			return new DropShadowFilter(	dist, 
											45, 
											color.hexa, 
											alpha, 
											4, 
											4, 
											1, 
											3, 
											inner );
		}
		/**
		 * Renvoie un objet <code>GlowFilter</code> réglé pour faire
		 * apparâitre une bordure de 1px autour d'un objet.
		 * 
		 * @param	color	couleur de la bordure
		 * @return	un objet <code>GlowFilter</code> réglé pour faire
		 * 			apparâitre une bordure de 1px autour d'un objet
		 */
		static public function get1pxBorder ( color : Color ) : GlowFilter
		{
			return new GlowFilter( color.hexa, 1, 1.2, 1.2, 500, 3 );
		}
		/**
		 * Renvoie un objet <code>GlowFilter</code> réglé pour faire
		 * apparâitre une bordure autour d'un objet.
		 * 
		 * @param	color	couleur de la bordure
		 * @param	size	taille de la bordure
		 * @return	un objet <code>GlowFilter</code> réglé pour faire
		 * 			apparâitre une bordure autour d'un objet
		 */
		static public function getBorder ( size : Number, color : Color ) : GlowFilter
		{
			return new GlowFilter( color.hexa, 1, size, size, 500, 3 );
		}
		
	}
}