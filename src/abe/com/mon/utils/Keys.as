/**
 * @license
 */
package abe.com.mon.utils 
{

	/**
	 * Classe regroupant les codes de touches d'un clavier standard. Étant donné que la plupart
	 * des codes de touches de la classe <code>Keyboard</code> ne sont accessibles que dans <code>AIR</code>
	 * (ce qui est fort ennuyeux, il faut le reconnaître), cette classe abolit ces restrictions en dupliquant
	 * l'ensemble des constantes se référant au codes de touches de la classe <code>Keyboard</code>.
	 * 
	 * @author Cédric Néhémie
	 */
	public class Keys
	{
		/*
		 * RegExp pour manipuler les constantes : 
		 * static public const ([A-Z0-9_]+) : uint = ([0-9]+);
		 * Remplacement pour générer la documentation (penser à enlever l'échapement du / de fin de commentaire) : 
		 * /\*\*\n\t\t \* Constante associé avec le code de touche de la touche <code>$1</code> ($2).\n\t\t \*\/\n\t\t$0
		 */
		/**
		 * Constante associé avec le code de touche de la touche <code>A</code> (65).
		 */
		static public const A : uint = 65;		/**
		 * Constante associé avec le code de touche de la touche <code>B</code> (66).
		 */
		static public const B : uint = 66;		/**
		 * Constante associé avec le code de touche de la touche <code>C</code> (67).
		 */
		static public const C : uint = 67;		/**
		 * Constante associé avec le code de touche de la touche <code>D</code> (68).
		 */
		static public const D : uint = 68;		/**
		 * Constante associé avec le code de touche de la touche <code>E</code> (69).
		 */
		static public const E : uint = 69;		/**
		 * Constante associé avec le code de touche de la touche <code>F</code> (70).
		 */
		static public const F : uint = 70;		/**
		 * Constante associé avec le code de touche de la touche <code>G</code> (71).
		 */
		static public const G : uint = 71;		/**
		 * Constante associé avec le code de touche de la touche <code>H</code> (72).
		 */
		static public const H : uint = 72;		/**
		 * Constante associé avec le code de touche de la touche <code>I</code> (73).
		 */
		static public const I : uint = 73;		/**
		 * Constante associé avec le code de touche de la touche <code>J</code> (74).
		 */
		static public const J : uint = 74;		/**
		 * Constante associé avec le code de touche de la touche <code>K</code> (75).
		 */
		static public const K : uint = 75;		/**
		 * Constante associé avec le code de touche de la touche <code>L</code> (76).
		 */
		static public const L : uint = 76;		/**
		 * Constante associé avec le code de touche de la touche <code>M</code> (77).
		 */
		static public const M : uint = 77;		/**
		 * Constante associé avec le code de touche de la touche <code>N</code> (78).
		 */
		static public const N : uint = 78;		/**
		 * Constante associé avec le code de touche de la touche <code>O</code> (79).
		 */
		static public const O : uint = 79;		/**
		 * Constante associé avec le code de touche de la touche <code>P</code> (80).
		 */
		static public const P : uint = 80;		/**
		 * Constante associé avec le code de touche de la touche <code>Q</code> (81).
		 */
		static public const Q : uint = 81;		/**
		 * Constante associé avec le code de touche de la touche <code>R</code> (82).
		 */
		static public const R : uint = 82;		/**
		 * Constante associé avec le code de touche de la touche <code>S</code> (83).
		 */
		static public const S : uint = 83;		/**
		 * Constante associé avec le code de touche de la touche <code>T</code> (84).
		 */
		static public const T : uint = 84;		/**
		 * Constante associé avec le code de touche de la touche <code>U</code> (85).
		 */
		static public const U : uint = 85;		/**
		 * Constante associé avec le code de touche de la touche <code>V</code> (86).
		 */
		static public const V : uint = 86;		/**
		 * Constante associé avec le code de touche de la touche <code>W</code> (87).
		 */
		static public const W : uint = 87;		/**
		 * Constante associé avec le code de touche de la touche <code>X</code> (88).
		 */
		static public const X : uint = 88;		/**
		 * Constante associé avec le code de touche de la touche <code>Y</code> (89).
		 */
		static public const Y : uint = 89;		/**
		 * Constante associé avec le code de touche de la touche <code>Z</code> (90).
		 */
		static public const Z : uint = 90;		
		/**
		 * Constante associé avec le code de touche de la touche <code>F1</code> (112).
		 */
		static public const F1 : uint = 112;		/**
		 * Constante associé avec le code de touche de la touche <code>F2</code> (113).
		 */
		static public const F2 : uint = 113;		/**
		 * Constante associé avec le code de touche de la touche <code>F3</code> (114).
		 */
		static public const F3 : uint = 114;		/**
		 * Constante associé avec le code de touche de la touche <code>F4</code> (115).
		 */
		static public const F4 : uint = 115;		/**
		 * Constante associé avec le code de touche de la touche <code>F5</code> (116).
		 */
		static public const F5 : uint = 116;		/**
		 * Constante associé avec le code de touche de la touche <code>F6</code> (117).
		 */
		static public const F6 : uint = 117;		/**
		 * Constante associé avec le code de touche de la touche <code>F7</code> (118).
		 */
		static public const F7 : uint = 118;		/**
		 * Constante associé avec le code de touche de la touche <code>F8</code> (119).
		 */
		static public const F8 : uint = 119;		/**
		 * Constante associé avec le code de touche de la touche <code>F9</code> (120).
		 */
		static public const F9 : uint = 120;		/**
		 * Constante associé avec le code de touche de la touche <code>F10</code> (121).
		 */
		static public const F10 : uint = 121;		/**
		 * Constante associé avec le code de touche de la touche <code>F11</code> (122).
		 */
		static public const F11 : uint = 122;		/**
		 * Constante associé avec le code de touche de la touche <code>F12</code> (123).
		 */
		static public const F12 : uint = 123;		/**
		 * Constante associé avec le code de touche de la touche <code>F13</code> (124).
		 */
		static public const F13 : uint = 124;		/**
		 * Constante associé avec le code de touche de la touche <code>F14</code> (125).
		 */
		static public const F14 : uint = 125;		/**
		 * Constante associé avec le code de touche de la touche <code>F15</code> (126).
		 */
		static public const F15 : uint = 126;		
		/**
		 * Constante associé avec le code de touche de la touche <code>NUMBER_0</code> (48).
		 */
		static public const NUMBER_0 : uint = 48;		/**
		 * Constante associé avec le code de touche de la touche <code>NUMBER_1</code> (49).
		 */
		static public const NUMBER_1 : uint = 49;		/**
		 * Constante associé avec le code de touche de la touche <code>NUMBER_2</code> (50).
		 */
		static public const NUMBER_2 : uint = 50;		/**
		 * Constante associé avec le code de touche de la touche <code>NUMBER_3</code> (51).
		 */
		static public const NUMBER_3 : uint = 51;		/**
		 * Constante associé avec le code de touche de la touche <code>NUMBER_4</code> (52).
		 */
		static public const NUMBER_4 : uint = 52;		/**
		 * Constante associé avec le code de touche de la touche <code>NUMBER_5</code> (53).
		 */
		static public const NUMBER_5 : uint = 53;		/**
		 * Constante associé avec le code de touche de la touche <code>NUMBER_6</code> (54).
		 */
		static public const NUMBER_6 : uint = 54;		/**
		 * Constante associé avec le code de touche de la touche <code>NUMBER_7</code> (55).
		 */
		static public const NUMBER_7 : uint = 55;		/**
		 * Constante associé avec le code de touche de la touche <code>NUMBER_8</code> (56).
		 */
		static public const NUMBER_8 : uint = 56;		/**
		 * Constante associé avec le code de touche de la touche <code>NUMBER_9</code> (57).
		 */
		static public const NUMBER_9 : uint = 57;
				
		/**
		 * Constante associé avec le code de touche de la touche <code>NUMPAD_0</code> (96).
		 */
		static public const NUMPAD_0 : uint = 96;		/**
		 * Constante associé avec le code de touche de la touche <code>NUMPAD_1</code> (97).
		 */
		static public const NUMPAD_1 : uint = 97;		/**
		 * Constante associé avec le code de touche de la touche <code>NUMPAD_2</code> (98).
		 */
		static public const NUMPAD_2 : uint = 98;		/**
		 * Constante associé avec le code de touche de la touche <code>NUMPAD_3</code> (99).
		 */
		static public const NUMPAD_3 : uint = 99;		/**
		 * Constante associé avec le code de touche de la touche <code>NUMPAD_4</code> (100).
		 */
		static public const NUMPAD_4 : uint = 100;		/**
		 * Constante associé avec le code de touche de la touche <code>NUMPAD_5</code> (101).
		 */
		static public const NUMPAD_5 : uint = 101;		/**
		 * Constante associé avec le code de touche de la touche <code>NUMPAD_6</code> (102).
		 */
		static public const NUMPAD_6 : uint = 102;		/**
		 * Constante associé avec le code de touche de la touche <code>NUMPAD_7</code> (103).
		 */
		static public const NUMPAD_7 : uint = 103;		/**
		 * Constante associé avec le code de touche de la touche <code>NUMPAD_8</code> (104).
		 */
		static public const NUMPAD_8 : uint = 104;		/**
		 * Constante associé avec le code de touche de la touche <code>NUMPAD_9</code> (105).
		 */
		static public const NUMPAD_9 : uint = 105;		/**
		 * Constante associé avec le code de touche de la touche <code>NUMPAD_MULTIPLY</code> (106).
		 */
		static public const NUMPAD_MULTIPLY : uint = 106;		/**
		 * Constante associé avec le code de touche de la touche <code>NUMPAD_ADD</code> (107).
		 */
		static public const NUMPAD_ADD : uint = 107;		/**
		 * Constante associé avec le code de touche de la touche <code>NUMPAD_ENTER</code> (108).
		 */
		static public const NUMPAD_ENTER : uint = 108;		/**
		 * Constante associé avec le code de touche de la touche <code>NUMPAD_SUBTRACT</code> (109).
		 */
		static public const NUMPAD_SUBTRACT : uint = 109;		/**
		 * Constante associé avec le code de touche de la touche <code>NUMPAD_DECIMAL</code> (110).
		 */
		static public const NUMPAD_DECIMAL : uint = 110;		/**
		 * Constante associé avec le code de touche de la touche <code>NUMPAD_DIVIDE</code> (111).
		 */
		static public const NUMPAD_DIVIDE : uint = 111;
		
		/**
		 * Constante associé avec le code de touche de la touche <code>BACKSPACE</code> (8).
		 */
		static public const BACKSPACE : uint = 8;
		/**
		 * Constante associé avec le code de touche de la touche <code>TAB</code> (9).
		 */
		static public const TAB : uint = 9;
		
		/**
		 * Constante associé avec le code de touche de la touche <code>ENTER</code> (13).
		 */
		static public const ENTER : uint = 13;
		
		/**
		 * Constante associé avec le code de touche de la touche <code>COMMAND</code> (15).
		 */
		static public const COMMAND : uint = 15;
		/**
		 * Constante associé avec le code de touche de la touche <code>SHIFT</code> (16).
		 */
		static public const SHIFT : uint = 16;
		/**
		 * Constante associé avec le code de touche de la touche <code>CONTROL</code> (17).
		 */
		static public const CONTROL : uint = 17;
		/**
		 * Constante associé avec le code de touche de la touche <code>ALTERNATE</code> (18).
		 */
		static public const ALTERNATE : uint = 18;
				/**
		 * Constante associé avec le code de touche de la touche <code>CAPS_LOCK</code> (20).
		 */
		static public const CAPS_LOCK : uint = 20;		
		/**
		 * Constante associé avec le code de touche de la touche <code>ESCAPE</code> (27).
		 */
		static public const ESCAPE : uint = 27;
		
		/**
		 * Constante associé avec le code de touche de la touche <code>SPACE</code> (32).
		 */
		static public const SPACE : uint = 32;		/**
		 * Constante associé avec le code de touche de la touche <code>PAGE_UP</code> (33).
		 */
		static public const PAGE_UP : uint = 33;
		/**
		 * Constante associé avec le code de touche de la touche <code>PAGE_DOWN</code> (34).
		 */
		static public const PAGE_DOWN : uint = 34;		
		/**
		 * Constante associé avec le code de touche de la touche <code>END</code> (35).
		 */
		static public const END : uint = 35;
		/**
		 * Constante associé avec le code de touche de la touche <code>HOME</code> (36).
		 */
		static public const HOME : uint = 36;
		/**
		 * Constante associé avec le code de touche de la touche <code>LEFT</code> (37).
		 */
		static public const LEFT : uint = 37;
		/**
		 * Constante associé avec le code de touche de la touche <code>UP</code> (38).
		 */
		static public const UP : uint = 38;
		/**
		 * Constante associé avec le code de touche de la touche <code>RIGHT</code> (39).
		 */
		static public const RIGHT : uint = 39;
		/**
		 * Constante associé avec le code de touche de la touche <code>DOWN</code> (40).
		 */
		static public const DOWN : uint = 40;		
		/**
		 * Constante associé avec le code de touche de la touche <code>INSERT</code> (45).
		 */
		static public const INSERT : uint = 45;
		/**
		 * Constante associé avec le code de touche de la touche <code>DELETE</code> (46).
		 */
		static public const DELETE : uint = 46;		
		
		/**
		 * Constante associé avec le code de touche de la touche <code>SEMICOLON</code> (186).
		 */
		static public const SEMICOLON : uint = 186;
		/**
		 * Constante associé avec le code de touche de la touche <code>EQUAL</code> (187).
		 */
		static public const EQUAL : uint = 187;
		/**
		 * Constante associé avec le code de touche de la touche <code>COMMA</code> (188).
		 */
		static public const COMMA : uint = 188;
		/**
		 * Constante associé avec le code de touche de la touche <code>MINUS</code> (189).
		 */
		static public const MINUS : uint = 189;
		/**
		 * Constante associé avec le code de touche de la touche <code>PERIOD</code> (190).
		 */
		static public const PERIOD : uint = 190;
		
		/**
		 * Constante associé avec le code de touche de la touche <code>SLASH</code> (191).
		 */
		static public const SLASH : uint = 191;
				/**
		 * Constante associé avec le code de touche de la touche <code>BACKQUOTE</code> (192).
		 */
		static public const BACKQUOTE : uint = 192;
		
		/**
		 * Constante associé avec le code de touche de la touche <code>LEFTBRACKET</code> (219).
		 */
		static public const LEFTBRACKET : uint = 219;		/**
		 * Constante associé avec le code de touche de la touche <code>BACKSLASH</code> (220).
		 */
		static public const BACKSLASH : uint = 220;
		/**
		 * Constante associé avec le code de touche de la touche <code>RIGHTBRACKET</code> (221).
		 */
		static public const RIGHTBRACKET : uint = 221;		
		/**
		 * Constante associé avec le code de touche de la touche <code>QUOTE</code> (222).
		 */
		static public const QUOTE : uint = 222;
		
		// objet contenant l'ensembles des noms de clés définies en constantes.
		static private const KEY_NAMES : Object = initializeKeyNames();
		
		/**
		 * Renvoie le nom de la constante de la classe <code>Keys</code> associé
		 * avec le code de touche passé en paramètre.
		 * 
		 * @param	keyCode	le code de la touche dont on veut connaître le nom
		 * @return	le nom de la constante de la classe <code>Keys</code> associé
		 * 			avec le code de touche passé en paramètre
		 */
		static public function getKeyName ( keyCode : Number ) : String
		{
			if( KEY_NAMES.hasOwnProperty( keyCode ) )
				return KEY_NAMES[ keyCode ] as String;
			else
				return keyCode.toString();
		}

		/**
		 * Initialise la liste des noms de touches associés aux codes de touches
		 * définit par la classe <code>Keys</code>.
		 */
		static private function initializeKeyNames () : Object
		{
			var a : Object = {};
			
			a[ A ] = "A";
			a[ B ] = "B";
			a[ C ] = "C";
			a[ D ] = "D";
			a[ E ] = "E";
			a[ F ] = "F";
			a[ G ] = "G";
			a[ H ] = "H";
			a[ I ] = "I";
			a[ J ] = "J";
			a[ K ] = "K";
			a[ L ] = "L";
			a[ M ] = "M";
			a[ N ] = "N";
			a[ O ] = "O";
			a[ P ] = "P";
			a[ Q ] = "Q";
			a[ R ] = "R";
			a[ S ] = "S";
			a[ T ] = "T";
			a[ U ] = "U";
			a[ V ] = "V";
			a[ W ] = "W";
			a[ X ] = "X";
			a[ Y ] = "Y";
			a[ Z ] = "Z";
				
			a[ F1 ] = "F1";
			a[ F2 ] = "F2";
			a[ F3 ] = "F3";
			a[ F4 ] = "F4";
			a[ F5 ] = "F5";
			a[ F6 ] = "F6";
			a[ F7 ] = "F7";
			a[ F8 ] = "F8";
			a[ F9 ] = "F9";
			a[ F10 ] = "F10";
			a[ F11 ] = "F11";
			a[ F12 ] = "F12";
			a[ F13 ] = "F13";
			a[ F14 ] = "F14";
			a[ F15 ] = "F15";
			
			a[ CAPS_LOCK ] = "CAPS_LOCK";
			a[ CONTROL ] = "CONTROL";
			a[ SHIFT ] = "SHIFT";

			a[ BACKSPACE ] = "BACKSPACE";
			a[ ENTER ] = "ENTER";
			a[ ESCAPE ] = "ESCAPE";
			a[ SPACE ] = "SPACE";
			a[ TAB ] = "TAB";

			a[ LEFT ] = "LEFT";
			a[ RIGHT ] = "RIGHT";
			a[ DOWN ] = "DOWN";
			a[ UP ] = "UP";
			
			a[ DELETE ] = "DELETE";
			a[ END ] = "END";
			a[ HOME ] = "HOME";
			a[ INSERT ] = "INSERT";
			a[ PAGE_DOWN ] = "PAGE_DOWN";
			a[ PAGE_UP ] = "PAGE_UP";

			a[ NUMBER_0 ] = "NUMBER_0";
			a[ NUMBER_1 ] = "NUMBER_1";
			a[ NUMBER_2 ] = "NUMBER_2";
			a[ NUMBER_3 ] = "NUMBER_3";
			a[ NUMBER_4 ] = "NUMBER_4";
			a[ NUMBER_5 ] = "NUMBER_5";
			a[ NUMBER_6 ] = "NUMBER_6";
			a[ NUMBER_7 ] = "NUMBER_7";
			a[ NUMBER_8 ] = "NUMBER_8";
			a[ NUMBER_9 ] = "NUMBER_9";
			
			a[ NUMPAD_0 ] = "NUMPAD_0";
			a[ NUMPAD_1 ] = "NUMPAD_1";
			a[ NUMPAD_2 ] = "NUMPAD_2";
			a[ NUMPAD_3 ] = "NUMPAD_3";
			a[ NUMPAD_4 ] = "NUMPAD_4";
			a[ NUMPAD_5 ] = "NUMPAD_5";
			a[ NUMPAD_6 ] = "NUMPAD_6";
			a[ NUMPAD_7 ] = "NUMPAD_7";
			a[ NUMPAD_8 ] = "NUMPAD_8";
			a[ NUMPAD_9 ] = "NUMPAD_9";
			a[ NUMPAD_ADD ] = "NUMPAD_ADD";
			a[ NUMPAD_DECIMAL ] = "NUMPAD_DECIMAL";
			a[ NUMPAD_DIVIDE ] = "NUMPAD_DIVIDE";
			a[ NUMPAD_ENTER ] = "NUMPAD_ENTER";
			a[ NUMPAD_MULTIPLY ] = "NUMPAD_MULTIPLY";
			a[ NUMPAD_SUBTRACT ] = "NUMPAD_SUBTRACT";
			
			return a;
		}
	}
}
