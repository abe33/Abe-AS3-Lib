/**
 * @license
 */
package abe.com.ponents.actions 
{
	import abe.com.mon.utils.KeyStroke;
	import abe.com.mon.utils.Keys;
	import abe.com.patibility.lang._;
	import abe.com.ponents.actions.builtin.BuiltInActionsList;
	import abe.com.ponents.actions.builtin.ForceGC;
	import abe.com.ponents.actions.builtin.RedoAction;
	import abe.com.ponents.actions.builtin.UndoAction;
	import abe.com.ponents.history.UndoManagerInstance;

	import flash.utils.Dictionary;
	/**
	 * La classe <code>ActionManager</code> fournie un moyen d'enregistrer des actions
	 * permettant ainsi de mutualiser simplement des commandes au sein d'une interface
	 * graphique.
	 * <p>
	 * Les objets <code>Action</code> sont enregistrés avec un identifiant sous forme
	 * de chaîne de caractères permettant de les récupérer par la suite à l'aide de ce
	 * dernier.
	 * </p>
	 * 
	 * @author Cédric Néhémie
	 */
	public class ActionManager 
	{
		/**
		 * Un vecteur contenant toutes les actions enregistrées dans ce gestionnaire.
		 */
		/*FDT_IGNORE*/
		TARGET::FLASH_9
		protected var _actions : Array;		
		TARGET::FLASH_10		protected var _actions : Vector.<Action>;		
		TARGET::FLASH_10_1 /*FDT_IGNORE*/		protected var _actions : Vector.<Action>;
		/**
		 * Un dictionnaire contenant les associations <code>KeyStroke-&gt;Action</code>
		 * pour ce gestionnaire.
		 */
		protected var _keyStrokes : Dictionary;
		/**
		 * Un dictionnaire contenant les associations <code>String-&gt;Action</code>
		 * pour ce gestionnaire.
		 */		protected var _keys : Dictionary;
		/**
		 * Un dictionnaire contenant les associations <code>Action-&gt;String</code>
		 * pour ce gestionnaire.
		 */		protected var _values : Dictionary;
		
		/**
		 * Constructeur de la classe <code>ActionManager</code>.
		 */
		public function ActionManager ()
		{
			/*FDT_IGNORE*/
			TARGET::FLASH_9 {
				_actions = [];
			}
			TARGET::FLASH_10 {
				_actions = new Vector.<Action>();
			}
			TARGET::FLASH_10_1 { /*FDT_IGNORE*/
			_actions = new Vector.<Action>(); /*FDT_IGNORE*/ } /*FDT_IGNORE*/
			
			_keyStrokes = new Dictionary( true );			_keys = new Dictionary( true );			_values = new Dictionary( true );
		}
		
		/*-----------------------------------------------------------*
		 * 	GETTER / SETTERS
		 *-----------------------------------------------------------*/
		/**
		 * Accès à une copie du vecteur contenant les actions enregistrées dans ce gestionnaire.
		 */
		/*FDT_IGNORE*/
		TARGET::FLASH_9
		public function get actions () : Array { return _actions.concat(); }		
		TARGET::FLASH_10		public function get actions () : Vector.<Action> { return _actions.concat(); }		
		TARGET::FLASH_10_1 /*FDT_IGNORE*/ 		public function get actions () : Vector.<Action> { return _actions.concat(); }
		
		/**
		 * Accès à un tableau contenant la liste des clés d'accès utilisés dans ce gestionnaire.
		 */
		public function get ids () : Array
		{
			var a : Array = [];
			
			for( var i : String in _keys )
				a.push( i ); 
			
			return a;
		}
		/**
		 * Accès à un vecteur contenant tout les objets <code>KeyStroke</code> enregistrés
		 * dans ce gestionnaire.
		 */
		public function get keyStrokes () : *
		{
			/*FDT_IGNORE*/
			TARGET::FLASH_9 {
				var a :  Array = [];
			}
			TARGET::FLASH_10 {
				var a :  Vector.<KeyStroke> = new Vector.<KeyStroke>();
			}
			TARGET::FLASH_10_1 { /*FDT_IGNORE*/
			var a :  Vector.<KeyStroke> = new Vector.<KeyStroke>(); /*FDT_IGNORE*/ } /*FDT_IGNORE*/
			
			for( var i : * in _keyStrokes )
				a.push( i ); 
			
			return a;
		}
		/*-----------------------------------------------------------*
		 * 	REGISTER
		 *-----------------------------------------------------------*/
		/**
		 * Enregistre une action dans ce gestionnaire et l'associe avec la clé <code>id</code>
		 * si celle-ci est définie. Si l'action posède un raccourcis clavier, l'association 
		 * <code>KeyStroke-&gt;Action</code> est faite à ce moment.
		 * <p>
		 * Une action ne peut être enregistrée qu'avec une seule clé, si l'action était déjà
		 * présente dans ce gestionnaire lors de l'appel, celui-ci sera ignoré.
		 * </p>
		 * 
		 * @param	act	l'action à enregistrer dans le gestionnaire
		 * @param	id	identifiant d'accès à l'action
		 */
		public function registerAction ( act : Action, id : String = null ) : void
		{
			if( !containsAction( act ) )
			{
				_actions.push( act );
				
				if( act.accelerator )
					_keyStrokes[ act.accelerator ] = act;
				
				if( id )
				{
					_keys[ id ] = act;
					_values[ act ] = id;
				}
			}
		}
		/**
		 * Modifie la clé d'accès à la commande <code>act</code>.
		 * <p>
		 * Si celle-ci n'était pas enregistrée précedemment dans ce gestionnaire
		 * elle le sera à la fin de l'appel.
		 * </p>
		 * @param	act	l'action dont on souhaite modifier l'identifiant
		 * @param	id	nouvel identifiant d'accès à l'action
		 */
		public function setId ( act : Action, id : String ) : void
		{
			if( containsAction( act ) )
				unregisterAction ( act )

			registerAction( act, id );
		}
		
		/*-----------------------------------------------------------*
		 * 	RETREIVE DATAS
		 *-----------------------------------------------------------*/
		/**
		 * Renvoie l'action associée avec l'identifiant <code>id</code> si 
		 * il existe une telle association, sinon la fonction renvoie <code>null</code>.
		 * 
		 * @param	id	identifiant de l'action à récupérer
		 * @return	l'action associée avec l'identifiant <code>id</code> sinon <code>null</code>
		 */
		public function getAction ( id : String ) : Action
		{
			if( containsId( id ) )
				return _keys[ id ];
			else
				return null;
		}
		/**
		 * Renvoie l'action associé avec le raccourci clavier <code>ks</code>
		 * si il existe une telle association, sinon la fonction renvoie <code>null</code>.
		 * 
		 * @param	ks	raccourci clavier de l'action à récupérer
		 * @return	l'action associée avec le raccourci <code>ks</code> sinon <code>null</code>
		 */
		public function getActionWithKeyStroke ( ks : KeyStroke ) : Action
		{
			if( containsKeyStroke( ks ) )
				return _keyStrokes[ ks ];
			else
				return null;
		}
		/**
		 * Renvoie l'identifiant associé à l'action <code>act</code> si il existe
		 * une telle association, sinon la fonction renvoie <code>null</code>.
		 * 
		 * @param	act	l'action dont on souhaite récupérer l'identifiant
		 * @return	l'identifiant associée à l'action <code>act</code> sinon <code> null</code>
		 */
		public function getActionId ( act : Action ) : String
		{
			if( hasId( act ) )
				return _values[ act ];
			else
				return null;
		}
		
		/*-----------------------------------------------------------*
		 * 	UNREGISTER
		 *-----------------------------------------------------------*/
		/**
		 * Supprime une action de ce gestionnaire si celle-ci a été précedemment
		 * enregistrée.
		 * <p>
		 * À la fin de l'appel toutes les associations avec cette actions auront
		 * été effacées de ce gestionnaire.
		 * </p>
		 * 
		 * @param	act	action à supprimer de ce gestionnaire
		 */
		public function unregisterAction ( act : Action ) : void		{
			if( containsAction( act ) )
			{
				var index : Number = _actions.indexOf( act );
				_actions.splice( index, 1 );
				
				if( act.accelerator )
					delete _keyStrokes[ act.accelerator ];
					
				if( _values[ act ] )
				{
					delete _keys[ _values[ act ] ];
					delete _values[ act ];
				}
			}
		}
		/**
		 * Supprime l'action enregistrée dans ce gestionnaire avec l'identifiant
		 * <code>id</code>.
		 * 
		 * @param	id	identifiant de l'action à supprimer
		 */
		public function unregisterActionById ( id : String ) : void
		{
			if( containsId( id ) )
				unregisterAction( _keys[ id ] );
		}
		/**
		 * Supprime l'action enregistrée dans ce gestionnaire avec le raccourci
		 * <code>ks</code>.
		 * 
		 * @param	ks	raccourci de l'action à supprimer
		 */
		public function unregisterActionByKeyStroke ( ks : KeyStroke ) : void
		{
			if( containsKeyStroke( ks ) )
				unregisterAction( _keyStrokes[ ks ] );
		}
		
		/*-----------------------------------------------------------*
		 * 	LOOKUP CONTENT
		 *-----------------------------------------------------------*/
		/**
		 * Renvoie <code>true</code> si l'action <code>act</code> est enregistrée
		 * dans ce gestionnaire
		 * 
		 * @param	act l'action dont on souhaite savoir si elle est enregistrée
		 * @return	<code>true</code> si l'action <code>act</code> est enregistrée
		 * 			dans ce gestionnaire
		 */
		public function containsAction ( act : Action ) : Boolean
		{
			return _actions.indexOf( act ) != -1;
		}
		/**
		 * Renvoie <code>true</code> si une action est enregistrée avec l'identifiant
		 * <code>id</code> dans ce gestionnaire.
		 * 
		 * @param	id	identifiant dont on souhaite savoir si il est enregistré
		 * @return	<code>true</code> si une action est enregistrée avec l'identifiant
		 * 			<code>id</code> dans ce gestionnaire
		 */
		public function containsId ( id : String ) : Boolean
		{
			return _keys[ id ] != undefined;
		}
		/**
		 * Renvoie <code>true</code> si une action enregistrée dans ce gestionnaire
		 * possède un raccourci clavier équivalent à <code>ks</code>.
		 * 
		 * @param	ks	raccourci dont on souhaite savoir si une action l'utilise
		 * @return	<code>true</code> si une action enregistrée dans ce gestionnaire
		 * 			possède un raccourci clavier équivalent à <code>ks</code>
		 */
		public function containsKeyStroke ( ks : KeyStroke ) : Boolean
		{
			return _keyStrokes[ ks ] != undefined;
		}
		/**
		 * Renvoie <code>true</code> si l'action <code>act</code> est enregistrée avec
		 * un identifiant.
		 * 
		 * @param	act	action dont on souhaite savoir si elle possède un identifiant
		 * @return	<code>true</code> si l'action <code>act</code> est enregistrée avec
		 * 			un identifiant
		 */
		public function hasId ( act : Action ) : Boolean
		{
			return _values[ act ] !=  undefined;
		}
		/**
		 * Créée un certain nombre d'actions natives.
		 * <p>
		 * La fonction créer des instances des actions suivantes : 
		 * </p>
		 * <ul>
		 * <li><code>UndoAction</code> : Action permettant d'effectuer un retour dans l'historique. 
		 * Elle est associée avec la clé <code>undo</code> et le raccourci <code>Ctrl + Z</code>.</li>
		 * <li><code>RedoAction</code> : Action permettant d'effectuer une avancée dans l'historique. 
		 * Elle est associée avec la clé <code>redo</code> et le raccourci <code>Ctrl + Y</code>.</li>		 * <li><code>ForceGC</code> : Action permettant de forcer le passage du ramasse miette de la machine virtuelle. 
		 * Elle est associée avec la clé <code>forceGC</code>.</li>		 * </ul>
		 */
		public function createBuiltInActions () : void
		{
			var undo : Action = new UndoAction( KeyStroke.getKeyStroke( Keys.Z, KeyStroke.getModifiers( true ) ), UndoManagerInstance );
			var redo : Action = new RedoAction( KeyStroke.getKeyStroke( Keys.Y, KeyStroke.getModifiers( true ) ), UndoManagerInstance  );			var forcegc : Action = new ForceGC( _("Force GC"), null, _("Force the GC to pass using the System.gc()\nif in a debug player, else use the double LocalConnection\ntricks in a normal player") );
			
			registerAction( undo, BuiltInActionsList.UNDO );			registerAction( redo, BuiltInActionsList.REDO );			registerAction( forcegc, BuiltInActionsList.FORCE_GC );
		}		
	}
}
