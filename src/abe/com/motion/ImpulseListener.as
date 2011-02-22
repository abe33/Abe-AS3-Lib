package abe.com.motion
{

	/**
	 * L'interface <code>ImpulseListener</code> définie la méthode
	 * <code>tick</code> que les objets souhaitant interagir avec
	 * un <code>MotionImpulse</code> se doivent d'implémenter.
	 *
	 * @author Cédric Néhémie
	 */
	public interface ImpulseListener
	{
		/**
		 * Fonction appelée à chaque interval temporel par une instance
		 * de la classe <code>MotionImpulse</code>.
		 *
		 * @param	e	objet <code>ImpulseEvent</code> diffusé avec l'évènement
		 */
		function tick( e : ImpulseEvent ) : void;
	}
}
