/**
 * @license
 */
package abe.com.ponents.skinning.decorations 
{
    import abe.com.mon.core.Cloneable;
    import abe.com.mon.core.Equatable;
    import abe.com.mon.core.Serializable;
    import abe.com.ponents.core.Component;
    import abe.com.ponents.utils.Borders;
    import abe.com.ponents.utils.Corners;

    import flash.display.Graphics;
    import flash.geom.Rectangle;
	/**
	 * @author Cédric Néhémie
	 */
	public interface ComponentDecoration extends Equatable, Serializable, Cloneable
	{
		function draw ( r : Rectangle, 
						g : Graphics, 
						c : Component,
						borders : Borders = null,
						corners : Corners = null, 
						smoothing : Boolean = false ) : void;
	}
}
