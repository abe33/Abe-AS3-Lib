/**
 * @license 
 */
package  abe.com.edia.dialogues
{

	/**
	 * La classe <code>Question</code> permet de poser des questions
	 * au joueur durant une phase de dialogue. La question possèdent
	 * un certain nombre de réponses potentielles sous la forme d'un
	 * tableau d'objet <code>Answer</code>.
	 * <p>
	 * Même si la classe <code>Question</code> hérite de la classe
	 * <code>Speech</code>, et donc de sa propriété <code>nextSpeech</code>
	 * celle-ci ne devrait pas être utilisée par un lecteur de dialogues
	 * basé sur cette structure. Et ce car la suite du dialogue est 
	 * en général déterminé par la réponse de l'utilisateur, la 
	 * propriété <code>nextSpeech</code> de la réponse devrait être
	 * utilisée par le lecteur de dialogue.
	 * </p><p>
	 * La classe <code>DialogueKernel</code>, qui implémente la lecture
	 * de dialogue, ignore systématiquement cette propriété.
	 * </p>
	 * @author Cédric Néhémie
	 */
	public class Question extends Speech
	{
		/**
		 * Les objets <code>Answer</code> représentant les réponses
		 * à cette question.
		 */
		/*FDT_IGNORE*/
		TARGET::FLASH_9
		public var answers : Array;
		
		TARGET::FLASH_10
		public var answers : Vector.<Answer>;
		
		TARGET::FLASH_10_1 /*FDT_IGNORE*/
		public var answers : Vector.<Answer>;

		/**
		 * Créer une nouvelle instance de la classe <code>Question</code>.
		 * 
		 * @param	message		le contenu de la question
		 * @param	speaker		l'auteur de cette question
		 * @param	answer		une suite d'objet <code>Answer</code>
		 * 						représentant l'ensemble des réponses 
		 * 						possibles à cette question
		 */
		public function Question( message : String, speaker : String, ... answers )
		{
			super( message, speaker );
			
			/*FDT_IGNORE*/
			TARGET::FLASH_9 { var ans : Array = []; }
			TARGET::FLASH_10 { var ans : Vector.<Answer> = new Vector.<Answer>(); }
			TARGET::FLASH_10_1 { /*FDT_IGNORE*/
			var ans : Vector.<Answer> = new Vector.<Answer>(); /*FDT_IGNORE*/ } /*FDT_IGNORE*/
			
			var l : Number = answers.length;
			
			for(var i : Number = 0; i < l; i++ )
			{
				if( answers[ i ] is Answer )
					ans.push( answers[ i ] as Answer );
			}
			
			this.answers = ans;
		}
	}
}