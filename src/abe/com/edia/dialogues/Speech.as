/**
 * @license 
 */
package  abe.com.edia.dialogues
{
    import abe.com.mon.core.Serializable;
	/**
	 * La classe <code>Speech</code> est la classe de base de tout les types
	 * de paroles échangées avec les <acronym title="Personnages Non Joueurs">PNJ</acronym>.
	 * <p>
	 * Un objet <code>Speech</code> représente une parole prononcée par un personnage. Chaque
	 * parole peut être suivie d'une autre parole, du même personnage ou d'un autre personnage.
	 * </p>
	 */
    [Serialize(constructorArgs="message,speaker,nextSpeech")]
	public class Speech implements Serializable
	{
		/**
		 * L'identifiant du <acronym title="Personnages Non Joueurs">PNJ</acronym> 
		 * prononcant ces paroles. 
		 */		
		public var speaker : String;
		/**
		 * Les paroles prononcé par le <acronym title="Personnages Non Joueurs">PNJ</acronym> 
		 * dans un encart. 
		 */		
		public var message : String;
		/**
		 * Le discourt de l'encart suivant.
		 */		
		public var nextSpeech : Speech;
		
		/**
		 * Créer une instance de la classe <code>Speech</code>.
		 * 
		 * @param	message		le contenu de cette parole
		 * @param	speaker		l'auteur de cette parole
		 * @param	nextSpeech	la parole suivante à celle-ci
		 */
		public function Speech( message : String, speaker : String, nextSpeech : Speech = null )
		{
			this.speaker = speaker;
			this.message = message;
			this.nextSpeech = nextSpeech;
		}
	}
}