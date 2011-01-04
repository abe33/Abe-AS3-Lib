/**
 * @license
 */
package aesia.com.mon.utils 
{

	/**
	 * La classe <code>KeyStroke</code> représente une combinaison particulière de touches
	 * sur le clavier. Cette combinaison est composée par un <code>keyCode</code> (code de 
	 * touche) et des <code>modifiers</code> qui représente le contexte dans lequel a été 
	 * enfoncée. Le contexte étant défini par les trois touches <code>Keys.CONTROL</code>,
	 * <code>Keys.SHIFT</code> et <code>Keys.ALTERNATE</code>. La valeur de <code>modifiers</code>
	 * est définie par l'addition des constantes <code>CTRL_MASK</code>, <code>SHIFT_MASK</code>
	 * et <code>ALT_MASK</code> selon que les touches correspondantes sont enfoncées ou non.
	 * <p>
	 * Pour obtenir une instance de la classe <code>KeyStroke</code> il est conseillé d'utiliser
	 * la méthode <code>getKeyStroke</code> plutôt que le constructeur, celle-ci garantie en effet
	 * qu'il n'existe qu'une seule instance de la classe <code>KeyStroke</code> pour une combinaison
	 * de touches donnée. Ceci permet d'utiliser une instance de <code>KeyStroke</code> avec l'opérateur
	 * <code>===</code>, et donc en tant que clé dans un objet <code>Dictionary</code>.
	 * </p><p>
	 * Il est cependant possible de comparer deux instances différentes ayant les mêmes valeurs internes
	 * en utilisant le résultat de la méthode <code>toString</code> qui sera toujours identiques pour deux
	 * instances différentes référencant la même combinaison de touche.
	 * </p>
	 */
	public class KeyStroke 
	{
		/*
		 * CLASS MEMBERS
		 */
		/**
		 * Constante associée au masque de modification utilisée lorsque
		 * la touche <code>Keys.SHIFT</code> est enfoncée.
		 */
		static public const SHIFT_MASK : uint = 1;
		/**
		 * Constante associée au masque de modification utilisée lorsque
		 * la touche <code>Keys.CONTROL</code> est enfoncée.
		 */
		static public const CTRL_MASK : uint = 2;
		/**
		 *  Constante associée au masque de modification utilisée lorsque
		 * la touche <code>Keys.ALTERNATE</code> est enfoncée.
		 */
		static public const ALT_MASK : uint = 4;
		
		/**
		 * Renvoie l'instance de <code>KeyStroke</code> correspondant à la combinaison
		 * de touches passée en paramètre. Si aucune instance n'existe, la fonction créée
		 * une nouvelle instance pour cette combinaison, et la renvoie.
		 * 
		 * @param	keyCode		code de la touche
		 * @param	modifiers	contexte associé à cette touche
		 * @return	une instance de <code>KeyStroke</code> représentant la combinaison
		 */
		static public function getKeyStroke ( keyCode : uint, modifiers : uint = 0 ) : KeyStroke
		{
			var ks : KeyStroke = __getKeyStroke( keyCode, modifiers );
			if( ks == null )
				return new KeyStroke( keyCode, modifiers );
			else
				return ks;
		}
		
		/**
		 * Renvoie un entier représentant un contexte utilisable en tant que valeur pour
		 * la propriété <code>modifiers</code> d'une instance de <code>KeyStroke</code>. 
		 * 
		 * @param	ctrlKey		un booléen indiquant si la touche <code>Keys.CONTROL</code>
		 * 						est enfoncée
		 * @param	shiftKey	un booléen indiquant si la touche <code>Keys.SHIFT</code>
		 * 						est enfoncée
		 * @param	altKey		un booléen indiquant si la touche <code>Keys.ALTERNATE</code>
		 * 						est enfoncée
		 * @return	un entier représentant un contexte utilisable en tant que valeur pour
		 * 			la propriété <code>modifiers</code> d'une instance de 
		 * 			<code>KeyStroke</code>
		 */
		static public function getModifiers ( ctrlKey : Boolean = false, shiftKey : Boolean = false, altKey : Boolean = false ) : int
		{
			var mod : int = 0;
			
			if( ctrlKey ) mod += CTRL_MASK;			if( shiftKey ) mod += SHIFT_MASK;			if( altKey ) mod += ALT_MASK;
			
			return mod;	
		}
		
		// Vecteur stockant toutes les instances de KeyStrokes créées.
		/*FDT_IGNORE*/ 
		TARGET::FLASH_9
		static private var instances : Array = [];
		
		TARGET::FLASH_10 
		static private var instances : Vector.<KeyStroke> = new Vector.<KeyStroke> ();
		
		TARGET::FLASH_10_1 /*FDT_IGNORE*/
		static private var instances : Vector.<KeyStroke> = new Vector.<KeyStroke> ();

		/*
		 * Renvoie l'instance stockée avec cette combinaison. Si la combinaison n'existe
		 * pas la fonction renvoie null
		 */
		static private function __getKeyStroke ( keyCode : uint, modifiers : uint = 0 ) : KeyStroke
		{
			var l : Number = instances.length;
 		 	var ks : KeyStroke;
			for( var i : Number = 0; i< l; i++ )
			{
				ks = instances[ i ];
			 	if( ks.equals( keyCode, modifiers ) )
			 		return ks;
			}
			return null;
		}
		
		/*
		 * INSTANCES MEMBERS
		 */
		// code de la touche correspondant à cette instance
		private var _keyCode : uint;
		// contexte d'usage du code de la touche
		private var _modifiers : uint;
		
		/**
		 * Créer une nouvelle instance de la classe <code>KeyStroke</code>.
		 * La classe s'enregistre elle-même au sein du tableau des instances
		 * de la classe <code>KeyStroke</code> si la combinaison qu'elle
		 * représente n'est pas déjà présente. Ainsi, même si plusieurs instances
		 * représentant la même combinaison existe, le tableau des instances ne
		 * contiendra que des combinaisons uniques.
		 * 
		 * @param	keyCode		code de la touche
		 * @param	modifiers	contexte associé à cette touche
		 */
		public function KeyStroke( keyCode : uint, modifiers : uint = 0 )
		{
			this._keyCode = keyCode;
			this._modifiers = modifiers;
			
			if( __getKeyStroke( keyCode, modifiers ) == null )
				instances.push( this );
		}
		/**
		 * Renvoie <code>true</code> si la combinaison représentée par l'instance 
		 * courante est identique à celle passée en paramètre.
		 * 
		 * @param	keyCode		code de la touche
		 * @param	modifiers	contexte associé à cette touche
		 * @return	<code>true</code> si la combinaison représentée par l'instance 
		 * 			courante est identique à celle passée en paramètre
		 */
		public function equals ( keyCode : uint, modifiers : uint = 0 ) : Boolean
		{
			return _keyCode == keyCode && _modifiers == modifiers;
		}
		
		/**
		 * Accès au code de la touche de cette instance.
		 */
		public function get keyCode () : uint
		{
			return _keyCode;
		}
		
		/**
		 * Accès au contexte de cette instance.
		 */
		public function get modifiers () : uint
		{
			return _modifiers;
		}

		/**
		 * Renvoie une chaîne représentant l'instance courante.
		 * 
		 * @return	une chaîne représentant l'instance courante
		 */
		public function toString() : String 
		{
			return toHumanString();
		}
		/**
		 * Renvoie une chaîne de caractère représentant l'instance
		 * courante sous une forme compréhensible par un humain.
		 * 
		 * @return	une chaîne de caractère représentant l'instance
		 * 			courante sous une forme compréhensible par un humain
		 */
		public function toHumanString () : String
		{
			return getModifiersArray( _modifiers ).map( function( i:*, ... args) : * 
			{
				return StringUtils.capitalize( String(i).toLocaleLowerCase() );
			} ).concat(Keys.getKeyName( _keyCode ) ).join("+");
		}

		/**
		 * Renvoie un tableau contenant les touches de modifications
		 * contenues dans <code>mod</code> sous forme de chaîne de caractère.
		 * 
		 * @param	mod	code des modificateurs de raccourcis
		 * @return	un tableau contenant les touches de modifications
		 * 			sous forme de chaîne de caractère
		 */
		protected function getModifiersArray( mod : uint ) : Array
		{
			var a : Array = [];
			
			if( mod & CTRL_MASK )
				a.push( "CTRL" );
			if( mod & SHIFT_MASK )
				a.push( "SHIFT" );
			if( mod & ALT_MASK )
				a.push( "ALT" );
			
			return a;
		}
	}
}
