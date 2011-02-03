/**
 * @license
 */
package aesia.com.mon.utils
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	/**
	 * Classe utilitaire fournissant des contrôles sur l'objet <code>Stage</code> de manière globale.
	 * Pour fonctionner correctement un certain nombre d'objets (notamment parmis les composants) nécessite
	 * que le <code>StageUtils</code> soit initialisé avant d'être instanciés.
	 *
	 * @author Cédric Néhémie
	 */
	public class StageUtils
	{
		/**
		 * Constante utilisée avec la méthode <code>lockToStage</code>.
		 * Si on appelle <code>lockToStage</code> pour un objet déjà enregistré
		 * et avec la contrainte <code>NONE</code>, cela équivaut à un appel à
		 * la méthode <code>unlockFromStage</code>. Autrement, cette contrainte
		 * n'est pas traitée.
		 *
		 * @see #lockToStage()		 * @see #unlockFromStage()
		 */
		static public const NONE : uint = 0;

		/**
		 * Constante utilisée avec la méthode <code>lockToStage</code>.
		 * L'objet vérouillé avec cette contrainte verra sa longueur systématiquement
		 * ajusté selon la taille du <code>Stage</code>.
		 *
		 * @see #lockToStage()
		 */
		static public const WIDTH : uint = 1;
		/**
		 * Constante utilisée avec la méthode <code>lockToStage</code>.
		 * L'objet vérouillé avec cette contrainte verra sa hauteur systématiquement
		 * ajusté selon la taille du <code>Stage</code>.
		 *
		 * @see #lockToStage()
		 */
		static public const HEIGHT : uint = 2;
		/**
		 * Constante utilisée avec la méthode <code>lockToStage</code>.
		 * L'objet vérouillé avec cette contrainte sera toujours aligné sur
		 * le bord gauche du <code>Stage</code>
		 *
		 * @see #lockToStage()
		 */
		static public const X_ALIGN_LEFT : uint = 4;
		/**
		 * Constante utilisée avec la méthode <code>lockToStage</code>.
		 * L'objet vérouillé avec cette contrainte sera toujours centré
		 * horizontalement par rapport au <code>Stage</code>
		 *
		 * @see #lockToStage()
		 */
		static public const X_ALIGN_CENTER : uint = 8;
		/**
		 * Constante utilisée avec la méthode <code>lockToStage</code>.
		 * L'objet vérouillé avec cette contrainte sera toujours aligné sur
		 * le bord droit du <code>Stage</code>
		 *
		 * @see #lockToStage()
		 */
		static public const X_ALIGN_RIGHT : uint = 16;
		/**
		 * Constante utilisée avec la méthode <code>lockToStage</code>.
		 * L'objet vérouillé avec cette contrainte sera toujours visible sur
		 * le <code>Stage</code>.
		 * <p>
		 * Dans la pratique, cela signifie que si l'objet dépasse du <code>Stage</code>
		 * lors de son apparition, ou d'un redimensionnement du <code>Stage</code> sa position
		 * en X sera corrigée afin de conserver l'objet entièrement sur la scène. Le seul cas où
		 * l'objet pourra sortir du <code>Stage</code> est si celui-ci est plus grand que l'espace
		 * disponible.
		 * </p>
		 *
		 * @see #lockToStage()
		 */		static public const X_ALWAYS_VISIBLE : uint = 32;
		/**
		 * Constante utilisée avec la méthode <code>lockToStage</code>.
		 * L'objet vérouillé avec cette contrainte sera toujours aligné sur
		 * le bord supérieur du <code>Stage</code>
		 *
		 * @see #lockToStage()
		 */
		static public const Y_ALIGN_TOP : uint = 64;
		/**
		 * Constante utilisée avec la méthode <code>lockToStage</code>.
		 * L'objet vérouillé avec cette contrainte sera toujours centré
		 * verticalement par rapport au <code>Stage</code>
		 *
		 * @see #lockToStage()
		 */
		static public const Y_ALIGN_CENTER : uint = 128;
		/**
		 * Constante utilisée avec la méthode <code>lockToStage</code>.
		 * L'objet vérouillé avec cette contrainte sera toujours aligné sur
		 * le bord inférieur du <code>Stage</code>
		 *
		 * @see #lockToStage()
		 */
		static public const Y_ALIGN_BOTTOM : uint = 256;		/**
		 * Constante utilisée avec la méthode <code>lockToStage</code>.
		 * L'objet vérouillé avec cette contrainte sera toujours visible sur
		 * le <code>Stage</code>.
		 * <p>
		 * Dans la pratique, cela signifie que si l'objet dépasse du <code>Stage</code>
		 * lors de son apparition, ou d'un redimensionnement du <code>Stage</code> sa position
		 * en Y sera corrigée afin de conserver l'objet entièrement sur la scène. Le seul cas où
		 * l'objet pourra sortir du <code>Stage</code> est si celui-ci est plus grand que l'espace
		 * disponible.
		 * </p>
		 *
		 * @see #lockToStage()
		 */
		static public const Y_ALWAYS_VISIBLE : uint = 512;
		/**
		 * Une référence vers la véritable racine de l'application
		 */
		static protected var _root : DisplayObjectContainer;
		
		/**
		 * Un objet <code>Vector</code> contenant l'ensemble des objets <code>StageConstraint</code>
		 * créer par l'intermédiaire de la méthode <code>lockToStage</code>.
		 */		static protected var _lockedObjects : Array = [];
		/**
		 * Une valeur booléenne indiquant si la classe à été initialisée.
		 */
		static private var _initialized : Boolean = false; 
		/**
		 * Initialise la classe avec la racine de l'animation.
		 *
		 * @param	r	la véritable racine d'origine de l'animation
		 */		
		static public function setup( r : DisplayObjectContainer ) : void
		{
			if(_initialized)
				return;
			
			_root = r;
			_initialized = true;
		}
		/**
		 * Accès global à la racine de l'application.
		 */
		static public function get root () : DisplayObjectContainer { return _root; }
		/**
		 * Accès global à la scène principale.
		 */		static public function get stage () : Stage { return _root.stage; }
/*-------------------------------------------------------------------------*
 * 	STAGE MANAGEMENT
 *-------------------------------------------------------------------------*/
		/**
		 * Configure le <code>Stage</code> de l'animation tel que :
		 * <ol>
	  	 * <li>l'animation conservera toujours la même échelle (<code>StageScaleMode.NO_SCALE</code>).</li>
		 * <li>le centre de l'animation sera toujours situé en haut à gauche de
		 * l'espace disponible (<code>StageAlign.TOP_LEFT</code>).</li>
		 * </ol>
		 */
		static public function flexibleStage () : void
		{
			_root.stage.scaleMode = StageScaleMode.NO_SCALE;
			_root.stage.align = StageAlign.TOP_LEFT;
		}
		/**
		 * Configure le <code>Stage</code> de l'animation tel que :
		 * <ol>
	  	 * <li>l'animation sera toujours à la meilleure taille possible
		 * (<code>StageScaleMode.EXACT_FIT</code>).</li>
		 * <li>le centre de l'animation sera toujours situé en haut à gauche de
		 * l'espace disponible (<code>StageAlign.TOP_LEFT</code>).</li>
		 * </ol>
		 */
		static public function fixedStage () : void
		{
			_root.stage.scaleMode = StageScaleMode.EXACT_FIT;
			_root.stage.align = StageAlign.TOP_LEFT;
		}
		/**
		 * Configure le <code>Stage</code> de l'animation tel que l'animation conservera
		 * toujours la même échelle (<code>StageScaleMode.NO_SCALE</code>).
		 * Aucune règle d'alignement particulière n'est définie pour ce mode.
		 */
		static public function unscaledStage () : void
		{
			_root.stage.scaleMode = StageScaleMode.NO_SCALE;
		}
/*-------------------------------------------------------------------------*
 * 	CONTEXTUAL MENUS
 *-------------------------------------------------------------------------*/
 		/*FDT_IGNORE*/ FEATURES::MENU_CONTEXT { /*FDT_IGNORE*/
			
		/**
		 * Un objet <code>Vector</code> contenant des objets <code>ContextMenuItem</code>
		 * utilisé pour constituer le menu contextuel global.
		 * <p>
		 * Dans le cas d'un composant, les menus globaux sont ajoutés aux menus du composant
		 * pour constituer le menu final.
		 * </p>
		 */
		/*FDT_IGNORE*/
		TARGET::FLASH_9
		static protected var _globalMenus : Array = [];
		
		TARGET::FLASH_10
		static protected var _globalMenus : Vector.<ContextMenuItem> = new Vector.<ContextMenuItem>();
		
		TARGET::FLASH_10_1 /*FDT_IGNORE*/
		static protected var _globalMenus : Vector.<ContextMenuItem> = new Vector.<ContextMenuItem>();
		
		/**
		 * Un vecteur contenant les menus contextuels courants. 
		 */
		/*FDT_IGNORE*/
		TARGET::FLASH_9
		static protected var _currentMenuContext : Array;
		
		TARGET::FLASH_10
		static protected var _currentMenuContext : Vector.<ContextMenuItem>;
		
		TARGET::FLASH_10_1 /*FDT_IGNORE*/
		static protected var _currentMenuContext : Vector.<ContextMenuItem>;
		
		/**
		 * Un tableau contenant le menu contextuel courant, c'est-à-dire formé par les menus définit
		 * par un composant (si la souris est au dessus de l'un d'eux, et qu'il fournit des menus) et
		 * par les menus globaux.
		 */
		static protected var _currentMenu : Array;
		
		static protected var _versionMenuContext : ContextMenuItem;
		
		static public function get versionMenuContext() : ContextMenuItem { return _versionMenuContext; }
		static public function set versionMenuContext ( contextMenuItem : ContextMenuItem) : void { _versionMenuContext = contextMenuItem; }
		
		/**
		 * Supprime tout les éléments de base du menu contextuel du Flash Player.
		 *
		 * @see http://livedocs.adobe.com/flex/3/langref/flash/ui/ContextMenu.html#hideBuiltInItems() ContextMenu.hideBuiltInItems()
		 */
		static public function noMenu () : void
		{
			var contextMenu : ContextMenu = new ContextMenu();
			contextMenu.hideBuiltInItems();

			_root.contextMenu = contextMenu;
		}
		/**
		 * Définie les menus disponible depuis le menu contextuel. Les menus
		 * définit globalement sont automatiquement ajouté à la suite des menus
		 * passés en argument (dans la mesure des restrictions imposées par le
		 * flash player).
		 * <p>
		 * Les menus globaux sont séparés des menus réellement lié au contexte
		 * par un séparateur.
		 * </p>
		 * @param	m	vecteur contenant les menus à afficher dans le menu
		 * 				contextuel
		 */
		/*FDT_IGNORE*/
		TARGET::FLASH_9
		static public function setMenus ( m : Array ) : void
		{
			_currentMenuContext = m;
			updateMenus();
		}
		
		TARGET::FLASH_10		static public function setMenus ( m : Vector.<ContextMenuItem> ) : void
		{
			_currentMenuContext = m;
			updateMenus();
		}
		
		TARGET::FLASH_10_1 /*FDT_IGNORE*/		static public function setMenus ( m : Vector.<ContextMenuItem> ) : void
		{
			_currentMenuContext = m;
			updateMenus();
		}
		/**
		 * Supprime tout les menus définit précédemment par un appel à la méthode <code>setMenus</code>.
		 * <p>
		 * Si des menus globaux ont été définis, ceux-ci resteront visible dans le menu contextuel.
		 * </p>
		 */
		static public function unsetMenus () : void
		{
			_currentMenuContext = null;
			updateMenus();
		}
		/**
		 * Ajoute le menu <code>m</code> transmis en argument en tant que
		 * menu global disponible en permanence dans le menu contextuel.
		 *
		 * @param	m	menu à ajouter aux menus globaux
		 */
		static public function addGlobalMenu ( m : ContextMenuItem ) : void
		{
			if( containsGlobalMenu(m) )
				return;

			_globalMenus.push( m );
			updateMenus();
		}
		/**
		 * Supprime le menu <code>m</code> des menus globaux accessible
		 * en permanence depuis le menu contextuel.
		 *
		 * @param	m	menu à supprimer des menus globaux
		 */
		static public function removeGlobalMenu ( m : ContextMenuItem ) : void
		{
			if( !containsGlobalMenu(m) )
				return;

			_globalMenus.splice( _globalMenus.indexOf(m), 1 );
			updateMenus();
		}
		/**
		 * Renvoie <code>true</code> si le menu <code>m</code> en argument est
		 * présent parmis les menu globaux.
		 *
		 * @param	m	menu à vérifier qu'il est contenu dans les menus globaux
		 * @return	<code>true</code> si le menu <code>m</code> en argument est
		 * 			présent parmis les menu globaux, autrement <code>false</code>
		 */
		static public function containsGlobalMenu( m : ContextMenuItem ) : Boolean
		{
			return _globalMenus.indexOf( m ) != -1;
		}
		/**
		 * Met à jour le menu contextuel suite à une transformation dans les menus disponible.
		 */
		static protected function updateMenus () : void
		{
			_currentMenu = [];
			var l : Number;
			var i : Number;

			if( _currentMenuContext )
			{
				l = _currentMenuContext.length;
				for( i=0; i<l; i++ )
					_currentMenu.push( _currentMenuContext[ i ] );

			}
			l = _globalMenus.length;
			for( i=0; i<l; i++ )
			{
				if( _currentMenuContext && i == 0 && _currentMenu.length > 0)
					_globalMenus[ i ].separatorBefore = true;
				else
					_globalMenus[ i ].separatorBefore = false;

				_currentMenu.push( _globalMenus[ i ] );
			}
			if( _versionMenuContext )
			{
				_versionMenuContext.separatorBefore = true;
				_currentMenu.push( _versionMenuContext );
			}

			var menu : ContextMenu = ( _root.contextMenu as ContextMenu );
			if( !menu )
				menu = new ContextMenu();

			menu.customItems = _currentMenu;
			_root.contextMenu = menu;
		}
		/*FDT_IGNORE*/ } /*FDT_IGNORE*/
		
/*-------------------------------------------------------------------------*
 * 	LOCKED OBJECTS
 *-------------------------------------------------------------------------*/
		/**
		 * Vérrouille l'objet <code>o</code> au <code>Stage</code> selon les règles définit
		 * dans <code>constraints</code>.
		 * <p>
		 * Les valeurs de contraintes possibles sont :
		 * <ul>
		 * <li>NONE</li>		 * <li>WIDTH</li>		 * <li>HEIGHT</li>		 * <li>X_ALIGN_LEFT</li>		 * <li>X_ALIGN_CENTER</li>		 * <li>X_ALIGN_RIGHT</li>		 * <li>X_ALWAYS_VISIBLE</li>		 * <li>Y_ALIGN_TOP</li>		 * <li>Y_ALIGN_CENTER</li>		 * <li>Y_ALIGN_BOTTOM</li>		 * <li>Y_ALWAYS_VISIBLE</li>
		 * </ul>
		 * Elles sont pour certaines combinable entre elles (voir les exemples).
		 * </p>
		 * @param	o			l'objet que l'on souhaite soumettre à des contraintes liées au <code>Stage</code>
		 * @param	constraints	un entier représentant les contraintes applicable à l'objet
		 * @see #NONE
		 * @see #WIDTH		 * @see #HEIGHT		 * @see #X_ALIGN_LEFT		 * @see #X_ALIGN_CENTER		 * @see #X_ALIGN_RIGHT		 * @see #X_ALWAYS_VISIBLE
		 * @see #Y_ALIGN_LEFT
		 * @see #Y_ALIGN_CENTER
		 * @see #Y_ALIGN_RIGHT
		 * @see #Y_ALWAYS_VISIBLE
		 * @example
		 * <p>La configuration suivante redimenssionne l'objet selon les dimensions
		 * du <code>Stage</code> : </p>
		 * <listing>StageUtils.lockToStage( obj );</listing>
		 * <p>
		 * La configuration suivante vérrouille la longueur de l'objet sur celle du
		 * <code>Stage</code> et l'aligne sur le bord inférieur de l'écran.
		 * </p>		 * <listing>StageUtils.lockToStage( obj, StageUtils.WIDTH + StageUtils.Y_ALIGN_BOTTOM );</listing>
		 * <p>
		 * La configuration suivante vérrouille la hauteur de l'objet sur celle du
		 * <code>Stage</code> et l'aligne sur le bord droit de l'écran.
		 * </p>
		 * <listing>StageUtils.lockToStage( obj, StageUtils.HEIGHT + StageUtils.X_ALIGN_RIGHT );</listing>
		 */
		static public function lockToStage ( o : DisplayObject, constraints : uint = 3 ) : void
		{
			if( !isLocked( o ) && constraints != NONE )
			{
				var st : StageConstraint = new StageConstraint( o, constraints );
				_lockedObjects.push(st);
				st.applyConstraints();

				if( _lockedObjects.length == 1 )
					stage.addEventListener( Event.RESIZE, stageResize );
			}
			else if( constraints == NONE )
				unlockFromStage( o );
		}
		/**
		 * Enlève toutes les contraintes associées à l'objet <code>o</code>.
		 *
		 * @param	o	l'objet pour lequel supprimer les contraintes
		 */
		static public function unlockFromStage ( o : DisplayObject ) : void
		{
			if( isLocked(o) )
			{
				_lockedObjects.splice( _lockedObjects.indexOf( getConstraints(o) ), 1 );

				if( _lockedObjects.length == 0 )
					stage.removeEventListener( Event.RESIZE, stageResize );
			}
		}
		/**
		 * Renvoie <code>true</code> si l'objet a des contraintes associées, autrement
		 * la fonction renvoie <code>false</code>.
		 *
		 * @param	o	objet pour lequel on souhaite vérifier l'existence de contraintes
		 * @return	<code>true</code> si l'objet a des contraintes associées, autrement
		 * 			la fonction renvoie <code>false</code>
		 */
		static public function isLocked ( o : DisplayObject ) : Boolean
		{
			for each ( var st : StageConstraint in _lockedObjects )
			{
				if( st.target == o )
					return true;
			}
			return false;
		}
		/*
		 * Renvoie les contraintes associé à l'objet o
		 */
		static private function getConstraints ( o : DisplayObject) : StageConstraint
		{
			for each ( var st : StageConstraint in _lockedObjects )
			{
				if( st.target == o )
					return st;
			}
			return null;
		}
		/**
		 * Reçoie les évènement <code>stageResize</code> et réalise les
		 * ajustements nécessaire pour les objets contraints.
		 *
		 * @param	event	l'objet <code>Event</code> diffusé avec l'évènement
		 */
		static public function stageResize (event : Event) : void
		{
			for each ( var st : StageConstraint in _lockedObjects )
				st.applyConstraints();
		}
		/**
		 * Centre l'objet <code>o</code> sur l'axe x par rapport à la taille de la scène.
		 *
		 * @param	o		l'objet à centrer
		 * @param	width	une longueur optionnelle utilisée à la place de la longueur
		 * 					de l'objet <code>o</code>.
		 */
		static public function centerX ( o : DisplayObject, width : Number = NaN ) : void
		{
			if( isNaN( width ) )
				width = o.width;

			o.x = ( stage.stageWidth - width ) / 2;
		}
		/**
		 * Centre l'objet <code>o</code> sur l'axe y par rapport à la taille de la scène.
		 *
		 * @param	o		l'objet à centrer
		 * @param	height	une hauteur optionnelle utilisée à la place de la hauteur
		 * 					de l'objet <code>o</code>.
		 */
		static public function centerY ( o : DisplayObject, height : Number = NaN ) : void
		{
			if( isNaN( height ) )
				height = o.height;

			o.y = ( stage.stageHeight - height ) / 2;
		}
		
		static public function isDescendant( a : DisplayObject, b : DisplayObjectContainer ): Boolean
		{
			var p : DisplayObjectContainer = a.parent;
			while( p )
			{
				if( p == b )
					return true;
				
				p = p.parent;
			}
			return false;
		}
	}
}

import aesia.com.mon.utils.StageUtils;

import flash.display.DisplayObject;

/*
 * Un objet StageConstraint est utilisé en interne
 * par la classe StageUtils pour représenter les contraintes
 * appliquées à un objet.
 */
internal class StageConstraint
{
	public var target : DisplayObject;
	public var constraint : uint;

	public function StageConstraint ( target : DisplayObject, constraint : uint )
	{
		this.target = target;
		this.constraint = constraint;
	}

	public function applyConstraints () : void
	{
		if( constraint & StageUtils.WIDTH )
			target.width = StageUtils.stage.stageWidth;

		if( constraint & StageUtils.HEIGHT )
			target.height = StageUtils.stage.stageHeight;

		if( constraint & StageUtils.X_ALIGN_LEFT )
			target.x = 0;
		else if( constraint & StageUtils.X_ALIGN_CENTER )
			target.x = ( StageUtils.stage.stageWidth - target.width ) / 2;
		else if( constraint & StageUtils.X_ALIGN_RIGHT )
			target.x = StageUtils.stage.stageWidth - target.width;
		else if( constraint & StageUtils.X_ALWAYS_VISIBLE )
		{
			if( target.x < 0 )
				target.x = 0;
			else if( target.x + target.width > StageUtils.stage.stageWidth )
				target.x = StageUtils.stage.stageWidth - target.width;
		}

		if( constraint & StageUtils.Y_ALIGN_TOP )
			target.y = 0;
		else if( constraint & StageUtils.Y_ALIGN_CENTER )
			target.y = ( StageUtils.stage.stageHeight - target.height ) / 2;
		else if( constraint & StageUtils.Y_ALIGN_BOTTOM )
			target.y = StageUtils.stage.stageHeight - target.height;
		else if( constraint & StageUtils.Y_ALWAYS_VISIBLE )
		{
			if( target.y < 0 )
				target.y = 0;
			else if( target.y + target.height > StageUtils.stage.stageHeight )
				target.y = StageUtils.stage.stageHeight - target.height;
		}
	}
}