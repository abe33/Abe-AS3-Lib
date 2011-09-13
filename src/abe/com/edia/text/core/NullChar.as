/**
 * @license
 */
package abe.com.edia.text.core 
{
    import flash.display.DisplayObject;
    import flash.text.TextFormat;
	/**
	 * @author Cédric Néhémie
	 */
	public class NullChar implements Char 
	{	
		public function get x () : Number 						{ return NaN; }
		public function get y () : Number 						{ return NaN; }
		public function get text () : String 					{ return ""; }
		public function get format () : TextFormat				{ return null; }
		public function get charWidth () : Number				{ return 0; }
		public function get visible () : Boolean				{ return false;	}
		public function get filters () : Array					{ return null; }
		public function get charHeight () : Number				{ return 0;	}
		public function get scaleX () : Number					{ return 1; }
		public function get scaleY () : Number					{ return 1; }
		public function get width () : Number					{ return 0; }
		public function get height () : Number					{ return 0;	}
		public function get alpha () : Number					{ return 1; }
		public function get background () : Boolean				{ return false;	}
		public function get backgroundColor () : uint			{ return 0xffffff; }
		public function get charContent () : DisplayObject		{ return null; }
		public function get baseline () : Number				{ return 0; }
		public function set x (n : Number) : void				{}
		public function set y (n : Number) : void				{}
		public function set text (s : String) : void			{}
		public function set format (tf : TextFormat) : void		{}
		public function set visible (b : Boolean) : void		{}
		public function set filters (b : Array) : void			{}
		public function set scaleX (n : Number) : void			{}
		public function set scaleY (n : Number) : void			{}
		public function set alpha (n : Number) : void			{}
		public function set background (b : Boolean) : void		{}
		public function set backgroundColor (b : uint) : void	{}
		public function toString () : String					{ return text; }
	}
}
