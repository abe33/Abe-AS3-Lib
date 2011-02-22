/**
 * @license
 */
package abe.com.ponents.core.edit 
{
	import abe.com.mon.utils.AllocatorInstance;

	import flash.display.DisplayObject;
	import flash.utils.getQualifiedClassName;
	/**
	 * La classe <code>EditorFactory</code> fournie un moyen simple
	 * d'enregistrer des objets ou des classes <code>Editor</code>
	 * pour l'édition de certains types de données. 
	 * <p>
	 * Il est possible d'associer soit des instances soit des classes
	 * avec la représentation sous forme de chaîne de caractères d'un
	 * type de données.
	 * </p>
	 * @author Cédric Néhémie
	 */
	public class EditorFactory 
	{
		/**
		 * Un objet contenant des instances d'objets <code>Editor</code>
		 * accessibles à l'aide d'une clé.
		 */
		public var _editors : Object;
		/**
		 * Un objet contenant des références à des classes <code>Editor</code>
		 * accessibles à l'aide d'une clé.
		 */
		public var _editorsClasses : Object;
		/**
		 * Constructeur de la classe <code>EditorFactory</code>.
		 */
		public function EditorFactory ()
		{
			_editors = {};			_editorsClasses = {};
		}
		/**
		 * Renvoie un objet <code>Editor</code> associé à la clé <code>s</code>
		 * au sein de cette instance de <code>EditorFactory</code>. Si aucune association
		 * n'existe, la fonction retourne la valeur <code>null</code>.
		 * 
		 * @param	s	clé d'accès à l'objet <code>Editor</code>
		 * @return	un objet <code>Editor</code> ou <code>null</code>
		 */
		public function get ( s : String = null ) : Editor
	    { 
			if( _editors.hasOwnProperty( s ) )
				return _editors[s] as Editor;
	    	
	    	if( _editorsClasses.hasOwnProperty( s ) )
	    		return AllocatorInstance.get( _editorsClasses[ s ] );
	    	
			return _editors["null"];
		}
	    /**
	     * Renvoie un objet <code>Editor</code> associé à la représentation
	     * sous forme de chaîne de la classe <code>c</code> telle que renvoyée
	     * par la fonction <code>getQualifiedClassName</code>.
	     * 
	     * @param	c	classe pour laquelle on souhaite récupérer un <code>Editor</code>
	     * @return	un objet <code>Editor</code> associé la classe
	     */
	    public function getForType( c : Class ) : Editor
	    {
	    	return get( getQualifiedClassName( c ) );
	    }
		
		/**
		 * Libère un objet <code>Editor</code> précedemment récupérer à l'aide des méthodes
		 * <code>get</code> et <code>getForType</code>.
		 * 
		 * @param	e	l'objet <code>Editor</code> à libérer
		 */
	    public function release( e : Editor ) : void
	    {
	    	if( e is DisplayObject &&  ( e as DisplayObject ).stage )
	    		( e as DisplayObject).parent.removeChild( e as DisplayObject );
	    	
	    	for( var i : String in _editors )
	    		if( _editors[i]== e )
	    			return;
	    			
	    	AllocatorInstance.release( e );
	    }
	    /**
	     * Enregistre une instance d'<code>Editor</code> en association
	     * avec la clé <code>s</code>.
	     * 
	     * @param	s	la clé d'association
	     * @param	o	l'objet <code>Editor</code> à associer
	     */
		public function register ( s : String, o : Editor ): void
		{
			_editors[s] = o;
		}
		/**
		 * Supprime l'association entre une instance et une clé actuellement 
		 * enregistrée pour la clé <code>s</code>.
		 * 
		 * @param	s	clé de l'association à supprimer
		 */
	    public function unregister( s : String ) : void
	    {
			delete _editors[s];
		}
		/**
		 * Enregistre une classe d'<code>Editor</code> en association
		 * avec la clé <code>s</code>.
		 * 
		 * @param	s	la clé d'association
	     * @param	c	la classe d'<code>Editor</code> à associer
		 */
		public function registerClass( s : String, c : Class ) : void
	    {
	    	_editorsClasses[ s ] = c;
	    }
	    /**
	     * Supprime l'association entre une classe et une clé actuellement 
		 * enregistrée pour la clé <code>s</code>.
		 * 
		 * @param	s	clé de l'association à supprimer
	     */
	    public function unregisterClass( s : String ) : void
	    {
			delete _editorsClasses[s];
		}
	}
}
