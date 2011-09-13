/**
 * @license
 */
package abe.com.mon.utils
{
    import abe.com.mon.geom.Dimension;

    import flash.geom.Point;
	/**
	 * La classe <code>IsoMath</code> est une classe utilitaire fournissant
	 * des méthodes permettant de travailler dans un espace isométrique.
	 *
	 * @author Cédric Néhémie
	 */
	public class IsoMath
	{
		static protected const DEFAULT_OFFSET : Point = new Point();

		/**
		 * Renvoie les coordonnées écran correspondant aux coordonnées
		 * de la grille <code>gridPos</code>.
		 *
		 * @param	gridPos		la position dans la grile à convertir
		 * 						en coordonnées écran
		 * @param	cellSize	la demi-taille d'une cellule de la grille
		 * 						sur l'écran
		 * @param	offset		un objet <code>Point</code> servant de décalage
		 * 						aux coordonnées écran
		 * @param	level		un nombre représentant le différentiel d'altitude
		 * 						de la cellule de la grille
		 * @return	les coordonnées écran correspondantes
		 */
		static public function getScreenPos (  gridPos : Point,
											   cellSize : Dimension,
											   offset : Point = null,
											   level : Number = 0) : Point
		{
			if( offset == null )
				offset = DEFAULT_OFFSET;

			return new Point( ( gridPos.x * cellSize.width - gridPos.y * cellSize.width ) + offset.x ,
		   		  			  ( gridPos.y * cellSize.height + gridPos.x * cellSize.height ) + offset.y - level );
		}
		/**
		 * Renvoie des coordonnées discrète dans la grille à partir de coordonnées
		 * écran. Les coordonnées sont dites dicrètes car elle sont représentées sous
		 * la formes de nombre à virgule flottante.
		 * 
		 * @param	screenPos	les coordonnées écran à convertir
		 * @param	cellSize	la dimension d'une cellule à l'écran
		 * @param	offset		un objet <code>Point</code> servant de décalage
		 * 						aux coordonnées écran
		 * @param	level		un nombre représentant le différentiel d'altitude
		 * 						de la cellule de la grille
		 * @return	les coordonnées discrète dans la grille correspondant aux coordonnées
		 * 			écran transmises
		 */
		static public function getDiscretGridPos ( screenPos : Point,
													 cellSize : Dimension,
													 offset : Point = null,
													 level : Number = 0) : Point
		{
			if( offset == null )
				offset = DEFAULT_OFFSET;

			return new Point (
				 ( ( screenPos.x - offset.x ) / cellSize.width +
							   ( screenPos.y - offset.y + level ) / cellSize.height ) / 2,
				 ( ( screenPos.y - offset.y + level ) / cellSize.height -
							   ( screenPos.x - offset.x ) / cellSize.width ) / 2 );
		}
		/**
		 * Renvoie des coordonnées dans la grille à partir de coordonnées
		 * écran. 
		 * 
		 * @param	screenPos	les coordonnées écran à convertir
		 * @param	cellSize	la dimension d'une cellule à l'écran
		 * @param	offset		un objet <code>Point</code> servant de décalage
		 * 						aux coordonnées écran
		 * @param	level		un nombre représentant le différentiel d'altitude
		 * 						de la cellule de la grille
		 * @return	les coordonnées dans la grille correspondant aux coordonnées
		 * 			écran transmises
		 */
		static public function getGridPos ( screenPos : Point,
										 	cellSize : Dimension,
										 	offset : Point = null,
										 	level : Number = 0) : Point
		{
			if( offset == null )
				offset = DEFAULT_OFFSET;

			return new Point (
				Math.round ( ( ( screenPos.x - offset.x ) / cellSize.width +
							   ( screenPos.y - offset.y + level ) / cellSize.height ) / 2 ),
				Math.round ( ( ( screenPos.y - offset.y + level ) / cellSize.height -
							   ( screenPos.x - offset.x ) / cellSize.width ) / 2 )
			);
		}
	}
}
