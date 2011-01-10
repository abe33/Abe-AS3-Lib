package aesia.com.ponents.core.edit 
{
	import aesia.com.mands.events.CommandEvent;
	import aesia.com.ponents.actions.builtin.EditObjectPropertiesAction;

	import flash.display.DisplayObject;
	/**
	 * La classe <code>ObjectPropertiesEditor</code> est un éditeur
	 * générique permettant l'édition des propriétés d'objets complexes.
	 * <p>
	 * La classe <code>ObjectPropertiesEditor</code> fait appel en interne
	 * à la classe <code>EditObjectPropertiesAction</code>.
	 * </p> 
	 * @author cedric
	 */
	public class ObjectPropertiesEditor implements Editor 
	{
		/**
		 * Une référence vers l'objet à éditer.
		 */
		protected var _value : *;
		/**
		 * Une référence vers l'objet <code>Editable</code> ayant initié la séquence d'édition.
		 */
		protected var _caller : Editable;
		/**
		 * Une référence vers l'objet <code>EditObjectPropertiesAction</code> utilisé en interne.
		 */
		protected var _action : EditObjectPropertiesAction;
		
		/**
		 * @inheritDoc
		 */
		public function initEditState (caller : Editable, value : *, overlayTarget : DisplayObject = null) : void
		{
			this.caller = caller;
			this.value = value;
			
			_action = new EditObjectPropertiesAction( _value );
			_action.addEventListener(CommandEvent.COMMAND_END, editEnd);
			_action.execute();
		}
		
		/**
		 * Recoit l'évènement <code>CommandEvent.COMMAND_END</code> de la classe
		 * <code>EditObjectPropertiesAction</code> à la fin de la séquence d'édition.
		 * 
		 * @param	event	évènement diffusé en fin d'édition
		 */
		protected function editEnd (event : CommandEvent) : void
		{
			_action.removeEventListener( CommandEvent.COMMAND_END, editEnd );
			_caller.confirmEdit();
			
			_action = null;
			_caller = null;
			_value = null;
		}
		/**
		 * @inheritDoc
		 */
		public function get caller () : Editable { return _caller; }
		public function set caller (e : Editable) : void
		{
			_caller = e;
		}
		/**
		 * @inheritDoc
		 */
		public function get value () : * { return _value; }
		public function set value (v : *) : void
		{
			_value = v;
		}
	}
}
