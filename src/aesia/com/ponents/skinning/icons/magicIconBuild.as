package aesia.com.ponents.skinning.icons 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.media.Sound;
	import flash.net.URLRequest;
	import flash.text.Font;

	/**
	 * Fonction de magie noire permettant de construire rapidement n'importe quel type
	 * d'objet <code>Icon</code> selon la valeur et le type de <code>o</code>.
	 * <p>
	 * <ul>
	 * <li>Si <code>o</code> est une <code>String</code>, la fonction renverra soit un objet
	 * <code>ExternalBitmapIcon</code> si la chaîne contient un des formats d'image en extension
	 * (&#42;.png, &#42;.jpg, &#42;.gif), soit un objet <code>SWFIcon</code> si l'extension de l'url est celle
	 * d'un fichier SWF (&#42;.swf).</li>
	 * <li>Si <code>o</code> est un objet <code>URLRequest</code>, la fonction renverra soit un objet
	 * <code>ExternalBitmapIcon</code> si l'url contient un des formats d'image en extension
	 * (&#42;.png, &#42;.jpg, &#42;.gif), soit un objet <code>SWFIcon</code> si l'extension de l'url est celle
	 * d'un fichier SWF (&#42;.swf).</li>
	 * <li>Si <code>o</code> est une classe : 
	 * <ul>
	 * <li>Si l'instance de la classe <code>o</code> est un objet <code>Bitmap</code> la fonction
	 * renvoie un objet <code>EmbeddedBitmapIcon</code>.</li>
	 * <li>Si l'instance de la classe <code>o</code> est un objet <code>BitmapData</code> la fonction
	 * renvoie un objet <code>BitmapIcon</code>.</li>
	 * <li>Si l'instance de la classe <code>o</code> est un objet <code>Font</code> la fonction
	 * renvoie un objet <code>FontIcon</code>.</li>
	 * <li>Si l'instance de la classe <code>o</code> est un objet <code>DisplayObject</code> la fonction
	 * renvoie un objet <code>DOIcon</code>.</li>
	 * <li>Si l'instance de la classe <code>o</code> est un objet <code>Icon</code> la fonction
	 * renvoie simplement une instance de la classe <code>o</code>.</li>
	 * </ul></li>
	 * <li>Si <code>o</code> est une instance de <code>BitmapData</code>, la fonction renvoie
	 * une instance de la classe <code>BitmapIcon</code>.</li>
	 * <li>Si <code>o</code> est une instance de <code>DisplayObject</code>, la fonction renvoie
	 * une instance de la classe <code>DOInstanceIcon</code>.</li>
	 * </ul>
	 * </p>
	 * <p>
	 * <strong>Note : </strong> Pour des questions de performances, les résultats des requêtes sont mis en cache afin que les
	 * requêtes ultérieures soit plus rapide.
	 * </p>
	 * 
	 * @author Cédric Néhémie
	 * @param	o	une chaîne, une url, une classe ou un objet graphique
	 * @return	un objet <code>Icon</code> correspondant au type de <code>o</code>
	 */
	public function magicIconBuild ( o : * ) : Icon
	{
		if( o == null )
			return null;
		
		if( !_dict[ o ] )
		{
			if( o is String )
			{
				var s : String = o as String;
				if( s.match( /(.png|.jpg|.gif)$/gi ) )
					_dict[o] = new ExternalBitmapIcon(new URLRequest(s));
				else if( s.match( /.swf$/gi ) )
					_dict[o] = new SWFIcon(new URLRequest(s));
			}
			else if( o is URLRequest )
			{
				var url : URLRequest = o as URLRequest;
				
				if( url.url.match( /(.png|.jpg|.gif)$/gi ) )
					_dict[o] = new ExternalBitmapIcon(url);
				else if( url.url.match( /.swf$/gi ) )
					_dict[o] = new SWFIcon(url);
			}
			else if( o is Class )
			{
				var c : Class = o as Class;	
				var b : *;
				
				try
				{
					b = new c();
				}
				catch( e : ArgumentError )
				{
					b = new c(1,1);
				}
				
				if( b is Bitmap )
				{
					( b as Bitmap ).bitmapData.dispose();
					_dict[o] = new EmbeddedBitmapIcon( c );	
				}
				else if( b is BitmapData )
					_dict[o] = new BitmapIcon( new Bitmap( b ) );	
				else if( b is Sound )
					return new DOIcon( LoadingIcon );
				else if( b is Font )
					_dict[o] = new FontIcon( o );
				else if( b is Icon )
					_dict[o] = b;
				else if( b is MovieClip )
					_dict[o] = new MovieClipIcon( c );
				else if( b is DisplayObject )
					_dict[o] = new DOIcon( c );
			}
			else if( o is BitmapData )
				_dict[o] = new BitmapIcon( new Bitmap( o ) );	
			else if( o is DisplayObject )
				return new DOInstanceIcon(o);
		}
		return ( _dict[ o ] as Icon ).clone();
	}
}
import flash.utils.Dictionary;

internal var _dict : Dictionary = new Dictionary();
