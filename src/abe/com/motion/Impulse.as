/**
 * @license
 */
package abe.com.motion
{
    import abe.com.mon.debug.DebuggableManagerInstance;
	/**
	 * Instance globale de la classe <code>MotionImpulse</code>.
	 *
	 * @author Cédric Néhémie
	 */
	public const Impulse : MotionImpulse = new MotionImpulse();
    
    CONFIG::DEBUG {
        DebuggableManagerInstance.activateClassDebug( MotionImpulse );
        DebuggableManagerInstance.registerInstance( MotionImpulse, Impulse );
    }
}
