/**
 * @license
 */
package  aesia.com.ponents.utils 
{
	import aesia.com.mon.utils.StageUtils;
	import aesia.com.ponents.skinning.cursors.Cursor;

	import flash.display.Sprite;

	/**
	 * La classe utilitaire <code>Toolkit</code> fournit quelques méthodes
	 * bien pratique pour la configuration rapide d'une scène Flash.
	 * Dans le registre des fonctionnalités de la classe <code>Toolkit</code>
	 * on trouve : 
	 * <ul>
	 * <li>Un accès global au niveau racine de la hiérarchie graphique.</li>
	 * <li>La configuration automatique des comportements de redimensionnement
	 *    du Stage selon plusieurs modèles récurents.</li>
	 * </ul>
	 */
	public class ToolKit 
	{
		/**
		 * Une référence vers le niveau des outils, celui-ci est situé
		 * au dessus du niveau des popups, et en dessous de celui des
		 * infobulles.
		 */
		static public var toolLevel : Sprite;
		/**
		 * Une référence vers ce qui devrait être le niveau principal de l'animation.
		 * Cette référence doit être utilisé à la place de la racine normale de 
		 * l'animation, cette méthode permet notament à certains composants de
		 * pouvoir toujours être affiché au dessus de la scène 
		 * (ex. <code>Cursor</code> et <code>Tooltip</code>).
		 */
		static public var mainLevel : Sprite;
		/**
		 * Une référence vers un niveau situé au dessus de <code>mainLevel</code>.
		 * À utiliser lorsqu'il est nécessaire de créer des popups par
		 * par dessus la totalité de la scène. Cependant ce niveau est 
		 * toujours situé sous le niveau des outils, du curseur et des
		 * infos bulles.
		 */
		static public var popupLevel : Sprite;		/**
		 * Une référence vers un niveau situé au dessus de <code>popupLevel</code>.
		 * Cependant ce niveau est toujours situé sous le niveau du curseur et des
		 * infos bulles.
		 */
		static public var dndLevel : Sprite;
		/**
		 * Une référence vers un objet <code>Sprite</code> utilisée par la classe
		 * <code>Tooltip</code> pour l'affichage d'infobulles.
		 */
		static public var tooltipLevel : Sprite;
		/**
		 * Une référence vers un objet <code>Sprite</code> utilisée par la classe
		 * <code>Cursor</code> pour l'affichage des curseurs.
		 */
		static public var cursorLevel : Sprite;
		/**
		 * Une valeur booléenne indiquant si la classe à été initialisée.
		 */
		static private var _initialized : Boolean = false;
		/**
		 * Initialise la classe avec la racine de l'animation. Durant
		 * cette phase les différents niveaux du système sont crées.
		 * 
		 * @param	r	la véritable racine d'origine de l'animation
		 */		 
		static public function initializeToolKit () : void
		{
			if( _initialized )
				return;
			
			mainLevel = new Sprite();
			popupLevel = new Sprite();
			
			toolLevel = new Sprite();			
			toolLevel.mouseEnabled = false;
			toolLevel.mouseChildren = false;
			
			dndLevel = new Sprite();
			dndLevel.mouseEnabled = false;
			dndLevel.mouseChildren = false;
			
			cursorLevel = new Sprite();
			cursorLevel.mouseEnabled = false;
			cursorLevel.mouseChildren = false;
			
			tooltipLevel = new Sprite();
			tooltipLevel.mouseEnabled = false;
			tooltipLevel.mouseChildren = false;
			
			StageUtils.root.addChild( mainLevel );
			StageUtils.root.addChild( popupLevel );			StageUtils.root.addChild( dndLevel );
			StageUtils.root.addChild( toolLevel );
			StageUtils.root.addChild( tooltipLevel );
			StageUtils.root.addChild( cursorLevel );
			
			/*FDT_IGNORE*/ FEATURES::CURSOR { /*FDT_IGNORE*/
				Cursor.init( ToolKit.cursorLevel );
			/*FDT_IGNORE*/ } /*FDT_IGNORE*/
			_initialized = true;
		}
		/**
		 * Configure l'objet <code>Sprite</code> pour que les évènements de claviers
		 * diffusé par ses enfants lui soit correctement reportés.
		 * <p>
		 * La fonction modifie les propriétés tel que : 
		 * </p>
		 * <ul>
		 * <li><code>buttomMode = true</code></li>
		 * <li><code>useHandCursor = false</code></li>
		 * <li><code>tabEnabled = false</code></li>
		 * </ul>
		 * 
		 * @param	canvas	l'objet <code>Sprite</code> à configurer
		 */
		static public function enableKeyboardEvent ( canvas : Sprite ) : void
		{			
			canvas.buttonMode = true;
			canvas.useHandCursor = false;
			canvas.tabEnabled = false;
		}
	}
}
