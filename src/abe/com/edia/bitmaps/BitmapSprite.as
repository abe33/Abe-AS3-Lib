/**
 * @license
 */
package abe.com.edia.bitmaps
{
	import abe.com.mon.core.Cloneable;

	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * Classe de base pour un moteur de <a href="http://en.wikipedia.org/wiki/Bit_blit">blitting</a>.
	 * Un objet <code>BitmapSprite</code> représente une entité pouvant être dessiné sur un canevas bitmap.
	 * <p>
	 * Un objet <code>BitmapSprite</code> ne fournit pas de méthode de dessin, mais fournit les informations
	 * permettant de le dessiner. Ainsi, un objet <code>BitmapSprite</code> fournit les informations suivantes :
	 * </p>
	 * <ul>
	 * <li><code>position</code>
	 * <p>La position du sprite dans l'espace de la scène sous forme d'un objet <code>Point</code>.</p></li>	 * <li><code>center</code>
	 * <p>La position du centre, ou point de référence, au sein du bitmap, sous forme d'un objet <code>Point</code>.
	 * Ces coordonnées seront retranchées à la position du sprite lors de la phase de dessin.</p></li>
	 * <li><code>area</code>
	 * <p>Un objet <code>Rectangle</code> représentant la portion de bitmap à prélever et à dessiner.</p></li>
	 * <li><code>visible</code>
	 * <p>Une valeur booléenne indiquant si cet objet doit être dessiné ou non.</p></li>
	 * </ul>
	 * @author Cédric Néhémie
	 * @see http://livedocs.adobe.com/flex/3/langref/flash/display/BitmapData.html BitmapData
	 * @see http://fr.wikipedia.org/wiki/Sprite_(jeu_vidéo) Définition de Sprite sur Wikipédia (fr)
	 * @see http://en.wikipedia.org/wiki/Bit_blit Définition du Bit Blit sur Wikipédia (en)
	 */
	public class BitmapSprite implements Cloneable
	{
		/**
		 * Les données graphiques de ce sprite.
		 */
		public var data : BitmapData;
		/**
		 * La position de ce sprite sur la scène.
		 */
		public var position : Point;
		/**
		 * Coordonnées du centre du bitmap par rapport à l'origine (point 0,0) de l'objet <code>BitmapData</code>.
		 */
        public var center : Point;
        /**
         * Zone de l'objet <code>BitmapData</code> à prélever lors de la phase de dessin.
         */
        public var area : Rectangle;
        /**
         * Une valeur booléenne indiquant si cet objet doit être dessiné ou non.
         */
        public var visible : Boolean;

        public var reversed : Boolean;

        /**
         * Créer un nouvel objet <code>BitmapSprite</code>.
         * <p>
         * Par défaut, la zone de prélèvement <code>area</code> correspond à la totalité
         * de la surface du <code>BitmapData</code> contenant les données graphique de l'objet.
         * </p>
         *
         * @param	data	les données graphique pour cet objet
         */
        public function BitmapSprite( data : BitmapData = null )
        {
        	if( data )
        		this.data = data;

			position = new Point();
            center = new Point();
            area = new Rectangle( 0, 0, data ? data.width : 32, data ? data.height : 32);
            visible = true;
            reversed = false;
        }

        /**
         * Renvoie une copie de l'objet courant.
         *
         * @return une copie de l'objet courant
         */
        public function clone () : *
        {
            var bs : BitmapSprite = new BitmapSprite( data );
            bs.center = center.clone();
            bs.position = position.clone();
            bs.area = area.clone();
            bs.visible = visible;
			bs.reversed = reversed;
            return bs;
        }
	}
}
