/**
 * @license
 */
package abe.com.ponents.buttons 
{
    import abe.com.mon.core.IDisplayObject;
    import abe.com.mon.core.IDisplayObjectContainer;
    import abe.com.mon.core.IInteractiveObject;
    import abe.com.mon.core.LayeredSprite;
    import abe.com.ponents.core.*;
    import abe.com.ponents.core.focus.Focusable;
    import abe.com.ponents.skinning.icons.Icon;

	public class RadioToggleButton extends ToggleButton  implements IDisplayObject, 
														              IInteractiveObject, 
														              IDisplayObjectContainer, 
														              Component, 
														              Focusable,
												             		  LayeredSprite
	{
		public function RadioToggleButton (actionOrLabel : * = null, icon : Icon = null )
		{
			super( actionOrLabel, icon );
		}
		/**
		 * @inheritDoc
		 */
		override public function click ( context : UserActionContext ) : void
		{
			swapSelect(true);
		}
	}
}
