/**
 * @license
 */
package abe.com.mon.utils 
{
	import abe.com.mon.core.Equatable;
	import abe.com.mon.utils.Color;
	import abe.com.mon.utils.Gradient;

	import flash.utils.getQualifiedClassName;

	/**
	 * Un objet <code>Palette</code> définit un ensemble de couleurs
	 * ordonnées et regroupées sous un ensemble commun. 
	 * <p>
	 * Le package <code>abe.com.patibility.codecs</code> possède des
	 * classes permettant d'importer ou d'exporter des palettes 
	 * aux formats <code>&#42;.aco</code> (palettes photoshop) 
	 * et <code>&#42;.gpl</code> (palettes gimp).
	 * </p>
	 * @author Cédric Néhémie
	 * @see	abe.com.patibility.codecs.ACOCodec	 * @see	abe.com.patibility.codecs.GPLCodec
	 */
	public class Palette implements Equatable
	{
		/**
		 * Un tableau contenant l'ensemble des couleurs de cet objet <code>Palette</code>.
		 */
		protected var _colors : Array;
		/**
		 * Le nom de cet objet <code>Palette</code>.
		 */
		protected var _name : String;
		
		/**
		 * Constructeur de la classe <code>Palette</code>.
		 * <p>
		 * Le paramètre <code>args</code> peut être soit une suite d'objets
		 * <code>Color</code> soit un tableau d'objets <code>Color</code>.
		 * </p>
		 * 
		 * @param	name	nom de la palette
		 * @param	args	une suite d'objets <code>Color</code> ou un tableau
		 * 					d'objets <code>Color</code>
		 * @example <listing>var palette : Palette = new Palette("My Palette", Color.White, Color.Black );</listing>		 * @example <listing>var palette : Palette = new Palette("My Palette", [ Color.White, Color.Black ] );</listing>
		 */
		public function Palette ( name : String = "", ... args )
		{
			if( args.length == 1 && args[0] is Array )
				_colors = args[0];
			else
				_colors = args;
			
			_name = name;
		}

		/*-------------------------------------------------------------------
		 * 	ACCESS ELEMENTS METHODS
		 *------------------------------------------------------------------*/
		 /**
		  * Accès à une copie du tableau de couleurs de cette palette.
		  */
		public function get colors () : Array { return _colors.concat(); }
		/**
		 * Un entier représentant le nombre de couleurs dans cette palette.
		 */		public function get size () : int { return _colors.length; }
		/**
		 * Accès à un objet <code>Gradient</code> contenant toutes les couleurs
		 * de cette palette.
		 */
		public function get gradient () : Gradient
		{
			var l : Number = size;
			var ratioStep : Number = 1 / (l-1);
			var cols : Array = [];			var ratios : Array = [];			var ratio : Number = 0;
			
			for( var i : Number = 0; i < l; i++ )
			{
				var col : Color = _colors[i];
				
				cols[ i ] = col;
				ratios[ i ] = ratio;
				ratio += ratioStep;
			}
			
			return new Gradient(cols, ratios );		
		}
		/**
		 * Le nom de cette palette.
		 */
		public function get name () : String { return _name; }		
		public function set name (name : String) : void
		{
			_name = name;
		}
		
		/**
		 * Renvoie la couleur située à l'index <code>id</code>
		 * dans le tableau des couleurs de cette palette.
		 * 
		 * @param	id	index de la couleur à récupérer.
		 * @return	la couleur située à l'index <code>id</code>
		 * 			dans le tableau des couleurs de cette palette
		 */
		public function getColorAt ( id : uint ) : Color
		{
			if( id < _colors.length )
				return _colors[id];
			else
				return null;
		}
		/**
		 * Renvoie l'index de la couleur <code>o</code> dans le tableau
		 * des couleurs de cette palette
		 * 
		 * @param	o	couleur dont on souhaite connaître l'index
		 * @return	l'index de la couleur <code>o</code> dans le tableau
		 * 			des couleurs de cette palette
		 */
		public function getColorIndex ( o : Color ) : int
		{
			return _colors.indexOf( o );
		}
		/**
		 * [fluent] Modifie la position de la couleur <code>o</code> dans le tableau
		 * des couleurs de cette palette.
		 * 
		 * @param	o	couleur à déplacer
		 * @param	id	nouvel index de la couleur
		 * @return	une référence à cet objet <code>Palette</code>
		 */
		public function setColorIndex ( o : Color, id : uint ) : Palette
		{
			var ido : int = getColorIndex (o);
			 
			_colors.splice( ido, 1 );
			if( id >= _colors.length )
				_colors.push( o );
			else
				_colors.splice( id, 0, o );
				
			return this;
		}
		/**
		 * Renvoie <code>true</code> si cette palette contient l'objet
		 * couleur <code>o</code>.
		 * 
		 * @param	o	la couleur dont on souhaite savoir si elle est
		 * 				présente dans la palette
		 * @return	<code>true</code> si cette palette contient la couleur
		 */
		public function containsColor ( o : Color ) : Boolean
		{
			return _colors.indexOf( o ) != -1; 
		} 

		/*-------------------------------------------------------------------
		 * 	ADD ELEMENTS METHODS
		 *------------------------------------------------------------------*/
		/**
		 * [fluent] Ajoute la couleur <code>o</code> à la palette courante.
		 * 
		 * @param	o	couleur à ajouter
		 * @return	une référence à cet objet <code>Palette</code>
		 */
		public function addColor ( o : Color ) : Palette
		{
			if( !containsColor( o ) )
			{
				_colors.push( o );
			}
			return this;
		}
		/**
		 * [fluent] Ajoute la couleur <code>o</code> à la palette courante.
		 * 
		 * @param	o	couleur à ajouter
		 * @param	id	index de la couleur
		 * @return	une référence à cet objet <code>Palette</code>
		 */
		public function addColorAt ( o : Color, id : Number = 0 ) : Palette
		{
			if( !containsColor( o ) )
			{
				_colors.splice( id, 0, o );
			}
			return this;
		}
		/**
		 * 
		 * [fluent] Ajoute un ensemble d'objets <code>Color</code>
		 * à cette palette.
		 * 
		 * @param	args	couleurs à ajouter
		 * @return	une référence à cet objet <code>Palette</code>
		 */
		public function addColors ( ... objs ) : Palette
		{
			for each( var o : Color in objs )
				if( o )
					addColor( o );
			
			return this;
		}
		/**
		 * 
		 * [fluent] Ajoute un ensemble d'objets <code>Color</code>
		 * à cette palette.
		 * 
		 * @param	objs	couleurs à ajouter
		 * @return	une référence à cet objet <code>Palette</code>
		 */
		public function addColorsArray ( objs : Array ) : Palette
		{
			for each( var o : Color in objs )
				if( o )
					addColor( o );
			
			return this;
		}
		/*-------------------------------------------------------------------
		 * 	REMOVE ELEMENTS METHODS
		 *------------------------------------------------------------------*/
		/**
		 * [fluent] Supprime une couleur de cet palette.
		 * 
		 * @param	o	couleur à supprimer
		 * @return	une référence à cet objet <code>Palette</code>
		 */
		public function removeColor ( o : Color ) : Palette
		{
			if( containsColor( o ) )
			{
				_colors.splice( _colors.indexOf( o ), 1 );
			}
			return this;
		}
		/**
		 * [fluent] Supprime un ensemble de couleurs de cet palette.
		 * 
		 * @param	objs	couleurs à supprimer
		 * @return	une référence à cet objet <code>Palette</code>
		 */
		public function removeColors ( ... objs ) : Palette
		{
			for each( var o : Color in objs )
				if( o )
					removeColor( o );
			
			return this;
		}
		/**
		 * [fluent] Supprime un ensemble de couleurs de cet palette.
		 * 
		 * @param	objs	couleurs à supprimer
		 * @return	une référence à cet objet <code>Palette</code>
		 */
		public function removeColorsArray ( objs : Array ) : Palette
		{
			for each( var o : Color in objs )
				if( o )
					removeColor( o );
				
			return this;
		}
		/**
		 * Renvoie la représentation de l'objet sous forme de chaîne.
		 * 
		 * @return	la représentation de l'objet sous forme de chaîne.
		 */
		public function toString() : String 
		{
			return StringUtils.stringify(this);
		}
		/**
		 * Compare l'instance courante avec <code>o</code> et renvoie 
		 * <code>true</code> si les deux sont équivalentes.
		 * <p>
		 * Deux instances sont considérées comme égales si leurs nom et
		 * contenu sont égaux. 
		 * </p>
		 * 
		 * @param	o	instance à comparer
		 * @return	<code>true</code> si les deux instances sont équivalentes
		 */
		public function equals (o : *) : Boolean
		{
			if( o is Palette )
			{
				var p : Palette = o as Palette;
				if( _name != p.name )
					return false;
				if( _colors.length != p.colors.length )
					return false;
				
				return _colors.every( function ( c : Color, i : int, ... args ) : Boolean 
				{
					return c.equals( p.colors[i] );
				} );
			}
			return false;
		}
	}
}
