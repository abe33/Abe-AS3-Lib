/**
 * @license
 */
package abe.com.ponents.buttons 
{
	import abe.com.mon.core.IDisplayObject;
	import abe.com.mon.core.IDisplayObjectContainer;
	import abe.com.mon.core.IInteractiveObject;
	import abe.com.mon.core.LayeredSprite;
	import abe.com.ponents.core.Component;
	import abe.com.ponents.core.focus.Focusable;
	import abe.com.ponents.skinning.icons.Icon;
	import abe.com.ponents.skinning.icons.RadioCheckedIcon;
	import abe.com.ponents.skinning.icons.RadioUncheckedIcon;

	import flash.events.Event;
	import flash.events.IEventDispatcher;

	/**
	 * Évènement diffusé par l'instance au moment d'un changement de sa valeur.
	 * 
	 * @eventType abe.com.ponents.events.ComponentEvent.DATA_CHANGE
	 */
	[Event(name="dataChange",type="abe.com.ponents.events.ComponentEvent")]
	public class RadioToggleButton extends ToggleButton  implements IDisplayObject, 
														              IInteractiveObject, 
														              IDisplayObjectContainer, 
														              Component, 
														              Focusable,
												             		  LayeredSprite,
												             		  IEventDispatcher
	{
		public function RadioToggleButton (actionOrLabel : * = null, icon : Icon = null )
		{
			super( actionOrLabel, icon );
		}
		/**
		 * @inheritDoc
		 */
		override public function click (e : Event = null) : void
		{
			swapSelect(true);
		}
	}
}
