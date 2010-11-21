/**
 * @license
 */
package aesia.com.ponents.core.edit 
{
	import aesia.com.ponents.core.Component;

	/**
	 * Un composant <code>Editable</code> est un composant dont le contenu
	 * peut être édité par un composant tiers.
	 * <p>
	 * Certains composants, dit de manipulation directe, sont conçus pour
	 * permettre l'édition de la valeur qu'ils contiennent de manière directe.
	 * D'autres, comme les cellules d'une liste, ne permettent pas directement
	 * l'édition de leur contenu, mais fournissent un mécanisme permettant
	 * de faire appel à un composant tiers afin d'éditer ce contenu.
	 * Ils sont dit <code>Editable</code>.
	 * </p>
	 * <p>
	 * Un objet <code>Editable</code> fait appel à un <code>Editor</code> afin
	 * de permettre à l'utilisateur de manipuler son contenu.
	 * </p>
	 * 
	 * @author Cédric Néhémie
	 */
	public interface Editable extends Component
	{
		/**
		 * Une valeur booléenne indiquant si ce composant autorise
		 * actuellement l'édition de son contenu par un composant
		 * tiers.
		 */
		function get allowEdit() : Boolean;
		function set allowEdit( b : Boolean ) : void;
		/**
		 * Une référence vers l'objet <code>Editor</code> chargé
		 * de la manipulation de son contenu.
		 */
		function get editor(): Editor;
		/**
		 * Une valeur booléenne indiquant si le contenu de ce composant
		 * est actuellement en cours d'édition à travers l'objet <code>Editor</code>
		 * correspondant.
		 */
		function get isEditing(): Boolean;
		
		/**
		 * Une valeur booléenne indiquant si ce composant supporte la mécanique
		 * d'édition de son contenu.
		 * <p>
		 * Cette propriété est différente de <code>allowEdit</code> en cela qu'elle
		 * permet à une classe de composant de désactiver complètement la mécanique
		 * d'édition qu'elle aurait par exemple héritée d'une de ses classes mères,
		 * là où la propriété <code>allowEdit</code> est spécifique à un composant.
		 * </p>
		 */
		function get supportEdit(): Boolean;
		
		/**
		 * Initie la séquence d'édition du contenu du composant en faisant appel
		 * à la méthode <code>initEditState</code> de l'objet <code>Editor</code>
		 * de cet objet.
		 */
		function startEdit(): void;
		/**
		 * Annule la séquence d'édition en cours.
		 */
		function cancelEdit(): void;
		/**
		 * Confirme les modifications effectuées durant la séquence d'édition.
		 * <p>
		 * La nouvelle valeur est récupérée depuis l'objet <code>Editor</code>
		 * permettant à cet objet <code>Editable</code> de ce mettre à jour.
		 * </p>
		 */
		function confirmEdit(): void;
	}
}
