package abe.com.ponents.core.edit 
{
    import abe.com.mands.Command;
    import abe.com.mon.utils.StageUtils;
    import abe.com.mon.utils.magicCopy;
    import abe.com.ponents.actions.builtin.EditObjectPropertiesAction;
    import abe.com.ponents.containers.Window;
    import abe.com.ponents.forms.FormObject;
    import abe.com.ponents.forms.managers.SimpleFormManager;

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
			
			_action = new EditObjectPropertiesAction( _value, editObjectCallback, null, null, null, null, true );
			_action.commandEnded.add( editEnded );
			_action.execute();
		}
		protected function editObjectCallback ( o : Object, 
											    form : FormObject, 
											    manager : SimpleFormManager,
											    window : Window ):void
		{
			manager.save();
			magicCopy( form.target, o );
			
			window.close();
			StageUtils.stage.focus = null;
		}
		
		/**
		 */
		protected function editEnded ( command : Command ) : void
		{
			_action.commandEnded.remove( editEnded );
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
