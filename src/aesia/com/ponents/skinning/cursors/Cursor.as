/**
 * @license
 */
package  aesia.com.ponents.skinning.cursors
{
	import aesia.com.ponents.skinning.icons.LoadingIcon;

	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.display.PixelSnapping;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	import flash.utils.Dictionary;

	/**
	 * Classe de gestion du curseur, des objets peuvent s'enregistrer, et
	 * laisser la classe s'occuper de l'affichage du curseur. A l'inverse,
	 * le choix du curseur peut être totalement géré par l'utilisateur,
	 * sans passer par la logique d'association automatique.
	 * <p>
	 * Un curseur n'est rien de plus qu'un <code>InteractiveObject</code> affiché
	 * en lieu et place de la souris. Le <i>hot point</i> (ou point déclenchant
	 * les interactions) du curseur sera  défini par le centre (ou point 0,0)
	 * de l'InteractiveObject.
	 * </p><p>
	 * Pour fonctionner correctement la classe doit connaître le root.
	 * De plus, il est absolument nécessaire que la propriété <code>mouseEnabled</code>
	 * du curseur soit à <code>false</code>, sinon on aura un effet de clignotement.
	 * Par défaut, tout les curseurs enregistrés dans le dictionnaire de la classe
	 * verront leur propriété <code>mouseEnabled</code> placé sur <code>false</code>.
	 * </p>
	 * @author Cédric Néhémie
	 */
	public class Cursor extends Sprite
	{
		/*--------------------------------------------------*
		 *	EMBEDDED CURSORS
		 *--------------------------------------------------*/
		[Embed(source="resize_E.png")]
		static public var CURSOR_RESIZE_EAST 				: Class;
		[Embed(source="resize_W.png")]
		static public var CURSOR_RESIZE_WEST  				: Class;
		[Embed(source="resize_N.png")]
		static public var CURSOR_RESIZE_NORTH  				: Class;
		[Embed(source="resize_S.png")]
		static public var CURSOR_RESIZE_SOUTH  				: Class;
		[Embed(source="resize_NE.png")]
		static public var CURSOR_RESIZE_NORTH_EAST 			: Class;
		[Embed(source="resize_NW.png")]
		static public var CURSOR_RESIZE_NORTH_WEST			: Class;
		[Embed(source="resize_SE.png")]
		static public var CURSOR_RESIZE_SOUTH_EAST			: Class;
		[Embed(source="resize_SW.png")]
		static public var CURSOR_RESIZE_SOUTH_WEST 			: Class;

		[Embed(source="rotate.png")]
		static public var CURSOR_ROTATE						: Class;

		[Embed(source="drag.png")]
		static public var CURSOR_DRAG 						: Class;
		[Embed(source="drag_H.png")]
		static public var CURSOR_DRAG_HORIZONTAL 			: Class;
		[Embed(source="drag_V.png")]
		static public var CURSOR_DRAG_VERTICAL 				: Class;


		static public const RESIZE_E  : String = "resize_e";
		static public const RESIZE_W  : String = "resize_w";
		static public const RESIZE_N  : String = "resize_n";
		static public const RESIZE_S  : String = "resize_s";
		static public const RESIZE_SW : String = "resize_sw";
		static public const RESIZE_NW : String = "resize_nw";
		static public const RESIZE_SE : String = "resize_se";
		static public const RESIZE_NE : String = "resize_ne";
		static public const ROTATE 	  : String = "rotate";		static public const DRAG 	  : String = "drag";
		static public const DRAG_H 	  : String = "drag_h";
		static public const DRAG_V 	  : String = "drag_v";		static public const WAIT 	  : String = "wait";

		static public var currentCursor : InteractiveObject;
		static public var currentLabel : String;
		static public var hideSystemCursor : Boolean = true;

		static private var root : DisplayObjectContainer;
		static private var defaultCursor : InteractiveObject;
		static private var triggerMap : Dictionary;
		static private var cursorMap : Dictionary;

		static protected var _lazyInitialized : Boolean;

		/**
		 * Initialise la classe Cursor en lui précisant quel est sa racine
		 * de référence.
		 *
		 * @param	root	le DisplayObjectContainer servant de racine
		 * 					pour les curseurs
		 */
		static public function init( root : DisplayObjectContainer ) : void
		{
			Cursor.root = root;
			Cursor.root.stage.addEventListener( MouseEvent.MOUSE_MOVE, mouseMove );
			Cursor.triggerMap = new Dictionary( true );
			Cursor.cursorMap = new Dictionary( false );
		}

		/**
		 *
		 */
		static public function get ( name : String ) : Cursor
		{
			if( !_lazyInitialized )
			{
				_lazyInitialized = true;
				initializeDefaultCursors();
			}
			if( cursorMap[ name ] )
				return cursorMap[ name ] as Cursor;
			else
				return null;
		}

		/**
		 *
		 */
		static protected function createDefaultCursor ( key : String, c : Class, hotSpot : Point ) : void
		{
			 Cursor.registerCursor( key,  new Cursor( new c() as DisplayObject, hotSpot ) );
		}
		static public function initializeDefaultCursors () : void
		{
			createDefaultCursor( RESIZE_E, 	CURSOR_RESIZE_EAST, 		new Point( 22,  12 	) );			createDefaultCursor( RESIZE_W, 	CURSOR_RESIZE_WEST,  		new Point( 0,  	12 	) );			createDefaultCursor( RESIZE_N, 	CURSOR_RESIZE_NORTH,  		new Point( 12,  0 	) );			createDefaultCursor( RESIZE_S, 	CURSOR_RESIZE_SOUTH,  		new Point( 12,  22 	) );			createDefaultCursor( RESIZE_NE,	CURSOR_RESIZE_NORTH_EAST,   new Point( 22,  0 	) );			createDefaultCursor( RESIZE_SE, CURSOR_RESIZE_SOUTH_EAST,   new Point( 22,  22 	) );			createDefaultCursor( RESIZE_NW, CURSOR_RESIZE_NORTH_WEST,   new Point( 0,  	0	) );			createDefaultCursor( RESIZE_SW, CURSOR_RESIZE_SOUTH_WEST,   new Point( 0,  	22	) );			createDefaultCursor( DRAG,  	CURSOR_DRAG,  				new Point( 12, 	12 	) );			createDefaultCursor( DRAG_H, 	CURSOR_DRAG_HORIZONTAL, 	new Point( 12, 	12 	) );			createDefaultCursor( DRAG_V,  	CURSOR_DRAG_VERTICAL,  		new Point( 12, 	12 	) );
			createDefaultCursor( ROTATE, 	CURSOR_ROTATE, 				new Point( 12, 	12 	) );
			createDefaultCursor( WAIT, 		LoadingIcon, 				new Point( 8, 	8 	) );

			Cursor.registerCursor( MouseCursor.HAND, 	new SystemCursor( MouseCursor.HAND ) );			Cursor.registerCursor( MouseCursor.BUTTON, 	new SystemCursor( MouseCursor.BUTTON ) );			Cursor.registerCursor( MouseCursor.IBEAM, 	new SystemCursor( MouseCursor.IBEAM ) );			Cursor.registerCursor( MouseCursor.ARROW, 	new SystemCursor( MouseCursor.ARROW ) );
		}
		/**
		 * Change le curseur actuel pour passer sur celui en paramètre.
		 * <p>
		 * Un valeur égale à <code>null</code> équivaut à supprimer le
		 * curseur et de remettre le curseur par défaut.
		 * </p>
		 *
		 * @param	cursor	le nouveau le curseur à afficher
		 */
		static public function setCursor ( cursor : InteractiveObject ) : void
		{
			if( cursor == currentCursor )
				return;

			if( currentCursor && !(currentCursor is SystemCursor) )
				root.removeChild( currentCursor );

			if( cursor )
			{
				Mouse.cursor = MouseCursor.AUTO;
				if( cursor is SystemCursor )
				{
					Mouse.cursor = (cursor as SystemCursor).systemCursorName;
					Mouse.show();
				}
				else
				{
					root.addChild( cursor );
					cursor.x = root.stage.mouseX;
					cursor.y = root.stage.mouseY;

					if( hideSystemCursor )
						Mouse.hide();
				}
				currentCursor = cursor;
			}
			else if ( defaultCursor )
			{
				if( defaultCursor is SystemCursor )
				{
					Mouse.cursor = (defaultCursor as SystemCursor).systemCursorName;
					Mouse.show();
				}
				else
				{
					root.addChild( defaultCursor );
					cursor.x = root.stage.mouseX;
					cursor.y = root.stage.mouseY;

					if( hideSystemCursor )
						Mouse.hide();
				}
				currentCursor = defaultCursor;
			}
			else
			{
				Mouse.cursor = MouseCursor.AUTO;
				Mouse.show();
				/*
				if( currentCursor is SystemCursor )
				{

				}
				else
				{
					if( hideSystemCursor )
						Mouse.hide();
				}*/
				currentCursor = null;
			}
		}
		/**
		 * Change le curseur actuel pour passer sur celui enregistré avec
		 * la clé passée en paramètre.
		 * <p>
		 * Si la clé n'existe pas, l'appel équivaut à un <code>setCursor(null)</code>.
		 * </p>
		 * @param	key	la clé du nouveau curseur à afficher
		 */
		static public function setCursorWithLabel ( key : String ) : void
		{
			currentLabel = key;
			setCursor( cursorMap[ key ] as InteractiveObject );
		}
		/**
		 * Restaure le curseur sur celui par défaut immédiatement après l'appel.
		 * Par défaut, le curseur par défaut est celui fourni par le système.
		 * Si un appel a <code>setDefaultCursor</code> à été effectué précedemment
		 * alors c'est ce curseur qui sera utilisé en tant que valeur par défaut.
		 * <p>
		 * L'appel est équivalent à un appel de <code>setCursor</code> avec
		 * la valeur <code>null</code>
		 * </p>
		 */
		static public function restoreCursor() : void
		{
			currentLabel = null;
			setCursor( null );
		}
		/**
		 * Définit le curseur par défaut à la place du curseur natif.
		 * Si cette fonction est utilisée, les passages du curseur flèche
		 * au curseur main dut à la propriété <code>mouseEnabled</code>
		 * seront donc caduque.
		 * <p>
		 * Un valeur égale à <code>null</code> équivaut à supprimer le
		 * curseur par défaut et de remettre la valeur par défaut sur
		 * le curseur système.
		 * </p>
		 * @param	cursor	le nouveau curseur par défaut
		 */
		static public function setDefaultCursor ( cursor : InteractiveObject ) : void
		{
			defaultCursor = cursor;
		}

		/**
		 * Définit le curseur par défaut en utilisant un curseur identifié par une
		 * clé dans le dictionnaire interne. Si la clé n'est pas présente dans le
		 * dictionnaire, l'appel équivaut à un appel de <code>setDefaultCursor(null)</code>
		 *
		 * @param	key	la clé du nouveau curseur par défaut
		 */
		static public function setDefaultCursorWithLabel ( key : String ) : void
		{
			setDefaultCursor( cursorMap[ key ] as InteractiveObject );
		}

		/**
		 * Restaure le curseur par défaut sur la valeur par défaut, c'est-à-dire
		 * sur le curseur du système.
		 * <p>
		 * L'appel est équivalent à un appel de <code>setDefaultCursor</code> avec
		 * la valeur <code>null</code>
		 * </p>
		 */
		static public function restoreDefault() : void
		{
			setDefaultCursor( null );
		}
		/**
		 * Enregistre un curseur dans le dictionnaire interne associé avec la clé
		 * passée en paramètre
		 *
		 * @param	key		clé d'identification pour ce curseur
		 * @param	cursor	curseur à insérer dans le dictionnaire
		 */
		static public function registerCursor ( key : String, cursor : InteractiveObject ) : void
		{
			cursorMap[ key ] = cursor;
			cursor.mouseEnabled = false;
		}
		/**
		 * Supprime le curseur associé avec la clé passée en paramètre.
		 *
		 * @param	key		clé d'identification du curseur
		 */
		static public function unregisterCursor ( key : String ) : void
		{
			cursorMap[ key ] = null;
			delete cursorMap[ key ];
		}
		/**
		 * Enregistre un curseur avec un <code>InteractiveObject</code>.
		 * Ce curseur sera donc utilisé lorsque la souris passe au dessus
		 * de cet objet.
		 *
		 * @param	cursor	le curseur à associer avec le trigger
		 * @param	trigger	objet au dessus duquel le curseur s'affichera
		 */
		static public function registerTrigger( cursor : InteractiveObject, trigger : InteractiveObject ) : void
		{
			triggerMap[ trigger ] = [
				function ( e : MouseEvent ) : void
				{
					Cursor.setCursor( cursor );
				},
				function ( e : MouseEvent ) : void
				{
					Cursor.restoreCursor();
				} ];
			trigger.addEventListener( MouseEvent.ROLL_OVER, triggerMap[ trigger ][0] as Function );
			trigger.addEventListener( MouseEvent.ROLL_OUT, triggerMap[ trigger ][1] as Function );
		}
		/**
		 * Enregistre un curseur identifié par <code>key</code> dans le dictionnaire
		 * avec un <code>InteractiveObject</code>. Ce curseur sera donc utilisé
		 * lorsque la souris passe au dessus de cet objet.
		 *
		 * @param	key		la clé d'identification du curseur à associer
		 * @param	trigger	objet au dessus duquel le curseur s'affichera
		 */
		static public function registerTriggerWithLabel( key : String, trigger : InteractiveObject ) : void
		{
			registerTrigger( cursorMap[ key ] as InteractiveObject, trigger );
		}
		/**
		 * Supprime la relation entre un <code>InteractiveObject</code>
		 * et un curseur.
		 *
		 * @param	trigger objet au dessus duquel le curseur s'affichait
		 */
		static public function unregisterTrigger( trigger : InteractiveObject ) : void
		{
			trigger.removeEventListener( MouseEvent.ROLL_OVER, triggerMap[ trigger ][0] as Function );
			trigger.removeEventListener( MouseEvent.ROLL_OUT, triggerMap[ trigger ][1] as Function );

			triggerMap[ trigger ] = null;
			delete triggerMap[ trigger ];
		}
		/**
		 * Positionne le curseur à la position de la souris.
		 */
		static public function mouseMove ( e : MouseEvent ) : void
		{
			if( currentCursor )
			{
				currentCursor.x = e.stageX;
				currentCursor.y = e.stageY;
			}
		}

		/**
		 * Créer un nouvel objet Cursor qui compose n'importe quel DisplayObjet
		 * pour le transformer en curseur.
		 */
		public function Cursor ( o : DisplayObject, hotSpot : Point = null ) : void
		{

			if( hotSpot == null )
				hotSpot = new Point();

			if( o )
			{
				o.x = -hotSpot.x;
				o.y = -hotSpot.y;
				addChild( o );
			}

			if( o is Bitmap )
				( o as Bitmap ).pixelSnapping = PixelSnapping.ALWAYS;
		}
	}
}
