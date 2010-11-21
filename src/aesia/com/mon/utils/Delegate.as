/**
 * @license
 */
package aesia.com.mon.utils 
{
	/**
	 * La classe <code>Delegate</code> fournie une méthode de création de fonction proxy.
	 * 
	 * @author Cédric Néhémie
	 */
	public class Delegate 
	{
		/**
		 * Renvoie une fonction œuvrant comme proxy de la fonction <code>method</code> réalisant
		 * un appel avec les arguments <code>args</code>.
		 * 
		 * @param	method	méthode pour laquelle créer un proxy
		 * @param	args	argments à transmettre à la fonction
		 * @return	un proxy vers la fonction
		 */
		public static function create( method : Function, ... args ) : Function 
        {
            return function( ... rest ) : *
            {
                return method.apply( null, rest.length>0? (args.length>0?rest.concat(args):rest) : (args.length>0?args:null) );
            };
        }
	}
}
