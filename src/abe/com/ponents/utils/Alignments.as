/**
 * @license
 */
package abe.com.ponents.utils 
{

	/**
	 * @author Cédric Néhémie
	 */
	public class Alignments 
	{
		static public const LEFT : String = "left";		static public const RIGHT : String = "right";		static public const CENTER : String = "center";		static public const TOP : String = "top";		static public const BOTTOM : String = "bottom";		
		static public function alignHorizontal ( w : Number, ref : Number, insets : Insets,  align : String = "left" ) : Number
		{
			switch( align )
			{
				case Alignments.CENTER :
					return insets.left + ( ref - w - insets.horizontal ) / 2;
				case Alignments.RIGHT : 
					return ref - w - insets.right;
				case Alignments.LEFT : 
				default :
					return insets.left;
			}
		}
		static public function alignVertical ( h : Number,ref : Number, insets : Insets, align : String = "top" ) : Number
		{
			switch( align )
			{
				case Alignments.CENTER :
					return insets.top + ( ref - h - insets.vertical ) / 2;
				case Alignments.BOTTOM : 
					return ref - h - insets.bottom;
				case Alignments.TOP : 
				default :
					return insets.top;
			}
		}
	}
}
