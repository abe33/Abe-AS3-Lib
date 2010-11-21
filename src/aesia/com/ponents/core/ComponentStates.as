/**
 * @license
 */
package aesia.com.ponents.core 
{

	/**
	 * La classe <code>ComponentStates</code> fournies les constantes
	 * associées aux états possible d'un composant ainsi que des propriétés
	 * permettant de récupérer des ensembles d'états à utiliser dans le 
	 * cadre des méthodes de définitions de style.
	 * 
	 * @author Cédric Néhémie
	 */
	public class ComponentStates 
	{
		/**
		 * L'état de base d'un composant au repos.
		 */
		static public const NORMAL : uint = 0;
		
		/**
		 * Marqueur d'un composant désactivé.
		 */		static public const DISABLED : uint = 1;
		/**
		 * Marqueur d'un composant pour lequel la souris se situe au dessus.
		 */				static public const OVER : uint = 2;
		/**
		 * Marqueur d'un composant por lequel le bouton de la souris a été
		 * pressé au dessus.
		 */		static public const PRESSED : uint = 3;
		/**
		 * Marqueur d'un composant ayant le focus clavier.
		 */		static public const FOCUS : uint = 4;		
		/**
		 * Marqueur d'un composant étant sélectionné.
		 */		static public const SELECTED : uint = 8;
		
		/**
		 * Renvoie l'ensemble des états au repos d'un composant.
		 * 
		 * @return l'ensemble des états au repos d'un composant
		 */
		static public function get allNormal () : Array 
		{
			return [ NORMAL, 
					 NORMAL + FOCUS, 
					 NORMAL + SELECTED,
					 NORMAL + FOCUS + SELECTED ];
		}
		/**
		 * Renvoie l'ensemble des états d'un composant n'étant 
		 * pas sélectionné, et n'ayant pas le focus clavier.
		 * 
		 * @return	l'ensemble des états d'un composant n'étant 
		 * 			pas sélectionné, et n'ayant pas le focus clavier
		 */
		static public function get allNormal2 () : Array 
		{
			return [ NORMAL, 
					 DISABLED,
					 OVER, 
					 PRESSED ];
		}
		/**
		 * Renvoie l'ensemble des états d'un composant étant sous
		 * le focus clavier mais n'étant pas sélectionné.
		 * 
		 * @return	l'ensemble des états d'un composant étant sous
		 * 			le focus clavier mais n'étant pas sélectionné
		 */
		static public function get allFocus () : Array 
		{
			return [ FOCUS, 
					 FOCUS + OVER,
					 FOCUS + DISABLED, 
					 FOCUS + PRESSED ];
		}
		/**
		 * Renvoie l'ensemble des états d'un composant étant sélectionné
		 * mais n'ayant pas le focus clavier.
		 * 
		 * @return	l'ensemble des états d'un composant étant sélectionné
		 * 			mais n'ayant pas le focus clavier
		 */
		static public function get allSelected () : Array 
		{
			return [ SELECTED, 
					 SELECTED + OVER,
					 SELECTED + DISABLED, 
					 SELECTED + PRESSED ];
		}
		/**
		 * Renvoie l'ensemble des états d'un composant étant sélectionné
		 * et ayant le focus clavier.
		 * 
		 * @return	l'ensemble des états d'un composant étant sélectionné
		 * 			et ayant le focus clavier
		 */
		static public function get allFocusSelected () : Array 
		{
			return [ FOCUS + SELECTED, 
					 FOCUS + SELECTED + OVER,
					 FOCUS + SELECTED + DISABLED, 
					 FOCUS + SELECTED + PRESSED ];
		}
		/**
		 * Renvoie l'ensemble des états d'un composant désactivé.
		 * 
		 * @return	l'ensemble des états d'un composant désactivé
		 */
		static public function get allDisabled () : Array 
		{
			return [ DISABLED, 
					 DISABLED + FOCUS, 
					 DISABLED + SELECTED,
					 DISABLED + FOCUS + SELECTED ];
		}
		/**
		 * Renvoie l'ensemble des états d'un composant lorsque la souris
		 * se situe au dessus de lui.
		 * 
		 * @return	l'ensemble des états d'un composant lorsque la souris
		 * 			se situe au dessus de lui
		 */
		static public function get allOver () : Array 
		{
			return [ OVER, 
					 OVER + FOCUS, 
					 OVER + SELECTED,
					 OVER + FOCUS + SELECTED ];
		}
		/**
		 * Renvoie l'ensemble des états d'un composant lorsque la souris
		 * a été pressé au dessus de lui.
		 * 
		 * @return	l'ensemble des états d'un composant lorsque la souris
		 * 			a été pressé au dessus de lui
		 */
		static public function get allPressed () : Array 
		{
			return [ PRESSED, 
					 PRESSED + FOCUS, 
					 PRESSED + SELECTED,
					 PRESSED + FOCUS + SELECTED ];
		}
	}
}
