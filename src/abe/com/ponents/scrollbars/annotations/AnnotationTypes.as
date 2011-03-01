package abe.com.ponents.scrollbars.annotations
{
	import abe.com.mon.utils.Color;
	/**
	 * @author Cédric Néhémie
	 */
	public class AnnotationTypes
	{
		static public const INFO : String = "info";

		static public const COLORS : Object = {
												info:Color.GreenYellow,
												warn:Color.Orange,
												error:Color.Red,
												fatal:Color.Crimson,
												search:Color.DodgerBlue
											   };
	}
}