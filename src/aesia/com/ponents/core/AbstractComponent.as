/**
 * @license
 */
package aesia.com.ponents.core
{
	import aesia.com.mon.logs.Log;
	import aesia.com.mon.core.IDisplayObject;
	import aesia.com.mon.core.IDisplayObjectContainer;
	import aesia.com.mon.core.IInteractiveObject;
	import aesia.com.mon.core.LayeredSprite;
	import aesia.com.mon.geom.ColorMatrix;
	import aesia.com.mon.geom.Dimension;
	import aesia.com.mon.utils.StageUtils;
	import aesia.com.patibility.lang._;
	import aesia.com.patibility.lang._$;
	import aesia.com.ponents.builder.styles.DefaultComponentPreview;
	import aesia.com.ponents.core.focus.FocusGroup;
	import aesia.com.ponents.core.focus.Focusable;
	import aesia.com.ponents.core.paint.RepaintManagerInstance;
	import aesia.com.ponents.dnd.DragSource;
	import aesia.com.ponents.dnd.gestures.DragGesture;
	import aesia.com.ponents.events.ComponentEvent;
	import aesia.com.ponents.events.PropertyEvent;
	import aesia.com.ponents.skinning.ComponentStyle;
	import aesia.com.ponents.skinning.SkinManagerInstance;
	import aesia.com.ponents.skinning.StyleProperties;
	import aesia.com.ponents.skinning.cursors.Cursor;
	import aesia.com.ponents.tips.ToolTipInstance;
	import aesia.com.ponents.transfer.ComponentTransferable;
	import aesia.com.ponents.transfer.Transferable;
	import aesia.com.ponents.utils.Insets;

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.events.ContextMenuEvent;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.ui.ContextMenuItem;
	import flash.utils.Dictionary;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.IExternalizable;
	import flash.utils.getQualifiedClassName;

	/*-----------------------------------------------------------------
 * 	EVENTS METADATA
 *----------------------------------------------------------------*/
	/**
	 * Évènement diffusé lors d'un redimensionnement du composant.
	 * <p>
	 * En règle général, un évènement ne sera diffusé que si la taille
	 * du composant à réellement changé. C'est-à-dire si un appel à l'une
	 * des propriétés du composant (<code>size</code>, <code>preferredSize</code>)
	 * a été appelée avec des valeurs différente que la tailel actuelle, ou si le
	 * contenu du composant à changer sa taille de préférence.
	 * </p>
	 *
	 * @eventType aesia.com.ponents.events.ComponentEvent.COMPONENT_RESIZE
	 */
	[Event(name="componentResize", type="aesia.com.ponents.events.ComponentEvent")]
	/**
	 * Évènement diffusé lorsqu'un changement est provoqué au sein du composant.
	 *
	 * @eventType flash.events.Event.CHANGE
	 */
	[Event(name="change", type="flash.events.Event")]
	/**
	 * Évènement diffusé lorsque la position du composant à été changé.
	 * 
	 * @eventType aesia.com.ponents.events.ComponentEvent.POSITION_CHANGE
	 */
	[Event(name="positionChange", type="flash.events.Event")]
	/**
	 * Évènement diffusé lorsque le contenu du composant est déplacé à l'aide des
	 * propriétés <code>contentScrollH</code> et <code>contentScrollV</code>.
	 *
	 * @eventType aesia.com.ponents.events.ComponentEvent.SCROLL
	 */	[Event(name="scroll", type="aesia.com.ponents.events.ComponentEvent")]
	/**
	 * Évènement diffusé lorsque le composant est repaint.
	 * <p>
	 * Cet évènement intervient lors du passage dans la méthode <code>repaint</code>
	 * et donc une seule fois par frame, quelque soit le nombre d'appel fait à la
	 * méthode <code>invalidate</code>.
	 * </p>
	 *
	 * @eventType aesia.com.ponents.events.ComponentEvent.REPAINT
	 */	[Event(name="repaint", type="aesia.com.ponents.events.ComponentEvent")]
	/**
	 * Évènement diffusé lorsque l'état d'activation du composant à changer.
	 *
	 * @eventType aesia.com.ponents.events.ComponentEvent.ENABLED_CHANGE
	 */	[Event(name="enabledChange", type="aesia.com.ponents.events.ComponentEvent")]
	/**
	 * Évènement diffusé lorsqu'une propriété du composant est modifiée.
	 *
	 * <p>Les propriétés suivantes sont à l'origine de la diffusion de l'évènement
	 * <code>propertyChange</code></p>
	 * <ul>
	 * <li>cursor</li>	 * <li>contentScrollH</li>	 * <li>contentScrollV</li>	 * <li>enabled</li>	 * <li>focusParent</li>	 * <li>position</li>	 * <li>size</li>	 * <li>styleKey</li>	 * <li>tooltip</li>	 * </ul>
	 *
	 * @eventType aesia.com.ponents.events.PropertyEvent.PROPERTY_CHANGE
	 */	[Event(name="propertyChange", type="aesia.com.ponents.events.PropertyEvent")]
/*-----------------------------------------------------------------
 * 	STYLE METADATA
 *----------------------------------------------------------------*/
	/**
	 * Les tailles des marges intérieures du composant.
	 * <p>
	 * <strong>Note : </strong> Les marges intérieures du composant sont
	 * prisent en compte lors du calcul de la taille de préférence du composant.
	 * </p>
	 * <p>
	 * <strong>Note : </strong> La modification ou la récupération du style pour une instance de composant peut
	 * se faire des manières suivantes :
	 * </p>
	 * <ul>
	 * <li><pre>var insets : Insets = monComposant.style.insets;</pre>
	 * Récupère la valeur du style dans l'état courant du composant.</li>
	 * <li><pre>monComposant.style.insets = new Insets(1,2,3,4);</pre>
	 * Modifie la valeur du style pour ce composant et pour tout ses états.
	 * Cette opération est équivalente à l'usage de la méthode
	 * <code>setForAllStates</code> de la classe <code>ComponentStyle</code>.</li>
	 * </ul>
	 */
	[Style(name="insets",type="aesia.com.ponents.utils.Insets")]
	/**
	 * Les tailles des bordures du composant.
	 * <p>
	 * <strong>Note : </strong> Les bordures du composant ne sont pas prises en compte dans
	 * le calcul de la taille de préférence du composant.
	 * </p>
	 * <p>
	 * <strong>Note : </strong> La modification ou la récupération du style pour une instance de composant peut
	 * se faire des manières suivantes :
	 * </p>
	 * <ul>
	 * <li><pre>var borders : Borders = monComposant.style.borders;</pre>
	 * Récupère la valeur du style dans l'état courant du composant.</li>
	 * <li><pre>monComposant.style.borders = new Borders(1,2,3,4);</pre>
	 * Modifie la valeur du style pour ce composant et pour tout ses états.
	 * Cette opération est équivalente à l'usage de la méthode
	 * <code>setForAllStates</code> de la classe <code>ComponentStyle</code>.</li>
	 * </ul>
	 */
	[Style(name="borders",type="aesia.com.ponents.utils.Borders")]
	/**
	 * Les rayons des coins du composant.
	 * <p>
	 * <strong>Note : </strong> La modification ou la récupération du style pour une instance de composant peut
	 * se faire des manières suivantes :
	 * </p>
	 * <ul>
	 * <li><pre>var corners : Corners = monComposant.style.corners;</pre>
	 * Récupère la valeur du style dans l'état courant du composant.</li>
	 * <li><pre>monComposant.style.corners = new Corners(1,2,3,4);</pre>
	 * Modifie la valeur du style pour ce composant et pour tout ses états.
	 * Cette opération est équivalente à l'usage de la méthode
	 * <code>setForAllStates</code> de la classe <code>ComponentStyle</code>.</li>
	 * </ul>
	 */
	[Style(name="corners",type="aesia.com.ponents.utils.Corners")]
	/**
	 * La décoration de l'arrière-plan de ce composant.
	 * <p>
	 * <strong>Note : </strong> La modification ou la récupération du style pour une instance de composant peut
	 * se faire des manières suivantes :
	 * </p>
	 * <ul>
	 * <li><pre>var background : ComponentDecoration = monComposant.style.background;</pre>
	 * Récupère la valeur du style dans l'état courant du composant.</li>
	 * <li><pre>monComposant.style.background = new SimpleFill(Color.White);</pre>
	 * Modifie la valeur du style pour ce composant et pour tout ses états.
	 * Cette opération est équivalente à l'usage de la méthode
	 * <code>setForAllStates</code> de la classe <code>ComponentStyle</code>.</li>
	 * </ul>
	 */
	[Style(name="background",type="aesia.com.ponents.skinning.decorations.ComponentDecoration")]
	/**
	 * La décoration de l'avant-plan de ce composant.
	 * <p>
	 * <strong>Note : </strong> La modification ou la récupération du style pour une instance de composant peut
	 * se faire des manières suivantes :
	 * </p>
	 * <ul>
	 * <li><pre>var foreground : ComponentDecoration = monComposant.style.foreground;</pre>
	 * Récupère la valeur du style dans l'état courant du composant.</li>
	 * <li><pre>monComposant.style.foreground = new SimpleBorders(Color.Black);</pre>
	 * Modifie la valeur du style pour ce composant et pour tout ses états.
	 * Cette opération est équivalente à l'usage de la méthode
	 * <code>setForAllStates</code> de la classe <code>ComponentStyle</code>.</li>
	 * </ul>
	 */
	[Style(name="foreground",type="aesia.com.ponents.skinning.decorations.ComponentDecoration")]
	/**
	 * Les filtres appliqués sur la totalité du composant.
	 * <p>
	 * <strong>Note : </strong> La modification ou la récupération du style pour une instance de composant peut
	 * se faire des manières suivantes :
	 * </p>
	 * <ul>
	 * <li><pre>var outerFilters : Array = monComposant.style.outerFilters;</pre>
	 * Récupère la valeur du style dans l'état courant du composant.</li>
	 * <li><pre>monComposant.style.outerFilters = [new GlowFilter()]</pre>
	 * Modifie la valeur du style pour ce composant et pour tout ses états.
	 * Cette opération est équivalente à l'usage de la méthode
	 * <code>setForAllStates</code> de la classe <code>ComponentStyle</code>.</li>
	 * </ul>
	 */
	[Style(name="outerFilters",type="Array", arrayType="flash.filters.BitmapFilter")]
	/**
	 * Les filtres appliqués sur le contenu du composant.
	 * <p>
	 * <strong>Note : </strong> La modification ou la récupération du style pour une instance de composant peut
	 * se faire des manières suivantes :
	 * </p>
	 * <ul>
	 * <li><pre>var innerFilters : Array = monComposant.style.innerFilters;</pre>
	 * Récupère la valeur du style dans l'état courant du composant.</li>
	 * <li><pre>monComposant.style.innerFilters = [new GlowFilter()]</pre>
	 * Modifie la valeur du style pour ce composant et pour tout ses états.
	 * Cette opération est équivalente à l'usage de la méthode
	 * <code>setForAllStates</code> de la classe <code>ComponentStyle</code>.</li>
	 * </ul>
	 */
	[Style(name="innerFilters",type="Array", arrayType="flash.filters.BitmapFilter")]
	/**
	 * La couleur du texte du composant.
	 * <p>
	 * <strong>Note : </strong> Par convention, la couleur définie dans la propriété
	 * <code>textColor</code> du style d'un composant est prioritaire sur la couleur
	 * définie dans la propriété <code>format</code>, et ce afin de permettre un changement
	 * de couleur du texte simple, sans avoir à redéfinir l'ensemble des paramètres de formatage
	 * du texte définis dans les styles parents.
	 * </p>
	 * <p>
	 * <strong>Note : </strong> La modification ou la récupération du style pour une instance de composant peut
	 * se faire des manières suivantes :
	 * </p>
	 * <ul>
	 * <li><pre>var textColor : Color = monComposant.style.textColor;</pre>
	 * Récupère la valeur du style dans l'état courant du composant.</li>
	 * <li><pre>monComposant.style.textColor = Color.Red</pre>
	 * Modifie la valeur du style pour ce composant et pour tout ses états.
	 * Cette opération est équivalente à l'usage de la méthode
	 * <code>setForAllStates</code> de la classe <code>ComponentStyle</code>.</li>
	 * </ul>
	 */
	[Style(name="textColor",type="aesia.com.mon.utils.Color")]
	/**
	 * Le format du texte du composant.
	 * <p>
	 * <strong>Note : </strong> Par convention, la couleur définie dans la propriété
	 * <code>textColor</code> du style d'un composant est prioritaire sur la couleur
	 * définie dans la propriété <code>format</code>, et ce afin de permettre un changement
	 * de couleur du texte simple, sans avoir à redéfinir l'ensemble des paramètres de formatage
	 * du texte définis dans les styles parents.
	 * </p>
	 * <p>
	 * <strong>Note : </strong> La modification ou la récupération du style pour une instance de composant peut
	 * se faire des manières suivantes :
	 * </p>
	 * <ul>
	 * <li><pre>var format : TextFormat = monComposant.style.format;</pre>
	 * Récupère la valeur du style dans l'état courant du composant.</li>
	 * <li><pre>monComposant.style.format = new TextFormat("FreeSans", 16)</pre>
	 * Modifie la valeur du style pour ce composant et pour tout ses états.
	 * Cette opération est équivalente à l'usage de la méthode
	 * <code>setForAllStates</code> de la classe <code>ComponentStyle</code>.</li>
	 * </ul>
	 */
	[Style(name="format",type="flash.text.TextFormat")]
/*-----------------------------------------------------------------
 * 	SKIN METADATA
 *----------------------------------------------------------------*/
	[Skinable(skin="DefaultComponent")]
	/**
	 * Implémentation de base de l'interface <code>Component</code>.
	 * <p>
	 * Dans la grande majorité des cas vous avez juste à étendre la classe <code>AbstractComponent</code>
	 * ou l'une de ses sous-classes afin de créer un nouveau type de composant.
	 * </p>
	 * <p>
	 * La classe <code>AbstractComponent</code> fournie un grand de fonctionnalité de base telle que la
	 * gestion des styles de composants, des états de composant, la gestion du curseur, des info-bulles
	 * ou encore la gestion des raccourcis clavier ou des menus contextuels. Un certain nombre de ces
	 * fonctionnalités sont soumises à la compilation conditionnelle.
	 * </p>
	 *
	 * @author	Cédric Néhémie
	 * @see ../../../../annexes-summary.html#components Annexes des composants
	 */
	public class AbstractComponent extends Sprite implements Component,
															 IDisplayObject,
															 IInteractiveObject,
															 IDisplayObjectContainer,
															 Focusable,
															 LayeredSprite,
															 IEventDispatcher,
															 DragSource,
															 IExternalizable

	{
/*-----------------------------------------------------------------
 * 	STATIC MEMBERS
 *----------------------------------------------------------------*/
		/**
		 * Renvoie un tableau contenant les filtres de transformation par défaut pour
		 * les composants désactivés.
		 * <p>
		 * Le tableau contient un objet <code>ColorMatrixFilter</code> enlevant toute saturation
		 * au composant et réduisant l'opacité de <code>100</code>.
		 * </p>
		 * @return	un tableau contenant les filtres de transformation par défaut pour
		 * 			les composants désactivés
		 */
		static public function createDisabledInnerFilters () : Array
		{
			var m : ColorMatrix = new ColorMatrix( );
			m.adjustSaturation( -100 );
			m.adjustAlpha( -100 );
			return [ new ColorMatrixFilter( m ) ];
		}

		/*FDT_IGNORE*/ FEATURES::BUILDER { /*FDT_IGNORE*/
		/**
		 * [conditional-compile] Renvoie un composant chargé de servir de prévisualisation pour
		 * les styles définis dans ce fichier au sein de l'éditeur de styles
		 * de composant.
		 * <p>
		 * <strong>Note :</strong> Cette fonction est soumise à la constante
		 * <a href="../../../../Conditional-Compilation.html#BUILDER">FEATURES::BUILDER</a>
		 * dans le cadre de la <a href="../../../../Conditional-Compilation.html">compilation conditionnelle</a>.
		 * Veillez donc à conditionner l'usage de cette fonctionnalité à l'usage de la constante de compilation associée.
		 * </p>
		 * @see ../../../../Conditional-Compilation.html#BUILDER Constante FEATURES::BUILDER
		 * @return	un composant chargé de servir de prévisualisation dans l'éditeur
		 * 			de styles de composant
		 */
		static public function defaultPreview () : Component
		{
			return new DefaultComponentPreview();
		}
		/*FDT_IGNORE*/ } /*FDT_IGNORE*/

/*-----------------------------------------------------------------
 * 	IDENTIFICATION
 *
 *----------------------------------------------------------------*/
 		/**
 		 * L'identifiant de ce composant.
 		 *
 		 * @default null
 		 */
 		protected var _id : String;
/*-----------------------------------------------------------------
 * 	COMPONENTS STATES
 *
 * 	Les états propre aux composants.
 *----------------------------------------------------------------*/
		/**
		 * L'état d'activation de ce composant.
		 * <p>
		 * Un composant désactivé continue d'avoir des interactions avec la souris.
		 * Les évènements continuent d'être diffusés. Seulement tout les comportements
		 * liés à sa nature de composants sont désactivés. Hormis l'apparition des info-bulles.
		 * </p>
		 *
		 * @default true
		 * @see ../../../../Components-Structure.html#behavior Structure comportementale
		 */
		protected var _enabled : Boolean;
		/**
		 * L'état de sélection du composant.
		 * <p>
		 * Un composant peut être sélectionné sans pour autant
		 * avoir le focus.
		 * </p>
		 *
		 * @default false
		 * @see ../../../../Components-Structure.html#behavior Structure comportementale
		 */
		protected var _selected : Boolean;
		/**
		 * L'état de focus du composant.
		 * <p>
		 * Un composant peut se retrouver dans un état de focus même avec
		 * <code>stage.focus != this</code> dans les cas suivants :
		 * </p>
		 * <ul>
		 * <li>Le composant implémente l'interface <code>Container</code> et
		 * un de ses enfants à reçu le focus.</li>
		 * <li>Dans le cas d'un composant de saisie de texte, le focus du composant est
		 * toujours transmis à l'objet <code>TextField</code> utilisé en interne.</li>
		 * </ul>
		 *
		 * @default false
		 * @see ../../../../Components-Structure.html#behavior Structure comportementale
		 * @see Container
		 * @see http://livedocs.adobe.com/flex/3/langref/flash/display/Stage.html#focus flash.display.Stage.focus
		 */
		protected var _focus : Boolean;
		/**
		 * L'état de présence sur la scène du composant.
		 * <p>
		 * L'état <code>displayed</code> est activé et désactivé en réponse
		 * à la diffusion des évènements <code>Event.ADDED_TO_STAGE</code> et
		 * <code>Event.REMOVE_FROM_STAGE</code>.
		 * </p>
		 *
		 * @default false
		 */
		protected var _displayed : Boolean;
		/**
		 * L'état de pression du bouton de la souris au dessus du composant.
		 *		 * @default false
		 * @see ../../../../Components-Structure.html#behavior Structure comportementale
		 */
		protected var _pressed : Boolean;
		/**
		 * L'état de survol du composant par la souris.
		 *
		 * @default false
		 * @see ../../../../Components-Structure.html#behavior Structure comportementale
		 */
		protected var _over : Boolean;
		/**
		 * Si <code>true</code> le composant autorise les intéractions clavier et souris,
		 * autrement le composant est totalement inerte.
		 *
		 * @default true
		 */
		protected var _interactive : Boolean;

/*-----------------------------------------------------------------
 * 	COMPONENTS STATES SWITCHES
 *
 * 	Certains états peuvent être désactivés à l'aide
 * 	de ces interrupteurs.
 *----------------------------------------------------------------*/
		/**
		 * L'état d'activation de la fonction de survol du composant par la souris.
		 * <p>
		 * Placée cette valeur à <code>false</code> fait que la propriété <code>_over</code>
		 * sera toujours à <code>false</code>. Tout les comportements associés seront donc
		 * désactivés à leur tour, notamment l'utilisation des états liés au survol
		 * de la souris dans les styles du composant.
		 * </p>
		 *
		 * @default true
		 * @see ../../../../Components-Structure.html#behavior Structure comportementale
		 */
		protected var _allowOver : Boolean;
		/**
		 * L'état d'activation de la fonction de pression du composant par la souris.
		 * <p>
		 * Placée cette valeur à <code>false</code> fait que la propriété <code>_pressed</code>
		 * sera toujours à <code>false</code>. Tout les comportements associés seront donc
		 * désactivés à leur tour, notamment l'utilisation des états liés à la pression du bouton
		 * de la souris dans les styles du composant.
		 * </p>
		 *
		 * @default true
		 * @see ../../../../Components-Structure.html#behavior Structure comportementale
		 */
		protected var _allowPressed : Boolean;
		/**
		 * L'état d'activation de la fonction de sélection du composant.
		 * <p>
		 * Placée cette valeur à <code>false</code> fait que la propriété <code>_selected</code>
		 * sera toujours à <code>false</code>. Tout les comportements associés seront donc
		 * désactivés à leur tour, notamment l'utilisation des états liés à la sélection
		 * dans les styles du composant.
		 * </p>
		 *
		 * @default true
		 * @see ../../../../Components-Structure.html#behavior Structure comportementale
		 */
		protected var _allowSelected : Boolean;
		/**
		 * L'état d'activation de la fonction de focus du composant.
		 * <p>
		 * Placée cette valeur à <code>false</code> fait que la propriété <code>_focus</code>
		 * sera toujours à <code>false</code>. Tout les comportements associés seront donc
		 * désactivés à leur tour, notamment l'utilisation des états liés au focus
		 * dans les styles du composant.
		 * </p>
		 *
		 * @default true
		 * @see ../../../../Components-Structure.html#behavior Structure comportementale
		 */
		protected var _allowFocus : Boolean;
		/**
		 * L'état d'activation de la fonction de transmissions du focus
		 * au enfants d'un composant.
		 * <p>
		 * Placée cette valeur à <code>false</code> permet de garantir
		 * qu'un focus placé sur le composant par une manipulation de
		 * l'utilisateur le sera sur le composant et non sur l'enfant qui
		 * aura déclencher réellement la prise de focus. Permettant de garantir
		 * que <code>stage.focus == this</code>.
		 * </p>
		 * @default true
		 * @see ../../../../Components-Structure.html#focus Transmission du focus
		 * @private
		 */		protected var _allowFocusTraversing : Boolean;
		/**
		 * L'état d'activation de la fonction de masque du contenu du composant.
		 * <p>
		 * Placée cette valeur à <code>false</code> prévient la fonction dessin
		 * du composant d'utiliser la propriété <code>scrollRect</code> afin
		 * afin de réduire l'espace visible du contenu du composant à la zone
		 * prévue par sa taille et son style.
		 * Plus concrètement, si cette valeur est à <code>false</code> le contenu
		 * pourra apparaître en dehors du composant.
		 * </p>
		 *
		 * @default true
		 * @see ../../../../Components-Structure.html#graphics Structure graphique
		 */
		protected var _allowMask : Boolean;
		/**
		 * L'état de transmissions des évènements de type <code>MouseEvent.MOUSE_OVER</code>
		 * et <code>MouseEvent.MOUSE_OUT</code> aux parents graphiques de ce composant.
		 * <p>
		 * Placée cette valeur à <code>false</code> équivaut à empêcher toute remontée des évènements
		 * de survol du composant par la souris.
		 * </p>
		 *
		 * @default true
		 */
		protected var _allowOverEventBubbling : Boolean;

/*-----------------------------------------------------------------
 * 	COMPONENTS STYLE AND REPAINT PROPERTIES
 *
 * 	Propriétés liées au redessins du composant est à sa validation
 *----------------------------------------------------------------*/
 		/*
 		 * Utilisé pour satisfaire à l'interface LayeredSprite
 		 */
		private var _backgroundCleared : Boolean;
		/*
 		 * Utilisé pour satisfaire à l'interface LayeredSprite
 		 */
		private var _foregroundCleared : Boolean;

		/**
		 * Propriété volatile servant à indiquer si le composant est considéré
		 * comme la racine de la validation graphique, ou si la validation doit
		 * être déplacé au niveau de son parent.
		 * <p>
		 * Cette propriété est toujours replacée à <code>true</code> après un appel
		 * à la fonction <code>repaint</code>.
		 * </p>
		 *
		 * @default true
		 * @see ../../../../Components-Structure.html#graphics Structure graphique
		 */
		protected var _validateRoot : Boolean;
		/**
		 * Un entier indiquant l'état courant du composant.
		 * <p>
		 * Une description complète des états d'un composants ainsi que des transitions
		 * dans les états est disponible en annexe.
		 * </p>
		 * @default 0
		 * @see ../../../../Components-Structure.html#behavior Structure comportementale
		 */
		protected var _state : uint;
		/**
		 * Le style du composant.
		 * <p>
		 * La classe <code>AbstractComponent</code> construit un objet <code>ComponentStyle</code>
		 * par défaut dans son constructeur. Cette instance est construite à l'aide des balises
		 * <code>[Skinable]</code> et <code>[Skin]</code> définies pour ce composant.
		 * </p>
		 * @see ../../../../Components-Structure.html#styles Construction des styles
		 * @see ../../../../Metas.html#skinable Balise [Skinable]		 * @see ../../../../Metas.html#skin Balise [Skin]
		 */
		protected var _style : ComponentStyle;
		/**
		 * Un objet <code>Shape</code> servant au dessin du fond du composant.
		 *
		 * @see ../../../../Components-Structure.html#graphics Structure graphique
		 */
		protected var _background : Sprite;		/**
		 * Un objet <code>Shape</code> servant au dessin du premier plan du composant.
		 *
		 * @see ../../../../Components-Structure.html#graphics Structure graphique
		 */
		protected var _foreground : Sprite;
		/**
		 * Permet de conserver l'état de visibilité d'un composant hors de la scène
		 * afin de le masquer durant sa phase de premier redessin après un ajout sur
		 * la scène.
		 */
		/*
		protected var _visibleWhileNotInStage : Boolean;
		protected var _wasAddedToStage : Boolean;
		*/
/*-----------------------------------------------------------------
 * 	DISPLAY LIST RELATED
 *
 * 	Propriétés traitant de la relation avec la chaîne d'affichage
 * 	graphique.
 *----------------------------------------------------------------*/
		/**
		 * Un objet <code>Sprite</code> servant à contenir les enfants de ce composants
		 * qu'il s'agisse d'autres composants ou de simple <code>DisplayObject</code>.
		 * <p>
		 * La distinction entre les différents types de contenus et à la façon de les gérer
		 * est laissé à la discretion des descendants de la classe <code>AbstractComponent</code>
		 * </p>
		 *
		 * @see ../../../../Components-Structure.html#graphics Structure graphique
		 */
		protected var _childrenContainer : Sprite;
		/**
		 * L'objet <code>FocusGroup</code> chargé d'organiser la transmission du focus
		 * pour ce composant.
		 * <p>
		 * Cet objet n'est utilisé que dans le cadre de la navigation au clavier.
		 * </p>
		 *
		 * @see ../../../../Components-Structure.html#focus Transmission du focus
		 */
		protected var _focusParent : FocusGroup;
		/**
		 * La taille courante du composant.
		 *
		 * @see ../../../../Components-Structure.html#layout Taille et layouts
		 */
		protected var _size : Dimension;
		/**
		 * La taille de préférence définie par l'utilisateur.
		 * <p>
		 * Cette propriété ne vaut pas <code>null</code> seulement si un appel
		 * au propriétés de taille de préférences a été réalisé.
		 * </p>
		 *
		 * @default null
		 * @see ../../../../Components-Structure.html#layout Taille et layouts
		 */		protected var _preferredSize : Dimension;
		/**
		 * La dernière taille de préférence calculée pour ce composant.
		 * <p>
		 * La méthode choisie pour déterminer la valeur de la taille de préférence
		 * est laissé à la discretion des descendants de la classe <code>AbstractComponent</code>
		 * </p>
		 *
		 * @default null
		 * @see ../../../../Components-Structure.html#layout Taille et layouts
		 */
		protected var _preferredSizeCache : Dimension;
		/**
		 * La valeur de décalage horizontal appliquer au contenu de ce composant.
		 *
		 * @default 0
		 */
		protected var _contentScrollH : Number;
		/**
		 * La valeur de décalage vertical appliquer au contenu de ce composant.
		 *
		 * @default 0
		 */
		protected var _contentScrollV : Number;
		/**
		 * Préviens l'utilisation de valeurs avec flottants pour les
		 * données spaciale d'un composant (taille et position).
		 *
		 * @default true
		 */
		protected var _integerForSpatialInformations : Boolean;

		/**
		 * DisplayObject utilisé comme référence pour l'affichage des info-bulles
		 * en mode overlay.
		 *
		 * @default null
		 */
		protected var _tooltipOverlayTarget : DisplayObject;
		/**
		 * Si <code>true</code> l'info-bulle est affichée en overlay
		 * sur un passage de la souris au dessus du composant.
		 *
		 * @default false
		 */
		protected var _tooltipOverlayOnMouseOver : Boolean;
		/**
		 * Si <code>true</code> ce composant est considéré comme un
		 * composant à part entière dans la hierarchie, autrement, on
		 * considère qu'il fait partie d'un composant plus complèxe et
		 * ne peut être distinguer de celui-ci.
		 * <p>
		 * Cette propriété est utilisée notament dans la fonction
		 * <code>firstLeafComponent</code> qui remonte la structure
		 * graphique à partir d'un objet graphique quelquonque jusqu'au
		 * premier objet <code>Component</code> avec la propriété
		 * <code>isComponentLeaf</code> à <code>true</code>.
		 * </p>
		 *
		 * @default true
		 */
		protected var _isComponentLeaf : Boolean;

		/**
		 * Initialise les éléments de base d'un composant.
		 * <p>
		 * Une requête est effectuée dans le constructeur au <code>SkinManager</code>
		 * afin de récupérer une instance de la classe <code>ComponentStyle</code>
		 * pour ce composant.
		 * </p>
		 * <p>
		 * Le constructeur enregistre lui même l'instance comme écouteur pour l'ensemble des
		 * évènements nécessaires au fonctionnement du composant.
		 * </p>
		 *
		 * @see ../../../../Components-Structure.html#styles Structure des styles
		 * @see ../../../../Metas.html#skinable Balise [Skinable]
		 * @see ../../../../Metas.html#skin Balise [Skin]
		 */
		public function AbstractComponent ()
		{
			_enabled = true;
			_pressed = false;			_selected = false;
			_over = false;
			_allowFocus = true;
			_allowOver = true;
			_allowPressed = true;
			_allowSelected = true;
			_allowMask = true;
			_allowFocusTraversing = true;
			_integerForSpatialInformations = true;
			_allowOverEventBubbling = false;
			_background = new Sprite();
			_foreground = new Sprite();			_childrenContainer = new Sprite();
			_style = SkinManagerInstance.getComponentStyle( this );
			_contentScrollH = 0;
			_tooltipOverlayOnMouseOver = false;
			_contentScrollV = 0;
			_interactive = true;
			_isComponentLeaf = true;

			/*FDT_IGNORE*/ FEATURES::DND { /*FDT_IGNORE*/
			_allowDrag = false;
			/*FDT_IGNORE*/ } /*FDT_IGNORE*/

			/*FDT_IGNORE*/ FEATURES::KEYBOARD_CONTEXT { /*FDT_IGNORE*/
			_keyboardContext = new Dictionary();
			/*FDT_IGNORE*/ } /*FDT_IGNORE*/
			/*FDT_IGNORE*/ FEATURES::MENU_CONTEXT { /*FDT_IGNORE*/
			_menuContextGroups = {};
			_menuContextOrder = [];
			_menuContextMap = {};
			_menuContextEnabledMap = new Dictionary(true);			/*FDT_IGNORE*/ } /*FDT_IGNORE*/

			_background.mouseEnabled = false;			_foreground.mouseEnabled = false;
			_childrenContainer.mouseEnabled = false;
			_childrenContainer.mouseChildren = false;

			buttonMode = true;
			useHandCursor = false;
			focusRect = false;

			addChild( _background );
			addChild( _childrenContainer );			addChild( _foreground );

			addWeakEventListener( Event.ADDED_TO_STAGE, addedToStage );			addWeakEventListener( Event.REMOVED_FROM_STAGE, removeFromStage );

			_style.addEventListener( PropertyEvent.PROPERTY_CHANGE, stylePropertyChanged, false, 0, true );
		}

/*-----------------------------------------------------------------
 * 	GETTERS / SETTERS
 *----------------------------------------------------------------*/
 		/**
 		 * L'identifiant de ce composant.
 		 *
 		 * @default null
 		 */
 		public function get id () : String { return _id; }
		public function set id (id : String) : void
		{
			_id = id;
		}
		/**
		 * Une référence vers l'objet <code>Shape</code> sur lequel le composant
		 * déssine les décorations d'arrière-plan.
		 *
		 * @default new Shape()
		 */
		public function get background () : Sprite { return _background; }
		/**
		 * Une référence vers l'objet <code>Shape</code> sur lequel le composant
		 * déssine les décorations d'avant-plan.
		 *
		 * @default new Shape()
		 */
		public function get foreground () : Sprite { return _foreground; }
		/**
		 * Une référence vers l'objet <code>Sprite</code> contenant les enfants de
		 * ce composant.
		 *
		 * @default new Sprite()
		 */
		public function get middle () : Sprite { return _childrenContainer; }

		/**
		 * État de présence dans la <em>Display List</em> de ce composant.
		 * <p>
		 * La valeur de cette propriété est determiné en fonction de la
		 * reception de
		 * </p>
		 */
		public function get displayed () : Boolean { return _displayed; }
		/**
		 * L'état de survol du composant par la souris.
		 *
		 * @default false
		 * @see ../../../../Components-Structure.html#behavior Structure comportementale
		 */
		public function get over () : Boolean { return _over; }
		/**
		 * L'état de pression du bouton de la souris au dessus du composant.
		 *
		 * @default false
		 * @see ../../../../Components-Structure.html#behavior Structure comportementale
		 */
		public function get pressed () : Boolean { return _pressed; }
		/**
		 * État d'activation de ce composant.
		 * <p>
		 * Un composant désactivé continue d'avoir des interactions avec la souris.
		 * Les évènements continuent d'être diffusés. Seulement, tout les comportements
		 * liés à sa nature de composant sont désactivés, excepté l'apparition des info-bulles.
		 * </p>
		 * <p>
		 * <strong>Note : </strong> La modification de cette propriété conduit
		 * à la diffusion d'un évènement <code>PropertyEvent.PROPERTY_CHANGE</code>.
		 * </p>
		 * @see ../../../../Components-Structure.html#behavior Structure comportementale
		 */
		public function get enabled () : Boolean { return _enabled;	}
		public function set enabled (b : Boolean) : void
		{
			if( b != _enabled )
			{
				_enabled = b;
				if( !b )
				{
					if( _pressed && !_over )
						releaseOutside();
					_over = _pressed = b;
				}
				else
				{
					if( stage && this.hitTestPoint( stage.mouseX, stage.mouseY, true ) )
						_over = true;
				}

				buttonMode = tabEnabled = b;
				fireChangeEvent( );
				firePropertyEvent( "enabled", b );
				fireComponentEvent( ComponentEvent.ENABLED_CHANGE );
				invalidate( true );
			}
		}
		/**
		 * Position de ce composant
		 * <p>
		 * La valeur des coordonnées <code>x</code> et <code>y</code>
		 * de la position d'un composant sont toujours cohérentes par rapport
		 * aux valeurs des propriétés <code>x</code> et <code>y</code>
		 * du composant.
		 * </p>
		 * <p>
		 * <strong>Note : </strong> La modification de cette propriété conduit
		 * à la diffusion d'un évènement <code>PropertyEvent.PROPERTY_CHANGE</code>.
		 * </p>
		 */
		public function get position () : Point	{return new Point( x, y ); }
		public function set position (p : Point) : void
		{
			super.x = _integerForSpatialInformations ? Math.floor( p.x ) : p.x;
			super.y = _integerForSpatialInformations ? Math.floor( p.y ) : p.y;
			fireChangeEvent();
			firePropertyEvent( "position", p );
			firePositionChangeEvent();
			invalidate();
		}
		/**
		 * Réecriture de l'accesseur défini dans <code>DisplayObject</code>
		 * afin de prendre en compte la gestion des entiers dans les coordonnées
		 * spatiales.
		 * <p>
		 * <strong>Note : </strong> La modification de cette propriété conduit
		 * à la diffusion d'un évènement <code>PropertyEvent.PROPERTY_CHANGE</code>.
		 * </p>
		 * @see #position
		 */
		override public function set x (value : Number) : void
		{
			super.x = _integerForSpatialInformations ? Math.floor( value ) : value;
			fireChangeEvent();
			firePropertyEvent( "position", position );
			firePositionChangeEvent();		}
		/**
		 * Réecriture de l'accesseur défini dans <code>DisplayObject</code>
		 * afin de prendre en compte la gestion des entiers dans les coordonnées
		 * spatiales.
		 * <p>
		 * <strong>Note : </strong> La modification de cette propriété conduit
		 * à la diffusion d'un évènement <code>PropertyEvent.PROPERTY_CHANGE</code>.
		 * </p>
		 * @see #position
		 */
		override public function set y (value : Number) : void
		{
			super.y = _integerForSpatialInformations ? Math.floor( value ) : value;
			fireChangeEvent();
			firePropertyEvent( "position", position );
			firePositionChangeEvent();
		}
		/**
		 * Réecriture de l'accesseur défini dans <code>DisplayObject</code>
		 * afin de prendre en compte la gestion des entiers dans les coordonnées
		 * spatiales.
		 * <p>
		 * <strong>Note : </strong> La modification de cette propriété conduit
		 * à la diffusion d'un évènement <code>PropertyEvent.PROPERTY_CHANGE</code>
		 * si la taille du composant à changer.
		 * </p>
		 * @see #size
		 */
		override public function get width () : Number { return _size ? _size.width : preferredWidth; }
		override public function set width (n : Number) : void
		{
			size = new Dimension( n, height );
		}
		/**
		 * Réecriture de l'accesseur défini dans <code>DisplayObject</code>
		 * afin de prendre en compte la gestion des entiers dans les coordonnées
		 * spatiales.
		 * <p>
		 * <strong>Note : </strong> La modification de cette propriété conduit
		 * à la diffusion d'un évènement <code>PropertyEvent.PROPERTY_CHANGE</code>
		 * si la taille du composant à changer.
		 * </p>
		 * @see #size
		 */
		override public function get height () : Number { return _size ? _size.height : preferredHeight; }
		override public function set height (n : Number) : void
		{
			size = new Dimension( width, n );
		}
		/**
		 * Taille de ce composant.
		 * <p>
		 * Cette propriété est utilisé prioritairement par les objets layout lorsqu'ils
		 * ont déterminés la taille qu'un composant doit avoir dans le cadre de ce layout.
		 * </p>
		 * <p>
		 * <strong>Note :</strong> Il est important de se souvenir que la taille
		 * d'un composant ne peut en aucun cas être garantie. La propriété
		 * <code>size</code> renvoie la taille du composant à un instant t, cependant,
		 * définir la taille en utilisant la propriété <code>size</code> ne garantit
		 * pas qu'elle ne changera pas par la suite.
		 * </p>
		 * <p>
		 * <strong>Note : </strong> Il est vivement conseillé d'utiliser la propriété
		 * <code>preferredSize</code> plutôt que <code>size</code> pour définir une
		 * taille particulière pour un composant.
		 * </p>
		 * <p>
		 * <strong>Note : </strong> La modification de cette propriété conduit
		 * à la diffusion d'un évènement <code>PropertyEvent.PROPERTY_CHANGE</code>
		 * si la taille du composant à changer.
		 * </p>
		 * @see aesia.com.ponents.layouts.Layout
		 * @see ../../../../Components-Structure.html#layout Taille et layouts
		 */
		public function get size () : Dimension	{ return _size;	}
		public function set size (d : Dimension) : void
		{
			var oldw : Number;
			var oldh : Number;

			if( _size )
			{
				oldw = _integerForSpatialInformations ? Math.floor( _size.width ) : _size.width;
				oldh = _integerForSpatialInformations ? Math.floor( _size.height ) : _size.height;
			}

			_size = d ? new Dimension( _integerForSpatialInformations ? Math.floor( d.width ) : d.width,
								   	   _integerForSpatialInformations ? Math.floor( d.height ) : d.height ) :
						d;

			if( _size )
			{
				if( _size.width < 0 )
					_size.width = 0;

				if( _size.height < 0 )
					_size.height = 0;
			}
			fireResizeEventIfSizeChanged( oldw, oldh );			fireChangeEvent();
			invalidateIfSizeChanged( oldw, oldh );
		}
		/**
		 * Taille de préférence de ce composant.
		 * <p>
		 * La taille de préférence d'un composant peut être déterminés de deux manières :
		 * </p>
		 * <ul>
		 * <li>Par le composant lui même, à l'aide de son <code>Layout</code>.</li>
		 * <li>Par l'utilisateur du composant, à l'aide de la propriété <code>preferredSize</code></li>
		 * </ul>
		 * <p>
		 * Ma classe <code>AbstractComponent</code> privilégie toujours la taille définie
		 * par l'utilisateur lorsque on accède à sa taille de préférence. De même que,
		 * s'il possède un layout, il privilégie toujours la taille fournie
		 * par ce dernier si aucune taille n'est précisée par l'utilisateur.
		 * </p>
		 * <p>
		 * Le choix de la méthode de calcule de la taille de préférence, qu'il s'agisse
		 * d'un layout, ou autre, est laissé à la discretion des classes descendant de
		 * <code>AbstractComponent</code>
		 * </p>
		 * <p>
		 * <strong>Note : </strong> La modification de cette propriété conduit
		 * à la diffusion d'un évènement <code>PropertyEvent.PROPERTY_CHANGE</code>
		 * si la taille du composant à changer.
		 * </p>
		 * @see aesia.com.ponents.layouts.Layout
		 * @see ../../../../Components-Structure.html#layout Taille et layouts
		 */
		public function get preferredSize () : Dimension { return _preferredSize ? _preferredSize : _preferredSizeCache; }
		public function set preferredSize ( d : Dimension ) : void
		{
			var oldw : Number;
			var oldh : Number;

			if( _preferredSize )
			{
				oldw = _preferredSize.width;
				oldh = _preferredSize.height;
			}
			_preferredSize = d;
			fireResizeEventIfSizeChanged( oldw, oldh );
			fireChangeEvent();
			invalidateIfSizeChanged( oldw, oldh );
		}
		/**
		 * Longueur de préférence de ce composant.
		 * <p>
		 * <strong>Note : </strong> La modification de cette propriété conduit
		 * à la diffusion d'un évènement <code>PropertyEvent.PROPERTY_CHANGE</code>
		 * si la taille du composant à changer.
		 * </p>
		 * @see #preferredSize
		 */
		public function get preferredWidth () : Number { return preferredSize.width; }
		public function set preferredWidth ( n : Number) : void
		{
			preferredSize = new Dimension( n, preferredSize.height );
		}
		/**
		 * Hauteur de préférence de ce composant.
		 * <p>
		 * <strong>Note : </strong> La modification de cette propriété conduit
		 * à la diffusion d'un évènement <code>PropertyEvent.PROPERTY_CHANGE</code>
		 * si la taille du composant à changer.
		 * </p>
		 * @see #preferredSize
		 */
		public function get preferredHeight () : Number { return preferredSize.height; }
		public function set preferredHeight ( n : Number) : void
		{
			preferredSize = new Dimension( preferredSize.width, n );
		}
		/**
		 * Accès à l'objet <code>ComponentStyle</code> de ce composant.
		 * <p>
		 * Cette propriété n'est pas accessible en écriture car les objets
		 * <code>ComponentStyle</code> compose une chaîne afin de construire
		 * le style exploitable. Ainsi, en changeant uniquement la clé du style,
		 * il est possible de distinguer les modifications faites sur le composant
		 * de la racine du style de référence.
		 * </p>
		 */
		public function get style () : ComponentStyle { return _style; }
		/**
		 * La clé de l'objet <code>style</code> de ce composant.
		 * <p>
		 * Cette clé sert d'accès à la lignée hierarchique des styles.
		 * Un changement de cette propriété appel une invalidation complète
		 * de ce composant, c'est-à-dire avec un re-calcul de sa taille
		 * de préférence.
		 * </p>
		 * <p>
		 * <strong>Note : </strong> La modification de cette propriété conduit
		 * à la diffusion d'un évènement <code>PropertyEvent.PROPERTY_CHANGE</code>.
		 * </p>
		 * @see #style
		 */
		public function get styleKey () : String { return _style.defaultStyleKey; }
		public function set styleKey ( s : String ) : void
		{
			_style.defaultStyleKey = s;
			invalidatePreferredSizeCache();
			fireChangeEvent();
			firePropertyEvent( "styleKey", styleKey );
		}
		/**
		 * Référence à l'objet <code>FocusGroup</code> auquel le composant doit se référer
		 * lors de la navigation au clavier.
		 * <p>
		 * En général, le <code>focusParent</code> est le <code>Container</code> possédant
		 * le composant, mais ce n'est pas une règle absolue.
		 * </p>
		 * <p>
		 * <strong>Note : </strong> La modification de cette propriété conduit
		 * à la diffusion d'un évènement <code>PropertyEvent.PROPERTY_CHANGE</code>.
		 * </p>
		 */
		public function get focusParent () : FocusGroup	{ return _focusParent; }
		public function set focusParent ( parent : FocusGroup ) : void
		{
			_focusParent = parent;
			fireChangeEvent();
			firePropertyEvent( "focusParent", _focusParent );
		}
		/**
		 * Renvoie l'objet <code>Container</code> contenant actuellement
		 * le composant ou <code>null</code> s'il n'a aucun parent.
		 * <p>
		 * Le parent est determiné en remontant l'ensemble de la hierarchie
		 * graphique jusqu'au premier objet <code>Container</code>.
		 * </p>
		 */
		public function get parentContainer () : Container
		{
			var d : DisplayObjectContainer = this;
			do
			{
				if( d.parent )
				{
					d = d.parent;
					if( d is Container )
						return d as Container;
				}
				else
					d = null;
			}
			while( d );

			return null;
		}
		/**
		 * Une valeur booléenne indiquant si le composant est visible ou non.
		 * <p>
		 * À la différence de la propriété <code>visible</code>, la propriété
		 * <code>isVisible</code> prend en compte les parents de ce composant
		 * pour déterminer si celui-ci est visible ou non. Ainsi, si l'un de
		 * ces parents à sa propriété <code>visible</code> à <code>false</code>
		 * la propriété <code>isVisible</code> de ce composant sera elle aussi
		 * à <code>false</code>.
		 * </p>
		 */
		public function get isVisible () : Boolean
		{
			if( !visible )
				return false;

			var d : DisplayObjectContainer = this;
			do
			{
				if( d.parent )
				{
					d = d.parent;
					if( !d.visible )
						return false;
				}
				else
					d = null;
			}
			while( d );

			return true;
		}
		/**
		 * La valeur de décalage horizontal appliquer au contenu de ce composant.
		 * <p>
		 * <strong>Note : </strong> La modification de cette propriété conduit
		 * à la diffusion d'un évènement <code>PropertyEvent.PROPERTY_CHANGE</code>.
		 * </p>
		 */
		public function get contentScrollH () : Number { return _contentScrollH; }
		public function set contentScrollH (contentScrollH : Number) : void
		{
			_contentScrollH = contentScrollH;
			fireComponentEvent( ComponentEvent.SCROLL );
			invalidate( true );
			fireChangeEvent();
			firePropertyEvent( "contentScrollH", contentScrollH );
		}
		/**
		 * La valeur de décalage vertical appliquer au contenu de ce composant.
		 * <p>
		 * <strong>Note : </strong> La modification de cette propriété conduit
		 * à la diffusion d'un évènement <code>PropertyEvent.PROPERTY_CHANGE</code>.
		 * </p>
		 */
		public function get contentScrollV () : Number { return _contentScrollV; }
		public function set contentScrollV (contentScrollV : Number) : void
		{
			_contentScrollV = contentScrollV;
			fireComponentEvent( ComponentEvent.SCROLL );
			invalidate( true );
			fireChangeEvent();
			firePropertyEvent( "contentScrollV", contentScrollV );
		}
		/**
		 * La distance maximum de décalage vertical du contenu de ce composant.
		 * <p>
		 * Le calcul de la taille maximum est laissé à la discretion des classes
		 * descendantes de la classe <code>AbstractComponent</code>.
		 * </p>
		 */
		public function get maxContentScrollV () : Number { return 0; }
		/**
		 * La distance maximum de décalage horizontal du contenu de ce composant.
		 * <p>
		 * Le calcul de la taille maximum est laissé à la discretion des classes
		 * descendantes de la classe <code>AbstractComponent</code>.
		 * </p>
		 */
		public function get maxContentScrollH () : Number { return 0; }
		/**
		 * La zone visible du composant dans son espace de référence.
		 */
		public function get visibleArea () : Rectangle { return new Rectangle( 0, 0, width, height ); }
		/**
		 * La zone visible du composant dans l'espace de l'écran.
		 * <p>
		 * L'objet Rectangle est calculée en parcourant la hierarchie
		 * graphique du composant jusqu'à la racine, et en calculant
		 * les décalages et restrictions opérés sur le composant par
		 * ses parents.
		 * </p>
		 * @return zone visible du composant dans l'espace de l'écran
		 */
		public function get screenVisibleArea () : Rectangle
		{
			var r : Rectangle = visibleArea;
			var p : Container = parentContainer;
			var rp : Rectangle;

			if( _childrenContainer.scrollRect || !p )
			{
				r.x += x;
				r.y += y;
			}

			while( p )
			{
				rp = p.visibleArea;				r = r.intersection( rp );
				//r = intersection( r, rp );
				r.x += p.x;
				r.y += p.y;
				p = p.parentContainer;
			}

			return r;
		}
		/**
		 * État de transmission des évènements de type <code>MouseEvent.MOUSE_OVER</code>
		 * et <code>MouseEvent.MOUSE_OUT</code> aux parents graphiques de ce composant.
		 * <p>
		 * Placée cette valeur à <code>false</code> équivaut à empêcher toute remontée des évènements
		 * de survol du composant par la souris.
		 * </p>
		 *
		 * @default true
		 */
		public function get allowOverEventBubbling () : Boolean { return _allowOverEventBubbling; }
		public function set allowOverEventBubbling (allowOverEventBubbling : Boolean) : void
		{
			_allowOverEventBubbling = allowOverEventBubbling;
			fireChangeEvent();
		}
		/**
		 * État d'activation de la fonction de survol du composant par la souris.
		 * <p>
		 * Placée cette valeur à <code>false</code> fait que la propriété <code>_over</code>
		 * sera toujours à <code>false</code>. Tout les comportements associés seront donc
		 * désactivés à leur tour, notamment l'utilisation des états liés au survol
		 * de la souris dans les styles du composant.
		 * </p>
		 *
		 * @default true
		 * @see ../../../../Components-Structure.html#behavior Structure comportementale
		 */
		public function get allowOver () : Boolean { return _allowOver; }
		public function set allowOver (allowOver : Boolean) : void
		{
			_allowOver = allowOver;
			fireChangeEvent();
		}
		/**
		 * État d'activation de la fonction de sélection du composant.
		 * <p>
		 * Placée cette valeur à <code>false</code> fait que la propriété <code>_selected</code>
		 * sera toujours à <code>false</code>. Tout les comportements associés seront donc
		 * désactivés à leur tour, notamment l'utilisation des états liés à la sélection
		 * dans lol, vont tous finir avec des puces dans la tète!! moi jte ldis!! les styles du composant.
		 * </p>
		 *
		 * @default true
		 * @see ../../../../Components-Structure.html#behavior Structure comportementale
		 */
		public function get allowPressed () : Boolean { return _allowPressed; }
		public function set allowPressed (allowPressed : Boolean) : void
		{
			_allowPressed = allowPressed;
			fireChangeEvent();
		}
		/**
		 * État d'activation de la fonction de focus du composant.
		 * <p>
		 * Placée cette valeur à <code>false</code> fait que la propriété <code>_focus</code>
		 * sera toujours à <code>false</code>. Tout les comportements associés seront donc
		 * désactivés à leur tour, notamment l'utilisation des états liés au focus
		 * dans les styles du composant.
		 * </p>
		 *
		 * @default true
		 * @see ../../../../Components-Structure.html#behavior Structure comportementale
		 */
		public function get allowSelected () : Boolean { return _allowSelected;	}
		public function set allowSelected (allowSelected : Boolean) : void
		{
			_allowSelected = allowSelected;
			fireChangeEvent();
		}
		/**
		 * État d'activation de la fonction de focus du composant.
		 * <p>
		 * Placée cette valeur à <code>false</code> fait que la propriété <code>_focus</code>
		 * sera toujours à <code>false</code>. Tout les comportements associés seront donc
		 * désactivés à leur tour, notamment l'utilisation des états liés au focus
		 * dans les styles du composant.
		 * </p>
		 *
		 * @default true
		 * @see ../../../../Components-Structure.html#behavior Structure comportementale
		 */
		public function get allowFocus () : Boolean { return _allowFocus; }
		public function set allowFocus (allowFocus : Boolean) : void
		{
			_allowFocus = allowFocus;
			fireChangeEvent();
		}
		/**
		 * État d'activation de la fonction de transmissions du focus
		 * au enfants d'un composant.
		 * <p>
		 * Placée cette valeur à <code>false</code> permet de garantir
		 * qu'un focus placé sur le composant par une manipulation de
		 * l'utilisateur le sera sur le composant et non sur l'enfant qui
		 * aura déclencher réellement la prise de focus. Permettant de garantir
		 * que <code>stage.focus == this</code>.
		 * </p>
		 *
		 * @default true
		 * @see ../../../../Components-Structure.html#focus Transmission du focus
		 */
		public function get allowFocusTraversing () : Boolean { return _allowFocusTraversing; }
		public function set allowFocusTraversing (allowFocusTraversing : Boolean) : void
		{
			_allowFocusTraversing = allowFocusTraversing;
		}
		/**
		 * État d'activation de la fonction de masque du contenu du composant.
		 * <p>
		 * Placée cette valeur à <code>false</code> prévient la fonction dessin
		 * du composant d'utiliser la propriété <code>scrollRect</code> afin
		 * afin de réduire l'espace visible du contenu du composant à la zone
		 * prévue par sa taille et son style.
		 * Plus concrètement, si cette valeur est à <code>false</code> le contenu
		 * pourra apparaître en dehors du composant.
		 * </p>
		 *
		 * @default true
		 * @see ../../../../Components-Structure.html#graphics Structure graphique
		 */
		public function get allowMask () : Boolean { return _allowMask; }
		public function set allowMask ( allowMask : Boolean ) : void
		{
			_allowMask = allowMask;
			fireChangeEvent();
		}
		/**
		 * Renvoie <code>true</code> si la souris est actuellement au dessus de ce composant.
		 *
		 * @return <code>true</code> si la souris est actuellement au dessus de ce composant
		 */
		public function get isMouseOver () : Boolean { return _over; }

		/**
		 * Définit si ce composant autorise les intéractions.
		 * <p>Cette propriété sert essentiellement à désactiver tout les comportements
		 * d'un composant sans passer par la propriété <code>enabled</code>. Ainsi elle
		 * est utilisé dans la création d'éditeurs graphiques pour la manipulation des composants.</p>
		 *
		 * @default true
		 */
		public function get interactive () : Boolean { return _interactive; }
		public function set interactive (interactive : Boolean) : void
		{
			if( _interactive == interactive )
				return;

			_interactive = interactive;
			if( _displayed )
			{
				if( _interactive )
					registerToOnStageEvents();
				else
					unregisterFromOnStageEvents();
			}
			/*FDT_IGNORE*/ FEATURES::DND { /*FDT_IGNORE*/
			if( _dragGesture )
				_dragGesture.enabled = _interactive;
			/*FDT_IGNORE*/ } /*FDT_IGNORE*/
		}
		/**
		 * Si <code>true</code> ce composant est considéré comme un
		 * composant à part entière dans la hiérarchie, autrement, on
		 * considère qu'il fait partie d'un composant plus complexe et
		 * ne peut être distinguer de celui-ci.
		 * <p>
		 * Cette propriété est utilisée notament dans la fonction
		 * <code>firstIndependentComponent</code> qui remonte la structure
		 * graphique à partir d'un objet graphique quelquonque jusqu'au
		 * premier objet <code>Component</code> avec la propriété
		 * <code>isComponentIndependent</code> à <code>true</code>.
		 * </p>
		 *
		 * @default true
		 */
		public function get isComponentIndependent () : Boolean { return _isComponentLeaf; }
		public function set isComponentIndependent ( b : Boolean) : void
		{
			_isComponentLeaf = b;
		}

/*-----------------------------------------------------------------
 * 	FLUENT CODING METHODS
 *
 * 	Méthodes de modification fluides
 *----------------------------------------------------------------*/
		/**
		 * [fluent] Définie la taille de ce composant et renvoie une référence vers lui-même.
		 * <p>
		 * <strong>Note :</strong> Il est important de se souvenir que la taille
		 * d'un composant ne peut en aucun cas être garantie. La propriété
		 * <code>size</code> renvoie la taille du composant au moment de l'appel, cependant,
		 * définir la taille en utilisant la méthode <code>setSize</code> ne garantit
		 * pas qu'elle ne changera pas par la suite.
		 * </p>
		 * <p>
		 * <strong>Note : </strong> Il est vivement conseillé d'utiliser la propriété
		 * <code>setPreferredSize</code> plutôt que <code>setSize</code> pour définir une
		 * taille particulière pour un composant.
		 * </p>
		 * <p>
		 * <strong>Note : </strong> L'appel à cette méthode conduit
		 * à la diffusion d'un évènement <code>PropertyEvent.PROPERTY_CHANGE</code>
		 * si la taille du composant à changer.
		 * </p>
		 * @param	d	dimension du composant
		 * @return	une référence vers l'instance courante pour satisfaire l'interface fluide
		 * @see aesia.com.ponents.layouts.Layout
		 * @see ../../../../Components-Structure.html#layout Taille et layouts
		 */
		public function setSize ( d : Dimension ) : Component
		{
			size = d;
			return this;
		}
		/**
		 * [fluent] Définie la taille de ce composant et renvoie une référence vers lui-même.
		 * <p>
		 * <strong>Note :</strong> Il est important de se souvenir que la taille
		 * d'un composant ne peut en aucun cas être garantie. La propriété
		 * <code>size</code> renvoie la taille du composant à un instant t, cependant,
		 * définir la taille en utilisant la méthode <code>setSizeWH</code> ne garantit
		 * pas qu'elle ne changera pas par la suite.
		 * </p>
		 * <p>
		 * <strong>Note : </strong> Il est vivement conseillé d'utiliser la propriété
		 * <code>setPreferredSizeWH</code> plutôt que <code>setSizeWH</code> pour définir une
		 * taille particulière pour un composant.
		 * </p>
		 * <p>
		 * <strong>Note : </strong> L'appel à cette méthode conduit
		 * à la diffusion d'un évènement <code>PropertyEvent.PROPERTY_CHANGE</code>
		 * si la taille du composant à changer.
		 * </p>
		 * @param	w	nouvelle longueur du composant		 * @param	h	nouvelle hauteur du composant
		 * @return	une référence vers l'instance courante pour satisfaire l'interface fluide
		 * @see aesia.com.ponents.layouts.Layout
		 * @see ../../../../Components-Structure.html#layout Taille et layouts
		 */
		public function setSizeWH ( w : Number, h : Number ) : Component
		{
			size = new Dimension(w,h);
			return this;
		}
		/**
		 * [fluent] Définie la longueur de ce composant et renvoie une référence vers lui-même.
		 * <p>
		 * <strong>Note :</strong> Il est important de se souvenir que la taille
		 * d'un composant ne peut en aucun cas être garantie. La propriété
		 * <code>size</code> renvoie la taille du composant à un instant t, cependant,
		 * définir la taille en utilisant la méthode <code>setWidth</code> ne garantit
		 * pas qu'elle ne changera pas par la suite.
		 * </p>
		 * <p>
		 * <strong>Note : </strong> Il est vivement conseillé d'utiliser la propriété
		 * <code>setPreferredWidth</code> plutôt que <code>setWidth</code> pour définir une
		 * taille particulière pour un composant.
		 * </p>
		 * <p>
		 * <strong>Note : </strong> L'appel à cette méthode conduit
		 * à la diffusion d'un évènement <code>PropertyEvent.PROPERTY_CHANGE</code>
		 * si la taille du composant à changer.
		 * </p>
		 * @param	w	nouvelle longueur du composant
		 * @return	une référence vers l'instance courante pour satisfaire l'interface fluide
		 * @see aesia.com.ponents.layouts.Layout
		 * @see ../../../../Components-Structure.html#layout Taille et layouts
		 */
		public function setWidth ( d : Number ) : Component
		{
			width = d;
			return this;
		}
		/**
		 * [fluent] Définie la hauteur de ce composant et renvoie une référence vers lui-même.
		 * <p>
		 * <strong>Note :</strong> Il est important de se souvenir que la taille
		 * d'un composant ne peut en aucun cas être garantie. La propriété
		 * <code>size</code> renvoie la taille du composant à un instant t, cependant,
		 * définir la taille en utilisant la méthode <code>setHeight</code> ne garantit
		 * pas qu'elle ne changera pas par la suite.
		 * </p>
		 * <p>
		 * <strong>Note : </strong> Il est vivement conseillé d'utiliser la propriété
		 * <code>setPreferredHeight</code> plutôt que <code>setHeight</code> pour définir une
		 * taille particulière pour un composant.
		 * </p>
		 * <p>
		 * <strong>Note : </strong> L'appel à cette méthode conduit
		 * à la diffusion d'un évènement <code>PropertyEvent.PROPERTY_CHANGE</code>
		 * si la taille du composant à changer.
		 * </p>
		 * @param	h	nouvelle hauteur du composant
		 * @return	une référence vers l'instance courante pour satisfaire l'interface fluide
		 * @see aesia.com.ponents.layouts.Layout
		 * @see ../../../../Components-Structure.html#layout Taille et layouts
		 */
		public function setHeight ( d : Number ) : Component
		{
			height = d;
			return this;
		}
		/**
		 * [fluent] Définie la taille de préférence de ce composant.
		 *
		 * @param	d	nouvelle dimension de préférence du composant
		 * @return	une référence vers l'instance courante pour satisfaire l'interface fluide
		 * @see #preferredSize
		 * @see aesia.com.ponents.layouts.Layout
		 * @see ../../../../Components-Structure.html#layout Taille et layouts
		 */
		public function setPreferredSize ( d : Dimension ) : Component
		{
			preferredSize = d;
			return this;
		}
		/**
		 * [fluent] Définie la longueur de préférence de ce composant.
		 *
		 * @param	w	nouvelle longueur de préférence du composant
		 * @return	une référence vers l'instance courante pour satisfaire l'interface fluide
		 * @see #preferredWidth
		 * @see aesia.com.ponents.layouts.Layout
		 * @see ../../../../Components-Structure.html#layout Taille et layouts
		 */
		public function setPreferredWidth ( w : Number ) : Component
		{
			preferredWidth = w;
			return this;
		}
		/**
		 * [fluent] Définie la hauteur de préférence de ce composant.
		 *
		 * @param	w	nouvelle hauteur de préférence du composant
		 * @return	une référence vers l'instance courante pour satisfaire l'interface fluide
		 * @see #preferredHeight
		 * @see aesia.com.ponents.layouts.Layout
		 * @see ../../../../Components-Structure.html#layout Taille et layouts
		 */
		public function setPreferredHeight ( w : Number ) : Component
		{
			preferredWidth = w;
			return this;
		}
		/**
		 * [fluent] Définie la taille de préférence de ce composant.
		 *
		 * @param	w	nouvelle longueur de préférence du composant
		 * @param	h	nouvelle hauteur de préférence du composant
		 * @return	une référence vers l'instance courante pour satisfaire l'interface fluide
		 * @see #preferredSize
		 * @see aesia.com.ponents.layouts.Layout
		 * @see ../../../../Components-Structure.html#layout Taille et layouts
		 */
		public function setPreferredSizeWH ( w : Number, h : Number ) : Component
		{
			preferredSize = new Dimension(w,h);
			return this;
		}
		/**
		 * [fluent] Définie la clé de l'objet <code>style</code> de ce composant.
		 * <p>
		 * <strong>Note : </strong> La modification de cette propriété conduit
		 * à la diffusion d'un évènement <code>PropertyEvent.PROPERTY_CHANGE</code>.
		 * </p>
		 *
		 * @param	s	la nouvelle clé de style pour ce composant.
		 * @return	une référence vers l'instance courante pour satisfaire l'interface fluide
		 * @see #styleKey
		 */
		public function setStyleKey ( s : String ) : Component
		{
			styleKey = s;
			return this;
		}

/*-----------------------------------------------------------------
 * 	VALIDATION & REPAINT
 *----------------------------------------------------------------*/
		/**
		 * [fluent] Ajuste le décalage du contenu afin que le rectangle <code>r</code>
		 * soit visible.
		 *
		 * @param	r
		 * @return	une référence vers l'instance courante pour satisfaire l'interface fluide
		 */
		public function ensureRectIsVisible ( r : Rectangle ) : Component
		{
			if( r.y < contentScrollV )
				contentScrollV = r.y - _style.insets.top;
			else if( r.y + r.height > contentScrollV + height )
				contentScrollV = r.y + r.height - height + _style.insets.bottom;

			if( r.x < contentScrollH )
				contentScrollH = r.x - _style.insets.left;
			else if( r.x + r.width > contentScrollH + width )
				contentScrollH = r.x + r.width - width + _style.insets.right;

			return this;
		}
		/**
		 * Invalide le composant, le composant sera redessiné à la fin de la frame courante
		 * lors de la diffusion de l'évènement <code>Event.EXIT_FRAME</code>.
		 * <p>
		 * Si <code>asValidateRoot</code> est à <code>true</code> l'invalidation ne remontera
		 * pas la chaîne de container parent.
		 * </p>
		 * @param	asValidateRoot	si <code>true</code> l'invalidation ne remontera
		 * 							pas la chaîne de container parent
		 */
		public function invalidate ( asValidateRoot : Boolean = false ) : void
		{
			_validateRoot = asValidateRoot;
			checkState();
			//if( stage && visible )
			RepaintManagerInstance.invalidate( this );
		}
		/**
		 * Invalide et recalcule le cache de la taille de préférence calculée pour ce composant.
		 * <p>
		 * La méthode de calcul de la taille du composant est laissé à la discrétion des classes
		 * héritant de <code>AbstractComponent</code>.
		 * </p>
		 */
		public function invalidatePreferredSizeCache () : void
		{
			invalidate( false );
		}
		/**
		 * Compare les dimensions courante de l'objet avec les anciennes valeurs transmises
		 * en paramètres et invalide l'objet si celles-ci sont différentes.
		 * <p>
		 * Cette fonction est utile pour ne déclencher l'invalidation que si la taille finale
		 * du composant à changer.
		 * </p>
		 * @param	oldW	ancienne longueur à comparer à la longueur actuelle
		 * @param	oldH	ancienne hauteur à comparer à la hauteur actuelle
		 */
		protected function invalidateIfSizeChanged ( oldW : Number, oldH : Number ) : void
		{
			if( oldW != width || oldH != height )
			{
				firePropertyEvent( "size", new Dimension( width, height ) );
				invalidate();
			}
		}
		/**
		 * Renvoie <code>true</code> si le composant est actuellement la racine
		 * de revalidation.
		 */
		public function isValidateRoot () : Boolean
		{
			return _validateRoot;
		}
		/**
		 * Appelée lors de l'évènement <code>Event.EXIT_FRAME</code> afin de redessiner
		 * le composant.
		 * <p>
		 * Cette fonction fait appel à la méthode <code>_repaint</code> qui implémente
		 * concrètement la routine de dessin.
		 * </p>
		 * @see #_repaint()
		 */
		public function repaint () : void
		{
			var size : Dimension = calculateComponentSize();
			_repaint( size );
		}
		/**
		 * Déssine les élements de base du composant (arrière-plan et avant-plan),
		 * affecte les filtres internes et externes et applique le masque sur le
		 * contenu de ce composant.
		 * <p>
		 * <strong>Note : </strong> L'appel à cette méthode conduit
		 * à la diffusion d'un évènement <code>ComponentEvent.REPAINT</code>.
		 * </p>
		 * @param	size	la taille à laquelle dessiner le composant
		 */
		protected function _repaint ( size : Dimension, forceClear : Boolean = true ) : void
		{
			_validateRoot = true;
			
			if( forceClear )
			{
				_background.graphics.clear();				_foreground.graphics.clear();
			}
			else
			{
				clearBackgroundGraphics();				clearForegroundGraphics();
			}
			if( size )
			{
				_style.draw( new Rectangle( 0, 0, size.width, size.height ), _background.graphics, _foreground.graphics, this );
				var insets : Insets = _style.insets;
				filters = _style.outerFilters;
				_childrenContainer.filters = _style.innerFilters;

				applyMask( size, insets );
			}
			else
			{				_childrenContainer.scrollRect = null;
			}

			dispatchEvent( new ComponentEvent( ComponentEvent.REPAINT ) );
		}
		/**
		 * Applique le masque sur le contenu du composant. Le masque n'est appliquer
		 * que si la propriété <code>_allowMask</code> est à true.
		 *
		 * @param	size	taille du composant
		 * @param	insets	tailles des marges internes du style courant
		 */
		protected function applyMask ( size : Dimension, insets : Insets ) : void
		{
			if( _allowMask )
			{
				_childrenContainer.x = insets.left;
				_childrenContainer.y = insets.top;
				var w : Number = size.width - insets.horizontal;
				var h : Number = size.height - insets.vertical;

				if( w <= 0 || h <= 0 )
					_childrenContainer.scrollRect = new Rectangle();
				else
					_childrenContainer.scrollRect = new Rectangle( insets.left + _contentScrollH, insets.top + _contentScrollV, w, h );
			}
			else
				_childrenContainer.scrollRect = null;
		}
		/**
		 * Renvoie la taille finale de ce composant.
		 * <p>
		 * La taille finale est déterminé selon un ordre de priorité
		 * sur les différentes propriétés de taille du composant.
		 * Dans l'ordre ceci donne :
		 * </p>
		 * <ul>
		 * <li>Si <code>_size</code> est non nul, <code>_size</code> est renvoyée.</li>		 * <li>Si <code>_preferredSize</code> est non nul, <code>_preferredSize</code> est renvoyée.</li>		 * <li>Si <code>_preferredSizeCache</code> est non nul, <code>_preferredSizeCache</code> est renvoyée.</li>
		 * <li>Autrement, un nouvel objet <code>Dimension</code> vide est renvoyé.</li>
		 * </ul>
		 * @return la taille finale de ce composant
		 */
		protected function calculateComponentSize () : Dimension
		{
			return _size ?
						_size :
					  ( _preferredSize ?
							_preferredSize :
						  ( _preferredSizeCache ?
						  		_preferredSizeCache :
						  		new Dimension() ) );
		}
		/**
		 * Calcule l'état actuel du composant est met à jour le style en fonction.
		 * <p>
		 * Une description complète des états d'un composants ainsi que des transitions
		 * dans les états est disponible en annexe.
		 * </p>
		 * @see ../../../../Components-Structure.html#behavior Structure comportementale
		 */
		protected function checkState () : void
		{
			var s : uint = 0;
			if( !_enabled )
				s += ComponentStates.DISABLED;
			else
			{
				if( _pressed && _over && _allowPressed )
					s += ComponentStates.PRESSED;
				else if( _over && _allowOver )
					s += ComponentStates.OVER;

				if( _focus && _allowFocus )
					s += ComponentStates.FOCUS;
			}

			if( _selected && _allowSelected )
				s += ComponentStates.SELECTED;
			_style.currentState = s;
		}

/*-----------------------------------------------------------------
 * 	FOCUSABLE METHODS
 *
 * 	Implémentation de l'interface Focusable
 *----------------------------------------------------------------*/
		/**
		 * Place le focus sur le composant suivant. Le composant suivant
		 * est déterminé de deux façon :
		 * <ul>
		 * <li>Si le composant à une référence à un <code>FocusContainer</code>
		 * dans sa propriété <code>_focusParent</code> il relai l'appel vers
		 * la méthode <code>focusNextChild</code> de ce dernier.</li>
		 * <li>Autrement, le composant utilisera la méthode <code>findNextFocusable</code>
		 * pour trouver le prochain objet supportant le focus dans la display list.</li>
		 * </ul>
		 */
		public function focusNext () : void
		{
			if( _focusParent )
				_focusParent.focusNextChild( this );
			else
			{
				var id : Number = parent.getChildIndex( this );
				StageUtils.stage.focus = findNextFocusable( id + 1 );
			}
		}
		/**
		 * Place le focus sur le composant précédent. Le composant précédent
		 * est déterminé de deux façon :
		 * <ul>
		 * <li>Si le composant à une référence à un <code>FocusContainer</code>
		 * dans sa propriété <code>_focusParent</code> il relai l'appel vers
		 * la méthode <code>focusPreviousChild</code> de ce dernier.</li>
		 * <li>Autrement, le composant utilisera la méthode <code>findPreviousFocusable</code>
		 * pour trouver le précédent objet supportant le focus dans la display list.</li>
		 * </ul>
		 */
		public function focusPrevious () : void
		{
			if( _focusParent )
				_focusParent.focusPreviousChild( this );
			else
			{
				var id : Number = parent.getChildIndex( this );
				StageUtils.stage.focus = findPreviousFocusable( id );
			}
		}
		/**
		 * Renvoie <code>true</code> si le composant courant a actuellement le focus.
		 *
		 * @return	<code>true</code> si le composant courant a actuellement le focus
		 */
		public function hasFocus () : Boolean
		{
			return _focus;
		}
		/**
		 * Renvoie le prochain objet supportant le focus dans la display list.
		 * <p>
		 * La fonction parcours la hierarchie du composant à la recherche d'un
		 * objet <code>InteractiveObject</code> au même niveau que lui.
		 * </p>
		 */
		protected function findNextFocusable ( id : Number = 0 ) : InteractiveObject
		{
			var l : Number = parent.numChildren;
			for(var i : Number = 0; i < l; i++)
				if( parent.getChildAt( ( i + id ) % l ) is InteractiveObject )
					return parent.getChildAt( ( i + id ) % l ) as InteractiveObject;
			return null;
		}
		/**
		 * Renvoie le précédent objet supportant le focus dans la display list.
		 * <p>
		 * La fonction parcours la hierarchie du composant à la recherche d'un
		 * objet <code>InteractiveObject</code> au même niveau que lui.
		 * </p>
		 */
		protected function findPreviousFocusable ( id : Number = 0 ) : InteractiveObject
		{
			var l : Number = parent.numChildren;
			var _id : Number;

			for(var i : Number = 0; i < l; i--)
			{
				_id = ( l - 1 + ( id - i ) ) % l;
				if( parent.getChildAt( _id ) is InteractiveObject )
					return parent.getChildAt( _id ) as InteractiveObject;
			}

			return null;
		}
		/**
		 * Force la prise de focus par ce composant sans passé par une interaction.
		 */
		public function grabFocus () : void
		{
			StageUtils.stage.focus = this;
		}

/*-----------------------------------------------------------------
 * 	OTHER PUBLIC METHODS
 *----------------------------------------------------------------*/
		/**
		 * Renvoie la représentation de l'objet sous forme de chaîne.
		 *
		 * @return	la représentation de l'objet sous forme de chaîne
		 */
		override public function toString () : String
		{
			return getQualifiedClassName( this );
		}
		/**
		 * Renvoie <code>true</code> si le composant <code>c</code> est
		 * un ancêtre de ce composant, autrement <code>false</code>.
		 *
		 * @param	c	parent potentiel pour ce composant
		 * @return	<code>true</code> si le composant <code>c</code> est
		 * 			un ancêtre de ce composant, autrement <code>false</code>
		 */
		public function isAncestor ( c : Component ) : Boolean
		{
			var p : Component = parentContainer;

			while( p )
			{
				if( p == c )
					return true;
				else
					p = p.parentContainer;
			}
			return false;
		}
		/**
		 * Renvoie <code>true</code> si l'objet <code>child</code> est présent en tant qu'enfant
		 * de l'objet <code>_childrenContainer</code>.
		 * <p>
		 * <strong>Note : </strong>Cette fonction est un alias à la fonction <code>contains</code> du sous-objet
		 * <code>_childrenContainer</code>.
		 * </p>
		 *
		 * @param	child	DisplayObject dont on souhaite savoir si il est un enfant de ce composant
		 * @return	<code>true</code> si l'objet <code>child</code> est présent en tant qu'enfant
		 * 			de l'objet <code>_childrenContainer</code>
		 */
		protected function containsComponentChild (child : DisplayObject) : Boolean
		{
			return child != null && _childrenContainer.contains( child );
		}
		/**
		 * Ajoute le paramètre <code>child</code> en tant qu'enfant de l'objet <code>_childrenContainer</code>.
		 * <p>
		 * <strong>Note : </strong>Cette fonction est un alias à la fonction <code>addChild</code> du sous-objet
		 * <code>_childrenContainer</code>.
		 * </p>
		 *
		 * @param	child	enfant à ajouter dans le clip container de ce composant
		 */
		public function addComponentChild( child : DisplayObject ) : void
		{
			_childrenContainer.addChild( child );
		}
		/**
		 * Ajoute le paramètre <code>child</code> en tant qu'enfant de l'objet <code>_childrenContainer</code>
		 * à l'index précisé dans <code>index</code>.
		 * <p>
		 * <strong>Note : </strong>Cette fonction est un alias à la fonction <code>addChildAt</code> du sous-objet
		 * <code>_childrenContainer</code>.
		 * </p>
		 *
		 * @param	child	enfant à ajouter dans le clip container de ce composant
		 * @param	index	index d'insertion de cet enfant
		 */
		public function addComponentChildAt( child : DisplayObject, index : int ) : void
		{
			if( index < _childrenContainer.numChildren )
				_childrenContainer.addChildAt( child, index );
			else
				_childrenContainer.addChild( child );
		}
		/**
		 * Ajoute le paramètre <code>child</code> en tant qu'enfant de l'objet <code>_childrenContainer</code>
		 * à la suite de l'objet <code>after</code>.
		 *
		 * @param	child	enfant à ajouter dans le clip container de ce composant
		 * @param	after	objet après lequel insérer <code>child</code>
		 */
		public function addComponentChildAfter ( child : DisplayObject, after : DisplayObject ) : void
		{
			if( !containsComponentChild( after ) )
				return;

			var i : int = _childrenContainer.getChildIndex( after );
			if( i+1 >= _childrenContainer.numChildren )
				_childrenContainer.addChild( child );
			else
				_childrenContainer.addChildAt( child, i );
		}
		/**
		 * Ajoute le paramètre <code>child</code> en tant qu'enfant de l'objet <code>_childrenContainer</code>
		 * à l'index précédent celui de l'objet <code>before</code>.
		 *
		 * @param	child	enfant à ajouter dans le clip container de ce composant
		 * @param	before	objet avant lequel insérer <code>child</code>
		 */
		public function addComponentChildBefore ( child : DisplayObject, before : DisplayObject ) : void
		{
			if( !containsComponentChild( before ) )
				return;

			var i : int = _childrenContainer.getChildIndex( before );
			if( i-1 < 0 )
				_childrenContainer.addChildAt( child, 0 );
			else
				_childrenContainer.addChildAt(child, i-1);
		}
		/**
		 * Supprime l'objet de <code>child</code> des enfants de <code>_childrenContainer</code>.
		 * <p>
		 * <strong>Note : </strong>Cette fonction est un alias à la fonction <code>removeChild</code> du sous-objet
		 * <code>_childrenContainer</code>.
		 * </p>
		 * @param	child	objet à supprimer des enfants du clip container de ce composant
		 */
		public function removeComponentChild( child : DisplayObject ) : void
		{
			_childrenContainer.removeChild( child );
		}
		/**
		 * Supprime l'enfant de <code>_childrenContainer</code> situé à l'index <code>index</code>.
		 * <p>
		 * <strong>Note : </strong>Cette fonction est un alias à la fonction <code>removeChildAt</code> du sous-objet
		 * <code>_childrenContainer</code>.
		 * </p>
		 * @param	index	index de l'enfant à supprimer
		 */
		public function removeComponentChildAt( index : int ) : void
		{
			_childrenContainer.removeChildAt( index );
		}
		/**
		 * Modifie l'index de <code>child</code> dans la liste des enfants de <code>_childrenContainer</code>.
		 * <p>
		 * <strong>Note : </strong>Cette fonction est un alias à la fonction <code>setChildIndex</code> du sous-objet
		 * <code>_childrenContainer</code>.
		 * </p>
		 * @param	child	l'enfant dont on souhaite modifier l'index
		 * @param	index	nouvel index pour <code>child</code>
		 */
		public function setComponentChildIndex ( child : DisplayObject, index : int ) : void
		{
			if( !child || numChildren <= 1 )
				return;
			if( index >= numChildren )
				index = numChildren - 1;
			if( index < 0 )
				index = 0;
			_childrenContainer.setChildIndex( child, index );
		}
		/**
		 * Enlève ce composant de son parent.
		 * <p>
		 * Si le composant possède un <code>Container</code> parent,
		 * la méthode <code>removeComponent</code> est appelée sur celui-ci
		 * autrement, si le parent est un <code>DisplayObjectContainer</code>
		 * la méthode <code>removeChild</code> est utilisée.
		 * </p>
		 */
		public function remomeFromParent() : void
		{
			var p : Container =  parentContainer;
			if( p )
				p.removeComponent( this );
			else if( displayed )
				parent.removeChild( this );
		}

		/**
		 * @inheritDoc
		 */
		public function clearBackgroundGraphics () : void
		{
			if( !_backgroundCleared )
			{
				_background.graphics.clear();				_background.graphics.lineStyle();
				addEventListener(Event.EXIT_FRAME, exitFrame );
				_backgroundCleared = true;
			}
		}
		/**
		 * @inheritDoc
		 */
		public function clearForegroundGraphics () : void
		{
			if( !_foregroundCleared )
			{
				_foreground.graphics.clear();				_foreground.graphics.lineStyle();
				addEventListener(Event.EXIT_FRAME, exitFrame );
				_foregroundCleared = true;
			}
		}
		private function exitFrame (event : Event) : void
		{
			_backgroundCleared = false;
			_foregroundCleared = false;
			removeEventListener(Event.EXIT_FRAME, exitFrame );
		}

/*-----------------------------------------------------------------
 * 	EXTERNALIZABLE (experimental)
 *----------------------------------------------------------------*/
 		/**
 		 * Implémentation de l'interface <code>Externalizable</code>
 		 * <p>
 		 * Cette fonction n'est acutellement pas utilisée.
 		 * </p>
 		 */
 		public function readExternal (input : IDataInput) : void
		{}
		/**
 		 * Implémentation de l'interface <code>Externalizable</code>
 		 * <p>
 		 * Cette fonction n'est acutellement pas utilisée.
 		 * </p>
 		 */
		public function writeExternal (output : IDataOutput) : void
		{}

/*-----------------------------------------------------------------
 * 	CONDITIONAL COMPILE RELATED
 *
 * 	L'ensemble des éléments soumis à la compilation conditionnelle,
 * 	regroupés par fonctionnalités.
 *----------------------------------------------------------------*/
/*-----------------------------------------------------------------
 * 	TOOLTIP
 *----------------------------------------------------------------*/
		/*FDT_IGNORE*/ FEATURES::TOOLTIP { /*FDT_IGNORE*/
		/**
		 * [conditional-compile] Texte HTML à utiliser comme message de l'info-bulle de ce composant.
		 * <p>
		 * <strong>Note :</strong> Cette fonction est soumise à la constante
		 * <a href="../../../../Conditional-Compilation.html#TOOLTIP">FEATURES::TOOLTIP</a>
		 * dans le cadre de la <a href="../../../../Conditional-Compilation.html">compilation conditionnelle</a>.
		 * Veillez donc à conditionner l'usage de cette fonctionnalité à l'usage de la constante de compilation associée.
		 * </p>
		 * @default null
		 * @see ../../../../Conditional-Compilation.html#TOOLTIP Constante FEATURES::TOOLTIP
		 */
		protected var _tooltip : String;
		/**
		 * [conditional-compile] Texte HTML défini par l'utilisateur à utiliser comme message
		 * de l'info-bulle de ce composant. L'info-bulle défini par l'utilisateur sera toujours préféré
		 * à la valeur définie dans <code>_tooltip</code>.
		 * <p>
		 * <strong>Note :</strong> Cette fonction est soumise à la constante
		 * <a href="../../../../Conditional-Compilation.html#TOOLTIP">FEATURES::TOOLTIP</a>
		 * dans le cadre de la <a href="../../../../Conditional-Compilation.html">compilation conditionnelle</a>.
		 * Veillez donc à conditionner l'usage de cette fonctionnalité à l'usage de la constante de compilation associée.
		 * </p>
		 * @default null
		 * @see ../../../../Conditional-Compilation.html#TOOLTIP Constante FEATURES::TOOLTIP
		 */
		protected var _userTooltip : String;

		/**
		 * [conditional-compile] Texte HTML défini par l'utilisateur à utiliser comme message
		 * de l'info-bulle de ce composant. L'info-bulle défini par l'utilisateur sera toujours préféré
		 * à la valeur définie dans <code>_tooltip</code>.
		 * <p>
		 * Si aucune info-bulle utilisateur n'est définie pour ce composant le getter renvoie la valeur
		 * de <code>_tooltip</code>.
		 * </p>
		 * <p>
		 * <strong>Note :</strong> Cette fonction est soumise à la constante
		 * <a href="../../../../Conditional-Compilation.html#TOOLTIP">FEATURES::TOOLTIP</a>
		 * dans le cadre de la <a href="../../../../Conditional-Compilation.html">compilation conditionnelle</a>.
		 * Veillez donc à conditionner l'usage de cette fonctionnalité à l'usage de la constante de compilation associée.
		 * </p>
		 * @see ../../../../Conditional-Compilation.html#TOOLTIP Constante FEATURES::TOOLTIP
		 */
		public function get tooltip () : String { return _userTooltip ? _userTooltip : _tooltip; }
		public function set tooltip (tooltip : String) : void
		{
			_userTooltip = tooltip;
			firePropertyEvent("tooltip", _userTooltip );
		}
		/**
		 * [conditional-compile] Déclenche l'affichage de l'info-bulle de ce composant.
		 * L'info-bulle ne s'affichera pas si aucune valeur n'est définie dans <code>tooltip</code>
		 * ou si la valeur est une chaîne vide.
		 * <p>
		 * L'argument <code>overlay</code> détermine si l'info-bulle vient se superposer
		 * au composant ou si elle se positionne relativement à la souris.
		 * </p>
		 * <p>
		 * <strong>Note :</strong> Cette fonction est soumise à la constante
		 * <a href="../../../../Conditional-Compilation.html#TOOLTIP">FEATURES::TOOLTIP</a>
		 * dans le cadre de la <a href="../../../../Conditional-Compilation.html">compilation conditionnelle</a>.
		 * Veillez donc à conditionner l'usage de cette fonctionnalité à l'usage de la constante de compilation associée.
		 * </p>
		 *
		 * @param overlay 	détermine si l'info-bulle vient se superposer
		 * 					au composant ou si elle se positionne relativement à la souris
		 * @see ../../../../Conditional-Compilation.html#TOOLTIP Constante FEATURES::TOOLTIP
		 */
		public function showToolTip ( overlay : Boolean = false ) : void
		{
			if( _userTooltip )
				ToolTipInstance.show( _userTooltip, null, overlay ? _tooltipOverlayTarget ? _tooltipOverlayTarget : this : null );
			else if( _tooltip )
				ToolTipInstance.show( _tooltip, null, overlay ? _tooltipOverlayTarget ? _tooltipOverlayTarget : this : null );
		}
		/**
		 * [conditional-compile] Masque l'info-bulle de ce composant.
		 * <p>
		 * <strong>Note :</strong> Cette fonction est soumise à la constante
		 * <a href="../../../../Conditional-Compilation.html#TOOLTIP">FEATURES::TOOLTIP</a>
		 * dans le cadre de la <a href="../../../../Conditional-Compilation.html">compilation conditionnelle</a>.
		 * Veillez donc à conditionner l'usage de cette fonctionnalité à l'usage de la constante de compilation associée.
		 * </p>
		 *
		 * @see ../../../../Conditional-Compilation.html#TOOLTIP Constante FEATURES::TOOLTIP
		 */
		public function hideToolTip () : void
		{
			if( _tooltip || _userTooltip )
				ToolTipInstance.hide();
		}
		/*FDT_IGNORE*/ } /*FDT_IGNORE*/

/*-----------------------------------------------------------------
 * 	CURSOR
 *----------------------------------------------------------------*/
		/*FDT_IGNORE*/ FEATURES::CURSOR { /*FDT_IGNORE*/
		/**
		 * [conditional-compile] Référence à l'objet <code>Cursor</code> utilisé lorsque la souris survole
		 * ce composant.
		 * <p>
		 * <strong>Note :</strong> Cette fonction est soumise à la constante
		 * <a href="../../../../Conditional-Compilation.html#CURSOR">FEATURES::CURSOR</a>
		 * dans le cadre de la <a href="../../../../Conditional-Compilation.html">compilation conditionnelle</a>.
		 * Veillez donc à conditionner l'usage de cette fonctionnalité à l'usage de la constante de compilation associée.
		 * </p>
		 *
		 * @default null
		 * @see ../../../../Conditional-Compilation.html#CURSOR Constante FEATURES::CURSOR
		 */
		protected var _cursor : Cursor;
		/**
		 * [conditional-compile] Référence à l'objet <code>Cursor</code> utilisé lorsque la souris survole
		 * ce composant.
		 * <p>
		 * <strong>Note :</strong> Cette fonction est soumise à la constante
		 * <a href="../../../../Conditional-Compilation.html#CURSOR">FEATURES::CURSOR</a>
		 * dans le cadre de la <a href="../../../../Conditional-Compilation.html">compilation conditionnelle</a>.
		 * Veillez donc à conditionner l'usage de cette fonctionnalité à l'usage de la constante de compilation associée.
		 * </p>
		 *
		 * @see ../../../../Conditional-Compilation.html#CURSOR Constante FEATURES::CURSOR
		 */
		public function get cursor () : Cursor { return _cursor; }
		public function set cursor (cursor : Cursor) : void
		{
			_cursor = cursor;
			if( _over && _enabled )
				Cursor.setCursor( _cursor );

			fireChangeEvent( );
			firePropertyEvent( "cursor", cursor );
		}

		/**
		 * [conditional-compile] Vaut <code>true</code> si le composant à un curseur spécifique de défini.
		 * <p>
		 * <strong>Note :</strong> Cette fonction est soumise à la constante
		 * <a href="../../../../Conditional-Compilation.html#CURSOR">FEATURES::CURSOR</a>
		 * dans le cadre de la <a href="../../../../Conditional-Compilation.html">compilation conditionnelle</a>.
		 * Veillez donc à conditionner l'usage de cette fonctionnalité à l'usage de la constante de compilation associée.
		 * </p>
		 *
		 * @see ../../../../Conditional-Compilation.html#CURSOR Constante FEATURES::CURSOR
		 */
		public function get hasCursor () : Boolean { return _cursor != null; }
		/*FDT_IGNORE*/ } /*FDT_IGNORE*/

/*-----------------------------------------------------------------
 *  DRAG AND DROP
 *----------------------------------------------------------------*/
 		/*FDT_IGNORE*/ FEATURES::DND { /*FDT_IGNORE*/
 		/**
 		 * [conditional-compile] La référence vers l'objet <code>DragGesture</code> utilisé par ce composant.
 		 * <p>
		 * <strong>Note :</strong> Cette fonction est soumise à la constante
		 * <a href="../../../../Conditional-Compilation.html#DND">FEATURES::DND</a>
		 * dans le cadre de la <a href="../../../../Conditional-Compilation.html">compilation conditionnelle</a>.
		 * Veillez donc à conditionner l'usage de cette fonctionnalité à l'usage de la constante de compilation associée.
		 * </p>
		 * @default null
		 * @see ../../../../Conditional-Compilation.html#DND Constante FEATURES::DND
 		 */
 		protected var _dragGesture : DragGesture;
 		/**
 		 * [conditional-compile] Une valeur booléenne indiquant si le composant autorise
 		 * les manipulations de glisser/déposer (Drag And Drop).
 		 * <p>
		 * <strong>Note :</strong> Cette fonction est soumise à la constante
		 * <a href="../../../../Conditional-Compilation.html#DND">FEATURES::DND</a>
		 * dans le cadre de la <a href="../../../../Conditional-Compilation.html">compilation conditionnelle</a>.
		 * Veillez donc à conditionner l'usage de cette fonctionnalité à l'usage de la constante de compilation associée.
		 * </p>
		 *
		 * @see ../../../../Conditional-Compilation.html#DND Constante FEATURES::DND
 		 */
 		protected var _allowDrag : Boolean;
 		/**
 		 * [conditional-compile] Retroune un objet <code>Transferable</code> contenant les informations susceptibles
 		 * d'être utilisé dans les différentes opérations de glisser/déposer de ce composant.
 		 * <p>
 		 * Par défaut la propriété <code>transferData</code> renvoie un nouvel objet <code>ComponentTransferable</code>
 		 * dont la cible est le composant lui même. Ainsi, par défaut, un composant qui se voit affecter un objet
 		 * <code>DragGesture</code> et dont la propriété <code>allowDrag</code> est à <code>true</code> peut être déplacé
 		 * vers n'importe quel container supportant le glisser/déposer de composants (<code>ToolBar</code> ou
 		 * <code>MultiSplitPane</code> par exemple).
 		 * </p>
 		 * <p>
		 * <strong>Note :</strong> Cette fonction est soumise à la constante
		 * <a href="../../../../Conditional-Compilation.html#DND">FEATURES::DND</a>
		 * dans le cadre de la <a href="../../../../Conditional-Compilation.html">compilation conditionnelle</a>.
		 * Veillez donc à conditionner l'usage de cette fonctionnalité à l'usage de la constante de compilation associée.
		 * </p>
		 *
		 * @see ../../../../Conditional-Compilation.html#DND Constante FEATURES::DND
 		 */
 		public function get transferData () : Transferable { return new ComponentTransferable( this ); }
		/**
		 * [conditional-compile] Une référence vers le <code>DisplayObject</code> qui sera utilisé comme apparence
		 * pour les phases de glisser/déposer.
 		 * <p>
		 * <strong>Note :</strong> Cette fonction est soumise à la constante
		 * <a href="../../../../Conditional-Compilation.html#DND">FEATURES::DND</a>
		 * dans le cadre de la <a href="../../../../Conditional-Compilation.html">compilation conditionnelle</a>.
		 * Veillez donc à conditionner l'usage de cette fonctionnalité à l'usage de la constante de compilation associée.
		 * </p>
		 *
		 * @see ../../../../Conditional-Compilation.html#DND Constante FEATURES::DND
		 */
		public function get dragGeometry () : DisplayObject { return this; }
		/**
		 * [conditional-compile] Une référence vers l'objet <code>InteractiveObject</code> qui sera utilisé comme déclencheur
		 * des opérations de glisser/déposer.
		 * <p>
		 * Généralement les objets <code>DragGesture</code> vont utiliser l'objet fourni dans <code>dragGestureGeometry</code>
		 * comme source des évènements de souris déclenchant les opérations de glisser/déposer. Cet objet doit donc hériter de
		 * la classe <code>InteractiveObject</code> et doit pouvoir diffuser ses évènements (<code>mouseEnabled=true</code> et
		 * <code>mouseChildren=true</code> au niveau du composant).
		 * </p>
 		 * <p>
		 * <strong>Note :</strong> Cette fonction est soumise à la constante
		 * <a href="../../../../Conditional-Compilation.html#DND">FEATURES::DND</a>
		 * dans le cadre de la <a href="../../../../Conditional-Compilation.html">compilation conditionnelle</a>.
		 * Veillez donc à conditionner l'usage de cette fonctionnalité à l'usage de la constante de compilation associée.
		 * </p>
		 *
		 * @see ../../../../Conditional-Compilation.html#DND Constante FEATURES::DND
		 */
		public function get dragGestureGeometry () : InteractiveObject { return this; }

		/**
		 * [conditional-compile] Une valeur booléenne indiquant si ce composant supporte les opérations
		 * de glisser/déposer.
		 * <p>
		 * <strong>Note :</strong> La présence d'un objet <code>DragGesture</code> pour ce composant ne
		 * garantit en rien que le composant pourra initier des opérations de glisser/déposer. Les
		 * objets <code>DragGesture</code> prennent en compte la valeur de la propriété <code>allowDrag</code>
		 * pour déterminer si une opération de glisser/déposer peut ête inité pour ce composant.
		 * </p>
 		 * <p>
		 * <strong>Note :</strong> Cette fonction est soumise à la constante
		 * <a href="../../../../Conditional-Compilation.html#DND">FEATURES::DND</a>
		 * dans le cadre de la <a href="../../../../Conditional-Compilation.html">compilation conditionnelle</a>.
		 * Veillez donc à conditionner l'usage de cette fonctionnalité à l'usage de la constante de compilation associée.
		 * </p>
		 *
		 * @see ../../../../Conditional-Compilation.html#DND Constante FEATURES::DND
		 */
		public function get allowDrag () : Boolean { return _allowDrag; }
		public function set allowDrag (b : Boolean) : void
		{
			_allowDrag = b;
		}
		/**
		 * [conditional-compile] L'objet <code>DragGesture</code> en charge du déclenchement des opérations
		 * de glisser/déposer pour ce composant.
		 * <p>
		 * <strong>Note :</strong> La présence d'un objet <code>DragGesture</code> pour ce composant ne
		 * garantit en rien que le composant pourra initier des opérations de glisser/déposer. Les
		 * objets <code>DragGesture</code> prennent en compte la valeur de la propriété <code>allowDrag</code>
		 * pour déterminer si une opération de glisser/déposer peut ête inité pour ce composant.
		 * </p>
 		 * <p>
		 * <strong>Note :</strong> Cette fonction est soumise à la constante
		 * <a href="../../../../Conditional-Compilation.html#DND">FEATURES::DND</a>
		 * dans le cadre de la <a href="../../../../Conditional-Compilation.html">compilation conditionnelle</a>.
		 * Veillez donc à conditionner l'usage de cette fonctionnalité à l'usage de la constante de compilation associée.
		 * </p>
		 *
		 * @see ../../../../Conditional-Compilation.html#DND Constante FEATURES::DND
		 */
		public function get gesture () : DragGesture { return _dragGesture; }
		public function set gesture (gesture : DragGesture) : void
		{
			if( _dragGesture )
				_dragGesture.target = null;

			_dragGesture = gesture;

			if( _dragGesture )
			{
				_dragGesture.target = this;
				_dragGesture.enabled = _interactive;
			}


		}
 		/*FDT_IGNORE*/ } /*FDT_IGNORE*/
/*-----------------------------------------------------------------
 *  KEYBOARD CONTEXT
 *----------------------------------------------------------------*/
		/*FDT_IGNORE*/ FEATURES::KEYBOARD_CONTEXT { /*FDT_IGNORE*/
		/**
		 * [conditional-compile] Un dictionnaire contenant les associations
		 * <code>KeyStroke -> Command</code> à utiliser pour ce composant.
		 * <p>
		 * <strong>Note :</strong> Cette fonction est soumise à la constante
		 * <a href="../../../../Conditional-Compilation.html#KEYBOARD_CONTEXT">FEATURES::KEYBOARD_CONTEXT</a>
		 * dans le cadre de la <a href="../../../../Conditional-Compilation.html">compilation conditionnelle</a>.
		 * Veillez donc à conditionner l'usage de cette fonctionnalité à l'usage de la constante de compilation associée.
		 * </p>
		 *
		 * @see ../../../../Conditional-Compilation.html#KEYBOARD_CONTEXT Constante FEATURES::KEYBOARD_CONTEXT
		 */
		protected var _keyboardContext : Dictionary;
		/**
		 * [conditional-compile] Un dictionnaire contenant les associations
		 * <code>KeyStroke -> Command</code> à utiliser pour ce composant.
		 * <p>
		 * <strong>Note :</strong> Cette fonction est soumise à la constante
		 * <a href="../../../../Conditional-Compilation.html#KEYBOARD_CONTEXT">FEATURES::KEYBOARD_CONTEXT</a>
		 * dans le cadre de la <a href="../../../../Conditional-Compilation.html">compilation conditionnelle</a>.
		 * Veillez donc à conditionner l'usage de cette fonctionnalité à l'usage de la constante de compilation associée.
		 * </p>
		 *
		 * @see ../../../../Conditional-Compilation.html#KEYBOARD_CONTEXT Constante FEATURES::KEYBOARD_CONTEXT
		 */
		public function get keyboardContext () : Dictionary	{ return _keyboardContext; }
		/*FDT_IGNORE*/ } /*FDT_IGNORE*/

/*-----------------------------------------------------------------
 * 	CONTEXTUAL MENU
 *----------------------------------------------------------------*/
		/*FDT_IGNORE*/ FEATURES::MENU_CONTEXT { /*FDT_IGNORE*/
		/**
		 * [conditional-compile] Un objet contenant des paires clés-$gt;valeurs où une clé représente
		 * le nom d'un groupe de menus contextuels et la valeur un tableau contenant les objets <code>ContextMenuItem</code>.
		 * <p>
		 * Chaque groupe de menus sera séparé par un séparateur une fois ajoutés dans le menu contextuel de ce composant.
		 * </p>
		 * <p>
		 * <strong>Note :</strong> Cette fonction est soumise à la constante
		 * <a href="../../../../Conditional-Compilation.html#MENU_CONTEXT">FEATURES::MENU_CONTEXT</a>
		 * dans le cadre de la <a href="../../../../Conditional-Compilation.html">compilation conditionnelle</a>.
		 * Veillez donc à conditionner l'usage de cette fonctionnalité à l'usage de la constante de compilation associée.
		 * </p>
		 *
		 * @see ../../../../Conditional-Compilation.html#MENU_CONTEXT Constante FEATURES::MENU_CONTEXT
		 */
		protected var _menuContextGroups : Object;
		/**
		 * [conditional-compile] Un tableau déterminant l'ordre d'affichage dans le menu contextuel de chaque groupe
		 * de menus.
		 * <p>
		 * <strong>Note :</strong> Cette fonction est soumise à la constante
		 * <a href="../../../../Conditional-Compilation.html#MENU_CONTEXT">FEATURES::MENU_CONTEXT</a>
		 * dans le cadre de la <a href="../../../../Conditional-Compilation.html">compilation conditionnelle</a>.
		 * Veillez donc à conditionner l'usage de cette fonctionnalité à l'usage de la constante de compilation associée.
		 * </p>
		 *
		 * @see ../../../../Conditional-Compilation.html#MENU_CONTEXT Constante FEATURES::MENU_CONTEXT
		 */
		protected var _menuContextOrder : Array;
		/**
		 * [conditional-compile] Un objet permettant d'associer une entrée du menu contextuel à un identifiant,
		 * afin de pouvoir le récupérer par la suite.
		 * <p>
		 * <strong>Note :</strong> Cette fonction est soumise à la constante
		 * <a href="../../../../Conditional-Compilation.html#MENU_CONTEXT">FEATURES::MENU_CONTEXT</a>
		 * dans le cadre de la <a href="../../../../Conditional-Compilation.html">compilation conditionnelle</a>.
		 * Veillez donc à conditionner l'usage de cette fonctionnalité à l'usage de la constante de compilation associée.
		 * </p>
		 *
		 * @see ../../../../Conditional-Compilation.html#MENU_CONTEXT Constante FEATURES::MENU_CONTEXT
		 */
		protected var _menuContextMap : Object;
		protected var _menuContextEnabledMap : Dictionary;
		/**
		 * [conditional-compile] Un objet contenant des paires clés-$gt;valeurs où une clé représente
		 * le nom d'un groupe de menus contextuels et la valeur un tableau contenant les objets <code>ContextMenuItem</code>.
		 * <p>
		 * Chaque groupe de menus sera séparé par un séparateur une fois ajoutés dans le menu contextuel de ce composant.
		 * </p>
		 * <p>
		 * <strong>Note :</strong> Cette fonction est soumise à la constante
		 * <a href="../../../../Conditional-Compilation.html#MENU_CONTEXT">FEATURES::MENU_CONTEXT</a>
		 * dans le cadre de la <a href="../../../../Conditional-Compilation.html">compilation conditionnelle</a>.
		 * Veillez donc à conditionner l'usage de cette fonctionnalité à l'usage de la constante de compilation associée.
		 * </p>
		 *
		 * @see ../../../../Conditional-Compilation.html#MENU_CONTEXT Constante FEATURES::MENU_CONTEXT
		 */
		public function get menuContextGroups () : Object { return _menuContextGroups; }		public function set menuContextGroups ( o : Object ): void
		{
			_menuContextGroups = o;
		}
		/**
		 * [conditional-compile] Un tableau déterminant l'ordre d'affichage dans le menu contextuel de chaque groupe
		 * de menus.
		 * <p>
		 * <strong>Note :</strong> Cette fonction est soumise à la constante
		 * <a href="../../../../Conditional-Compilation.html#MENU_CONTEXT">FEATURES::MENU_CONTEXT</a>
		 * dans le cadre de la <a href="../../../../Conditional-Compilation.html">compilation conditionnelle</a>.
		 * Veillez donc à conditionner l'usage de cette fonctionnalité à l'usage de la constante de compilation associée.
		 * </p>
		 *
		 * @see ../../../../Conditional-Compilation.html#MENU_CONTEXT Constante FEATURES::MENU_CONTEXT
		 */		public function get menuContextOrder () : Array { return _menuContextOrder; }		public function set menuContextOrder ( a : Array ) : void
		{
			_menuContextOrder = a;
		}
		/**
		 * [conditional-compile] Un vecteur contenant les objets <code>ContextMenuItem</code> à afficher
		 * dans le menu contextuel de ce composant.
		 * <p>
		 * Le vecteur est constitué à l'aide des groupes de menus définis dans la propriété
		 * <code>menuContextGroups</code>, les groupes étant affichés dans l'ordre déterminé dans la propriété
		 * <code>menuContextOrder</code>. Les premières entrées de menu de chaque groupe verront leur propriété
		 * <code>separatorBefore</code> automatiquement mise à <code>true</code> lors de la constitution du vecteur.
		 * </p>
		 * <p>
		 * Un groupe qui serait présent dans <code>menuContextGroups</code> mais dont le nom ne figurerait pas dans
		 * <code>menuContextOrder</code> ne sera pas visible dans le vecteur <code>menuContext</code>.
		 * </p>
		 * <p>
		 * <strong>Note :</strong> Cette fonction est soumise à la constante
		 * <a href="../../../../Conditional-Compilation.html#MENU_CONTEXT">FEATURES::MENU_CONTEXT</a>
		 * dans le cadre de la <a href="../../../../Conditional-Compilation.html">compilation conditionnelle</a>.
		 * Veillez donc à conditionner l'usage de cette fonctionnalité à l'usage de la constante de compilation associée.
		 * </p>
		 *
		 * @see ../../../../Conditional-Compilation.html#MENU_CONTEXT Constante FEATURES::MENU_CONTEXT
		 */
		public function get menuContext () : Vector.<ContextMenuItem>
		{
			var l : uint = _menuContextOrder.length;

			var v : Vector.<ContextMenuItem> = new Vector.<ContextMenuItem> ();

			for( var i:int=0;i<l;i++)
			{
				var contextGroup : Array = _menuContextGroups[ _menuContextOrder[i] ] as Array;
				if( contextGroup )
				{
					var m : uint = contextGroup.length;
					for(var j:int=0;j<m;j++)
					{
						var cmi : ContextMenuItem = contextGroup[j];
						cmi.separatorBefore = i!=0 && j==0;

						v.push( cmi );
					}
				}
			}
			return v;
		}		/**
		 * [conditional-compile] Affecte les menus définis dans ce composant en tant que menus à afficher.
		 *
		 * <p>
		 * <strong>Note :</strong> Cette fonction est soumise à la constante
		 * <a href="../../../../Conditional-Compilation.html#MENU_CONTEXT">FEATURES::MENU_CONTEXT</a>
		 * dans le cadre de la <a href="../../../../Conditional-Compilation.html">compilation conditionnelle</a>.
		 * Veillez donc à conditionner l'usage de cette fonctionnalité à l'usage de la constante de compilation associée.
		 * </p>
		 *
		 * @see ../../../../Conditional-Compilation.html#MENU_CONTEXT Constante FEATURES::MENU_CONTEXT
		 */
		protected function setContextMenu () : void
		{
			var v : Vector.<ContextMenuItem> = menuContext;
			var l : Number = v.length;
			for( var i : Number = 0; i < l; i++ )
			{
				var cmi : ContextMenuItem = v[ i ];
				cmi.enabled = _menuContextEnabledMap[cmi] && _enabled;
			}
			StageUtils.setMenus( v );
		}
		/**
		 * [conditional-compile] Enlève les menus définis dans ce composant en tant que menus à afficher.
		 *
		 * <p>
		 * <strong>Note :</strong> Cette fonction est soumise à la constante
		 * <a href="../../../../Conditional-Compilation.html#MENU_CONTEXT">FEATURES::MENU_CONTEXT</a>
		 * dans le cadre de la <a href="../../../../Conditional-Compilation.html">compilation conditionnelle</a>.
		 * Veillez donc à conditionner l'usage de cette fonctionnalité à l'usage de la constante de compilation associée.
		 * </p>
		 *
		 * @see ../../../../Conditional-Compilation.html#MENU_CONTEXT Constante FEATURES::MENU_CONTEXT
		 */
		protected function unsetContextMenu () : void
		{
			StageUtils.unsetMenus();
		}
		/**
		 * [conditional-compile] Construit un nouvel objet <code>ContextMenuItem</code> pour cette instance et le
		 * place dans la liste des menus contextuels ainsi que dans son groupe de référence.
		 * <p>
		 * Si le groupe précisé n'existe pas, il sera crée. Le paramètre <code>groupOrder</code>
		 * sera uniquement utilisé lors de la création du groupe.
		 * </p>
		 * <p>
		 * <strong>Note :</strong> Cette fonction est soumise à la constante
		 * <a href="../../../../Conditional-Compilation.html#MENU_CONTEXT">FEATURES::MENU_CONTEXT</a>
		 * dans le cadre de la <a href="../../../../Conditional-Compilation.html">compilation conditionnelle</a>.
		 * Veillez donc à conditionner l'usage de cette fonctionnalité à l'usage de la constante de compilation associée.
		 * </p>
		 *
		 * @param	label			le texte du menu contextuel
		 * @param	id				l'identifiant de ce menu
		 * @param	selectCallBack	la fonction à appeler lors de la sélection du menu
		 * @param	group			le nom du groupe auquel le menu appartient
		 * @param	groupOrder		l'index du groupe dans la liste des groupes
		 * @param	disabled		détermine si le menu est désactivé au départ
		 * @return	le menu contextuel nouvellement crée
		 * @see ../../../../Conditional-Compilation.html#MENU_CONTEXT Constante FEATURES::MENU_CONTEXT
		 */
		public function addNewContextMenuItemForGroup ( label : String,
													    id : String,
													    selectCallBack : Function = null,
													    group : String = "default",
													    groupOrder : int = -1,
													    disabled : Boolean = false ) : ContextMenuItem
		{


			var menu : ContextMenuItem = new ContextMenuItem( label, false, !disabled );

			if( selectCallBack != null )
				menu.addEventListener( ContextMenuEvent.MENU_ITEM_SELECT, selectCallBack, false, 0, true );

			_menuContextMap[id] = menu;
			_menuContextEnabledMap[ menu ] = !disabled;
			registerContextMenuItemForGroup( menu, group, groupOrder);

			return menu;
		}
		/**
		 * [conditional-compile] Ajoute une instance de la classe <code>ContextMenuItem</code> déjà éxistante
		 * dans le groupe correspondant de cette instance.
		 * <p>
		 * <strong>Note :</strong> Cette fonction est soumise à la constante
		 * <a href="../../../../Conditional-Compilation.html#MENU_CONTEXT">FEATURES::MENU_CONTEXT</a>
		 * dans le cadre de la <a href="../../../../Conditional-Compilation.html">compilation conditionnelle</a>.
		 * Veillez donc à conditionner l'usage de cette fonctionnalité à l'usage de la constante de compilation associée.
		 * </p>
		 *
		 * @param	menu		le menu à enregistrer
		 * @param	id			l'identifiant du menu
		 * @param	group		l'identifiant du groupe
		 * @param	groupOrder	l'index du groupe dans la liste des groupes
		 * @param	disabled	le menu est-il désactivé
		 * @see ../../../../Conditional-Compilation.html#MENU_CONTEXT Constante FEATURES::MENU_CONTEXT
		 */
		public function addContextMenuItemForGroup ( menu : ContextMenuItem,
													 id : String,
													 group : String = "default",
													 groupOrder : int = -1,
													 disabled : Boolean = false ) : void
		{
			_menuContextMap[id] = menu;
			_menuContextEnabledMap[ menu ] = !disabled;
			registerContextMenuItemForGroup( menu, group, groupOrder);
		}
		/**
		 * [conditional-compile] Enregistre un menu contextuel comme faisant partie du groupe <code>group</code>.
		 * <p>
		 * Si le groupe précisé n'existe pas, il sera crée. Le paramètre <code>groupOrder</code>
		 * sera uniquement utilisé lors de la création du groupe.
		 * </p><p>
		 * Si le menu contextuel ne fait pas déjà partie du dictionnaire des menus contextuels pour
		 * cette instance il est conseillé de ne pas utiliser cette méthode, mais d'utiliser la méthode
		 * <code>addNewContextMenuItemForGroup</code>.
		 * </p><p>
		 * <strong>Note :</strong> Cette fonction est soumise à la constante
		 * <a href="../../../../Conditional-Compilation.html#MENU_CONTEXT">FEATURES::MENU_CONTEXT</a>
		 * dans le cadre de la <a href="../../../../Conditional-Compilation.html">compilation conditionnelle</a>.
		 * Veillez donc à conditionner l'usage de cette fonctionnalité à l'usage de la constante de compilation associée.
		 * </p>
		 *
		 * @param	menu		le menu à enregistrer
		 * @param	group		l'identifiant du groupe
		 * @param	groupOrder	l'index du groupe dans la liste des groupes
		 * @see ../../../../Conditional-Compilation.html#MENU_CONTEXT Constante FEATURES::MENU_CONTEXT
		 */
		public function registerContextMenuItemForGroup ( menu : ContextMenuItem, group : String, groupOrder : int = -1 ) : void
		{
			var menuGroup : Array;
			if( !hasContextMenuItemGroup( group ) )
			{
				menuGroup = [];
				_menuContextGroups[ group ] = menuGroup;
				if( groupOrder != -1 && groupOrder < _menuContextOrder.length )
					_menuContextOrder.splice( groupOrder, 0, group );
				else
					_menuContextOrder.push( group );
			}
			else
				menuGroup = _menuContextGroups[ group ];

			menuGroup.push( menu );
		}
		/**
		 * [conditional-compile] Supprime un menu contextuel d'un groupe.
		 * <p>
		 * Toutefois, le menu n'est pas supprimé de la liste des menus contextuels, il est
		 * donc toujours accessible via la méthode <code>getContextMenuItem()</code>.
		 * </p><p>
		 * <strong>Note :</strong> Cette fonction est soumise à la constante
		 * <a href="../../../../Conditional-Compilation.html#MENU_CONTEXT">FEATURES::MENU_CONTEXT</a>
		 * dans le cadre de la <a href="../../../../Conditional-Compilation.html">compilation conditionnelle</a>.
		 * Veillez donc à conditionner l'usage de cette fonctionnalité à l'usage de la constante de compilation associée.
		 * </p>
		 *
		 * @param	id				l'identifiant du menu contextuel
		 * @param	group			l'identifiant du groupe
		 * @throws Error Impossible de supprimer un menu contextuel qui n'existe pas.
		 * @see ../../../../Conditional-Compilation.html#MENU_CONTEXT Constante FEATURES::MENU_CONTEXT
		 */
		public function removeContextMenuItemFromGroup( id : String, group : String ) : void
		{
			var cmi : ContextMenuItem = getContextMenuItem( id );
			if( !cmi )
				throw new Error (_$(_("Impossible de supprimer un menu contextuel qui n'existe pas : $0" ), id));

			if( groupContainsContextMenuItem( id, group ) )
				_menuContextGroups[group].splice( _menuContextGroups[group].indexOf( cmi ), 1 );
		}
		/**
		 * [conditional-compile] Place un menu contextuel déjà créer dans le groupe cible.
		 * <p>
		 * Si le menu fait déjà d'un groupe et le paramètre <code>forceMove</code> est à <code>false</code>
		 * une erreur est levée.
		 * </p><p>
		 * <strong>Note :</strong> Cette fonction est soumise à la constante
		 * <a href="../../../../Conditional-Compilation.html#MENU_CONTEXT">FEATURES::MENU_CONTEXT</a>
		 * dans le cadre de la <a href="../../../../Conditional-Compilation.html">compilation conditionnelle</a>.
		 * Veillez donc à conditionner l'usage de cette fonctionnalité à l'usage de la constante de compilation associée.
		 * </p>
		 *
		 * @param	id			l'identifiant du menu contextuel		 * @param	group		le nom du groupe cible		 * @param	forceMove	force le déplacement du menu si celui-ci est déja présent
		 * 						dans un autre groupe
		 * @throws Error Impossible de manipuler un menu inexistant.		 * @throws Error Le groupe cible 'group' n'existe pas.		 * @throws Error Impossible de déplacer le menu 'id' car il est déjà contenu dans le groupe 'group'.
		 * @see ../../../../Conditional-Compilation.html#MENU_CONTEXT Constante FEATURES::MENU_CONTEXT
		 */
		public function putContextMenuItemInGroup( id : String, group : String, forceMove : Boolean = true ) : void
		{
			if( !hasContextMenuItem(id) )
				throw new Error(_$( _("Impossible de manipuler un menu inexistant : $0."), id ));
			if( !menuContextGroups.hasOwnProperty( group ) )
				throw new Error(_$(_("Le groupe cible '$0' n'existe pas."), group ));
			if( isContextMenuItemContainedInGroup(id) )
			{
				if( !forceMove )
					throw new Error(_$(_("Impossible de déplacer le menu '$0' car il est déjà contenu dans le groupe '$1'."),
									id, getContextMenuItemGroup(id) ));

				removeContextMenuItemFromGroup( id, getContextMenuItemGroup(id) );
			}
			registerContextMenuItemForGroup( getContextMenuItem( id ), group );
		}
		/**
		 * [conditional-compile] Supprime un menu contextuel de cette instance, et donc du groupe auquel il appartient
		 * si celui-ci est présent dans un groupe.
		 * <p>
		 * <strong>Note :</strong> Cette fonction est soumise à la constante
		 * <a href="../../../../Conditional-Compilation.html#MENU_CONTEXT">FEATURES::MENU_CONTEXT</a>
		 * dans le cadre de la <a href="../../../../Conditional-Compilation.html">compilation conditionnelle</a>.
		 * Veillez donc à conditionner l'usage de cette fonctionnalité à l'usage de la constante de compilation associée.
		 * </p>
		 *
		 * @param	id				l'identifiant du menu contextuel
		 * @throws Error Impossible de supprimer un menu contextuel qui n'existe pas.
		 * @see ../../../../Conditional-Compilation.html#MENU_CONTEXT Constante FEATURES::MENU_CONTEXT
		 */
		public function removeContextMenuItem ( id : String ) : void
		{
			if( !hasContextMenuItem( id ) )
				throw new Error (_$(_("Impossible de supprimer un menu contextuel qui n'existe pas : $0" ), id));

			if( isContextMenuItemContainedInGroup(id) )
				removeContextMenuItemFromGroup( id, getContextMenuItemGroup( id ) );

			delete _menuContextMap[id];
		}
		/**
		 * [conditional-compile] Vide un groupe de menu contextuels des menus qu'il
		 * contient. 
		 * <p>
		 * <strong>Note :</strong> Cette fonction est soumise à la constante
		 * <a href="../../../../Conditional-Compilation.html#MENU_CONTEXT">FEATURES::MENU_CONTEXT</a>
		 * dans le cadre de la <a href="../../../../Conditional-Compilation.html">compilation conditionnelle</a>.
		 * Veillez donc à conditionner l'usage de cette fonctionnalité à l'usage de la constante de compilation associée.
		 * </p>
		 *
		 * @param	group	l'identifiant du groupe
		 * @see ../../../../Conditional-Compilation.html#MENU_CONTEXT Constante FEATURES::MENU_CONTEXT
		 */
		public function cleanContextMenuItemGroup ( group : String ) : void
		{
			if( hasContextMenuItemGroup( group ) )
			{
				var l : uint = _menuContextGroups[group].length;
				while(l--)
					removeContextMenuItem( getContextMenuItemId( _menuContextGroups[group][l] ) );
			}
		}
		/**
		 * [conditional-compile] Renvoie <code>true</code> si le menu contextuel identifié
		 * par <code>id</code> et contenu dans un groupe.
		 * <p>
		 * <strong>Note :</strong> Cette fonction est soumise à la constante
		 * <a href="../../../../Conditional-Compilation.html#MENU_CONTEXT">FEATURES::MENU_CONTEXT</a>
		 * dans le cadre de la <a href="../../../../Conditional-Compilation.html">compilation conditionnelle</a>.
		 * Veillez donc à conditionner l'usage de cette fonctionnalité à l'usage de la constante de compilation associée.
		 * </p>
		 *
		 * @param	id	l'identifiant du menu
		 * @return	<code>true</code> si le menu contextuel identifié
		 * 			par <code>id</code> et contenu dans un groupe
		 * @see ../../../../Conditional-Compilation.html#MENU_CONTEXT Constante FEATURES::MENU_CONTEXT
		 */
		public function isContextMenuItemContainedInGroup ( id : String ) : Boolean
		{
			return getContextMenuItemGroup(id) != null;
		}
		/**
		 * [conditional-compile] Renvoie le nom du groupe contenant
		 * le menu contextuel identifié par <code>id</code>.
		 * <p>
		 * <strong>Note :</strong> Cette fonction est soumise à la constante
		 * <a href="../../../../Conditional-Compilation.html#MENU_CONTEXT">FEATURES::MENU_CONTEXT</a>
		 * dans le cadre de la <a href="../../../../Conditional-Compilation.html">compilation conditionnelle</a>.
		 * Veillez donc à conditionner l'usage de cette fonctionnalité à l'usage de la constante de compilation associée.
		 * </p>
		 *
		 * @param	id	l'identifiant du menu
		 * @return	le nom du groupe contenant le menu contextuel identifié par <code>id</code>
		 * @see ../../../../Conditional-Compilation.html#MENU_CONTEXT Constante FEATURES::MENU_CONTEXT
		 */
		public function getContextMenuItemGroup ( id : String ) : String
		{
			for( var i : String in _menuContextGroups )
				if( groupContainsContextMenuItem( id, i ) )
					return i;

			return null;
		}
		/**
		 * [conditional-compile] Renvoie <code>true</code> si le groupe <code>group</code>
		 * contient le menu contextuel identifié par <code>id</code>.
		 * <p>
		 * <strong>Note :</strong> Cette fonction est soumise à la constante
		 * <a href="../../../../Conditional-Compilation.html#MENU_CONTEXT">FEATURES::MENU_CONTEXT</a>
		 * dans le cadre de la <a href="../../../../Conditional-Compilation.html">compilation conditionnelle</a>.
		 * Veillez donc à conditionner l'usage de cette fonctionnalité à l'usage de la constante de compilation associée.
		 * </p>
		 *
		 * @param	id		identifiant du menu contextuel
		 * @param	group	identifiant du groupe de menus contextuel
		 * @return	<code>true</code> si le groupe <code>group</code> contient le menu contextuel
		 * 			identifié par <code>id</code>
		 * @throws Error Le groupe 'group' n'existe pas dans la listes des groupes de cette instance.
		 * @see ../../../../Conditional-Compilation.html#MENU_CONTEXT Constante FEATURES::MENU_CONTEXT
		 */
		public function groupContainsContextMenuItem ( id : String, group : String ) : Boolean
		{
			if( !hasContextMenuItemGroup( group ) )
				throw new Error ( _$(_("Le groupe '$0' n'existe pas dans la liste des groupes pour cette instance $1." ), group, this ) );

			return _menuContextGroups[group].indexOf( getContextMenuItem( id ) ) != -1;
		}
		/**
		 * [conditional-compile] Renvoie le menu contextuel enregistré
		 * avec l'identifiant <code>id</code> si il en existe un, sinon renvoie <code>null</code>.
		 * <p>
		 * <strong>Note :</strong> Cette fonction est soumise à la constante
		 * <a href="../../../../Conditional-Compilation.html#MENU_CONTEXT">FEATURES::MENU_CONTEXT</a>
		 * dans le cadre de la <a href="../../../../Conditional-Compilation.html">compilation conditionnelle</a>.
		 * Veillez donc à conditionner l'usage de cette fonctionnalité à l'usage de la constante de compilation associée.
		 * </p>
		 *
		 * @param	id	l'identifiant du menu contextuel
		 * @return	le menu contextuel enregistré avec l'identifiant <code>id</code>
		 * 			si il en existe un, sinon renvoie <code>null</code>
		 * @see ../../../../Conditional-Compilation.html#MENU_CONTEXT Constante FEATURES::MENU_CONTEXT
		 */
		public function getContextMenuItem ( id : String ) : ContextMenuItem
		{
			if( hasContextMenuItem( id ) )
				return _menuContextMap[id];
			else
				return null;
		}
		/**
		 * [conditional-compile] Renvoie l'identifiant d'un menu contextuel présent dans 
		 * cette instance.
		 * <p>
		 * <strong>Note :</strong> Cette fonction est soumise à la constante
		 * <a href="../../../../Conditional-Compilation.html#MENU_CONTEXT">FEATURES::MENU_CONTEXT</a>
		 * dans le cadre de la <a href="../../../../Conditional-Compilation.html">compilation conditionnelle</a>.
		 * Veillez donc à conditionner l'usage de cette fonctionnalité à l'usage de la constante de compilation associée.
		 * </p>
		 *
		 * @param	menu	le menu dont on souhaite connaître l'identifiant
		 * @return	l'identifiant d'un menu contextuel présent dans 
		 * 			cette instance
		 * @see ../../../../Conditional-Compilation.html#MENU_CONTEXT Constante FEATURES::MENU_CONTEXT
		 */
		public function getContextMenuItemId ( menu : ContextMenuItem ) : String 
		{
			for( var i : String in _menuContextMap )
				if( _menuContextMap[ i ] == menu )
					return i;
			
			return null;
		}
		/**
		 * [conditional-compile] Renvoie <code>true</code> si un menu contextuel
		 * est enregistré avec l'identifiant <code>id</code> dans cette instance.
		 * <p>
		 * <strong>Note :</strong> Cette fonction est soumise à la constante
		 * <a href="../../../../Conditional-Compilation.html#MENU_CONTEXT">FEATURES::MENU_CONTEXT</a>
		 * dans le cadre de la <a href="../../../../Conditional-Compilation.html">compilation conditionnelle</a>.
		 * Veillez donc à conditionner l'usage de cette fonctionnalité à l'usage de la constante de compilation associée.
		 * </p>
		 *
		 * @param	id	l'identifiant du menu contextuel
		 * @return	<code>true</code> si un menu contextuel est enregistré avec
		 * 			l'identifiant <code>id</code> dans cette instance
		 * @see ../../../../Conditional-Compilation.html#MENU_CONTEXT Constante FEATURES::MENU_CONTEXT
		 */
		public function hasContextMenuItem ( id : String ) : Boolean
		{
			return _menuContextMap.hasOwnProperty( id );
		}
		/**
		 * [conditional-compile] Renvoie <code>true</code> si un groupe de menu
		 * contextuels existe avec ce nom dans cette instance.
		 * <p>
		 * <strong>Note :</strong> Cette fonction est soumise à la constante
		 * <a href="../../../../Conditional-Compilation.html#MENU_CONTEXT">FEATURES::MENU_CONTEXT</a>
		 * dans le cadre de la <a href="../../../../Conditional-Compilation.html">compilation conditionnelle</a>.
		 * Veillez donc à conditionner l'usage de cette fonctionnalité à l'usage de la constante de compilation associée.
		 * </p>
		 *
		 * @param	id	l'identifiant du menu contextuel
		 * @return	 <code>true</code> si un groupe de menu
		 * 			 contextuels existe avec ce nom dans cette instance
		 * @see ../../../../Conditional-Compilation.html#MENU_CONTEXT Constante FEATURES::MENU_CONTEXT
		 */
		public function hasContextMenuItemGroup ( group : String ) : Boolean
		{
			return _menuContextGroups.hasOwnProperty( group );
		}
		/**
		 * [conditional-compile] Change le texte du menu contextuel
		 * identifié par la chaîne <code>id</code>.
		 * <p>
		 * <strong>Note :</strong> Cette fonction est soumise à la constante
		 * <a href="../../../../Conditional-Compilation.html#MENU_CONTEXT">FEATURES::MENU_CONTEXT</a>
		 * dans le cadre de la <a href="../../../../Conditional-Compilation.html">compilation conditionnelle</a>.
		 * Veillez donc à conditionner l'usage de cette fonctionnalité à l'usage de la constante de compilation associée.
		 * </p>
		 *
		 * @param	id			l'identifiant du menu contextuel
		 * @param	newCaption 	le nouveau texte pour ce menu
		 * @see ../../../../Conditional-Compilation.html#MENU_CONTEXT Constante FEATURES::MENU_CONTEXT
		 */
		public function setContextMenuItemCaption ( id : String, newCaption : String ) : void
		{
			if( hasContextMenuItem( id ) )
				getContextMenuItem( id ).caption = newCaption;
		}
		/**
		 * [conditional-compile] Change l'état d'activation du menu contextuel
		 * identifié par la chaîne <code>id</code>.
		 * <p>
		 * <strong>Note :</strong> Cette fonction est soumise à la constante
		 * <a href="../../../../Conditional-Compilation.html#MENU_CONTEXT">FEATURES::MENU_CONTEXT</a>
		 * dans le cadre de la <a href="../../../../Conditional-Compilation.html">compilation conditionnelle</a>.
		 * Veillez donc à conditionner l'usage de cette fonctionnalité à l'usage de la constante de compilation associée.
		 * </p>
		 *
		 * @param	id		l'identifiant du menu contextuel
		 * @param	enabled le nouvel état du menu
		 * @see ../../../../Conditional-Compilation.html#MENU_CONTEXT Constante FEATURES::MENU_CONTEXT
		 */
		public function setContextMenuItemEnabled ( id : String, enabled : Boolean ) : void
		{
			if( hasContextMenuItem( id ) )
				_menuContextEnabledMap[ getContextMenuItem( id ) ] = enabled;
		}
		/*FDT_IGNORE*/ } /*FDT_IGNORE*/
/*-----------------------------------------------------------------
 * 	EVENTS HANDLERS
 *----------------------------------------------------------------*/
		/**
		 * Recoit l' évènement de type <code>PropertyEvent.PROPERTY_CHANGE</code>
		 * de ce composant.
		 *
		 * @param	e	évènement diffusé par l'objet
		 */
		protected function propertyChange (e : PropertyEvent) : void
		{
		}
		/**
		 * Reçoit l'évènement <code>click</code> de ce composant. Cet évènement
		 * n'est pas le même que l'évènement <code>MouseEvent.CLICK</code> de ce
		 * composant. En fait, la fonction <code>click</code> est appelée par le
		 * composant lors de l'évènement <code>MouseEvent.MOUSE_UP</code> selon
		 * l'état du composant. Si celui-ci est désactivé, il n'exécutera pas l'appel
		 * à la fonction <code>click</code>.
		 *
		 * @param	e	évènement diffusé par l'objet
		 */
		public function click ( e : Event = null ) : void
		{
		}
		/**
		 * De même que la fonction <code>click</code>, la fonction <code>releaseOutside</code>
		 * est appeler par l'objet lors d'un click à l'éxtérieur après une pression au dessus
		 * du composant.
		 *
		 * @param	e	évènement diffusé par l'objet
		 */
		public function releaseOutside ( e : MouseEvent = null ) : void
		{
		}
		/**
		 * Recoit l'évènement de type <code>MouseEvent.MOUSE_DOWN</code>
		 * de ce composant.
		 * <p>
		 * Le composant passe dans l'état <code>PRESSED</code> à l'issue
		 * de l'appel à la fonction.
		 * </p>
		 *
		 * @param	e	évènement diffusé par l'objet
		 */
		public function mouseDown ( e : MouseEvent ) : void
		{
			if( _enabled )
			{
				_pressed = true;
				if( _allowPressed )
					invalidate( true );

				if( this.stage )
					this.stage.addEventListener( MouseEvent.MOUSE_UP, mouseUp );
			}
		}
		/**
		 * Recoit l'évènement de type <code>MouseEvent.MOUSE_UP</code>
		 * de ce composant.
		 * <p>
		 * Si le relâchement du bouton de la souris se produit à l'éxtérieur
		 * du composant, la fonction appelle <code>releaseOutside</code>, sinon
		 * elle appelle la fonction <code>click</code>
		 * </p>
		 * <p>
		 * Le composant sort de l'état <code>PRESSED</code> à l'issue
		 * de l'appel à la fonction.
		 * </p>
		 * @param	e	évènement diffusé par l'objet
		 */
		public function mouseUp ( e : MouseEvent ) : void
		{
			if( _enabled )
			{
				if( _pressed && _over )
				{
					click( e );
					/*FDT_IGNORE*/ FEATURES::TOOLTIP { /*FDT_IGNORE*/
						hideToolTip();
					/*FDT_IGNORE*/ } /*FDT_IGNORE*/
				}
				else if( !_over )
				{
					/*FDT_IGNORE*/ FEATURES::CURSOR { /*FDT_IGNORE*/
					if( hasCursor )
						Cursor.restoreCursor();
					/*FDT_IGNORE*/ } /*FDT_IGNORE*/

					if( this.stage )
						this.stage.removeEventListener( MouseEvent.MOUSE_UP, mouseUp );

					releaseOutside( e );
					dispatchEvent( new ComponentEvent( ComponentEvent.RELEASE_OUTSIDE ) );
				}
				_pressed = false;

				if( _allowPressed )
					invalidate( true );
			}
		}
		/**
		 * Recoit l'évènement de type <code>MouseEvent.MOUSE_OUT</code>
		 * de ce composant.
		 * <p>
		 * Le composant sort de l'état <code>OVER</code>, l'infobulle est masquée,
		 * le curseur par défaut est restauré, et le menu contextuel néttoyé à l'issue
		 * de l'appel à la fonction.
		 * </p>
		 * @param	e	évènement diffusé par l'objet
		 */
		public function mouseOut ( e : MouseEvent ) : void
		{
			if( _enabled )
			{
				_over = false;
				if( _pressed )
					if( this.stage )
						this.stage.addEventListener( MouseEvent.MOUSE_UP, mouseUp );

				/*FDT_IGNORE*/ FEATURES::CURSOR { /*FDT_IGNORE*/
				if( !_pressed )
					Cursor.restoreCursor();
				/*FDT_IGNORE*/ } /*FDT_IGNORE*/

				if( _allowOver )
					invalidate( true );
			}
			/*FDT_IGNORE*/ FEATURES::MENU_CONTEXT { /*FDT_IGNORE*/
			unsetContextMenu();
			/*FDT_IGNORE*/ } /*FDT_IGNORE*/

			if( !_allowOverEventBubbling )
				e.stopPropagation();

			/*FDT_IGNORE*/ FEATURES::TOOLTIP { /*FDT_IGNORE*/
			hideToolTip();
			/*FDT_IGNORE*/ } /*FDT_IGNORE*/
		}
		/**
		 * Recoit l'évènement de type <code>MouseEvent.MOUSE_OVER</code>
		 * de ce composant.
		 * <p>
		 * Le composant passe dans l'état <code>PRESSED</code>, l'infobulle
		 * est affichée, le curseur du composant afficher et le menu
		 * contextuel modifié à l'issue de l'appel à la fonction.
		 * </p>
		 * @param	e	évènement diffusé par l'objet
		 */
		public function mouseOver ( e : MouseEvent ) : void
		{
			if( _enabled )
			{
				_over = true;
				if( this.stage )
					this.stage.removeEventListener( MouseEvent.MOUSE_UP, mouseUp );

				/*FDT_IGNORE*/ FEATURES::CURSOR { /*FDT_IGNORE*/
				if( hasCursor )
					Cursor.setCursor( _cursor );
				else
					Cursor.restoreCursor();
				/*FDT_IGNORE*/ } /*FDT_IGNORE*/

				if( _allowOver )
					invalidate( true );
			}
			/*FDT_IGNORE*/ FEATURES::MENU_CONTEXT { /*FDT_IGNORE*/
				setContextMenu();
			/*FDT_IGNORE*/ } /*FDT_IGNORE*/

			if( !_allowOverEventBubbling )
				e.stopPropagation();

			/*FDT_IGNORE*/ FEATURES::TOOLTIP { /*FDT_IGNORE*/
			if( _tooltipOverlayOnMouseOver )
				showToolTip( true );
			else
				showToolTip();
			/*FDT_IGNORE*/ } /*FDT_IGNORE*/
		}
		/**
		 * Recoit l'évènement de type <code>MouseEvent.MOUSE_MOVE</code>
		 * de ce composant.
		 *
		 * @param	e	évènement diffusé par l'objet
		 */
		public function mouseMove ( e : MouseEvent ) : void
		{
		}
		/**
		 * Recoit l'évènement de type <code>FocusEvent.FOCUS_IN</code>
		 * de ce composant.
		 * <p>
		 * La gestion concrète de la prise de focus est réalisée dans la méthode
		 * <code>_focusIn</code>.
		 * </p>
		 * @param	e	évènement diffusé par l'objet
		 * @see #_focusIn()
		 */
		public function focusIn ( e : FocusEvent ) : void
		{
			_focusIn( e );
		}
		/**
		 * Implémente la routine concrète de prise de focus.
		 * <p>
		 * Si le composant est actif (<code>enabled = true</code>)
		 * et qu'il autorise la remontée de focus
		 * (<code>_allowFocusTraversing = true</code>),
		 * le composant passe dans l'état <code>FOCUS</code>.
		 * Autrement, le composant interrompt la diffusion de l'évènement.
		 * </p>
		 * <p>
		 * Si le composant est désactivé le focus est automatiquement placé
		 * sur le composant précédent ou suivant selon la valeur de
		 * <code>e.shiftKey</code>.
		 * </p>
		 * @param	e	évènement diffusé par l'objet
		 */
		protected function _focusIn ( e : FocusEvent ) : void
		{

			if( !_allowFocusTraversing )
				e.stopPropagation();

			if( !_enabled )
			{				e.stopPropagation();

				if( e.shiftKey )
					focusPrevious();
				else
					focusNext();
				return;
			}
			_focus = true;
			fireChangeEvent();
			if( _allowFocus )
				invalidate( true );
		}
		/**
		 * Recoit l'évènement de type <code>FocusEvent.FOCUS_OUT</code>
		 * de ce composant.
		 * <p>
		 * La gestion concrète de la perte de focus est réalisée dans la méthode
		 * <code>_focusOut</code>.
		 * </p>
		 * @param	e	évènement diffusé par l'objet
		 * @see #_focusOut()
		 */
		public function focusOut ( e : FocusEvent ) : void
		{
			_focusOut( e );
		}
		/**
		 * Implémente la routine concrète de perte de focus.
		 * <p>
		 * Le composant sort de l'état <code>FOCUS</code> à l'issue
		 * de l'appel à la fonction.
		 * </p>
		 * @param	e	évènement diffusé par l'objet
		 */
		protected function _focusOut ( e : FocusEvent ) : void
		{
			if( !_allowFocusTraversing )
				e.stopPropagation();
			_focus = false;
			fireChangeEvent();
			if( _allowFocus )
				invalidate( true );
		}
		/**
		 * Recoit l'évènement de type <code>FocusEvent.KEY_FOCUS_CHANGE</code>
		 * de ce composant.
		 * <p>
		 * Si le composant à une référence à un objet <code>FocusGroup</code>
		 * définie dans sa propriété <code>_focusParent</code> l'évènement est
		 * interromput et le focus est automatiquement placé
		 * sur le composant précédent ou suivant selon la valeur de
		 * <code>e.shiftKey</code> à l'aide des méthodes <code>focusPrevious</code>
		 * et <code>focusNext</code>.
		 * </p>
		 * @param	e	évènement diffusé par l'objet
		 */
		public function keyFocusChange ( e : FocusEvent ) : void
		{
			if( _focusParent )
			{
				e.preventDefault();
				if( e.shiftKey )
					focusPrevious();
				else
					focusNext();
			}
		}

		/**
		 * Recoit l'évènement de type <code>FocusEvent.MOUSE_FOCUS_CHANGE</code>
		 * de ce composant.
		 *
		 * @param	e	évènement diffusé par l'objet
		 */
		protected function mouseFocusChange (event : FocusEvent) : void
		{
		}

		/**
		 * Recoit l'évènement de type <code>Event.ADDED_TO_STAGE</code>
		 * de ce composant.
		 * <p>
		 * Lors de l'ajout d'un composant sur la scène, et jusqu'a l'appel à la
		 * fonction <code>wasAddedToStage</code>, le contenu de ce composant
		 * est invisible (<code>visible=false</code>).
		 * Après le premier <code>repaint</code> le contenu sera visible,
		 * et ce afin d'éviter d'afficher un contenu non mise en forme.
		 * </p>
		 * @param	e	évènement diffusé par l'objet
		 */
		public function addedToStage ( e : Event ) : void
		{
			_displayed = true;
			_childrenContainer.visible = false;
			addEventListener(ComponentEvent.REPAINT, wasAddedToStage );
			invalidatePreferredSizeCache();

			registerToOnStageEvents();
		}
		/**
		 * Appelée lors du premier <code>repaint</code> après que le composant
		 * ait été ajouter à la display list.
		 * <p>
		 * Lors de l'ajout d'un composant sur la scène, et jusqu'a l'appel à cette
		 * fonction, le contenu de ce composant est invisible (<code>visible=false</code>).
		 * Après le premier <code>repaint</code> le contenu sera visible, et ce afin d'éviter
		 * d'afficher un contenu non mise en forme.
		 * </p>
		 * @param	e	évènement diffusé par l'objet
		 */
		protected function wasAddedToStage ( e : ComponentEvent) : void
		{
			_childrenContainer.visible = true;
			removeEventListener(ComponentEvent.REPAINT, wasAddedToStage );
		}

		/**
		 * Recoit l'évènement de type <code>Event.REMOVE_FROM_STAGE</code>
		 * de ce composant.
		 * <p>
		 * Lorsque le composant est enlevé de la display list, ses décorations sont effacées,
		 * son info-bulle (si affichée) est masquée, il se désabonne aux évènements de souris
		 * et ses états d'interactions avec la souris sont ramenés aux valeurs par défaut.
		 * </p>
		 *
		 * @param	e	évènement diffusé par l'objet
		 */
		public function removeFromStage ( e : Event ) : void
		{
			_displayed = false;
			_over = false;
			_pressed = false;

			unregisterFromOnStageEvents();

			/*FDT_IGNORE*/ FEATURES::TOOLTIP { /*FDT_IGNORE*/
				hideToolTip();
			/*FDT_IGNORE*/ } /*FDT_IGNORE*/
			_background.graphics.clear();			_foreground.graphics.clear();
		}

		/**
		 * Recoit l'évènement de type <code>PropertyEvent.PROPERTY_CHANGED</code>
		 * de l'objet <code>ComponentStyle</code> de ce composant.
		 *
		 * @param	e	évènement diffusé par l'objet
		 */
		protected function stylePropertyChanged (event : PropertyEvent) : void
		{
			switch( event.propertyName )
			{
				case StyleProperties.INSETS :				case StyleProperties.FORMAT :					invalidatePreferredSizeCache();
					break;
				case StyleProperties.BACKGROUND :				case StyleProperties.FOREGROUND :				case StyleProperties.INNER_FILTERS :				case StyleProperties.OUTER_FILTERS :				case StyleProperties.CORNERS :				case StyleProperties.TEXT_COLOR :
				case StyleProperties.BORDERS :
				default :
					invalidate( true );
					break;
			}
		}

/*-----------------------------------------------------------------
 * 	EVENTS DISPATCHING
 *----------------------------------------------------------------*/
		/**
		 * Abonne le composant comme écouteur des évènements liés à sa présence
		 * dans la <code>Display List</code>.
		 */
		protected function registerToOnStageEvents () : void
		{
			if( _interactive )
			{
				addEventListener( MouseEvent.MOUSE_DOWN, mouseDown );
				addEventListener( MouseEvent.MOUSE_OUT, mouseOut );
				addEventListener( MouseEvent.MOUSE_UP, mouseUp );
				addEventListener( MouseEvent.MOUSE_OVER, mouseOver );
				addEventListener( MouseEvent.MOUSE_MOVE, mouseMove );
				addEventListener( FocusEvent.FOCUS_IN, focusIn );
				addEventListener( FocusEvent.FOCUS_OUT, focusOut );
				addEventListener( FocusEvent.KEY_FOCUS_CHANGE, keyFocusChange );				addEventListener( FocusEvent.MOUSE_FOCUS_CHANGE, mouseFocusChange );
			}
			//_style.registerToParentStyleEvent();		}

		/**
		 * Désabonne le composant comme écouteur des évènements liés à sa présence
		 * dans la <code>Display List</code>.
		 */
		protected function unregisterFromOnStageEvents () : void
		{
			if( _interactive )
			{
				removeEventListener( MouseEvent.MOUSE_DOWN, mouseDown );
				removeEventListener( MouseEvent.MOUSE_OUT, mouseOut );
				removeEventListener( MouseEvent.MOUSE_UP, mouseUp );
				removeEventListener( MouseEvent.MOUSE_OVER, mouseOver );
				removeEventListener( MouseEvent.MOUSE_MOVE, mouseMove );
				removeEventListener( FocusEvent.FOCUS_IN, focusIn );
				removeEventListener( FocusEvent.FOCUS_OUT, focusOut );
				removeEventListener( FocusEvent.KEY_FOCUS_CHANGE, keyFocusChange );
				removeEventListener( FocusEvent.MOUSE_FOCUS_CHANGE, mouseFocusChange );
			}
			//_style.unregisterToParentStyleEvent();
		}
		/**
		 * Ajoute un écouteur au composant en utilisant une référence faible pour stocker l'écouteur.
		 *
		 * @param eventType	type de l'évènement auquel l'écouteur s'abonne
		 * @param listener	l'écouteur à enregistrer
		 * @see http://livedocs.adobe.com/flex/3/langref/flash/events/EventDispatcher.html#addEventListener() EventDispatcher.addEventListener()
		 */
		public function addWeakEventListener ( eventType : String, listener : Function ) : void
		{
			addEventListener( eventType, listener, false, 0, true );
		}
		/**
		 * Diffuse un évènement de type <code>Event.CHANGE</code> pour ce composant.
		 */
		protected function fireChangeEvent () : void
		{
			dispatchEvent( new Event( Event.CHANGE, true, true ) );
		}
		/**
		 * Diffuse un évènement de type <code>Event.CHANGE</code> pour ce composant.
		 */
		protected function firePositionChangeEvent () : void
		{
			dispatchEvent( new ComponentEvent( ComponentEvent.POSITION_CHANGE, true, true ) );
		}
		/**
		 * Diffuse un évènement de type <code>ComponentEvent.COMPONENT_RESIZE</code> pour ce composant seulement
		 * si la taille finale actuelle de ce composant est différente des anciennes valeurs
		 * transmises en paramètres.
		 * @param	oldW	ancienne longueur à comparer à la longueur actuelle
		 * @param	oldH	ancienne hauteur à comparer à la hauteur actuelle
		 */
		protected function fireResizeEventIfSizeChanged ( oldW : Number, oldH : Number) : void
		{
			if( oldW != width || oldH != height )
				fireResizeEvent();
		}
		/**
		 * Diffuse un évènement de type <code>ComponentEvent.COMPONENT_RESIZE</code> pour ce composant.
		 */
		protected function fireResizeEvent () : void
		{
			dispatchEvent( new ComponentEvent( ComponentEvent.COMPONENT_RESIZE, true, true ) );
		}
		/**
		 * Diffuse un évènement de type <code>type</code> pour ce composant.
		 */
		protected function fireComponentEvent ( type : String ) : void
		{
			dispatchEvent( new ComponentEvent( type, true, true ) );
		}
		/**
		 * Diffuse un évènement de type <code>PropertyEvent.PROPERTY_CHANGE</code> pour ce composant.
		 *
		 * @param	pname	nom de la propriété provoquant la diffusion de l'évènement
		 * @param	pvalue	nouvelle valeur de cette propriété
		 */
		protected function firePropertyEvent ( pname : String, pvalue : * ) : void
		{
			var e : PropertyEvent = new PropertyEvent( PropertyEvent.PROPERTY_CHANGE, pname, pvalue, false, false );
			propertyChange( e );
			dispatchEvent( e );
		}
		/**
		 * Version accélérée de la fonction de diffusion d'évènement.
		 * @param	evt	l'évènement à diffuser
		 * @return	l'évènement à t'il était diffusé ?
		 */
		override public function dispatchEvent ( evt : Event) : Boolean
		{
			if (hasEventListener( evt.type ) || evt.bubbles)
		  		return super.dispatchEvent( evt );
			return false;
		}
	}
}
