/**
 * @license
 */
package abe.com.ponents.buttons 
{
	import abe.com.mon.core.IDisplayObject;
	import abe.com.mon.core.IDisplayObjectContainer;
	import abe.com.mon.core.IInteractiveObject;
	import abe.com.mon.core.LayeredSprite;
	import abe.com.ponents.actions.BooleanAction;
	import abe.com.ponents.core.Component;
	import abe.com.ponents.core.focus.Focusable;
	import abe.com.ponents.events.ComponentEvent;
	import abe.com.ponents.events.PropertyEvent;
	import abe.com.ponents.layouts.display.DOInlineLayout;
	import abe.com.ponents.skinning.icons.CheckBoxCheckedIcon;
	import abe.com.ponents.skinning.icons.CheckBoxUncheckedIcon;
	import abe.com.ponents.skinning.icons.Icon;
	import abe.com.ponents.skinning.icons.magicIconBuild;
	import abe.com.ponents.utils.Directions;

	import flash.display.DisplayObject;
	import flash.events.IEventDispatcher;

	/**
	 * Évènement diffusé par l'instance au moment d'un changement de sa valeur.
	 * 
	 * @eventType abe.com.ponents.events.ComponentEvent.DATA_CHANGE
	 */
	[Event(name="dataChange", type="abe.com.ponents.events.ComponentEvent")]
	/**
	 * Une propriété du style contenant l'icône de référence lorsque le composant
	 * <code>CheckBox</code> est sélectionné.
	 * <p>
	 * <strong>Note : </strong> La modification ou la récupération du style pour une instance de composant peut
	 * se faire des manières suivantes : 
	 * </p>
	 * <ul>
	 * <li><pre>var checkedIcon : Icon = monComposant.style.checkedIcon;</pre>
	 * Récupère la valeur du style dans l'état courant du composant.</li>
	 * <li><pre>monComposant.style.setCustomProperty( 'checkedIcon', new Icon() );</pre>
	 * Modifie la valeur du style pour ce composant.</li>
	 * </ul>
	 */
	[Style(name="checkedIcon",type="abe.com.ponents.skinning.icons.Icon")]
	/**
	 * Une propriété du style contenant l'icône de référence lorsque le composant
	 * <code>CheckBox</code> est désélectionné.
	 * <p>
	 * <strong>Note : </strong> La modification ou la récupération du style pour une instance de composant peut
	 * se faire des manières suivantes : 
	 * </p>
	 * <ul>
	 * <li><pre>var uncheckedIcon : Icon = monComposant.style.uncheckedIcon;</pre>
	 * Récupère la valeur du style dans l'état courant du composant.</li>
	 * <li><pre>monComposant.style.setCustomProperty( 'uncheckedIcon', new Icon() );</pre>
	 * Modifie la valeur du style pour ce composant.</li>
	 * </ul>
	 */
	[Style(name="uncheckedIcon",type="abe.com.ponents.skinning.icons.Icon")]
	/*
	 * Déclarations des styles du composant.
	 */
	[Skinable(skin="CheckBox")]
	[Skin(define="ToolBar_CheckBox",
		  inherit="ToolBar_Button",
		  state__0_1_4_5_8_9_12_13__foreground="skin.noDecoration",
		  state__0_1_4_5_8_9_12_13__background="skin.emptyDecoration"
	)]	
	[Skin(define="CheckBox",
		  inherit="EmptyComponent",
		  preview="abe.com.ponents.buttons::CheckBox.defaultCheckBoxPreview",
		  state__all__insets="new cutils::Insets(4,2,4,2)",
		  state__4_6_7_12_14_15__foreground="new deco::SimpleBorders( skin.focusBorderColor )",
		  
		  custom_checkedIcon="icon(abe.com.ponents.skinning.icons::CheckBoxCheckedIcon)",
		  custom_uncheckedIcon="icon(abe.com.ponents.skinning.icons::CheckBoxUncheckedIcon)"
	)]
	/**
	 * Un composant <code>CheckBox</code> est un <code>ToggleButton</code>
	 * dont l'apparence s'apparente à une case à cocher.
	 * <p>
	 * Un icône supplémentaire est utilisé afin de représenter l'état
	 * de sélection du composant.
	 * </p>
	 * 
	 * @author	Cédric Néhémie
	 */
	public class CheckBox extends ToggleButton implements IDisplayObject, 
														  IInteractiveObject, 
														  IDisplayObjectContainer, 
														  Component, 
														  Focusable,
												 		  LayeredSprite,
												 		  IEventDispatcher
	{
		/*FDT_IGNORE*/ FEATURES::BUILDER { /*FDT_IGNORE*/
		/**
		 * [conditional-compile] Renvoie un composant <code>CheckBox</code> utilisé en tant
		 * que prévisualisation pour le style <code>CheckBox</code>
		 * au sein de l'éditeur de composant.
		 * <p>
		 * <strong>Note :</strong> Cette fonction est soumise à la constante
		 * <a href="../../../../Conditional-Compilation.html#BUILDER">FEATURES::BUILDER</a>
		 * dans le cadre de la <a href="../../../../Conditional-Compilation.html">compilation conditionnelle</a>.
		 * Veillez donc à conditionner l'usage de cette fonctionnalité à l'usage de la constante de compilation associée. 
		 * </p>
		 * @see ../../../../Conditional-Compilation.html#BUILDER Constante FEATURES::BUILDER
		 * @return	un composant <code>CheckBox</code> utilisé en tant
		 * 			que prévisualisation pour le style <code>CheckBox</code>
		 */
		static public function defaultCheckBoxPreview () : Component
		{
			return new CheckBox();
		}
		/*FDT_IGNORE*/ } /*FDT_IGNORE*/
		/*
		 * Utilisé pour forcer la compilation des dépendances du skin de ce composant.
		 */
		static private const DEPENDENCIES : Array = [ CheckBoxCheckedIcon, CheckBoxUncheckedIcon ];
		
		/**
		 * Une référence vers l'icône représentant l'état sélectionné du composant.
		 */
		protected var _checkedIcon : Icon;		/**
		 * Une référence vers l'icône représentant l'état désélectionné du composant.
		 */
		protected var _uncheckedIcon : Icon;
		/**
		 * Une référence vers l'icône représentant l'état courant du composant.
		 */
		protected var _tickIcon : Icon;
		/**
		 * Profondeur à laquelle l'icône représentant l'état de sélection du composant
		 * doit être positionné dans la structure graphique. 
		 */		protected var _tickIconIndex : int;
		
		/**
		 * Constructeur de classe <code>CheckBox</code>.
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
		public function CheckBox ( actionOrLabel : * = null, icon : Icon = null )
		{
			super( actionOrLabel, icon );
			
			_checkedIcon = _style.checkedIcon.clone();
			_uncheckedIcon = _style.uncheckedIcon.clone();
			_tickIconIndex = 2;
			
			( _childrenLayout as DOInlineLayout ).direction = Directions.RIGHT_TO_LEFT;
			( _childrenLayout as DOInlineLayout ).spacing = 3;
			
			updateTickIcon();
			invalidatePreferredSizeCache( );
		}
		/**
		 * Une valeur booléenne indiquant si cette <code>CheckBox</code> est
		 * cochée ou non.
		 */
		public function get value () : Boolean { return selected; }
		public function set value ( b : Boolean ) : void { selected = b; }
		/**
		 * Une valeur booléenne indiquant si cette <code>CheckBox</code> est
		 * cochée ou non.
		 */
		public function get checked () : Boolean { return selected; }
		public function set checked ( b : Boolean ) : void { selected = b; }
		
		/**
		 * @inheritDoc
		 */
		override public function set selected (b : Boolean) : void
		{
			super.selected = b;
			updateTickIcon();
		}
		/**
		 * Une référence vers l'objet <code>Icon</code> utilisé pour
		 * représenter l'état de sélection de ce composant <code>CheckBox</code>.
		 */
		public function get tickIcon () : Icon	{ return _icon;	}
		public function set tickIcon (icon : Icon ) : void
		{
			if( _tickIcon && contains( _tickIcon ) )
			{
				_tickIcon.removeEventListener( ComponentEvent.COMPONENT_RESIZE, iconResized );
				_childrenContainer.removeChild( _tickIcon );
			}
			
			if( _tickIcon )
				_tickIcon.dispose();
				
			_tickIcon = icon;
			
			if( _tickIcon )
			{
				_tickIcon.init();
				_tickIcon.invalidate();
				_tickIcon.addEventListener( ComponentEvent.COMPONENT_RESIZE, iconResized );
				//_childrenContainer.addChild
				if( _icon && containsComponentChild( _icon ) )
					addComponentChildAfter( _tickIcon, _icon );
				else if( _labelTextField && containsComponentChild( _labelTextField as DisplayObject ) )
					addComponentChildAfter( _tickIcon, _labelTextField as DisplayObject );
				else
					addComponentChildAt( _tickIcon, _tickIconIndex );
			}
			invalidatePreferredSizeCache();
		}
		
		protected function updateTickIcon () : void 
		{
			tickIcon = _selected ? _checkedIcon : _uncheckedIcon;
		}
		/**
		 * @inheritDoc
		 */
		override protected function stylePropertyChanged (event : PropertyEvent) : void
		{
			switch( event.propertyName )
			{
				case "checkedIcon" :
					_checkedIcon = magicIconBuild( event.propertyValue );
					tickIcon = _selected ? _checkedIcon : _uncheckedIcon;
					break;
				case "uncheckedIcon" :
					_uncheckedIcon = magicIconBuild( event.propertyValue );
					tickIcon = _selected ? _checkedIcon : _uncheckedIcon;
					break;
				default : 
					super.stylePropertyChanged( event );
					break;
			}
		}
	}
}
