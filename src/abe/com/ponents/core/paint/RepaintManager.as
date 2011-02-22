/**
 * @license
 */
package abe.com.ponents.core.paint 
{
	import abe.com.mon.utils.StageUtils;
	import abe.com.ponents.core.Component;
	import abe.com.ponents.core.Container;

	import flash.events.Event;
	import flash.utils.Dictionary;
	/**
	 * La classe <code>RepaintManager</code> implémente la gestion des redessin 
	 * des composants.
	 * <p>
	 * Lorsqu'un composant demande son invalidation, le gestionnaire va vérifier
	 * si ce composant est une racine de validation, si c'est le cas, il est ajouter
	 * à la liste des composants à redessiner, si ce n'est pas le cas, le gestionnaire
	 * va rechercher parmis les parents de ce composant le premier composant considérer
	 * comme une racine de validation et l'ajouter à la liste des composants à redessiner.
	 * </p>
	 * <p>
	 * Dès que le premier composant est ajouter à la liste des composants à redessiner, 
	 * le gestionnaire s'enregistre pour recevoir l'évènement <code>Event.EXIT_FRAME</code>.
	 * C'est à ce moment seulement que sera réaliser le redessin des composants précedemment
	 * invalidés. Ensuite, la liste sera vidée.
	 * </p>
	 * 
	 * @author Cédric Néhémie
	 */
	public class RepaintManager 
	{
		/**
		 * Un vecteur contenant les composants considérés comme racine de validation
		 * sur la séquence courante d'invalidation.
		 */
		/*FDT_IGNORE*/
		TARGET::FLASH_9
		protected var _invalidComponents : Array;		
		TARGET::FLASH_10		protected var _invalidComponents : Vector.<Component>;		
		TARGET::FLASH_10_1 /*FDT_IGNORE*/		protected var _invalidComponents : Vector.<Component>;
		/**
		 * Un dictionnaire stockant les objets déjà repeint durant une phase de redessin. 
		 */		protected var _repaintComponents : Dictionary;
		/**
		 * Une valeur booléenne indiquant si le gestionnaire est actuellement vérouillé
		 * car en train de procéder au redessin des composants invalidés précédemment.
		 */
		protected var _lock : Boolean;
		
		/**
		 * Constructeur de la classe <code>RepaintManager</code>.
		 */
		public function RepaintManager ()
		{
			reset();
		}
		/**
		 * Recoit l'évènement <code>Event.EXIT_FRAME</code> et réalise
		 * le redessin des composants précédemment invalidés.
		 * 
		 * @param	e	évènement diffusé lors de l'arrivée dans la fin de frame
		 */
		protected function exitFrame ( e : Event ) : void
		{
			_lock = true;
			
			var l : Number = _invalidComponents.length;
			
			for(var i : Number = 0; i<l;i++)
				_invalidComponents[i].repaint();

			reset();			
			StageUtils.root.removeEventListener( Event.EXIT_FRAME, exitFrame );
		}
		private function reset () : void 
		{
			/*FDT_IGNORE*/
			TARGET::FLASH_9 {
				_invalidComponents = [];
			}
			TARGET::FLASH_10 {
				_invalidComponents = new Vector.<Component>();
			}
			TARGET::FLASH_10_1 { /*FDT_IGNORE*/
			_invalidComponents = new Vector.<Component>(); /*FDT_IGNORE*/ } /*FDT_IGNORE*/
			
			_repaintComponents = new Dictionary( true );
			_lock = false;
		}
		/**
		 * Recoit la demande d'invalidation du composant <code>c</code>.
		 * <p>
		 * Lorsqu'un composant demande son invalidation, le gestionnaire va vérifier
		 * si ce composant est une racine de validation, si c'est le cas, il est ajouter
		 * à la liste des composants à redessiner, si ce n'est pas le cas, le gestionnaire
		 * va rechercher parmis les parents de ce composant le premier composant considérer
		 * comme une racine de validation et l'ajouter à la liste des composants à redessiner.
		 * </p>
		 * <p>
		 * Dès que le premier composant est ajouter à la liste des composants à redessiner, 
		 * le gestionnaire s'enregistre pour recevoir l'évènement <code>Event.EXIT_FRAME</code>.
		 * C'est à ce moment seulement que sera réaliser le redessin des composants précedemment
		 * invalidés. Ensuite, la liste sera vidée.
		 * </p>
		 * <p>
		 * <strong>Note :</strong> Il est impossible d'invalider un composant lorsque le gestionnaire
		 * est en pleine phase de redessin.
		 * </p>
		 * 
		 * @param	c	composant demandant son invalidation
		 */
		public function invalidate( c : Component ) : void
		{
			if( _lock )
				return;
			
			var cc : Component = c;
			
			// si le composant n'est pas sur la scene il n'est pas repeint
			if( !cc.stage )
				return;
			
			// on parcours les parents du composant dans une boucle
			while( cc )
			{
				// il s'agit d'une racine de validation
				if( cc.isValidateRoot() )
				{
					// le composant à déjà été enregistré comme étant à repeindre
					if( _repaintComponents[ cc ] )
						// alors on sors de la fonction
						return;
					else
						break;
				}
				else
				{
					// si il est déjà présent en tant que root, alors on l'enlève
					if( contains( cc ) )
						remove( cc );
					
					// il fait partie des composants qui seront repeints
					_repaintComponents[ cc ] = true;
				}
				
				var p : Container = cc.parentContainer;
				if( p )
					cc = p;
				else
					break;
			}
			if( !cc )
				cc = c;
			
			if( !contains(cc) )
				append( cc );
			
			if( _invalidComponents.length == 1 )
				StageUtils.root.addEventListener( Event.EXIT_FRAME, exitFrame );
		}
		/**
		 * Renvoie <code>true</code> si le composant <code>c</code> est présent dans
		 * la liste des composants à invalider.
		 * 
		 * @param	c	composant dont on souhaite savoir s'il est présent dans la liste
		 * 				d'invalidation
		 * @return	<code>true</code> si le composant est présent dans
		 * 			la liste des composants à invalider
		 */
		public function contains ( c : Component ) : Boolean
		{
			return _invalidComponents.indexOf( c ) != -1;
		}
		/**
		 * Supprime le composant <code>c</code> de la liste d'invalidation.
		 * 
		 * @param	c	composant à supprimer de la liste d'invalidation
		 */
		public function remove ( c : Component ) : void
		{
			_invalidComponents.splice( _invalidComponents.indexOf( c ), 1 );
		}
		/**
		 * Ajoute le composant <code>c</code> à la liste d'invalidation.
		 * 
		 * @param	c	composant à ajouter à la liste d'invalidation
		 */
		public function append ( c : Component ) : void
		{
			_invalidComponents.push( c );
		}
	}
}
