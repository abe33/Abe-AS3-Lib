/**
 * @license
 */
package  abe.com.mon.colors 
{
	import abe.com.mon.core.Cloneable;
	import abe.com.mon.core.Equatable;
	import abe.com.mon.core.Serializable;
	import abe.com.mon.utils.MathUtils;
	import abe.com.mon.utils.StringUtils;

	import flash.utils.getQualifiedClassName;
	/**
	 * Un objet <code>Gradient</code> représente une rampe de dégradé coloré
	 * à l'aide d'objet <code>Color</code>.
	 * <p>
	 * Les objets <code>Gradient</code> peuvent être utilisés par la suite
	 * avec les méthodes de dessins de l'API de la classe <code>Graphics</code>
	 * ou au sein de nombreux objets de la librairie AbeLib.
	 * </p>
	 * 
	 * @author Cédric Néhémie
	 * @see	Color
	 */
    [Serialize(constructorArgs="colors,positions,name")]
	public class Gradient implements Serializable, Cloneable, Equatable
    {
        static public const COLOR_SPECTRUM : Gradient = new Gradient([	Color.Red, Color.Yellow, Color.Green, 
        																Color.Cyan, Color.Blue, Color.Fuchsia, 
                                                                        Color.Red ], 
                                                                     [ 0 , 0.12, 0.30, 0.5, 0.70, 0.88, 1 ],
                                                                     "Color Spectrum" );
		/**
		 * Le tableau de couleurs constituant le dégradé.
		 */
		protected var _colors : Array;
		/**
		 * La position des couleurs dans le dégradé.
		 */
		protected var _positions : Array;
		/**
		 * Le nom de ce dégradé.
		 */
		protected var _name : String;

		/**
		 * Constructeur de la classe <code>Gradient</code>.
		 * <p>
		 * Les tableaux <code>colors</code> et <code>positions</code> doivent
		 * avoir la même longueur, sinon une erreur de type <code>Error</code> 
		 * est levée
		 * </p>
		 * 
		 * @param	colors
		 * @param	positions
		 * @throws Error Les deux tableaux en paramètre doivent être de longueur égale
		 */
		public function Gradient ( colors : Array, positions : Array, name:String="Unnamed gradient" )
		{
			if( colors.length != positions.length )
				throw new Error ( "Les deux tableaux en paramètre doivent être de longueur égale" );
			
			this._name = name;
			this._colors = colors;
			this._positions = positions;
		}
		/**
		 * Le nom de ce dégradé.
		 */
		public function get name () : String { return _name; }		
		public function set name (name : String) : void
		{
			_name = name;
		}
		/**
		 * Le tableau des couleurs de ce dégradé.
		 */
		public function get colors () : Array { return _colors; }		
		public function set colors (colors : Array) : void
		{
			_colors = colors;
		}
		/**
		 * La positiob des couleurs dans ce dégradé.
		 */
		public function get positions () : Array { return _positions; }
		public function set positions (positions : Array) : void
		{
			_positions = positions;
		}
		/**
		 * Renvoie la couleur située à la position <code>p</code>
		 * dans ce dégradé.
		 * 
		 * @param	p	position de la couleur à récupérer dans la plage 0-1
		 * @return	la couleur située à la position <code>p</code>
		 * 			dans ce dégradé
		 */
		public function getColor ( p : Number ) : Color
		{
			var startIndex : Number = getStartIndex(p);			var endIndex : Number = getEndIndex(p);

			var color1 : Color = this._colors[ startIndex ] as Color;
			var color2 : Color = this._colors[ endIndex ] as Color;			
			var position1 : Number = this._positions[ startIndex ];
			var position2 : Number = this._positions[ endIndex ];
			
			if( color1 && !color2 )
				return color1;
			else if( !color1 && color2 )
				return color2;
			else if ( position1 == position2 )
				return color1;		
			else
				return color1.interpolate( color2, MathUtils.normalize(p, position1, position2) );
		}	
		/**
		 * Renvoie une copie de cet objet <code>Gradient</code>.
		 * 
		 * @return	une copie de cet objet <code>Gradient</code>
		 */	
		public function clone () : *
		{
			return new Gradient( _colors.map( function(i:Color,...args) : Color { return i.clone();} ), 
								 _positions.concat() );
		}
		
		/**
		 * Renvoie la représentation de l'objet sous forme de chaîne.
		 * 
		 * @return la représentation de l'objet sous forme de chaîne
		 */
		public function toString () : String
		{
			return StringUtils.stringify(this);
		}
		/**
		 * Renvoie un tableau de couleurs au format héxadécimal tel
		 * qu'utilisé par la méthode <code>Graphic.beginGradientFill</code>.
		 * 
		 * @return	un tableau de couleurs au format héxadécimal tel
		 * 			qu'utilisé par la méthode <code>Graphic.beginGradientFill</code>
		 */
		public function toGradientFillColorsArray () : Array
		{
			var a : Array =[];
			
			for each ( var c : Color in _colors)
				a.push(c.hexa);
			
			return a;
		}
		/**
		 * Renvoie un tableau de valeurs de transparences tel
		 * qu'utilisé par la méthode <code>Graphic.beginGradientFill</code>.
		 * 
		 * @return	un tableau de valeurs de transparences tel
		 * 			qu'utilisé par la méthode <code>Graphic.beginGradientFill</code>
		 */
		public function toGradientFillAlphasArray () : Array
		{
			var a : Array =[];
			
			for each ( var c : Color in _colors)
				a.push(c.alpha/255);
			
			return a;
		}
		/**
		 * Renvoie un tableau de valeurs de positions tel
		 * qu'utilisé par la méthode <code>Graphic.beginGradientFill</code>.
		 * 
		 * @return	un tableau de valeurs de positions tel
		 * 			qu'utilisé par la méthode <code>Graphic.beginGradientFill</code>
		 */
		public function toGradientFillPositionsArray () : Array
		{
			var a : Array =[];
			var l : uint = _positions.length;
			var i : uint; 
			
			for (i=0;i<l;i++)
				a.push( Math.floor(_positions[i]*255) );
			
			return a;
		}
		/**
		 * Renvoie l'index de la couleur de départ de la tranche dans laquelle
		 * se situe la position passée en paramètre.
		 * 
		 * @param	position	position dont on souhaite connaître l'index
		 * 						de début de tranche
		 * @return	l'index de la couleur de départ de la tranche dans laquelle
		 * 			se situe la position passée en paramètre
		 */
		public function getStartIndex ( position : Number ) : Number
		{
			position = isValidPosition ( position );
			var l : Number = this._positions.length;
			
			while( l-- )
			{
				if( this._positions[ l ] <= position )
					return l;
			}
			return 0;
		}
		/**
		 *  Renvoie l'index de la couleur de fin de la tranche dans laquelle
		 * se situe la position passée en paramètre.
		 * 
		 * @param	position	position dont on souhaite connaître l'index
		 * 						de fin de tranche
		 * @return	l'index de la couleur de fin de la tranche dans laquelle
		 * 			se situe la position passée en paramètre
		 */
		public function getEndIndex ( position : Number ) : Number
		{
			position = isValidPosition ( position );
			var l : Number = this._positions.length;
			
			for( var i : Number = 0 ; i < l ; i++ )
			{
				if( this._positions[ i ] >= position )
					return i;
			}
			return l;
		}
		/**
		 * Renvoie <code>true</code> si la position est bien dans la plage
		 * <code>0-1</code>
		 * 
		 * @param	position	position à tester
		 * @return	<code>true</code> si la position est bien dans la plage
		 * 			<code>0-1</code>
		 */
		public function isValidPosition ( position : Number ) : Number
		{
			if( position < 0 )
				return 0;
			else if ( position > 1 )
				return 1;
			else return position;
		}
		/**
		 * Compare deux objets <code>Gradient</code> et renvoie <code>true</code>
		 * si tout les éléments les composants sont identiques.
		 * 
		 * @param	o	objet <code>Gradient</code> à comparer
		 * @return	<code>true</code> si tout les éléments 
		 * 			les composants sont identiques
		 */
		public function equals (o : *) : Boolean
		{
			if( o is Gradient )
			{
				var g : Gradient = o as Gradient;
				
				if( g.colors.length != colors.length )
					return false;
				
				var b : Boolean = _colors.every( 
						function(c:Color, i:int,... args):Boolean
						{ 
							return c.equals(g.colors[i]); 
						});
				b &&= _positions.every( 
						function( p:Number, i:int,... args) : Boolean
						{ 
							return p == g.positions[i]; 
						});
				return b;
			}
			
			return false;
		}
	}
}
