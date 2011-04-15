/**
 * @license
 */
package abe.com.ponents.buttons
{
	import abe.com.mands.Command;
	import abe.com.mands.ProxyCommand;
	import abe.com.mon.core.Cancelable;
	import abe.com.mon.core.IDisplayObject;
	import abe.com.mon.core.IDisplayObjectContainer;
	import abe.com.mon.core.IInteractiveObject;
	import abe.com.mon.core.ITextField;
	import abe.com.mon.core.LayeredSprite;
	import abe.com.mon.geom.Dimension;
	import abe.com.mon.utils.KeyStroke;
	import abe.com.mon.utils.Keys;
	import abe.com.ponents.actions.Action;
	import abe.com.ponents.core.Component;
	import abe.com.ponents.core.SimpleDOContainer;
	import abe.com.ponents.core.focus.Focusable;
	import abe.com.ponents.events.ComponentEvent;
	import abe.com.ponents.layouts.display.DOInlineLayout;
	import abe.com.ponents.skinning.icons.Icon;
	import abe.com.ponents.text.TextFieldImpl;
	import abe.com.ponents.utils.KeyboardControllerInstance;

	import org.osflash.signals.Signal;

	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;

	/**
	 * Détermine si le champ de texte utilisé au sein du composant utilise des
	 * polices embarquées (<code>true</code>) ou non (<code>false</code>).
	 * <p>
	 * <strong>Note : </strong> La modification ou la récupération du style pour une instance de composant peut
	 * se faire des manières suivantes :
	 * </p>
	 * <ul>
	 * <li><pre>var embedFonts : Boolean = monComposant.style.embedFonts;</pre>
	 * Récupère la valeur du style dans l'état courant du composant.</li>
	 * <li><pre>monComposant.style.embedFonts = true;</pre>
	 * Modifie la valeur du style pour ce composant et pour tout ses états.
	 * Cette opération est équivalente à l'usage de la méthode
	 * <code>setForAllStates</code> de la classe <code>ComponentStyle</code>.</li>
	 * </ul>
	 */
	[Style(name="embedFonts",type="Boolean",enumeration="true,false")]

	[Skinable(skin="Button")]
	[Skin(define="ToolBar_Button",
		  inherit="Button",
		  state__0_1_4_5__foreground="skin.noDecoration",
		  state__0_1_4_5__background="skin.emptyDecoration",		  state__0_1_4_5__outerFilters="[]"
	)]
	[Skin(define="Button",
		  inherit="DefaultGradientComponent",
		  preview="abe.com.ponents.buttons::AbstractButton.defaultButtonPreview",
		  state__all__insets="new cutils::Insets(3)",		  state__all__corners="new cutils::Corners(4)",

		  custom_embedFonts="false"
	)]
	/**
	 * La classe <code>AbstractButton</code> est la classe de base pour toutes les autres classes de boutons du set de composants
	 * (<code>CheckBox</code>, <code>RadioButton</code>, <code>MenuItem</code>, <code>DefaultListCell</code>, etc...).
	 * <p>
	 * Un bouton de base peut afficher un texte et un icône alternativement ou simultanément. L'affichage du texte ou de l'icône
	 * est déterminé à l'aide de la propriété <code>buttonDisplayMode</code> de la classe <code>AbstractButton</code>.
	 * </p>
	 * <p>
	 * De plus, un bouton peut posséder un objet <code>Action</code>. Une action étant une <code>Command</code> destiné à être
	 * partagée au sein d'un interface graphique et déclenché par un ou plusieur des éléments la composant (bouton, menu,
	 * raccourci clavier, menu contextuel, etc...). Dans le cas ou une action est définie pour un composant dérivé de <code>AbstractButton</code>
	 * le texte et l'icône de ce composant seront récupérés depuis l'objet <code>Action</code>.
	 * </p>
	 * <p>
	 * La classe <code>AbstractButton</code> offre un support spécifique dans le cas d'actions réellement asynchrones. Grâce à la propriété
	 * <code>disableButtonDuringActionExecution</code> il est possible de désactiver le bouton du début de l'exécution de la commande
	 * jusqu'à la diffusion d'un des évènements de fin d'exécution.
	 * </p>
	 *
	 *  @author Cédric Néhémie
	 *  @see abe.com.ponents.actions.Action
	 */
	public class AbstractButton extends SimpleDOContainer implements IDisplayObject,
																	 IInteractiveObject,
																	 IDisplayObjectContainer,
																	 Component,
																	 Focusable,
															 		 LayeredSprite,
															 		 IEventDispatcher
	{
		/*FDT_IGNORE*/ FEATURES::BUILDER { /*FDT_IGNORE*/
		/**
		 * [conditional-compile] Renvoie un objet <code>Button</code> servant de prévisualisation
		 * au style <code>Button</code> dans l'éditeur de styles de composant.
		 * <p>
		 * <strong>Note :</strong> Cette fonction est soumise à la constante
		 * <a href="../../../../Conditional-Compilation.html#BUILDER">FEATURES::BUILDER</a>
		 * dans le cadre de la <a href="../../../../Conditional-Compilation.html">compilation conditionnelle</a>.
		 * Veillez donc à conditionner l'usage de cette fonctionnalité à l'usage de la constante de compilation associée.
		 * </p>
		 * @see ../../../../Conditional-Compilation.html#BUILDER Constante FEATURES::BUILDER
		 * @return	un objet <code>Button</code> servant de prévisualisation au style <code>Button</code>
		 * 			dans l'éditeur de styles de composant
		 */
		static public function defaultButtonPreview () : Component
		{
			return new Button();
		}
		/*FDT_IGNORE*/ } /*FDT_IGNORE*/

		/**
		 * Si <code>true</code> le bouton devient désactivé lorsque son action entame son exécution
		 * suite à un click sur le bouton. Il ne sera réactivé que lorsque son action diffusera un
		 * des évènements de fin d'exécution de commandes (<code>COMMAND_END</code>, <code>COMMAND_FAIL</code>,
		 * <code>COMMAND_CANCEL</code>).
		 *
		 * @default false
		 */
		public var disableButtonDuringActionExecution : Boolean = false;
		/**
		 * L'objet <code>Action</code> associé à cette instance.
		 *
		 * @default null
		 */
		protected var _action : Action;
		/**
		 * Un objet utilisé pour déterminer le texte affiché par ce bouton.
		 *
		 * @default "Button"
		 */
		protected var _label : *;
		/**
		 * Une propriété servant de sauvegarde au label de ce composant dans le cas
		 * où son mode d'affichage désactive l'affichage du texte.
		 */
		protected var _safeLabel : *;
		/**
		 * Une référence vers un objet <code>Icon</code> utilisé en tant qu'icône pour
		 * ce composant.
		 *
		 * @default null
		 */
		protected var _icon : Icon;
		/**
		 * Une propriété servant de sauvegarde à l'icône de ce composant dans le cas
		 * où son mode d'affichage désactive l'affichage de l'icône.
		 */
		protected var _safeIcon : Icon;
		/**
		 * Une référence vers l'objet <code>ITextField</code> utilisé par ce composant
		 * pour l'affichage du texte.
		 *
		 * @default new TextFieldImpl()
		 */
		protected var _labelTextField : ITextField;
		/**
		 * Une valeur booléenne indiquant si l'objet <code>ITextField</code> doit
		 * être enlevé de la structure graphique dans le cas où le label de ce composant
		 * est une chaîne vide.
		 *
		 * @default	true
		 */
		protected var _removeLabelOnEmptyString : Boolean;
		/**
		 * Un entier indiquant le mode d'affichage actuel de ce composant.
		 * <p>
		 * Les valeurs possible pour cette propriété sont recensées dans la
		 * classe <code>ButtonDisplayModes</code>
		 * </p>
		 *
		 * @default ButtonDisplayModes.TEXT_AND_ICON
		 * @see	ButtonDisplayModes
		 * @see #checkDisplayMode()
		 */
		protected var _buttonDisplayMode : uint;
		/**
		 * Un entier indiquant l'index auquel l'icône doit être inséré dans la structure graphique.
		 *
		 * @default 1
		 */
		protected var _iconIndex : int;
		/**
		 * Un entier indiquant l'index auquel l'objet <code>ITextField</code> doit être inséré
		 * dans la structure graphique.
		 *
		 * @default 0
		 */		protected var _labelIndex : int;

		/**
		 * Constructeur de la classe <code>AbstractButton</code>.
		 * <p>
		 * Si le premier paramètre transmi au constructeur est un objet <code>Action</code>
		 * le label et l'icône de ce bouton seront déterminé à l'aide des données contenues
		 * dans l'objet <code>Action</code>. Auquel cas le second paramètre sera tout simplement
		 * ignoré.
		 * </p>
		 * <p>Si le premier paramètre transmi est une <code>String</code>, celle-ci sera utilisé
		 * comme valeur pour le label de ce bouton, et le second paramètre ne sera pas ignoré.
		 * </p>
		 *
		 * @param	actionOrLabel	un objet <code>Action</code> ou une chaîne de caractère
		 * @param	icon			un objet <code>Icon</code>
		 */
		public function AbstractButton ( actionOrLabel : * = null, icon : Icon = null )
		{
			super();
			
			actionTriggered = new Signal();
			buttonClicked = new Signal();			buttonDoubleClicked = new Signal();			buttonReleasedOutside = new Signal( );			componentSelectedChanged = new Signal();
			
			_labelIndex = 0;
			_iconIndex = 1;
			_removeLabelOnEmptyString = true;
			_labelTextField = _labelTextField ? _labelTextField : new TextFieldImpl();
			_labelTextField.autoSize = "left";
			_labelTextField.selectable = false;
			_labelTextField.defaultTextFormat = _style.format;
			_labelTextField.embedFonts = _style.embedFonts;
			_childrenLayout = _childrenLayout ? _childrenLayout : new DOInlineLayout( _childrenContainer );
			_childrenContainer.addChild( _labelTextField as DisplayObject );
			_tooltipOverlayTarget = _labelTextField as DisplayObject;

			if( actionOrLabel != null && actionOrLabel is Action )
				this.action = actionOrLabel;
			else if ( actionOrLabel != null && actionOrLabel is String )
				label = actionOrLabel;
			else
				label = "Button";

			if( icon )
				this.icon = icon;

			this.buttonDisplayMode = ButtonDisplayModes.TEXT_AND_ICON;

			/*FDT_IGNORE*/ FEATURES::KEYBOARD_CONTEXT { /*FDT_IGNORE*/
			_keyboardContext[ KeyStroke.getKeyStroke( Keys.ENTER ) ] = new ProxyCommand( click, true );			_keyboardContext[ KeyStroke.getKeyStroke( Keys.SPACE ) ] = new ProxyCommand( click, true );
			/*FDT_IGNORE*/ } /*FDT_IGNORE*/
		}
		
		public var actionTriggered : Signal;
		public var buttonClicked : Signal;
		public var buttonDoubleClicked : Signal;
		public var buttonReleasedOutside : Signal;
		public var componentSelectedChanged : Signal;
		
		/*-----------------------------------------------------------------
		 * 	GETTERS & SETTERS
		 *----------------------------------------------------------------*/
		/**
		 * Une référence vers l'objet <code>Action</code> de ce bouton.
		 */
		public function get action () : Action { return _action; }
		public function set action (action : Action) : void
		{
			if( _action )
				unregisterToCommandEvents( _action );

			_action = action;
			firePropertyChangedSignal("action", action);
			if( _action )
			{
				if( _action.name && _action.name != "" )
					label = _action.name;

				enabled = _action.actionEnabled;
				if( _action.icon != null )
					icon = ( _action.icon as Icon ).clone();

				registerToCommandEvents(_action);
			}
		}
		/**
		 * Une référence vers l'objet <code>ITextField</code> composé par ce bouton.
		 */
		public function get labelTextField () : ITextField { return _labelTextField; }
		/**
		 * Le mode d'affichage de ce bouton.
		 * <p>
		 * Les valeurs possible pour cette propriété sont recensées dans la
		 * classe <code>ButtonDisplayModes</code>
		 * </p>
		 * <p>
		 * <strong>Note : </strong> La modification de cette propriété conduit
		 * à la diffusion d'un évènement <code>PropertyEvent.PROPERTY_CHANGE</code>.
		 * </p>
		 * @see	ButtonDisplayModes
		 * @see #checkDisplayMode()
		 */
		public function get buttonDisplayMode () : uint { return _buttonDisplayMode; }
		public function set buttonDisplayMode (displayMode : uint) : void
		{
			_size = null;
			_buttonDisplayMode = displayMode;
			checkDisplayMode();
			firePropertyChangedSignal( "displayMode", _buttonDisplayMode );

		}
		/**
		 * Un référence vers l'objet <code>Icon</code> de ce bouton.
		 * <p>
		 * Il est possible de modifier cette propriété même si le mode
		 * d'affichage du bouton désactive l'usage de l'icône, celui-ci
		 * sera alors stocké dans la propriété de sauvegarde et récupérer
		 * si le mode d'affichage change.
		 * </p>
		 * <p>
		 * <strong>Note : </strong> La modification de cette propriété conduit
		 * à la diffusion d'un évènement <code>PropertyEvent.PROPERTY_CHANGE</code>.
		 * </p>
		 */
		public function get icon () : Icon	{ return _icon;	}
		public function set icon (icon : Icon ) : void
		{
			if( _buttonDisplayMode == ButtonDisplayModes.ICON_ONLY ||
				_buttonDisplayMode == ButtonDisplayModes.TEXT_AND_ICON )
			{
				setIcon ( icon );
			}
			else
				_safeIcon = icon;

			firePropertyChangedSignal( "icon", _icon );
		}
		/**
		 * Le label de ce bouton.
		 * <p>
		 * Il est possible de modifier cette propriété même si le mode
		 * d'affichage du bouton désactive l'usage du label, celui-ci
		 * sera alors stocké dans la propriété de sauvegarde et récupérer
		 * si le mode d'affichage change.
		 * </p>
		 * <p>
		 * <strong>Note : </strong> La modification de cette propriété conduit
		 * à la diffusion d'un évènement <code>PropertyEvent.PROPERTY_CHANGE</code>.
		 * </p>
		 */
		public function get label () : * { return _label; }
		public function set label ( val : * ) : void
		{
			if( _buttonDisplayMode == ButtonDisplayModes.TEXT_ONLY ||
				_buttonDisplayMode == ButtonDisplayModes.TEXT_AND_ICON )
			{
				setLabel ( val );
			}
			else
			{
				_safeLabel = val;
				if( !_icon )
					setLabel(val);
			}

			firePropertyChangedSignal( "label", _label );
		}
		/**
		 * Une valeur booléenne indiquant si ce bouton est actuellement sélectionné.
		 * <p>
		 * <strong>Note : </strong> La modification de cette propriété conduit
		 * à la diffusion d'un évènement <code>PropertyEvent.PROPERTY_CHANGE</code>.
		 * </p>
		 */
		public function get selected () : Boolean { return _selected; }
		public function set selected ( b : Boolean ) : void
		{
			if( b != _selected )
			{
				_selected = b;
				invalidate( );
				componentSelectedChanged.dispatch( this, _selected );
				fireComponentChangedSignal();
				firePropertyChangedSignal( "selected", _selected );
			}
		}
		/**
		 * @inheritDoc
		 */
		override public function get maxContentScrollV () : Number
		{
			return _childrenLayout.preferredSize.height - ( _childrenContainer.scrollRect.height - _style.insets.vertical );
		}
		/**
		 * @inheritDoc
		 */
		override public function get maxContentScrollH () : Number
		{
			return _childrenLayout.preferredSize.width - ( _childrenContainer.scrollRect.width - _style.insets.vertical );
		}

		/*-----------------------------------------------------------------
		 * 	KEYBOARD TRIGGER
		 *----------------------------------------------------------------*/

		/*FDT_IGNORE*/ FEATURES::KEYBOARD_CONTEXT { /*FDT_IGNORE*/
		/**
		 * [conditional-compile] Une référence vers un objet <code>KeyStroke</code> utilisé
		 * comme accélérateur de déclenchement de ce bouton.
		 * <p>
		 * <strong>Note :</strong> Cette fonction est soumise à la constante
		 * <a href="../../../../Conditional-Compilation.html#KEYBOARD_CONTEXT">FEATURES::KEYBOARD_CONTEXT</a>
		 * dans le cadre de la <a href="../../../../Conditional-Compilation.html">compilation conditionnelle</a>.
		 * Veillez donc à conditionner l'usage de cette fonctionnalité à l'usage de la constante de compilation associée.
		 * </p>
		 *
		 * @see ../../../../Conditional-Compilation.html#KEYBOARD_CONTEXT Constante FEATURES::KEYBOARD_CONTEXT
		 * @default null
		 */
		protected var _keyStroke : KeyStroke;
		/**
		 * [conditional-compile] Une référence vers un objet <code>KeyStroke</code> utilisé
		 * comme accélérateur de déclenchement de ce bouton.
		 * <p>
		 * <strong>Note :</strong> Cette fonction est soumise à la constante
		 * <a href="../../../../Conditional-Compilation.html#KEYBOARD_CONTEXT">FEATURES::KEYBOARD_CONTEXT</a>
		 * dans le cadre de la <a href="../../../../Conditional-Compilation.html">compilation conditionnelle</a>.
		 * Veillez donc à conditionner l'usage de cette fonctionnalité à l'usage de la constante de compilation associée.
		 * </p>
		 *
		 * @see ../../../../Conditional-Compilation.html#KEYBOARD_CONTEXT Constante FEATURES::KEYBOARD_CONTEXT
		 */
		public function get keyStroke () : KeyStroke { return _keyStroke; }
		public function set keyStroke (keyStroke : KeyStroke) : void
		{
			if( _keyStroke )
				KeyboardControllerInstance.removeGlobalKeyStroke( _keyStroke );

			_keyStroke = keyStroke;

			if( _keyStroke )
				KeyboardControllerInstance.addGlobalKeyStroke( _keyStroke, new ProxyCommand( click ) );
		}
		/*FDT_IGNORE*/ } /*FDT_IGNORE*/

		/*-----------------------------------------------------------------
		 * 	MISC & UTILS
		 *----------------------------------------------------------------*/
		/**
		 * Fonction réalisant le véritable changement d'un icône dans le cas
		 * où le mode d'affichage autorise l'affichage de celui-ci.
		 *
		 * @param	icon	le nouvel icône à afficher
		 */
		protected function setIcon ( icon : Icon ) : void
		{
			if( _icon && contains( _icon ) )
			{
				_icon.removeEventListener( ComponentEvent.COMPONENT_RESIZE, iconResized );
				removeComponentChild( _icon );
			}

			disposeIcon();

			_icon = icon;

			if( _icon )
			{
				_icon.init();
				_icon.invalidate();
				_icon.addEventListener( ComponentEvent.COMPONENT_RESIZE, iconResized );

				if( _labelTextField && containsComponentChild( _labelTextField as DisplayObject ) )
					addComponentChildAfter( _icon, _labelTextField as DisplayObject );
				else
					addComponentChildAt( _icon, _iconIndex );
			}

			invalidatePreferredSizeCache();
		}
		/**
		 * Appelle la méthode <code>dispose</code> sur l'icône de ce bouton si celui-ci
		 * en possède un.
		 */
		public function disposeIcon () : void
		{
			if( _icon )
				_icon.dispose();
		}
		/**
		 * Fonction réalisant le véritable changement de label dans le cas
		 * où le mode d'affichage autorise l'affichage de celui-ci.
		 *
		 * @param	val	le nouvel label à afficher
		 */
		protected function setLabel ( val : * ) : void
		{
			if( _label == val )
				return;

			_label = val;
			updateLabelText();
			checkForEmptyString ();
			invalidatePreferredSizeCache();
		}
		/**
		 * Vérifie la présence ou non d'une chaîne vide dans le label, et détermine
		 * l'attitude à adopter en fonction des différentes propriétés du bouton.
		 */
		protected function checkForEmptyString () : void
		{
			var valueNotEmpty : Boolean = isEmpty();
			var labelExist : Boolean = _childrenContainer.contains( _labelTextField as DisplayObject  );

			if( !valueNotEmpty && labelExist && _removeLabelOnEmptyString )
					removeComponentChild( _labelTextField as DisplayObject  );

			else if( valueNotEmpty && _removeLabelOnEmptyString && !labelExist )
			{
				if( _icon && containsComponentChild( _icon ) )
					addComponentChildBefore( _labelTextField as DisplayObject, _icon );
				else
					addComponentChildAt( _labelTextField as DisplayObject, _labelIndex );
			}
			else if( !_removeLabelOnEmptyString && !labelExist )
			{
				if( _icon && containsComponentChild( _icon ) )
					addComponentChildBefore( _labelTextField as DisplayObject, _icon );
				else
					addComponentChildAt( _labelTextField as DisplayObject, _labelIndex );
			}
		}
		/*FDT_IGNORE*/ FEATURES::TOOLTIP { /*FDT_IGNORE*/
		/**
		 * @inheritDoc
		 */
		override public function showToolTip ( overlay : Boolean = false ) : void
		{
			var r : Rectangle = screenVisibleArea;
			var w : Number = r.width;			var h : Number = r.height;
			var s : String;
			var ks : Array = [];

			// si une action est définie
			if( _action )
			{
				if( _action.longDescription )
				{
					s = _action.longDescription;
					overlay = false;
				}
				else if( buttonDisplayMode == ButtonDisplayModes.ICON_ONLY && _action.name )
					s = _action.name;
				else if( _action.accelerator && _action.name )
					s = _action.name;
				else
					s = "";

				if( _action.accelerator )
					ks.push( _action.accelerator );
			}
			else if( buttonDisplayMode == ButtonDisplayModes.ICON_ONLY && _safeLabel )
				s = _safeLabel;

			/*FDT_IGNORE*/ FEATURES::KEYBOARD_CONTEXT { /*FDT_IGNORE*/
			if( _keyStroke )
				ks.push( _keyStroke );
			/*FDT_IGNORE*/ } /*FDT_IGNORE*/

			if( ks.length > 0 )
			{
				if( !s )
					s = _labelTextField.htmlText;

				s += " (" + ks.join(",") + ")";
			}
			else if( !s && ( _labelTextField.textWidth > _labelTextField.width ||
			  _labelTextField.x + _labelTextField.textWidth > w ||
			  _labelTextField.y + _labelTextField.textHeight > h ) &&
			  buttonDisplayMode != ButtonDisplayModes.ICON_ONLY )
				s = _labelTextField.htmlText;

			_tooltip = s;
			super.showToolTip(overlay);
		}
		/*FDT_IGNORE*/ } /*FDT_IGNORE*/

		/**
		 * Vérifie le mode d'affichage du bouton et réalise les ajustement en conséquence.
		 * <p>
		 * Les cas particuliers suivants sont à considérer :
		 * </p>
		 * <ul>
		 * <li>Si le mode d'affichage n'autorise pas l'affichage du texte, mais qu'il n'existe pas d'icône
		 * pour ce bouton, le texte sera tout de même afficher.</li>
		 * <li>Si le mode d'affichage n'autorise pas l'affichage de l'icône, mais qu'il n'existe pas de texte
		 * pour ce bouton, l'icône sera tout de même afficher.</li>
		 * </ul>
		 */
		protected function checkDisplayMode () : void
		{
			var valueNotEmpty : Boolean = isEmpty();
			var safeValueNotEmpty : Boolean = _safeLabel !== "" && _safeLabel != null;

			switch( _buttonDisplayMode )
			{
				case ButtonDisplayModes.ICON_ONLY :
					if( valueNotEmpty )
					{
						_safeLabel = _label;
						setLabel("");
					}
					if( !_icon )
					{
						if( _safeIcon )
							setIcon(_safeIcon);
						else
						{
							setLabel(_safeLabel);
						}
					}
					break;

				case ButtonDisplayModes.TEXT_ONLY :
					if( _icon )
					{
						_safeIcon = _icon;
						setIcon(null);
					}
					if( !valueNotEmpty )
					{
						if( safeValueNotEmpty )
							setLabel( _safeLabel );
						else
							setIcon(_safeIcon);
					}
					break;

				case ButtonDisplayModes.TEXT_AND_ICON :
				default :
					if( !valueNotEmpty )
						if( safeValueNotEmpty )
							setLabel( _safeLabel);
					if( !_icon )
						if( _safeIcon )
							setIcon (_safeIcon);
					break;
			}
			checkForEmptyString ();
			invalidatePreferredSizeCache();
		}
		/*-----------------------------------------------------------------
		 * 	VALIDATION & REPAINT
		 *----------------------------------------------------------------*/
		/**
		 * @inheritDoc
		 */
		override public function repaint () : void
		{
			checkForEmptyString ();
			updateLabelText ();
			var size : Dimension = calculateComponentSize();

			super.repaint();

			if( _icon )
				_icon.repaint();
		}
		/**
		 * Met à jour le style de l'objet <code>ITextField</code>.
		 */
		protected function updateLabelText () : void
		{
			var valueNotEmpty : Boolean = isEmpty();
			if( _labelTextField )
			{
				_labelTextField.defaultTextFormat = _style.format;
				_labelTextField.textColor = _style.textColor.hexa;
				if( valueNotEmpty )
				{
					if( _removeLabelOnEmptyString )
						 affectLabelText ()
					else if( String( _label ) == "" )
						_labelTextField.htmlText = " ";
					else
						affectLabelText();
				}
			}
		}
		/**
		 * Met à jour le contenu de l'objet <code>ITextField</code>.
		 */
		protected function affectLabelText () : void
		{
			if( _labelTextField )
				_labelTextField.htmlText = String(_label);
		}
		/**
		 * Renvoie <code>true</code> si le label est nul, indéfini ou vide.
		 *
		 * @return	 <code>true</code> si le label est nul, indéfini ou vide
		 */
		protected function isEmpty () : Boolean
		{
			return ( _label != "" && _label != undefined ) || _label === false;
		}
		/**
		 * @inheritDoc
		 */
		override public function invalidatePreferredSizeCache () : void
		{
			updateLabelText ();
			super.invalidatePreferredSizeCache();
		}
/*-----------------------------------------------------------------
 * 	EVENT REGISTRATION
 *----------------------------------------------------------------*/
		/**
		 * @inheritDoc
		 */
		override protected function registerToOnStageEvents () : void
		{
			super.registerToOnStageEvents();
			addEventListener( MouseEvent.DOUBLE_CLICK, doubleClick );
		}
		/**
		 * @inheritDoc
		 */
		override protected function unregisterFromOnStageEvents () : void
		{
			super.unregisterFromOnStageEvents( );
			removeEventListener( MouseEvent.DOUBLE_CLICK, doubleClick );
		}
		/**
		 * @inheritDoc
		 */
		protected function registerToCommandEvents (action : Action) : void
		{
			action.propertyChanged.add( actionPropertyChanged );
			action.commandEnded.add( commandEnded );
			action.commandFailed.add( commandFail );

			if( action is Cancelable )
			  ( action as Cancelable ).commandCancelled.add( commandCancelled );
		}
		/**
		 * @inheritDoc
		 */
		protected function unregisterToCommandEvents (action : Action) : void
		{
			action.propertyChanged.remove( actionPropertyChanged );
			action.commandEnded.remove( commandEnded );
			action.commandFailed.remove( commandFail );

			if( action is Cancelable )
			  ( action as Cancelable ).commandCancelled.remove( commandCancelled );
		}

/*-----------------------------------------------------------------
 * 	EVENT HANDLERS
 *----------------------------------------------------------------*/
		/**
		 * Recoit l'évènement <code>ComponentEvent.COMPONENT_RESIZE</code> diffusé par l'objet <code>Icon</code>
		 * et invalide le cache de la taille préférentielle.
		 *
		 * @param	event	évènement diffusé par l'objet <code>Icon</code>
		 */
		protected function iconResized (event : Event) : void
		{
			invalidatePreferredSizeCache();
		}
		/**
		 * @inheritDoc
		 */
		override protected function stylePropertyChanged (propertyName : String, propertyValue : * ) : void
		{
			switch( propertyName )
			{
				case "embedFonts" :
					_labelTextField.embedFonts = _style.embedFonts;
					updateLabelText();
					invalidatePreferredSizeCache();
					break;
				default :
					super.stylePropertyChanged( propertyName, propertyValue );
					break;
			}
		}
		/**
		 * Recoit l'évènement <code>PropertyEvent.PROPERTY_CHANGE</code> diffusé par l'objet <code>Action</code>
		 * de ce bouton, et modifie les propriétés de ce bouton en conséquence.
		 *
		 * @param	event	évènement diffusé par l'objet <code>Action</code>
		 */
		protected function actionPropertyChanged ( propertyName : String, propertyValue : * ) : void
		{
			switch( propertyName )
			{
				case "actionEnabled" :
					enabled = propertyValue;
					break;
				case "name" :
					label = propertyValue;
					invalidatePreferredSizeCache();
					size = null;
					break;
				case "icon" :
					icon = ( propertyValue as Icon ).clone();
					invalidatePreferredSizeCache();
					size = null;
					break;
				default :
					break;
			}
		}
		/**
		 * @inheritDoc
		 */
		override public function releaseOutside () : void
		{
			buttonReleasedOutside.dispatch( this );
		}
		/**
		 * Recoit l'évènement <code>MouseEvent.DOUBLE_CLICK</code> diffusé par cet objet.
		 *
		 * @param	event	l'objet <code>MouseEvent</code> diffusé par l'objet
		 */
		protected function doubleClick ( event : MouseEvent = null ) : void
		{
			buttonDoubleClicked.dispatch( this );
		}
		/**
		 * @inheritDoc
		 */
		override public function click () : void
		{
			if( _action )
			{
				if( disableButtonDuringActionExecution )
					enabled = false;

				_action.execute();
			}
			actionTriggered.dispatch( this, action );
			buttonClicked.dispatch( this );
		}

		protected function commandEnded ( command : Command ) : void
		{
			if( disableButtonDuringActionExecution )
				enabled = _action.actionEnabled;
		}
		protected function commandFail ( command : Command  ) : void
		{
			if( disableButtonDuringActionExecution )
				enabled = true;
		}
		protected function commandCancelled ( command : Command ) : void
		{
			if( disableButtonDuringActionExecution )
				enabled = true;
		}
	}
}
