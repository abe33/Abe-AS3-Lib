/**
 * @license
 */
package abe.com.ponents.buttons 
{
	import abe.com.mon.core.IDisplayObject;
	import abe.com.mon.core.IDisplayObjectContainer;
	import abe.com.mon.core.IInteractiveObject;
	import abe.com.mon.core.LayeredSprite;
	import abe.com.ponents.actions.BooleanAction;
	import abe.com.ponents.core.Component;
	import abe.com.ponents.core.focus.Focusable;
	import abe.com.ponents.events.ActionEvent;
	import abe.com.ponents.events.ComponentEvent;
	import abe.com.ponents.skinning.icons.Icon;

	import flash.events.IEventDispatcher;

	/**
	 * Évènement diffusé par l'instance au moment d'un changement de sa valeur.
	 * 
	 * @eventType abe.com.ponents.events.ComponentEvent.DATA_CHANGE
	 */
	[Event(name="dataChange", type="abe.com.ponents.events.ComponentEvent")]
	/**
	 * Un <code>ToggleButton</code> est un bouton dont l'état sélectionné permute
	 * lorsque l'on clique dessus avec la souris.
	 * 
	 * @author Cédric Néhémie
	 */
	[Skinable(skin="Button")]
	public class ToggleButton extends AbstractButton  implements IDisplayObject, 
																 IInteractiveObject, 
																 IDisplayObjectContainer, 
																 Component, 
																 Focusable,
														 		 LayeredSprite,
														 		 IEventDispatcher	
	{	
		/**
		 * Constructeur de classe <code>ToggleButton</code>.
		 * <p>
		 * Si le premier paramètre transmi au constructeur est un objet <code>Action</code>
		 * le label et l'icône de ce bouton seront déterminé à l'aide des données contenues
		 * dans l'objet <code>Action</code>. Auquel cas le second paramètre sera tout simplement
		 * ignoré.
		 * </p>
		 * <p>Si le premier paramètre transmi est une <code>String</code>, celle-ci sera utilisé
		 * comme valeur pour le label de ce bouton, et le second paramètre ne sera pas ignoré.
		 * </p>
		 * 
		 * @param	actionOrLabel	un objet <code>Action</code> ou une chaîne de caractère
		 * @param	icon			un objet <code>Icon</code>
		 */	
		public function ToggleButton ( actionOrLabel : * = null, icon : Icon = null  )
		{
			super( actionOrLabel, icon );
			
			if( actionOrLabel is BooleanAction )
				selected = (actionOrLabel as BooleanAction).value;
			else
				selected = false;
		}
		/**
		 * <p>
		 * Lors du click, la valeur actuelle de la propriété <code>selected</code>
		 * de ce <code>ToggleButton</code> est permutée.
		 * </p>
		 * @inheritDoc
		 */
		override public function click () : void
		{
			if( _action && _action is BooleanAction )
				_action.execute();
			else
				swapSelect(!selected);
		}
		/**
		 * Définie la nouvelle valeur pour l'état <code>selected</code>
		 * du composant et diffuse un évènement de type <code>ComponentEvent.DATA_CHANGE</code>.
		 * <p>
		 * Au même moment, si le composant possède un objet <code>Action</code>, celui-ci est éxécuté,
		 * mais après que l'état ait été modifié, permettant à l'objet <code>Action</code> de le prendre
		 * en compte.
		 * </p>
		 * @param	b	la nouvelle valeur de l'état sélectionné
		 */
		protected function swapSelect ( b : Boolean ) : void
		{
			 selected = b;
			super.click();
			fireDataChange();
		}
		/**
		 * Diffuse un évènement de type <code>ComponentEvent.DATA_CHANGE</code> aux écouteurs
		 * de ce bouton.
		 */
		protected function fireDataChange () : void 
		{
			dispatchEvent( new ComponentEvent( ComponentEvent.DATA_CHANGE ) );
		}
		/**
		 * 
		 */
		override protected function actionPropertyChanged ( propertyName : String, propertyValue : * ) : void 
		{
			if( propertyName == "value" )
				selected = propertyValue;
			else
				super.actionPropertyChanged(propertyName, propertyValue);
		}
	}
}
