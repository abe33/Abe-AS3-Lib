/**
 * @license
 */
package aesia.com.ponents.skinning.decorations 
{
	import aesia.com.mon.core.Serializable;
	import aesia.com.mon.core.Equatable;
	import aesia.com.ponents.core.Component;
	import aesia.com.ponents.utils.Borders;
	import aesia.com.ponents.utils.Corners;

	import flash.display.Graphics;
	import flash.geom.Rectangle;

	/**
	 * @author Cédric Néhémie
	 */
	public interface ComponentDecoration extends Equatable, Serializable
	{
		function draw ( r : Rectangle, 
						g : Graphics, 
						c : Component,
						borders : Borders = null,
						corners : Corners = null, 
						smoothing : Boolean = false ) : void;
	}
}
