/**
 * @license
 */
package aesia.com.ponents.core
{
	import aesia.com.ponents.events.ComponentEvent;
	import aesia.com.mon.core.IDisplayObject;
	import aesia.com.mon.core.IDisplayObjectContainer;
	import aesia.com.mon.core.IInteractiveObject;
	import aesia.com.mon.core.Lockable;
	import aesia.com.mon.geom.Dimension;
	import aesia.com.ponents.core.edit.Editable;
	import aesia.com.ponents.core.focus.FocusGroup;
	import aesia.com.ponents.core.focus.Focusable;
	import aesia.com.ponents.events.ContainerEvent;
	import aesia.com.ponents.layouts.components.ComponentLayout;
	import aesia.com.ponents.layouts.components.NoLayout;

	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.IEventDispatcher;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * Évènement diffusé lors de l'ajout d'un enfant dans le composant.
	 *
	 * @eventType aesia.com.ponents.events.ContainerEvent.CHILD_ADD
	 */
	[Event(name="childAdd", type="aesia.com.ponents.events.ContainerEvent")]
	/**
	 * Évènement diffusé lors de la suppression d'un enfant du composant.
	 *
	 * @eventType aesia.com.ponents.events.ContainerEvent.CHILD_REMOVE
	 */	[Event(name="childRemove", type="aesia.com.ponents.events.ContainerEvent")]

	/**
	 * Implémentation standard de l'interface <code>Container</code>.
	 * <p>
	 * Pour créer un nouveau type de composant <code>Container</code> il suffit
	 * généralement d'étendre cette classe.
	 * </p>
	 *
	 * @author Cédric Néhémie
	 */
	public class AbstractContainer extends AbstractComponent implements Component,
																		IDisplayObject,
																		IInteractiveObject,
																		IDisplayObjectContainer,
																		Focusable,
																		FocusGroup,
																		Container,
																		Lockable,
																		IEventDispatcher
	{
		/**
		 * Un vecteur contenant la liste des objets <code>Component</code>
		 * contenu par ce <code>Container</code>.
		 *
		 * @default new Vector.<Component>()
		 */
		protected var _children : Vector.<Component>;
		/**
		 * Un objet <code>ComponentLayout</code> chargé de calculer la taille de préférence
		 * de ce composant et de mettre en forme les composants enfants.
		 *
		 * @default new NoLayout ( this )
		 */
		protected var _childrenLayout : ComponentLayout;
		/**
		 * Une valeur booléenne indiquant si les enfants de ce composant
		 * peuvent recevoir le focus.
		 *
		 * @default true
		 */
		protected var _allowChildrenFocus : Boolean;
		/**
		 * Une valeur booléenne indiquant si la transmission du focus
		 * clavier sort de ce composant lorsque l'on atteint un des enfants
		 * situés au début ou à la fin de la liste des enfants.
		 * <p>
		 * Lorsque <code>_allowFocusLoop</code> est à <code>true</code>
		 * le focus boucle au sein des enfants de ce composant.</p>
		 * <p>
		 * Lorsque <code>_allowFocusLoop</code> est à <code>false</code>
		 * le focus sort de ce composant pour aller vers le composant suivant
		 * ou précédent selon que la navigation du focus s'effectue dans le sens
		 * normal ou dans le sens inverse.
		 * </p>
		 *
		 * @default false
		 */
		protected var _allowFocusLoop : Boolean;
		/**
		 * Une valeur booléenne indiquant si les contextes clavier des enfants
		 * de ce composant doivent être pris en compte lors de la création du
		 * contexte clavier global.
		 *
		 * @default true
		 */
		protected var _childrenContextEnabled : Boolean;
		/**
		 * Une valeur booléenne indiquant si la mise en page des enfants de ce
		 * composant est vérrouillée lors des phases de re-dessin de ce composant.
		 *
		 * @default false
		 */
		protected var _lockedLayout : Boolean;
		/**
		 * Une valeur booléenne indiquant si ce composant est à considérer comme
		 * la racine de validation systématiquement ou non.
		 * <p>
		 * Lorsque cette valeur est à <code>true</code> l'invalidation de ce composant
		 * ne se propagera jamais à ses parents.
		 * </p>
		 *
		 * @default false
		 */
		protected var _alwaysValidateRoot : Boolean;

		/**
		 * Constructeur de la classe <code>AbstractContainer</code>
		 */
		public function AbstractContainer ()
		{
			super();
			_children = new Vector.<Component>();
			_childrenLayout = _childrenLayout ? _childrenLayout : new NoLayout ( this );
			_childrenContainer.mouseChildren = true;
			_childrenContainer.mouseEnabled = true;
			_childrenContextEnabled = true;
			_allowOver = false;
			_allowPressed = false;
			_allowChildrenFocus = true;
			_allowFocusLoop = false;
			buttonMode = false;
			invalidatePreferredSizeCache();
		}

/*-----------------------------------------------------------------
 * 	GETTERS / SETTERS
 *----------------------------------------------------------------*/
 		/**
 		 * Une copie du vecteur des enfants de ce composant.
 		 */
		public function get children () : Vector.<Component> { return _children.concat(); }
		/**
		 * Un entier représentant le nombre de composants contenu dans ce <code>Container</code>.
		 */
		public function get childrenCount () : int { return _children.length; }

		/**
		 * Une référence vers le premier enfant de ce composant.
		 */
		public function get firstChild() : Component { return hasChildren ? _children[0] : null; };
		/**
		 * Une référence vers le dernier enfant de ce composant.
		 */
		public function get lastChild() : Component { return hasChildren ? _children[_children.length-1] : null; }
		/**
		 * Une valeur booléenne indiquant si ce composant possède actuellement des sous composants.
		 */
		public function get hasChildren() : Boolean { return _children.length > 0; }

		/**
		 * Une référence vers un objet <code>ComponentLayout</code> chargé de la mise en page
		 * des sous composants de ce <code>Container</code> ainsi que du calcul de sa taille
		 * préférentielle.
		 */
		public function get childrenLayout () : ComponentLayout	{ return _childrenLayout; }
		public function set childrenLayout (cl : ComponentLayout) : void
		{
			_childrenLayout = cl;
			_childrenLayout.container = this;
			fireChangeEvent();
			firePropertyEvent("childrenLayout", _childrenLayout );

			if( hasChildren )
				invalidatePreferredSizeCache();
		}
		/**
		 * Une valeur booléenne indiquant si les enfants de ce composant
		 * peuvent recevoir le focus.
		 */
		public function get allowChildrenFocus () : Boolean { return _allowChildrenFocus; }
		public function set allowChildrenFocus (allowChildrenFocus : Boolean) : void
		{
			_allowChildrenFocus = allowChildrenFocus;
			firePropertyEvent("allowChildrenFocus", _allowChildrenFocus );
			fireChangeEvent();
		}
		/**
		 * Une valeur booléenne indiquant si la transmission du focus
		 * clavier sort de ce composant lorsque l'on atteint un des enfants
		 * situés au début ou à la fin de la liste des enfants.
		 * <p>
		 * Lorsque <code>allowFocusLoop</code> est à <code>true</code>
		 * le focus boucle au sein des enfants de ce composant.</p>
		 * <p>
		 * Lorsque <code>allowFocusLoop</code> est à <code>false</code>
		 * le focus sort de ce composant pour aller vers le composant suivant
		 * ou précédent selon que la navigation du focus s'effectue dans le sens
		 * normal ou dans le sens inverse.
		 * </p>
		 */
		public function get allowFocusLoopHole () : Boolean { return _allowFocusLoop; }
		public function set allowFocusLoopHole (allowFocusLoopHole : Boolean) : void
		{
			_allowFocusLoop = allowFocusLoopHole;
			firePropertyEvent("allowFocusLoopHole", _allowFocusLoop );
			fireChangeEvent();
		}
		/**
		 * Une valeur booléenne indiquant si ce composant est à considérer comme
		 * la racine de validation systématiquement ou non.
		 * <p>
		 * Lorsque cette valeur est à <code>true</code> l'invalidation de ce composant
		 * ne se propagera jamais à ses parents.
		 * </p>
		 */
		public function get alwaysValidateRoot () : Boolean { return _alwaysValidateRoot; }
		public function set alwaysValidateRoot (alwaysValidateRoot : Boolean) : void
		{
			_alwaysValidateRoot = alwaysValidateRoot;
		}
		/**
		 * Une valeur booléenne indiquant si les contextes clavier des enfants
		 * de ce composant doivent être pris en compte lors de la création du
		 * contexte clavier global.
		 */
		public function get childrenContextEnabled () : Boolean { return _childrenContextEnabled; }
		public function set childrenContextEnabled (childrenContextEnabled : Boolean) : void
		{
			_childrenContextEnabled = childrenContextEnabled;
			firePropertyEvent("childrenContextEnabled", _childrenContextEnabled );
			fireChangeEvent();
		}

		/**
		 * Une valeur booléenne indiquant si la mise en page des enfants de ce
		 * composant est vérrouillée lors des phases de re-dessin de ce composant.
		 */
		public function get isLocked () : Boolean { return _lockedLayout; }

		/**
		 * @inheritDoc
		 */
		override public function set enabled (b : Boolean) : void
		{
			super.enabled = b;
			for each ( var c : Component in _children )
				c.enabled = b;
		}
		/**
		 * @inheritDoc
		 */
		override public function get maxContentScrollV () : Number
		{
			_childrenLayout.container = this;
			return _childrenContainer.scrollRect != null ?
					_childrenLayout.preferredSize.height - ( _childrenContainer.scrollRect.height - _style.insets.vertical ) :
					0;
		}
		/**
		 * @inheritDoc
		 */
		override public function get maxContentScrollH () : Number
		{
			_childrenLayout.container = this;
			return _childrenContainer.scrollRect != null ?
					_childrenLayout.preferredSize.width - ( _childrenContainer.scrollRect.width - _style.insets.horizontal ) : 0;
		}

		/**
		 * @inheritDoc
		 */
		override public function get isMouseOver () : Boolean
		{
			return super.isMouseOver || _children.some( childrenMouseOver );
		}
		/**
		 * @inheritDoc
		 */
		override public function set interactive (interactive : Boolean) : void
		{
			super.interactive = interactive;

			for each ( var c : Component in _children )
				c.interactive = _interactive;
		}

/*-----------------------------------------------------------------
 *  CHILDREN HANDLING
 *----------------------------------------------------------------*/
		/**
		 * Renvoie <code>true</code> si la souris est au dessus du composant <code>c</code>,
		 * autrement la fonction renvoie <code>false</code>.
		 *
		 * @param	c		le composant à tester
		 * @param	args	non utilisé
		 * @return	<code>true</code> si la souris est au dessus du composant <code>c</code>,
		 * 			autrement la fonction renvoie <code>false</code>
		 */
		protected function childrenMouseOver (c : Component, ...args) : Boolean
		{
			return c.isMouseOver;
		}
		/**
		 * Renvoie <code>true</code> si le composant <code>c</code> est actuellement
		 * un enfant de ce <code>Container</code>.
		 *
		 * @param	c	le composant dont on souhaite savoir si il est un enfant
		 * 				de ce <code>Container</code>
		 * @return	<code>true</code> si le composant <code>c</code> est actuellement
		 * 			un enfant de ce <code>Container</code>
		 */
		public function containsComponent ( c : Component ) : Boolean
		{
			return _children.indexOf( c ) != -1;
		}
		/**
		 * Renvoie l'index du composant <code>c</code> au sein du vecteur des enfants
		 * de ce <code>Container</code>. Si le composant n'est pas un enfant de ce composant
		 * la fonction renvoie <code>-1</code>.
		 *
		 * @param	c	le composant dont on souhaite connaitre l'index
		 * @return	l'index du composant <code>c</code> au sein du vecteur des enfants
		 * 			de ce <code>Container</code> ou <code>-1</code> si celui-ci n'est
		 * 			pas un enfant de ce composant
		 */
		public function getComponentIndex ( c : Component) : int
		{
			return _children.indexOf( c );
		}
		/**
		 * Ajoute le composant <code>c</code> comme enfant de ce <code>Container</code>.
		 * <p>
		 * Lors de l'ajout d'un composant dans ce <code>Container</code>, le composant
		 * ajouté voit ses propriétés <code>focusParent</code> et <code>interactive</code>
		 * modifiées en fonction de l'état de ce <code>Container</code>.
		 * </p>
		 * <p>
		 * <strong>Note : </strong> l'ajout d'un enfant dans ce composant conduit
		 * à la diffusion d'un évènement <code>ContainerEvent.CHILD_ADD</code>.
		 * </p>
		 * @param	c	le composant à ajouter à ce <code>Container</code>
		 */
		public function addComponent (c : Component) : void
		{
			if( c && !containsComponent( c ) )
			{
				_children.push( c );
				_childrenContainer.addChild( c as DisplayObject );
				setupChildren(c);
				invalidatePreferredSizeCache();

				dispatchEvent( new ContainerEvent( ContainerEvent.CHILD_ADD, c ) );
			}
		}
		/**
		 * Ajoute le composant <code>c</code> comme enfant de ce <code>Container</code>
		 * à l'index <code>id</code>.
		 * <p>
		 * Si l'index pour l'ajout de ce composant se situe au delà des limites de
		 * ce <code>Container</code> le composant <code>c</code> est ajouté à la fin de la liste
		 * des enfants de ce composant.
		 * </p>
		 * <p>
		 * Lors de l'ajout d'un composant dans ce <code>Container</code>, le composant
		 * ajouté voit ses propriétés <code>focusParent</code> et <code>interactive</code>
		 * modifiées en fonction de l'état de ce <code>Container</code>.
		 * </p>
		 * <p>
		 * <strong>Note : </strong> l'ajout d'un enfant dans ce composant conduit
		 * à la diffusion d'un évènement <code>ContainerEvent.CHILD_ADD</code>.
		 * </p>
		 * @param	c	le composant à ajouter à ce <code>Container</code>
		 * @param	id	l'index auquel ajouté le composant
		 */
		public function addComponentAt (c : Component, id : uint ) : void
		{
			if( c && !containsComponent( c ) )
			{
				if( id < _children.length )
					_children.splice( id, 0, c );
				else
					_children.push( c );

				if( id < _childrenContainer.numChildren )
					_childrenContainer.addChildAt( c as DisplayObject, id);
				else
					_childrenContainer.addChild( c as DisplayObject );

				setupChildren(c);
				invalidatePreferredSizeCache();

				dispatchEvent( new ContainerEvent( ContainerEvent.CHILD_ADD, c ) );
			}
		}
		/**
		 * Ajoute le composant <code>c</code> à l'index précédent le composant <code>before</code>
		 * dans la liste des enfants de ce composant.
		 * <p>
		 * <strong>Note : </strong> l'ajout d'un enfant dans ce composant conduit
		 * à la diffusion d'un évènement <code>ContainerEvent.CHILD_ADD</code>.
		 * </p>
		 *
		 * @param	c		le composant à ajouter à ce <code>Container</code>
		 * @param	before	le composant avant lequel ajouter le composant <code>c</code>
		 */
		public function addComponentBefore ( c : Component, before : Component ) : void
		{
			if( containsComponent( before ) )
				addComponentAt( c , _children.indexOf( before )  );
		}
		/**
		 * Ajoute le composant <code>c</code> à l'index suivant le composant <code>after</code>
		 * dans la liste des enfants de ce composant.
		 * <p>
		 * <strong>Note : </strong> l'ajout d'un enfant dans ce composant conduit
		 * à la diffusion d'un évènement <code>ContainerEvent.CHILD_ADD</code>.
		 * </p>
		 *
		 * @param	c		le composant à ajouter à ce <code>Container</code>
		 * @param	after	le composant après lequel ajouter le composant <code>c</code>
		 */
		public function addComponentAfter ( c : Component, after : Component ) : void
		{
			if( containsComponent( after ) )
				addComponentAt( c , _children.indexOf( after ) + 1  );
		}
		/**
		 * Ajoute un nombre indéterminé de composants transmis en arguments
		 * à ce <code>Container</code>.
		 * <p>
		 * <strong>Note : </strong> l'ajout d'un enfant dans ce composant conduit
		 * à la diffusion d'un évènement <code>ContainerEvent.CHILD_ADD</code> pour
		 * chaque composants ajoutés.
		 * </p>
		 *
		 * @param	args	un nombre indéterminé de composants à ajouter à
		 * 					ce <code>Container</code>
		 */
		public function addComponents (...args : *) : void
		{
			for each (var c : Component in args )
				addComponent( c );
		}
		/**
		 * Supprime le composant <code>c</code> des enfants de ce <code>Container</code>.
		 * <p>
		 * <strong>Note : </strong> la suppression d'un enfant dans ce composant conduit
		 * à la diffusion d'un évènement <code>ContainerEvent.CHILD_REMOVE</code>.
		 * </p>
		 * @param	c	le composant à supprimer des enfants de ce <code>Container</code>
		 */
		public function removeComponent (c : Component) : void
		{
			if( c && containsComponent(c) )
			{
				_children.splice(_children.indexOf( c ), 1);

				if( _childrenContainer.contains( c as DisplayObject ) )
					_childrenContainer.removeChild( c as DisplayObject );

				teardownChildren(c);
				invalidatePreferredSizeCache();

				dispatchEvent( new ContainerEvent( ContainerEvent.CHILD_REMOVE, c ) );
			}
		}
		/**
		 * Supprime le composant situé à l'index <code>i</code> dans la liste des enfants
		 * de ce <code>Container</code>.
		 * <p>
		 * <strong>Note : </strong> la suppression d'un enfant dans ce composant conduit
		 * à la diffusion d'un évènement <code>ContainerEvent.CHILD_REMOVE</code>.
		 * </p>
		 * @param	i	index du composant à supprimer des enfants de ce <code>Container</code>
		 */
		public function removeComponentAt ( i:uint ) : void
		{
			if( i < childrenCount )
			{
				var c : Component = _children[i];
				removeComponent(c);
			}
		}
		/**
		 * Supprime tout les composants enfant de ce <code>Container</code>.
		 */
		public function removeAllComponents () : void
		{
			var l : Number = childrenCount;
			while( l--)
			{
				removeComponent( _children[l] );
			}
		}
		/**
		 * Renvoie le composant situé à l'index <code>index</code> dans la liste
		 * des enfants de ce <code>Container</code> ou <code>null</code> si l'index
		 * correspondant est en dehors des limites pour ce <code>Container</code>.
		 *
		 * @param	index	l'index pour lequel on souhaite récupérer le composant
		 * @return	le composant situé à l'index <code>index</code> dans la liste
		 * 			des enfants de ce <code>Container</code> ou <code>null</code>
		 * 			si l'index correspondant est en dehors des limites pour ce
		 * 			<code>Container</code>
		 */
		public function getComponentAt ( index : uint ) : Component
		{
			if( index < _children.length )
				return _children[ index ];
			else
				return null;
		}
		/**
		 * Renvoie l'enfant de ce <code>Container</code> dont l'identifiant est <code>id</code>
		 * ou <code>null</code> si aucun composant ne possède un tel identifiant dans la liste
		 * des enfants de ce <code>Container</code>.
		 *
		 * @param	id	identifiant du composant que l'on souhaite récupérer
		 * @return	l'enfant de ce <code>Container</code> dont l'identifiant est <code>id</code>
		 * 			ou <code>null</code> si aucun composant ne possède un tel identifiant
		 * 			dans la liste des enfants de ce <code>Container</code>
		 */
		public function getComponentByID ( id : String ) : Component
		{
			for each ( var c : Component in _children )
				if( c.id == id )
					return c;

			return null;
		}
		/**
		 * Renvoie l'enfant de ce <code>Container</code> dont le nom est <code>name</code>
		 * ou <code>null</code> si aucun composant ne possède un tel nom dans la liste
		 * des enfants de ce <code>Container</code>.
		 *
		 * @param	name	nom du composant que l'on souhaite récupérer
		 * @return	l'enfant de ce <code>Container</code> dont le nom est <code>name</code>
		 * 			ou <code>null</code> si aucun composant ne possède un tel nom
		 * 			dans la liste des enfants de ce <code>Container</code>
		 */
		public function getComponentByName ( name : String ) : Component
		{
			for each ( var c : Component in _children )
				if( c.name == name )
					return c;

			return null;
		}
		/**
		 * Revoie le premier composant situé aux coordonnées transmises dans <code>pt</code>
		 * ou <code>null</code> si aucun composant ne se situe à ces coordonnées.
		 *
		 * @param	pt
		 * @return	le premier composant situé aux coordonnées transmises dans <code>pt</code>
		 * 			ou <code>null</code> si aucun composant ne se situe à ces coordonnées
		 */
		public function getComponentUnderPoint ( pt : Point ) : Component
		{
			for each ( var c : Component in _children )
				if( c.hitTestPoint( pt.x, pt.y ) )
					return c;

			return null;
		}
		/**
		 * Renvoie <code>true</code> si le composant <code>c</code> est un
		 * descendant de ce <code>Container</code> autrement la fonction
		 * renvoie <code>false</code>.
		 * <p>
		 * Un composant est considéré comme étant un descendant d'un <code>Container</code>
		 * si il s'agit d'un de ses enfants direct ou s'il est l'enfant d'un de ces enfants.
		 * </p>
		 *
		 * @param	c	le composant dont on souhaite savoir si il est un descendant
		 * 				de ce <code>Container</code>
		 * @return	<code>true</code> si le composant <code>c</code> est un
		 * 			descendant de ce <code>Container</code> autrement la fonction
		 * 			renvoie <code>false</code>
		 */
		public function isDescendant ( c : Component ) : Boolean
		{
			for each( var child : Component in _children )
			{
				if( c == child )
					return true;
				else if( child is Container )
				{
					var b : Boolean = ( child as Container ).isDescendant( c );

					if( b ) return b;
				}
			}
			return false;
		}
		/**
		 * Renvoie <code>true</code> si le <code>DisplayObject o</code> est un
		 * descendant dans la chaîne graphique de ce composant.
		 *
		 * @param	o	le <code>DisplayObject</code> dont souhaite savoir s'il
		 *				fait partie de la chaîne graphique de ce composant
		 * @return	<code>true</code> si le <code>DisplayObject o</code> est un
		 * 			descendant dans la chaîne graphique de ce composant
		 */
		public function isDisplayObjectDescendant ( o : DisplayObject ) : Boolean
		{
			if( !o )
				return false;

			var p : DisplayObject = o;

			do {
				if( !p.parent )
					break;

				if( p == this )
					return true;

				p = p.parent;
			}
			while( p );

			return false;
		}
		/**
		 * Repositionne le composant <code>c</code> à l'index <code>index</code>
		 * au sein de la liste des enfants de ce <code>Container</code>.
		 *
		 * @param	c		le composant cible
		 * @param	index	le nouvel index pour ce composant
		 */
		public function setComponentIndex ( c : Component, index : uint ) : void
		{
			if( containsComponent( c ) )
			{
				removeComponent( c );
				addComponentAt( c, index );
			}
		}
		/**
		 * Change l'index dans la <code>Display List</code> pour le composant <code>c</code>
		 * sans toucher à sa position dans la liste des enfants de ce <code>Container</code>.
		 *
		 * @param	c		le composant cible
		 * @param	index	le nouvel index graphique pour ce composant
		 */
		public function setComponentDisplayIndex ( c : Component, index : uint ) : void
		{
			if( containsComponent( c ) && index < _childrenContainer.numChildren )
				_childrenContainer.setChildIndex( c as DisplayObject , index );
		}

		/**
		 * Initialise les propriétés d'un composant nouvellement ajouté dans ce <code>Container</code>.
		 *
		 * @param	c	le composant à initialiser
		 */
		protected function setupChildren ( c : Component ) : void
		{
			c.focusParent = this;
			c.interactive = _interactive;
		}
		/**
		 * Remet à zéro les propriétés d'un composant nouvellement supprimé de ce <code>Container</code>.
		 *
		 * @param	c	le composant à remettre à zéro
		 */
		protected function teardownChildren ( c : Component ) : void
		{
			c.focusParent = null;
		}

/*-----------------------------------------------------------------
 * 	REPAINT METHODS
 *----------------------------------------------------------------*/
		/**
		 * @inheritDoc
		 */
		override public function isValidateRoot () : Boolean
		{
			return _alwaysValidateRoot || super.isValidateRoot();
		}
		/**
		 * @inheritDoc
		 */
		override public function repaint () : void
		{
			var size : Dimension = calculateComponentSize();

			_childrenLayout.container = this;
			if( !_lockedLayout )
				_childrenLayout.layout( size, _style.insets );

			for each (var c : Component in _children )
				c.repaint();

			_repaint(size);
			_childrenContainer.filters=[];
		}
		/**
		 * @inheritDoc
		 */
		override public function invalidatePreferredSizeCache () : void
		{
			_childrenLayout.container = this;
			_preferredSizeCache = _childrenLayout.preferredSize.grow( _style.insets.horizontal, _style.insets.vertical );
			super.invalidatePreferredSizeCache();
		}
/*-----------------------------------------------------------------
 * 	LOCKABLE METHODS
 *----------------------------------------------------------------*/
		/**
		 * Vérrouille la mise en page des enfants de ce composant pendant
		 * les phases de redessin.
		 */
		public function lock () : void
		{
			_lockedLayout = true;
		}
		/**
		 * Dévérrouille la mise en page des enfants de ce composant pendant
		 * les phases de redessin.
		 */
		public function unlock () : void
		{
			_lockedLayout = false;
		}
/*-----------------------------------------------------------------
 * 	FOCUSABLE METHODS
 *----------------------------------------------------------------*/
		/**
		 * Place le focus clavier sur le premier enfant de ce <code>Container</code>
		 * si celui-ci à des enfants.
		 */
		public function focusFirstChild () : void
		{
			if( hasChildren )
			{
				var l : uint = childrenCount;
				for( var i : int = 0; i<l; i++ )
				{
					var c : Component = _children[i];
					if( c.enabled )
					{
						c.grabFocus();
						return;
					}
				}
				focusNext();
			}
		}
		/**
		 * Place le focus clavier sur le dernier enfant de ce <code>Container</code>
		 * si celui-ci à des enfants.
		 */
		public function focusLastChild () : void
		{
			if( hasChildren )
			{
				var l : uint = childrenCount;
				while( l-- )
				{
					var c : Component = _children[l];
					if( c.enabled )
					{
						c.grabFocus();
						return;
					}
				}
				focusPrevious();
			}
		}
		/**
		 * Place le focus clavier sur le prochain objet <code>Focusable</code>
		 * dans la liste des enfants de ce <code>Container</code>.
		 * <p>
		 * Si il n'y a pas d'autre enfant après cet objet et que la propriété
		 * <code>allowFocusLoop</code> est à <code>true</code> le focus sera
		 * placé sur le premier composant de ce <code>Container</code>, autrement
		 * la méthode <code>focusNext</code> sera appelée.
		 * </p>
		 * @param	child	le composant ayant actuellement le focus et qui servira
		 * 					à déterminer le prochain objet à recevoir le focus
		 */
		public function focusNextChild (child : Focusable) : void
		{
			var b : Boolean = false;
			var c : Component;
			if( child is Editable && (child as Editable).isEditing )
			{
				(child as Editable).confirmEdit();
				b = true;
			}

			var index : Number = _children.indexOf( child );
			if( index+1 < _children.length )
			{
				c = _children[ index + 1 ];
				c.grabFocus();

				ensureRectIsVisible( new Rectangle( c.x, c.y, c.width, c.height ) );

				if( c is Editable && b )
					(c as Editable).startEdit();
			}
			else if( b || _allowFocusLoop )
			{
				c = _children[ 0 ];
				c.grabFocus();

				ensureRectIsVisible( new Rectangle( c.x, c.y, c.width, c.height ) );

				if( c is Editable )
					(c as Editable).startEdit();
			}
			else
				focusNext();
		}
		/**
		 * Place le focus clavier sur le précédent objet <code>Focusable</code>
		 * dans la liste des enfants de ce <code>Container</code>.
		 * <p>
		 * Si il n'y a pas d'autre enfant avant cet objet et que la propriété
		 * <code>allowFocusLoop</code> est à <code>true</code> le focus sera
		 * placé sur le dernier composant de ce <code>Container</code>, autrement
		 * la méthode <code>focusPrevious</code> sera appelée.
		 * </p>
		 * @param	child	le composant ayant actuellement le focus et qui servira
		 * 					à déterminer le précédent objet à recevoir le focus
		 */
		public function focusPreviousChild (child : Focusable) : void
		{
			var b : Boolean = false;
			var c : Component;
			if( child is Editable && (child as Editable).isEditing )
			{
				(child as Editable).confirmEdit();
				b = true;
			}

			var index : Number = _children.indexOf( child );

			if( index == -1 )
				index = _children.length;

			if( index > 0 )
			{
				c = _children[ index - 1 ];
				c.grabFocus();

				ensureRectIsVisible( new Rectangle( c.x, c.y, c.width, c.height ) );

				if( c is Editable && b )
					(c as Editable).startEdit();
			}
			else if( b || _allowFocusLoop )
			{
				c = _children[ _children.length - 1 ];
				c.grabFocus();

				ensureRectIsVisible( new Rectangle( c.x, c.y, c.width, c.height ) );

				if( c is Editable )
					(c as Editable).startEdit();
			}
			else
				focusPrevious();
		}
/*-----------------------------------------------------------------
 * 	EVENT HANDLERS OVERRIDE
 *----------------------------------------------------------------*/
		/**
		 * @inheritDoc
		 */
		override public function keyFocusChange ( e : FocusEvent ) : void
		{
			// on laisse les enfants gérés le focus si il y en a
			// et que le container autorise le focus des enfants
			if( !_allowChildrenFocus || _children.length == 0  )
				super.keyFocusChange(e);
		}
		/**
		 * @inheritDoc
		 */
		override public function focusIn (e : FocusEvent) : void
		{
			super.focusIn( e );

			if( _allowChildrenFocus &&
			  	( 	e.target == this ||
			    	!isDisplayObjectDescendant( e.target as DisplayObject ) ) )
			{
				e.stopPropagation();

				if( e.target == this )
				{
					if( e.shiftKey )
						focusLastChild();
					else
						focusFirstChild();
				}
			}
		}
		/**
		 * @inheritDoc
		 */
		override public function addedToStage (e : Event) : void
		{
			for each( var child : AbstractComponent in _children )
				if( child )
					child.addedToStage(e);
			super.addedToStage( e );
		}
	}
}
