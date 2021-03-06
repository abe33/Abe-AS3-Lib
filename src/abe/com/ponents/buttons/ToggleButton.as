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
	import abe.com.ponents.core.*;
	import abe.com.ponents.core.focus.Focusable;
	import abe.com.ponents.skinning.icons.Icon;

	/**
	 * Un <code>ToggleButton</code> est un bouton dont l'état sélectionné permute
	 * lorsque l'on clique dessus avec la souris.
	 * 
	 * @author Cédric Néhémie
	 */
	[Skinable(skin="Button")]
	public class ToggleButton extends AbstractFormButton  implements IDisplayObject, 
																 IInteractiveObject, 
																 IDisplayObjectContainer, 
																 Component, 
																 Focusable,
														 		 LayeredSprite
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
		override public function click ( context : UserActionContext ) : void
		{
			if( _action && _action is BooleanAction )
				_action.execute( context );
			else
				swapSelect(!selected);
		}
		protected function swapSelect ( b : Boolean ) : void
		{
			 selected = b;
			super.click( new UserActionContext( this, UserActionContext.PROGRAM_ACTION ) );
			fireDataChangedSignal();
		}
		override protected function actionPropertyChanged ( propertyName : String, propertyValue : * ) : void 
		{
			if( propertyName == "value" )
				selected = propertyValue;
			else
				super.actionPropertyChanged(propertyName, propertyValue);
		}
	}
}
