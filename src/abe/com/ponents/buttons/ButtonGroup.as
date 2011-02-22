/**
 * @license
 */
package abe.com.ponents.buttons 
{
	import flash.events.EventDispatcher;
	import abe.com.ponents.events.ComponentEvent;
	
	/**
	 * Évènement diffusé par l'instance lorsque le bouton sélectionné a changé.
	 * 
	 * @eventType abe.com.ponents.events.ComponentEvent.SELECTION_CHANGE
	 */
	[Event(name="selectionChange",type="abe.com.ponents.events.ComponentEvent")]
	/**
	 * La classe <code>ButtonGroup</code> permet de définir un groupe de bouton
	 * dans lequel un seul bouton peut être sélectionné à un instant précis.
	 * <p>
	 * Les objets <code>ButtonGroup</code> sont utilisé notamment dans la construction
	 * d'un groupe de bouton radio ou dans la création de barre d'outils tel qu'on peut
	 * les voirs dans les logiciels de dessin. 
	 * </p>
	 * 
	 * @author Cédric Néhémie
	 */
	public class ButtonGroup extends EventDispatcher
	{
		/**
		 * Un vecteur contenant les boutons gérés par ce <code>ButtonGroup</code>.
		 */
		/*FDT_IGNORE*/
		TARGET::FLASH_9
		protected var _buttons : Array;		
		TARGET::FLASH_10		protected var _buttons : Vector.<AbstractButton>;		
		TARGET::FLASH_10_1 /*FDT_IGNORE*/		protected var _buttons : Vector.<AbstractButton>;
		/**
		 * Une référence vers le bouton actuellement sélectionné
		 * dans ce <code>ButtonGroup</code>.
		 */
		protected var _selectedButton : AbstractButton;
		/*
		 * Marqueur utilisé pour empêcher que la séquence
		 * Sélection d'un bouton > évènement > séléction d'un bouton
		 * ne boucle indéfiniment lorsqu'on définit le bouton
		 * sélectionné via la propriété selectedButton 
		 */
		private var _selectionSetProgrammatically : Boolean;
		
		/**
		 * Constructeur de la classe <code>ButtonGroup</code>.
		 */
		public function ButtonGroup ()
		{
			/*FDT_IGNORE*/
			TARGET::FLASH_9 {
				_buttons = [];
			}
			TARGET::FLASH_10 {
				_buttons = new Vector.<AbstractButton>();
			}
			TARGET::FLASH_10_1 { /*FDT_IGNORE*/
			_buttons = new Vector.<AbstractButton>(); /*FDT_IGNORE*/ } /*FDT_IGNORE*/
		}
		/**
		 * Une référence vers le bouton actuellement sélectionné
		 * dans ce <code>ButtonGroup</code>.
		 * <p>
		 * La modification de cette propriété conduit à la désélection
		 * du précédent bouton sélectionné si celui-ci est défini.
		 * </p>
		 * <p><strong>Note :</strong> La modification de cette propriété
		 * conduit à la diffusion d'un évènement <code>ComponentEvent.SELECTION_CHANGE</code>.
		 * </p>
		 */
		public function get selectedButton () : AbstractButton { return _selectedButton; }		
		public function set selectedButton ( selectedButton : AbstractButton ) : void
		{
			if( _selectedButton )
				_selectedButton.selected = false;
			
			_selectedButton = selectedButton;
			
			if( _selectedButton )
			{
				_selectionSetProgrammatically = true;
				_selectedButton.selected = true;
				_selectionSetProgrammatically = false;
			}
			
			fireSelectionChange();
		}
		/**
		 * Ajoute un objet <code>AbstractButton</code> à ce <code>ButtonGroup</code>.
		 * <p>
		 * Si ce bouton est actuellement sélectionné, il devient lors de son ajout,
		 * le nouveau bouton sélectionné pour ce <code>ButtonGroup</code>.
		 * </p>
		 * 
		 * @param	bt	le bouton à ajouter à ce groupe
		 */
		public function add ( bt : AbstractButton ) : void
		{
			if( _buttons.indexOf( bt ) == -1 )
			{
				_buttons.push( bt );
				bt.addWeakEventListener( ComponentEvent.SELECTED_CHANGE, selectedChange );
				
				if( bt.selected )				
					selectedButton = bt;
			}
		}
		/**
		 * Supprime un bouton de ce groupe.
		 * <p>
		 * Si le bouton supprimé était celui-ci actuellement sélectionné
		 * ce groupe se retrouve sans aucun bouton sélectionné à la fin de l'appel.
		 * </p>
		 * 
		 * @param	bt	le bouton à supprimer de ce groupe
		 */
		public function remove ( bt : AbstractButton ) : void
		{
			if( _buttons.indexOf( bt ) != -1 )
				_buttons.splice( _buttons.indexOf( bt ), 1 );
				
			if( bt == _selectedButton )
			{
				_selectedButton = null;
				bt.removeEventListener( ComponentEvent.SELECTED_CHANGE, selectedChange );
			}
		}
		/**
		 * Supprime tout les boutons actuellement géré par ce <code>ButtonGroup</code>.
		 */
		public function removeAll () : void
		{
			var l : uint = _buttons.length;
			while(l--)
			{
				remove( _buttons[l] );
			}
			selectedButton = null;
		}
		/**
		 * Recoit les évènements de changement de l'état sélectionné des 
		 * boutons gérés par ce <code>ButtonGroup</code>.
		 * <p>
		 * Lorsqu'un bouton voit son état sélectionné changé par l'action 
		 * de l'utilisateur, ce changement se reflète ainsi sur le groupe
		 * lui-même.
		 * </p>
		 * 
		 * @param	e	évènement diffusé par le bouton lors de son changement d'état
		 */
		public function selectedChange ( e : ComponentEvent ) : void
		{
			if( _selectionSetProgrammatically )
				return;
			
			var bt : AbstractButton = e.target as AbstractButton;
			if( bt.selected )
				selectedButton = bt;
			else
				selectedButton = null;
		}
		/**
		 * Diffuse un évènement <code>ComponentEvent.SELECTION_CHANGE</code>.
		 */
		protected function fireSelectionChange () : void 
		{
			dispatchEvent(new ComponentEvent(ComponentEvent.SELECTION_CHANGE));
		}
	}
}
