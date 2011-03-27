package abe.com.ponents.forms 
{
	import abe.com.mon.logs.Log;
	import abe.com.mon.geom.Dimension;
	import abe.com.mon.colors.Color;
	import abe.com.mon.colors.Gradient;
	import abe.com.mon.utils.Reflection;
	import abe.com.mon.utils.StringUtils;
	import abe.com.mon.utils.TimeDelta;
	import abe.com.mon.utils.XMLUtils;
	import abe.com.patibility.lang._;
	import abe.com.ponents.buttons.CheckBox;
	import abe.com.ponents.buttons.ColorPicker;
	import abe.com.ponents.buttons.ComponentDecorationPicker;
	import abe.com.ponents.buttons.DatePicker;
	import abe.com.ponents.buttons.FiltersPicker;
	import abe.com.ponents.buttons.GradientPicker;
	import abe.com.ponents.buttons.HexaColorPicker;
	import abe.com.ponents.buttons.IconPicker;
	import abe.com.ponents.buttons.TimeDeltaPicker;
	import abe.com.ponents.core.Component;
	import abe.com.ponents.lists.ListEditor;
	import abe.com.ponents.menus.ComboBox;
	import abe.com.ponents.models.DefaultBoundedRangeModel;
	import abe.com.ponents.models.SpinnerDateModel;
	import abe.com.ponents.models.SpinnerNumberModel;
	import abe.com.ponents.skinning.decorations.ComponentDecoration;
	import abe.com.ponents.skinning.icons.BitmapIcon;
	import abe.com.ponents.skinning.icons.CheckBoxCheckedIcon;
	import abe.com.ponents.skinning.icons.CheckBoxUncheckedIcon;
	import abe.com.ponents.skinning.icons.ColorIcon;
	import abe.com.ponents.skinning.icons.DOIcon;
	import abe.com.ponents.skinning.icons.DOInstanceIcon;
	import abe.com.ponents.skinning.icons.EmbeddedBitmapIcon;
	import abe.com.ponents.skinning.icons.ExternalBitmapIcon;
	import abe.com.ponents.skinning.icons.FontIcon;
	import abe.com.ponents.skinning.icons.GradientIcon;
	import abe.com.ponents.skinning.icons.Icon;
	import abe.com.ponents.skinning.icons.PaletteIcon;
	import abe.com.ponents.skinning.icons.RadioCheckedIcon;
	import abe.com.ponents.skinning.icons.RadioUncheckedIcon;
	import abe.com.ponents.skinning.icons.SWFIcon;
	import abe.com.ponents.sliders.HSlider;
	import abe.com.ponents.spinners.DoubleSpinner;
	import abe.com.ponents.spinners.QuadSpinner;
	import abe.com.ponents.spinners.Spinner;
	import abe.com.ponents.text.ClassPathInput;
	import abe.com.ponents.text.Label;
	import abe.com.ponents.text.TextArea;
	import abe.com.ponents.text.TextFormatEditor;
	import abe.com.ponents.text.TextInput;
	import abe.com.ponents.text.URLInput;
	import abe.com.ponents.tools.ColorMatrixEditor;
	import abe.com.ponents.utils.Borders;
	import abe.com.ponents.utils.Corners;
	import abe.com.ponents.utils.Insets;

	import flash.filters.ColorMatrixFilter;
	import flash.geom.Point;
	import flash.net.URLRequest;
	import flash.text.TextFormat;
	import flash.utils.getQualifiedClassName;
	/**
	 * @author Cédric Néhémie
	 */
	public class FormUtils 
	{
		static private const NUMBER_TYPES : Array = [ "Number","int","uint" ];
		
		static private function createTypesMap () : Object
		{
			var d : Object = new Object();
			
			// AbeLib Defaults :
			d[ FIELD_INT_SLIDER ] = getIntSlider;			d[ FIELD_INT_SPINNER ] = getIntSpinner;
			d[ getQualifiedClassName(int) ] = getIntSpinner;
			
			d[ FIELD_UINT_SLIDER ] = getUintSlider;			d[ FIELD_UINT_SPINNER ] = getUintSpinner;
			d[ getQualifiedClassName(uint) ] = getUintSpinner;
			
			d[ FIELD_FLOAT_SLIDER ] = getFloatSlider;			d[ FIELD_FLOAT_SPINNER ] = getFloatSpinner;
			d[ getQualifiedClassName(Number) ] = getFloatSpinner;
			
			d[ FIELD_STRING ] = getString;			d[ getQualifiedClassName(String) ] = getString;
			d[ FIELD_TEXT ] = getText;
			d[ FIELD_PASSWORD ] = getPassword;
			
			d[ FIELD_TEXT_FORMAT ] = getTextFormat;			d[ getQualifiedClassName(TextFormat) ] = getTextFormat;
						d[ FIELD_DATE_SPINNER ] = getDateSpinner;
			d[ FIELD_DATE_CALENDAR ] = getDateCalendar;			d[ getQualifiedClassName(Date) ] = getDateCalendar;			
			d[ FIELD_TIME_DELTA ] = getTimeDelta;			d[ getQualifiedClassName(TimeDelta) ] = getTimeDelta;
			
			d[ FIELD_ARRAY ] = getArray;			d[ getQualifiedClassName(Array) ] = getArray;
			
			d[ FIELD_BOOLEAN ] = getBoolean;			d[ getQualifiedClassName(Boolean) ] = getBoolean;
						d[ FIELD_COLOR ] = getColor;			d[ getQualifiedClassName(Color) ] = getColor;
						d[ FIELD_GRADIENT ] = getGradient;			d[ getQualifiedClassName(Gradient) ] = getGradient;
						d[ FIELD_DIMENSION_INT ] = getDimensionInt;			d[ FIELD_DIMENSION_UINT ] = getDimensionUint;			d[ FIELD_DIMENSION_FLOAT ] = getDimensionFloat;			d[ getQualifiedClassName(Dimension) ] = getDimensionFloat;
			
			d[ FIELD_POINT_INT ] = getPointInt;
			d[ FIELD_POINT_UINT ] = getPointUint;
			d[ FIELD_POINT_FLOAT ] = getPointFloat;			d[ getQualifiedClassName(Point) ] = getPointFloat;
			
			d[ FIELD_INSETS_INT ] = getInsetsInt;
			d[ FIELD_INSETS_UINT ] = getInsetsUint;
			d[ FIELD_INSETS_FLOAT ] = getInsetsFloat;			d[ getQualifiedClassName(Insets) ] = getInsetsFloat;
			
			d[ FIELD_BORDERS_INT ] = getBordersInt;
			d[ FIELD_BORDERS_UINT ] = getBordersUint;
			d[ FIELD_BORDERS_FLOAT ] = getBordersFloat;
			d[ getQualifiedClassName(Borders) ] = getBordersFloat;
			
			d[ FIELD_CORNERS_INT ] = getCornersInt;
			d[ FIELD_CORNERS_UINT ] = getCornersUint;
			d[ FIELD_CORNERS_FLOAT ] = getCornersFloat;
			d[ getQualifiedClassName(Corners) ] = getCornersFloat;			
			d[ FIELD_URL ] = getURLInput;			d[ getQualifiedClassName(URLRequest) ] = getURLInput;
			
			d[ FIELD_CLASS ] = getClassPathInput;			d[ getQualifiedClassName(Class) ] = getClassPathInput;				
			/*FDT_IGNORE*/ FEATURES::BUILDER { /*FDT_IGNORE*/
			d[ getQualifiedClassName(ExternalBitmapIcon) ] = getIcon;
			d[ getQualifiedClassName(EmbeddedBitmapIcon) ] = getIcon;			d[ getQualifiedClassName(SWFIcon) ] = getIcon;			d[ getQualifiedClassName(ColorIcon) ] = getIcon;			d[ getQualifiedClassName(GradientIcon) ] = getIcon;			d[ getQualifiedClassName(PaletteIcon) ] = getIcon;			d[ getQualifiedClassName(CheckBoxUncheckedIcon) ] = getIcon;			d[ getQualifiedClassName(CheckBoxCheckedIcon) ] = getIcon;			d[ getQualifiedClassName(RadioCheckedIcon) ] = getIcon;			d[ getQualifiedClassName(RadioUncheckedIcon) ] = getIcon;			d[ getQualifiedClassName(DOIcon) ] = getIcon;			d[ getQualifiedClassName(DOInstanceIcon) ] = getIcon;			d[ getQualifiedClassName(FontIcon) ] = getIcon;			d[ getQualifiedClassName(BitmapIcon) ] = getIcon;			d[ getQualifiedClassName(Icon) ] = getIcon;
			d[ FIELD_COMPONENT_DECORATION ] = getComponentDecoration;			d[ getQualifiedClassName(ComponentDecoration) ] = getComponentDecoration;			/*FDT_IGNORE*/ } /*FDT_IGNORE*/
			
			
			d[ FIELD_FILTERS_ARRAY ] = getFiltersArray;
			return d;
		}
		
		static private function createFormMap () : Object 
		{
			var o : Object = {};
			
			o[ ColorMatrixFilter ] = getColorMatrixFilterForm;			o[ Object ] = getObjectForm;
			
			return o;
		}
		
		static public const FIELD_ARRAY : String = "array";		static public const FIELD_BOOLEAN : String = "boolean";
		static public const FIELD_STRING : String = "string";				static public const FIELD_INT_SPINNER : String = "intSpinner";
		static public const FIELD_INT_SLIDER : String = "intSlider";				static public const FIELD_UINT_SPINNER : String = "uintSpinner";
		static public const FIELD_UINT_SLIDER : String = "uintSlider";				static public const FIELD_FLOAT_SPINNER : String = "floatSpinner";
		static public const FIELD_FLOAT_SLIDER : String = "floatSlider";
				static public const FIELD_TEXT : String = "text";		static public const FIELD_TEXT_FORMAT : String = "textFormat";		static public const FIELD_PASSWORD : String = "password";
				static public const FIELD_DATE_SPINNER : String = "dateSpinner";		static public const FIELD_DATE_CALENDAR : String = "dateCalendar";		static public const FIELD_TIME_DELTA : String = "timeDelta";
				
		static public const FIELD_COLOR : String = "color";		static public const FIELD_GRADIENT : String = "gradient";		static public const FIELD_FILTERS_ARRAY : String = "filtersArray";
				static public const FIELD_DIMENSION_INT : String = "dimensionInt";		static public const FIELD_DIMENSION_UINT : String = "dimensionUint";		static public const FIELD_DIMENSION_FLOAT : String = "dimensionFloat";
				static public const FIELD_POINT_INT : String = "pointInt";
		static public const FIELD_POINT_UINT : String = "pointUint";
		static public const FIELD_POINT_FLOAT : String = "pointFloat";
		
		static public const FIELD_INSETS_INT : String = "insetsInt";
		static public const FIELD_INSETS_UINT : String = "insetsUint";
		static public const FIELD_INSETS_FLOAT : String = "insetsFloat";
		
		static public const FIELD_BORDERS_INT : String = "bordersInt";
		static public const FIELD_BORDERS_UINT : String = "bordersUint";
		static public const FIELD_BORDERS_FLOAT : String = "bordersFloat";
		
		static public const FIELD_CORNERS_INT : String = "cornersInt";
		static public const FIELD_CORNERS_UINT : String = "cornersUint";
		static public const FIELD_CORNERS_FLOAT : String = "cornersFloat";		
		static public const FIELD_COMPONENT_DECORATION : String = "componentDecoration";		
		static public const FIELD_URL : String = "url";		static public const FIELD_CLASS : String = "class";
		
		static private var _typesMap : Object = createTypesMap();
		static private var _formMap : Object = createFormMap();		static private var _newMap : Object = createNewMap( );
		
		private static function createNewMap () : Object
		{
			var o : Object = {};
			
			o[String] = getClassicNewInstance;			o[Array] = getClassicNewInstance;			o[Boolean] = getClassicNewInstance;			o[Object] = getClassicNewInstance;			o[Number] = getClassicNewInstance;			o[int] = getClassicNewInstance;			o[uint] = getClassicNewInstance;			
			return o;
		}

		public static function getNewValue ( t : Class ) : *
		{
			if( _newMap[ t ] != undefined )
				return _newMap[ t ]( t );
			else
				return getClassicNewInstance( t );
		}
		
		static public function getClassicNewInstance( t : Class ) : *
		{
			return new t();
		}
		
		static public function addPublicMembersFormFunction ( cl : Class, f : Function ) : void
		{
			_formMap[ cl ] = f;
		}
		static public function addTypeMapFunction ( t : String, f : Function ) : void
		{
			_typesMap[ t ] = f;
		}
		static public function addNewValueFunction ( cl : Class, f : Function ) : void
		{
			_newMap[ cl ] = f;
		}
		/**
		 * Renvoie un objet <code>FormObject</code> pour toutes les propriétés publiques 
		 * de <code>o</code> pour lesquelles un type de controlleur existe.
		 * <p>
		 * Vous pouvez trouvez ci-dessous la liste des types de propriétés supportés
		 * par la méthode <code>createFormForPublicMembers</code> : 
		 * </p>
		 * <table class='innertable'>
		 * <tr><th>Type</th><th>Composant</th></tr>
		 * <tr><td>int</td><td>Spinner</td></tr>		 * <tr><td>uint</td><td>Spinner</td></tr>		 * <tr><td>Number</td><td>Spinner</td></tr>		 * <tr><td>Array</td><td>ListEditor</td></tr>		 * <tr><td>Boolean</td><td>CheckBox</td></tr>		 * <tr><td>String</td><td>TextInput</td></tr>		 * <tr><td>Color</td><td>ColorPicker</td></tr>		 * <tr><td>Gradient</td><td>GradientPicker</td></tr>		 * <tr><td>Date</td><td>DatePicker</td></tr>		 * <tr><td>Dimension</td><td>DoubleSpinner</td></tr>		 * <tr><td>Point</td><td>DoubleSpinner</td></tr>		 * <tr><td>Insets</td><td>QuadSpinner</td></tr>		 * <tr><td>Borders</td><td>QuadSpinner</td></tr>		 * <tr><td>Corners</td><td>QuadSpinner</td></tr>
		 * </table>
		 * 
		 * @param	o	l'objet pour lequel on souhaite créer un formulaire
		 * @return	une instance de <code>FormObject</code> contenant les champs de formulaires
		 * 			pour <code>o</code>
		 * @example Création d'un formulaire pour un objet de type <code>Point</code> : 
		 * <listing>var pt : Point = new Point( 15, 25 );
		 * // On créer le FormObject pour ce pt
		 * var fo : FormObject = FormUtils.createFormForPublicMembers( pt );
		 * // On génère la structure graphique chargé d'afficher le formulaire
		 * var c : Component = FieldSetFormRenderer.instance.render( fo );
		 * // On créer le gestionnaire pour le formulaire
		 * var sfm : SimpleFormManager = new SimpleFormManager( fo );
		 * // Finalement on ajoute le formulaire sur la scène
		 * addChild( c );</listing> 
		 */
		static public function createFormForPublicMembers ( o : Object ) : FormObject
		{
			var cl : Class = Reflection.getClass( o );
			
			if( _formMap.hasOwnProperty( cl ) )
				return _formMap[ cl ]( o ) as FormObject; 	
			
			var members : XMLList = Reflection.getPublicMembers( o );
			var fn : Function;
			var c : Component;
			var fd : Array = [];
			var i : Number = 0;
			
			for each( var x : XML in members )
			{
				var n : String = x.@name;
				var t : String = x.@type;
				
				if( x.@access == "readonly" )
					continue;
				
				fn = _typesMap[ t ];
				if( fn != null )
				{
					c = fn(o[n],{});
					if( t == "Array" )
					{
						var lE : ListEditor = c as ListEditor;
						if( n.search(/colors/gi) != -1 )
						{
							lE.contentType = uint;
							lE.list.itemFormatingFunction = StringUtils.formatUintAsHexadecimal;
							var m : SpinnerNumberModel = new SpinnerNumberModel(0,uint.MIN_VALUE, uint.MAX_VALUE ,1,true);
							m.uintDisplayMode = SpinnerNumberModel.HEXADECIMAL;
							lE.newValueProvider = new Spinner(m);
						}
						else if( n.search(/alphas/gi) != -1 )
						{
							lE.contentType = Number;
							lE.list.itemFormatingFunction = StringUtils.formatNumber;
							lE.newValueProvider = new Spinner(new SpinnerNumberModel(0, 0, 1, 0.1));
						}
						else if( n.search(/ratios/gi) != -1 )
						{
							lE.contentType = uint;
							lE.newValueProvider = new Spinner(new SpinnerNumberModel(0, 0, 255, 1, true));
						}
						else if( n.search(/matrix/gi) != -1 )
						{
							lE.contentType = uint;
							lE.newValueProvider = new Spinner(new SpinnerNumberModel(0, -255, 255, 1, true ));
						}
					}
					else if( n.search(/color/gi) != -1 && t == "uint" )
					{
						c = new HexaColorPicker(o[n]);
					}
					
					fd.push(new FormField(n, n, c,i++, Reflection.get( t ) ));
				}
			}
			var fo : FormObject = new FormObject( o , fd);
			return fo;
		}
		
		public static function getComponentForType ( v : * ) : Component
		{
			var fn : Function = _typesMap[ v ];			var fn2 : Function = _newMap[ v ];
			
			return fn != null ? fn( fn2 != null ? fn2() : null, {} ) : null;
		}
		public static function getComponentForValue ( v : * ) : Component
		{
			var fn : Function = _typesMap[ getQualifiedClassName(v) ];
			return fn != null ? fn(v,{}) : null;
		}
		/*-----------------------------------------------------------------------------------*
		 * SORTING FUNCTION FUNCTION
		 *-----------------------------------------------------------------------------------*/
		static protected var _tmpCategories : Object;
		
		static protected function categoriesSort ( a : String, b : String ) : Number
		{
			if( _tmpCategories[a].order > _tmpCategories[b].order )
				return 1;
			else if( _tmpCategories[a].order < _tmpCategories[b].order )
				return -1;
			else 
				return 0;
		}
		
		static protected function fieldsSort ( a : *, b : * ) : Number 
		{
			var order1 : Number = a.order;
			var order2 : Number = b.order;
			
			if( order1 > order2 )
				return 1;
			else if ( order2 > order1 )
				return -1;
			else
				return 0;
		}
		
		/**
		 * Renvoie un objet <code>FormObject</code> pour toute les propriétés de <code>o</code> décorées
		 * avec des balises de meta-données de type <code>[Form]</code>.
		 * 
		 * <p>Toutes les balises <code>[Form]</code> possèdent les propriétés communes suivantes :</p>
		 * <table class='innertable'>
		 * 
		 * <tr><th>Paramètre</th><th>Description</th></tr>
		 * 
		 * <tr><td>type</td><td>Définit le type de composant qui va être utilisé 
		 * (voir tableau suivant pour le détail des types).</td></tr>		 * 
		 * <tr><td>order</td><td>Un entier permettant de définir l'ordre de priorité d'affichage des champs du formulaire. 
		 * Tout élément avec un <code>order</code> <em>N</em> sera positionné avant un élément avec un <code>order</code> <em>N+1</em></td></tr>		 * 
		 * <tr><td>category</td><td>Définit que ce champ appartient à un groupe de champs. </td></tr>
		 * 
		 * <tr><td>categoryOrder</td><td>Un entier permettant de définir  l'ordre de priorité d'affichage de la catégorie définie 
		 * via la propriété <code>category</code>. Tout élément avec un <code>categoryOrder</code> <em>N</em> sera positionné avant un élément
		 * avec un <code>categoryOrder</code> <em>N+1</em>. 
		 * <p><strong>Note : </strong>La définition de l'ordre d'une catégorie ne se produit qu'une seule fois, c'est-à-dire que si
		 * l'ordre d'une même catégorie est définit plusieurs fois, seule la première valeur sera considérée. De plus, l'ordre de traitement
		 * des propriétés n'étant pas garantie, il est préférable de ne définir la propriété <code>categoryOrder</code> qu'une fois, quelque soit
		 * le nombre de champs dans la catégorie.</p></td></tr>		 * 
		 * <tr><td>label</td><td>Une chaîne de caractère utilisée comme label pour le champ. Si aucun label n'est fourni le nom
		 * de la propriété correspondante sera utilisé.</td></tr>
		 * 
		 * <tr><td>defaultValue</td><td>Valeur par défaut pour ce champ, la valeur par défaut sera utilisée si l'objet ne possède pas de valeur
		 * dans la propriété correspondante. La chaîne de valeur par défaut est évaluée selon les règles définie par la méthode <code>Reflection.get()</code></td></tr>
		 * 
		 * <tr><td>description</td><td>Un texte de description de ce champ de formulaire</td></tr>
		 * 		 * <tr><td>enabled</td><td>Le champ est-il éditable ?</td></tr>		 * </table>
		 * 
		 * <p>Certains type de champ définissent certaines propriétés additionelles dont voici la liste :</p>
		 * 
		 * <table class='innertable'>
		 * 
		 * <tr><th>Type</th><th>Composant</th><th>Paramètres additionnels</th></tr>
		 * 
		 * <tr><td>intSpinner</td><td>Spinner</td><td><ul>
		 * <li><code>range</code> : Un couple de valeur numérique servant à définir
		 * les bornes minimales et maximales pour la valeur de ce champ.
		 * <listing>range='-25,25'</listing></li>
		 * <li><code>step</code> : Une valeur numérique définissant le pas dans les valeurs possible pour ce champ.
		 * <listing>step='1'</listing></li></ul></td></tr>		 * 
		 * <tr><td>intSlider</td><td>HSlider</td><td><ul>
		 * <li><code>range</code> : Un couple de valeur numérique servant à définir
		 * les bornes minimales et maximales pour la valeur de ce champ.
		 * <listing>range='-25,25'</listing></li>
		 * <li><code>step</code> : Une valeur numérique définissant le pas dans les valeurs possible pour ce champ.
		 * <listing>step='1'</listing></li></ul></td></tr>		 * 
		 * <tr><td>uintSpinner</td><td>Spinner</td><td><ul>
		 * <li><code>range</code> : Un couple de valeur numérique servant à définir
		 * les bornes minimales et maximales pour la valeur de ce champ.
		 * <listing>range='0,25'</listing></li>
		 * <li><code>step</code> : Une valeur numérique définissant le pas dans les valeurs possible pour ce champ.
		 * <listing>step='1'</listing></li></ul></td></tr>		 * 
		 * <tr><td>uintSlider</td><td>HSlider</td><td><ul>
		 * <li><code>range</code> : Un couple de valeur numérique servant à définir
		 * les bornes minimales et maximales pour la valeur de ce champ.
		 * <listing>range='0,25'</listing></li>
		 * <li><code>step</code> : Une valeur numérique définissant le pas dans les valeurs possible pour ce champ.
		 * <listing>step='1'</listing></li></ul></td></tr>
		 * 
		 * <tr><td>floatSpinner</td><td>Spinner</td><td><ul>
		 * <li><code>range</code> : Un couple de valeur numérique servant à définir
		 * les bornes minimales et maximales pour la valeur de ce champ.
		 * <listing>range='0,1'</listing></li>
		 * <li><code>step</code> : Une valeur numérique définissant le pas dans les valeurs possible pour ce champ.
		 * <listing>step='0.01'</listing></li></ul></td></tr>		 * 
		 * <tr><td>floatSlider</td><td>Slider</td><td><ul>
		 * <li><code>range</code> : Un couple de valeur numérique servant à définir
		 * les bornes minimales et maximales pour la valeur de ce champ.
		 * <listing>range='0,1'</listing></li>
		 * <li><code>step</code> : Une valeur numérique définissant le pas dans les valeurs possible pour ce champ.
		 * <listing>step='0.01'</listing></li></ul></td></tr>
		 * 		 * <tr><td>string</td><td>TextInput|Combobox</td><td><ul>
		 * <li><code>length</code> : Un entier fixant la longueur maximum du texte contenu dans le champ de texte
		 * <listing>length='25'</listing></li>
		 * <li><code>enumeration</code> : Une liste de valeur prédéfinies représentant les choix possible pour l'utilisateur.
		 * <listing>enumeration='first item,second item,third item'</listing>
		 * <p>Si <code>enumeration</code> est définit, le composant <code>TextInput</code> sera remplacé par un composant
		 * <code>Combobox</code> avec les valeurs correspondantes.</p>
		 * </li></ul></td></tr>
		 * 		 * <tr><td>password</td><td>TextInput</td><td><ul>
		 * <li><code>length</code> : Un entier fixant la longueur maximum du texte contenu dans le champ de texte
		 * <listing>length='25'</listing></li></ul></td></tr>
		 * 		 * <tr><td>text</td><td>TextArea</td><td>Aucun paramètres additionnels</td></tr>		 * 
		 * <tr><td>array</td><td>ListEditor</td><td><ul>
		 * <li><code>contentType</code> : Une classe déterminant le type des éléments contenu dans le tableau.
		 * Le type sera utilisé en tant que clé pour récupérer le composant servant à fournir les valeurs à 
		 * insérer dans le tableau. Si aucun type n'est fourni, le contenu du tableau n'est jamais vérifié, et 
		 * le composant servant à fournir les nouvelles valeurs est un objet <code>TextInput</code>
		 * <listing>contentType='uint'</listing></li>
		 * <li><code>enumeration</code> : Si définie, le composant servant normalement à fournir les valeurs pour
		 * le tableau sera remplacer par un composant <code>ComboBox</code> contenant les valeurs dans l'énumération.
		 * <listing>enumeration='1,2,3,5,8,13,21'</listing></li>
		 * </ul></td></tr>
		 * 		 * <tr><td>boolean</td><td>CheckBox</td><td>Aucun paramètres additionnels</td></tr>
		 * 		 * <tr><td>color</td><td>ColorPicker</td><td>Aucun paramètres additionnels</td></tr>
		 * 		 * <tr><td>gradient</td><td>GradientPicker</td><td>Aucun paramètres additionnels</td></tr>		 * 		 * <tr><td>dateSpinner</td><td>Spinner</td><td><ul>
		 * <li><code>range</code> : Un couple d'objet <code>Date</code> servant à définir
		 * les bornes minimales et maximales pour la valeur de ce champ.
		 * <listing>range='new Date(2000,1,1),new Date(2010,1,1)'</listing></li></ul></td></tr>		 * 
		 * <tr><td>dateCalendar</td><td>DatePicker</td><td>Aucun paramètres additionnels</td></tr>
		 * 
		 * <tr><td>pointInt</td><td>DoubleSpinner</td><td><ul>
		 * <li><code>range</code> : Un couple de valeur numérique servant à définir
		 * les bornes minimales et maximales pour la valeur de ce champ.
		 * <listing>range='0,1'</listing></li>
		 * <li><code>step</code> : Une valeur numérique définissant le pas dans les valeurs possible pour ce champ.
		 * <listing>step='0.01'</listing></li></ul></td></tr>
		 * 
		 * <tr><td>pointUint</td><td>DoubleSpinner</td><td><ul>
		 * <li><code>range</code> : Un couple de valeur numérique servant à définir
		 * les bornes minimales et maximales pour la valeur de ce champ.
		 * <listing>range='0,1'</listing></li>
		 * <li><code>step</code> : Une valeur numérique définissant le pas dans les valeurs possible pour ce champ.
		 * <listing>step='0.01'</listing></li></ul></td></tr>
		 * 
		 * <tr><td>pointFloat</td><td>DoubleSpinner</td><td><ul>
		 * <li><code>range</code> : Un couple de valeur numérique servant à définir
		 * les bornes minimales et maximales pour la valeur de ce champ.
		 * <listing>range='0,1'</listing></li>
		 * <li><code>step</code> : Une valeur numérique définissant le pas dans les valeurs possible pour ce champ.
		 * <listing>step='0.01'</listing></li></ul></td></tr>
		 * 
		 * <tr><td>dimensionInt</td><td>DoubleSpinner</td><td><ul>
		 * <li><code>range</code> : Un couple de valeur numérique servant à définir
		 * les bornes minimales et maximales pour la valeur de ce champ.
		 * <listing>range='0,1'</listing></li>
		 * <li><code>step</code> : Une valeur numérique définissant le pas dans les valeurs possible pour ce champ.
		 * <listing>step='0.01'</listing></li></ul></td></tr>
		 * 
		 * <tr><td>dimensionUint</td><td>DoubleSpinner</td><td><ul>
		 * <li><code>range</code> : Un couple de valeur numérique servant à définir
		 * les bornes minimales et maximales pour la valeur de ce champ.
		 * <listing>range='0,1'</listing></li>
		 * <li><code>step</code> : Une valeur numérique définissant le pas dans les valeurs possible pour ce champ.
		 * <listing>step='0.01'</listing></li></ul></td></tr>
		 * 
		 * <tr><td>dimensionFloat</td><td>DoubleSpinner</td><td><ul>
		 * <li><code>range</code> : Un couple de valeur numérique servant à définir
		 * les bornes minimales et maximales pour la valeur de ce champ.
		 * <listing>range='0,1'</listing></li>
		 * <li><code>step</code> : Une valeur numérique définissant le pas dans les valeurs possible pour ce champ.
		 * <listing>step='0.01'</listing></li></ul></td></tr>
		 * 
		 * <tr><td>insetsInt</td><td>QuadSpinner</td><td><ul>
		 * <li><code>range</code> : Un couple de valeur numérique servant à définir
		 * les bornes minimales et maximales pour la valeur de ce champ.
		 * <listing>range='0,1'</listing></li>
		 * <li><code>step</code> : Une valeur numérique définissant le pas dans les valeurs possible pour ce champ.
		 * <listing>step='0.01'</listing></li></ul></td></tr>
		 * 
		 * <tr><td>insetsUint</td><td>QuadSpinner</td><td><ul>
		 * <li><code>range</code> : Un couple de valeur numérique servant à définir
		 * les bornes minimales et maximales pour la valeur de ce champ.
		 * <listing>range='0,1'</listing></li>
		 * <li><code>step</code> : Une valeur numérique définissant le pas dans les valeurs possible pour ce champ.
		 * <listing>step='0.01'</listing></li></ul></td></tr>
		 * 
		 * <tr><td>insetsFloat</td><td>QuadSpinner</td><td><ul>
		 * <li><code>range</code> : Un couple de valeur numérique servant à définir
		 * les bornes minimales et maximales pour la valeur de ce champ.
		 * <listing>range='0,1'</listing></li>
		 * <li><code>step</code> : Une valeur numérique définissant le pas dans les valeurs possible pour ce champ.
		 * <listing>step='0.01'</listing></li></ul></td></tr>
		 * 
		 * <tr><td>bordersInt</td><td>QuadSpinner</td><td><ul>
		 * <li><code>range</code> : Un couple de valeur numérique servant à définir
		 * les bornes minimales et maximales pour la valeur de ce champ.
		 * <listing>range='0,1'</listing></li>
		 * <li><code>step</code> : Une valeur numérique définissant le pas dans les valeurs possible pour ce champ.
		 * <listing>step='0.01'</listing></li></ul></td></tr>
		 * 
		 * <tr><td>bordersUint</td><td>QuadSpinner</td><td><ul>
		 * <li><code>range</code> : Un couple de valeur numérique servant à définir
		 * les bornes minimales et maximales pour la valeur de ce champ.
		 * <listing>range='0,1'</listing></li>
		 * <li><code>step</code> : Une valeur numérique définissant le pas dans les valeurs possible pour ce champ.
		 * <listing>step='0.01'</listing></li></ul></td></tr>
		 * 
		 * <tr><td>bordersFloat</td><td>QuadSpinner</td><td><ul>
		 * <li><code>range</code> : Un couple de valeur numérique servant à définir
		 * les bornes minimales et maximales pour la valeur de ce champ.
		 * <listing>range='0,1'</listing></li>
		 * <li><code>step</code> : Une valeur numérique définissant le pas dans les valeurs possible pour ce champ.
		 * <listing>step='0.01'</listing></li></ul></td></tr>
		 * 
		 * <tr><td>cornersInt</td><td>QuadSpinner</td><td><ul>
		 * <li><code>range</code> : Un couple de valeur numérique servant à définir
		 * les bornes minimales et maximales pour la valeur de ce champ.
		 * <listing>range='0,1'</listing></li>
		 * <li><code>step</code> : Une valeur numérique définissant le pas dans les valeurs possible pour ce champ.
		 * <listing>step='0.01'</listing></li></ul></td></tr>
		 * 
		 * <tr><td>cornersUint</td><td>QuadSpinner</td><td><ul>
		 * <li><code>range</code> : Un couple de valeur numérique servant à définir
		 * les bornes minimales et maximales pour la valeur de ce champ.
		 * <listing>range='0,1'</listing></li>
		 * <li><code>step</code> : Une valeur numérique définissant le pas dans les valeurs possible pour ce champ.
		 * <listing>step='0.01'</listing></li></ul></td></tr>
		 * 
		 * <tr><td>cornersFloat</td><td>QuadSpinner</td><td><ul>
		 * <li><code>range</code> : Un couple de valeur numérique servant à définir
		 * les bornes minimales et maximales pour la valeur de ce champ.
		 * <listing>range='0,1'</listing></li>
		 * <li><code>step</code> : Une valeur numérique définissant le pas dans les valeurs possible pour ce champ.
		 * <listing>step='0.01'</listing></li></ul></td></tr>
		 * 
		 * </table>
		 * 
		 * @param	o	objet pour lequel généré un objet formulaire
		 * @return	un objet <code>FormObject</code> pour toutes les propriétés de <code>o</code> décorées
		 * 			avec des balises de meta-données de type <code>[Form]</code>
		 * @see abe.com.mon.utils.Reflection#get()
		 * @example Ci-dessous la déclaration des balises <code>[Form]</code> dans la classe <code>Dimension</code>.
		 * <listing>public class Dimension implements Cloneable, Serializable, Equatable, FormMetaProvider
		 * {
		 * 	[Form(type="floatSpinner",
		 * 		  label="Width",
		 * 		  range="Number.NEGATIVE_INFINITY,Number.POSITIVE_INFINITY",
		 * 		  step="1",
		 * 		  order="0")]
		 * 	public var width : Number;
		 * 	
		 * 	[Form(type="floatSpinner",
		 * 		  label="Height",
		 * 		  range="Number.NEGATIVE_INFINITY,Number.POSITIVE_INFINITY",
		 * 		  step="1",
		 * 		  order="1")]
		 * 	public var height : Number;
		 * 	
		 * 	// Reste de la définition de la classe...
		 * }</listing>
		 * Le code ci-dessous permet de créer un formulaire pour cet objet : 
		 * <listing>// On créer une instance de la classe Dimension
		 * var d : Dimension = new Dimension(256,128),
		 * // On génère un objet FormObject pour l'instance de Dimension
		 * var fo : FormObject = FormUtils.createFormFromMetas( d );
		 * // On utilise le FieldSetFormRenderer afin de constuire le formulaire graphique
		 * var c : Component = FieldSetFormRenderer.instance.render( fo );
		 * // On créer un manager pour le FormObject
		 * var sfm : SimpleFormManager = new SimpleFormManager( fo );
		 * // Finalement on ajoute le formulaire graphique sur la scène
		 * addChild( c );</listing>
		 */
		static public function createFormFromMetas ( o : Object ) : FormObject
		{
			var members : XMLList = Reflection.getClassMembersWithMeta(o, "Form" );
			var excludeList : XMLList = Reflection.getClassMeta(o, "FormList");
			
			if( members.length() == 0 )
				return null;
			
			var meta : XMLList;
			var type : String;			var category : String;			var order : Number;
			var label : String;
			var value : *;
			var args : Object;
			var fn : Function;
			var name : String;
			var defaultValue : *;
			var c : Component;
			var linesOrders : Array = [];			var categoriesNames : Array = [];
			var categories : Object = {};
			var hasCategories : Boolean;
			var formObject : FormObject = new FormObject( o, [] );
			var formField : FormField;
			var categoryOrder : Number;
			var fieldExclusion : Object = {};
			var memberType : String;			var disabled : Boolean;			var description : String;
			
			/**
			 * <meta name="FormList"><arg key="fields" value="foo,oof"/></meta>
			 */
			/*
			 * Looping through the list of [FormList] tags of the object
			 * and construct a single array with the fields names.
			 * Then the map fieldExclusion is filled.
			 */
			if( excludeList.length() > 0 )
			{
				var fields : XMLList = excludeList..arg.(@key == "fields").@value;
				var ar : Array = [];
				for each( var s : String in fields)
					ar = ar.concat(s.split(","));
					
				var l : uint = ar.length;
				for( var jj : int = 0; jj<l; jj++)
					fieldExclusion[ar[jj]] = true;			}
			
			for each( var member : XML in members )
			{
				/*
				 * First checking the member's name against the eclusion list. 
				 */
				name = member.@name;
				memberType = member.@type;
				if( fieldExclusion.hasOwnProperty(name) )
					continue;
								
				/*
				 * Getting the whole data from meta and member
				 */
				meta = member.metadata.(@name=="Form");
				args = getArguments(meta.children());
				type = meta.arg.(@key=="type").@value;				label = meta.arg.(@key=="label").@value;				category = meta.arg.(@key=="category").@value;				categoryOrder = parseFloat( meta.arg.(@key=="categoryOrder").@value );				order = meta.arg.(@key=="order").@value;
				defaultValue = Reflection.get( meta.arg.(@key=="defaultValue").@value );
				description = meta.arg.(@key=="description").@value;
				disabled = meta.arg.(@key=="enabled").@value == "false";
				var objHasValue : Boolean = NUMBER_TYPES.indexOf(memberType)!= -1 ? !isNaN( o[name]) : o[name] != null;
				
				if( objHasValue )
					value = o[name];
				else if( defaultValue != undefined )
				{
					value = defaultValue;	
					o[name] = defaultValue;
				}
				else value = null;
				
				if( !type )
					type = member.@type;
				
				fn = _typesMap[ type ];
				if( fn != null )
				{
					c = fn(value,args);
					
					if( c )
					{
						formField = new FormField( label ? label : name, name, c, order, Reflection.get( memberType ), description );
						
						if( XMLUtils.hasAttribute( member, "access" ) && 
							member.@access == "readonly" )
							c.enabled = false;
						else
							c.enabled = !disabled;
						
						if( category && !hasCategories )
						{
							hasCategories = true;
							categories.nocategory = new FormCategory(_("Other(s)"), formObject.fields.concat() );
							categories[ category ] = new FormCategory(_(category), [ formField ], categoryOrder );
							categoriesNames.push( category );
						}
						else if( hasCategories )
						{
							if( category && !categories[ category ] )
							{
								categories[ category ] = new FormCategory( _(category), [ formField ], categoryOrder );
								categoriesNames.push( category );
							}
							else if ( category && categories[ category ] )
							{
								categories[ category ].fields.push(formField);
								if( isNaN( categories[ category ].order ) && !isNaN( categoryOrder ) )	
									categories[ category ].order = categoryOrder;
							}
							else
								categories.nocategory.fields.push(formField);
						}
						formObject.fields.push( formField );						linesOrders.push( order );
					}
				}
			}
			
			var cats : Array = [];
			if( hasCategories )
			{
				_tmpCategories = categories;
				categoriesNames.sort( categoriesSort );
				_tmpCategories = null;
				
				categoriesNames.push( "nocategory" );
				var ll : Number = categoriesNames.length;
				for( var i : int = 0;i<ll;i++ )
				{
					
					var a : FormCategory = categories[categoriesNames[i]];
					a.fields.sort( fieldsSort );
					cats.push( a );
				}
			}
			formObject.categories = cats;			formObject.fields.sort( fieldsSort );
				
			meta = null;
			type = null;
			category = null;
			order = 0;
			label = null;
			value = null;
			args  = null;
			fn = null;
			name = null;
			defaultValue = null;
			c = null;
			linesOrders  = null;
			categoriesNames = null;
			categories = null;
			formField = null;
			categoryOrder = 0;
			fieldExclusion = null;
			memberType = null;
			description = null;	
			
			return formObject;	
		}
		
		static private function getArguments ( xmlList : XMLList ) : Object
		{
			var o : Object = {};
			
			for each ( var x : XML in xmlList )
			{
				var key : String = x.@key;
				
				if( key == "type" ||
					key == "label" || 
					key == "defaultValue" ||					key == "order" ||					key == "category" ||					key == "categoryOrder" ||
					key == "environment" )
					continue;
				
				var value : * = Reflection.get(x.@value);
				
				o[ key ] = value;
			}
			
			return o;
		}
		
/*-----------------------------------------------------------------------------------*
 * NATIVE FORM FUNCTION
 *-----------------------------------------------------------------------------------*/
 		static private function getObjectForm ( o : Object ) : FormObject 
		{
			var fields : Array = [];
			var n : uint = 0;
			for( var i : String in o )
			{
				var f : FormField = new FormField( i, i, getComponentForValue(o[i]), n++, Reflection.getClass(o[i]) );
				fields.push(f);
			}
			return new FormObject( o, fields );
		}
		static private function getColorMatrixFilterForm ( o : ColorMatrixFilter ) : FormObject 
		{
			return new FormObject( o , 
								   [ new FormField( _("Matrix"), 
								   					"matrix", 
								   					new ColorMatrixEditor( o ), 
								   					0, 
								   					Array, 
								   					_("Due to the impossiblity to determinate the initial settings with the matrix contained in a ColorMatrixFilter instance, editing the matrix consist in recreating the whole matrix from scratch.") ) ] );
		}
		
/*-----------------------------------------------------------------------------------*
 * FORM COMPONENT FUNCTION
 *-----------------------------------------------------------------------------------*/
		static private function getArray ( v : Array, args : Object ) : *
		{
			var l : ListEditor = new ListEditor( v ? v : [] );
			
			ifenum:if( args.hasOwnProperty( "enumeration" ) && args.enumeration is Array )
			{
				var e : Array = args.enumeration;
				var le : uint = e.length;
				var c : ComboBox;
				if( args.hasOwnProperty( "contentType" ) && args.contentType is Class )
				{
					var t : Class = args.contentType;
					
					for( var i:int=0;i<le;i++) 
						if( !( e[i] is t ) )
							break ifenum;
					
					c = new ComboBox( e );
					l.newValueProvider = c;
					l.contentType = t;
				}
				else
				{
					c = new ComboBox( e );
					l.newValueProvider = c;
				}
				return l;
			}		
			if( args.hasOwnProperty( "contentType" ) && args.contentType is Class )
			{
				var fn : Function;
				fn = _typesMap[ getQualifiedClassName( args.contentType ) ];
				
				if( fn != null )
				{
					var provider : Component = fn( getNewValue(args.contentType), {} );
					if( provider )
						l.newValueProvider = provider;
					else
						l.newValueProvider = new TextInput();
				}
				l.contentType = args.contentType;
				
				if( args.hasOwnProperty( "listCell" ) && args.listCell is Class )
					l.list.listCellClass = args.listCell;
			}
			else
			{
				l.newValueProvider = new TextInput();
			}
			return l;
		}
		
		static private function getIntSpinner ( v : int, args : Object ) : Spinner
		{
			var min : int;			var max : int;			var step : int;
			
			if( args.hasOwnProperty( "range" ) && args.range is Array )
			{
				min = args.range[0];				max = args.range[1];
			}
			else
			{
				min = int.MIN_VALUE;
				max = int.MAX_VALUE;
			}
			if( args.hasOwnProperty( "step" ) )
			{
				step = args.step;
			}
			else
			{
				step = 1;
			}		
			
			return new Spinner(new SpinnerNumberModel( v, min, max, step, true ) );
		}
		static private function getIntSlider ( v : int, args : Object ) : HSlider
		{
			var min : int;
			var max : int;
			var step : int;
			
			if( args.hasOwnProperty( "range" ) && args.range is Array )
			{
				min = args.range[0];
				max = args.range[1];
			}
			else
			{
				min = int.MIN_VALUE;
				max = int.MAX_VALUE;
			}
			if( args.hasOwnProperty( "step" ) )
			{
				step = args.step;
			}
			else
			{
				step = 1;
			}
			var model : DefaultBoundedRangeModel = new DefaultBoundedRangeModel( v, min, max, step );
			model.formatFunction = function ( v : * ) : String { return String(v); }	
			
			return new HSlider( model, 
								10, 
								step, 
								false, 
								true, 
								true, 
								!isNaN( min ) ? new Label(min.toString() ) : null, 
								!isNaN( max ) ? new Label(max.toString() ) : null );
		}
		static private function getUintSpinner ( v : uint, args : Object ) : Spinner
		{
			var min : uint;
			var max : uint;
			var step : uint;
			
			if( args.hasOwnProperty( "range" ) && args.range is Array )
			{
				min = args.range[0];
				max = args.range[1];
			}
			else
			{
				min = uint.MIN_VALUE;
				max = uint.MAX_VALUE;
			}
			if( args.hasOwnProperty( "step" ) )
			{
				step = args.step;
			}
			else
			{
				step = 1;
			}		
			
			return new Spinner( new SpinnerNumberModel( v, min, max, step, true ) );
		}
		static private function getUintSlider ( v : uint, args : Object ) : HSlider
		{
			var min : uint;
			var max : uint;
			var step : uint;
			
			if( args.hasOwnProperty( "range" ) && args.range is Array )
			{
				min = args.range[0];
				max = args.range[1];
			}
			else
			{
				min = uint.MIN_VALUE;
				max = uint.MAX_VALUE;
			}
			
			if( args.hasOwnProperty( "step" ) )
				step = args.step;
			else
				step = 1;
				
			var model : DefaultBoundedRangeModel = new DefaultBoundedRangeModel( v, min, max, step );
			model.formatFunction = function ( v : * ) : String { return String(v); };
			return new HSlider( model, 
								10, 
								1, 
								false, 
								true, 
								true, 
								!isNaN( min ) ? new Label(min.toString() ) : null, 
								!isNaN( max ) ? new Label(max.toString() ) : null  );
		}
		static private function getFloatSpinner ( v : Number, args : Object ) : Spinner
		{
			var min : Number;
			var max : Number;
			var step : Number;
			
			if( args.hasOwnProperty( "range" ) && args.range is Array )
			{
				min = args.range[0];
				max = args.range[1];
			}
			else
			{
				min = Number.NEGATIVE_INFINITY;
				max = Number.POSITIVE_INFINITY;
			}
			if( args.hasOwnProperty( "step" ) )
			{
				step = args.step;
			}
			else
			{
				step = 1;
			}		
			
			return new Spinner(new SpinnerNumberModel( v, min, max, step ) );
		}
		static private function getFloatSlider ( v : Number, args : Object ) : HSlider
		{
			var min : Number;
			var max : Number;
			var step : Number;
			
			if( args.hasOwnProperty( "range" ) && args.range is Array )
			{
				min = args.range[0];
				max = args.range[1];
			}
			else
			{
				min = NaN;
				max = NaN;
			}
			if( args.hasOwnProperty( "step" ) )
			{
				step = args.step;
			}
			else
			{
				step = 1;
			}		
			
			return new HSlider( new DefaultBoundedRangeModel( v, min, max, step ), 
								10, 
								1, 
								false, 
								false, 
								true, 
								!isNaN( min ) ? new Label(min.toString() ) : null, 
								!isNaN( max ) ? new Label(max.toString() ) : null );
		}
		static private function getDateSpinner ( d : Date, args : Object ) : Spinner
		{
			var min : Date;
			var max : Date;
			if( args.hasOwnProperty( "range" ) && args.range is Array )
			{
				min = args.range[0];
				max = args.range[1];
			}
			return new Spinner( new SpinnerDateModel(d, min, max ) );
		}
		static private function getDateCalendar ( d : Date, args : Object ) : DatePicker
		{
			return new DatePicker(d);
		}
		static private function getTimeDelta ( d : TimeDelta, args : Object ) : TimeDeltaPicker
		{
			return new TimeDeltaPicker(d);
		}
		static private function getString ( v : String, args : Object ) : Component
		{
			if( args.hasOwnProperty( "enumeration" ) )
			{
				var combobox : ComboBox = new ComboBox( args.enumeration );
				
				combobox.model.selectedElement = v;
				combobox.popupAlignOnSelection = true;
					
				return combobox;
			}
			else
			{
				var ti : TextInput = new TextInput( args.hasOwnProperty( "length" ) ? args.length : 0 );
				ti.value = v ? v : "";
				return ti;
			}
		}
		static private function getText ( v : String, args : Object ) : TextArea
		{
			var ta : TextArea = new TextArea();

			ta.value = v ? v : "";
			
			return ta;
		}
		static private function getPassword ( v : String, args : Object ) : TextInput
		{
			var ti : TextInput = new TextInput( args.hasOwnProperty( "length" ) ? args.length : 0, true );

			ti.value = v ? v : "";
			
			
			return ti;
		}
		static private function getBoolean ( v : Boolean, args : Object ) : CheckBox
		{
			var c : CheckBox = new CheckBox("");
			c.checked = v;
			
			return c;
		}
		static private function getColor ( v : Color, args : Object ) : ColorPicker
		{
			return new ColorPicker(v);
		}
		static private function getGradient ( v : Gradient, args : Object ) : GradientPicker
		{
			return new GradientPicker(v);
		}
		static private function getFiltersArray ( v : Array, args : Object ) : *
		{
			return new FiltersPicker( v );
		}
		
		/*FDT_IGNORE*/ FEATURES::BUILDER /*FDT_IGNORE*/
		static private function getComponentDecoration ( v : ComponentDecoration, args : Object ) : *
		{
			return new ComponentDecorationPicker(); 
		}

		static private function getDimensionInt ( v : Dimension, args : Object ) : *
		{
			var min : int;
			var max : int;
			var step : int;
			
			if( args.hasOwnProperty( "range" ) && args.range is Array )
			{
				min = args.range[0];
				max = args.range[1];
			}
			else
			{
				min = int.MIN_VALUE;
				max = int.MAX_VALUE;
			}
			if( args.hasOwnProperty( "step" ) )
			{
				step = args.step;
			}
			else
			{
				step = 1;
			}	
			return new DoubleSpinner( v, "width", "height", min, max, step, true );
		}
		static private function getDimensionUint ( v : Dimension, args : Object ) : *
		{
			var min : uint;
			var max : uint;
			var step : uint;
			
			if( args.hasOwnProperty( "range" ) && args.range is Array )
			{
				min = args.range[0];
				max = args.range[1];
			}
			else
			{
				min = uint.MIN_VALUE;
				max = uint.MAX_VALUE;
			}
			if( args.hasOwnProperty( "step" ) )
			{
				step = args.step;
			}
			else
			{
				step = 1;
			}	
			return new DoubleSpinner( v, "width", "height", min, max, step, true );
		}
		static private function getDimensionFloat ( v : Dimension, args : Object ) : *
		{
			var min : Number;
			var max : Number;
			var step : Number;
			
			if( args.hasOwnProperty( "range" ) && args.range is Array )
			{
				min = args.range[0];
				max = args.range[1];
			}
			else
			{
				min = Number.NEGATIVE_INFINITY;
				max = Number.POSITIVE_INFINITY;
			}
			if( args.hasOwnProperty( "step" ) )
			{
				step = args.step;
			}
			else
			{
				step = 1;
			}	
			return new DoubleSpinner( v, "width", "height", min, max, step );
		}
		static private function getPointInt ( v : Point, args : Object ) : *
		{
			var min : int;
			var max : int;
			var step : int;
			
			if( args.hasOwnProperty( "range" ) && args.range is Array )
			{
				min = args.range[0];
				max = args.range[1];
			}
			else
			{
				min = int.MIN_VALUE;
				max = int.MAX_VALUE;
			}
			if( args.hasOwnProperty( "step" ) )
			{
				step = args.step;
			}
			else
			{
				step = 1;
			}	
			return new DoubleSpinner( v, "x", "y", min, max, step, true );
		}
		static private function getPointUint ( v : Point, args : Object ) : *
		{
			var min : uint;
			var max : uint;
			var step : uint;
			
			if( args.hasOwnProperty( "range" ) && args.range is Array )
			{
				min = args.range[0];
				max = args.range[1];
			}
			else
			{
				min = uint.MIN_VALUE;
				max = uint.MAX_VALUE;
			}
			if( args.hasOwnProperty( "step" ) )
			{
				step = args.step;
			}
			else
			{
				step = 1;
			}	
			return new DoubleSpinner( v, "x", "y", min, max, step, true );
		}
		static private function getPointFloat ( v : Point, args : Object ) : *
		{
			var min : Number;
			var max : Number;
			var step : Number;
			
			if( args.hasOwnProperty( "range" ) && args.range is Array )
			{
				min = args.range[0];
				max = args.range[1];
			}
			else
			{
				min = Number.NEGATIVE_INFINITY;
				max = Number.POSITIVE_INFINITY;
			}
			if( args.hasOwnProperty( "step" ) )
			{
				step = args.step;
			}
			else
			{
				step = 1;
			}	
			return new DoubleSpinner( v, "x", "y", min, max, step );
		}
		static private function getTextFormat ( v : TextFormat, args : Object ) : *
		{
			return new TextFormatEditor( v );
		}
		
		static private function getInsetsInt ( v : Insets, args : Object ) : *
		{
			var min : int;
			var max : int;
			var step : int;
			
			if( args.hasOwnProperty( "range" ) && args.range is Array )
			{
				min = args.range[0];
				max = args.range[1];
			}
			else
			{
				min = int.MIN_VALUE;
				max = int.MAX_VALUE;
			}
			if( args.hasOwnProperty( "step" ) )
			{
				step = args.step;
			}
			else
			{
				step = 1;
			}	
			return new QuadSpinner( v, "top", "bottom", "left", "right", min, max, step, true );
		}
		static private function getInsetsUint ( v : Insets, args : Object ) : *
		{
			var min : uint;
			var max : uint;
			var step : uint;
			
			if( args.hasOwnProperty( "range" ) && args.range is Array )
			{
				min = args.range[0];
				max = args.range[1];
			}
			else
			{
				min = uint.MIN_VALUE;
				max = uint.MAX_VALUE;
			}
			if( args.hasOwnProperty( "step" ) )
			{
				step = args.step;
			}
			else
			{
				step = 1;
			}	
			return new QuadSpinner( v, "top", "bottom", "left", "right", min, max, step, true );
		}
		
		static private function getInsetsFloat ( v : Insets, args : Object ) : *
		{
			var min : Number;
			var max : Number;
			var step : Number;
			
			if( args.hasOwnProperty( "range" ) && args.range is Array )
			{
				min = args.range[0];
				max = args.range[1];
			}
			else
			{
				min = Number.NEGATIVE_INFINITY;
				max = Number.POSITIVE_INFINITY;
			}
			if( args.hasOwnProperty( "step" ) )
			{
				step = args.step;
			}
			else
			{
				step = 1;
			}	
			return new QuadSpinner( v, "top", "bottom", "left", "right", min, max, step );
		}
		static private function getBordersInt ( v : Borders, args : Object ) : *
		{
			var min : int;
			var max : int;
			var step : int;
			
			if( args.hasOwnProperty( "range" ) && args.range is Array )
			{
				min = args.range[0];
				max = args.range[1];
			}
			else
			{
				min = int.MIN_VALUE;
				max = int.MAX_VALUE;
			}
			if( args.hasOwnProperty( "step" ) )
			{
				step = args.step;
			}
			else
			{
				step = 1;
			}	
			return new QuadSpinner( v, "top", "bottom", "left", "right", min, max, step, true );
		}
		static private function getBordersUint ( v : Borders, args : Object ) : *
		{
			var min : uint;
			var max : uint;
			var step : uint;
			
			if( args.hasOwnProperty( "range" ) && args.range is Array )
			{
				min = args.range[0];
				max = args.range[1];
			}
			else
			{
				min = uint.MIN_VALUE;
				max = uint.MAX_VALUE;
			}
			if( args.hasOwnProperty( "step" ) )
			{
				step = args.step;
			}
			else
			{
				step = 1;
			}	
			return new QuadSpinner( v, "top", "bottom", "left", "right", min, max, step, true );
		}
		static private function getBordersFloat ( v : Borders, args : Object ) : *
		{
			var min : Number;
			var max : Number;
			var step : Number;
			
			if( args.hasOwnProperty( "range" ) && args.range is Array )
			{
				min = args.range[0];
				max = args.range[1];
			}
			else
			{
				min = Number.NEGATIVE_INFINITY;
				max = Number.POSITIVE_INFINITY;
			}
			if( args.hasOwnProperty( "step" ) )
			{
				step = args.step;
			}
			else
			{
				step = 1;
			}	
			return new QuadSpinner( v, "top", "bottom", "left", "right", min, max, step );
		}
		
		static private function getCornersInt ( v : Corners, args : Object ) : *
		{
			var min : int;
			var max : int;
			var step : int;
			
			if( args.hasOwnProperty( "range" ) && args.range is Array )
			{
				min = args.range[0];
				max = args.range[1];
			}
			else
			{
				min = int.MIN_VALUE;
				max = int.MAX_VALUE;
			}
			if( args.hasOwnProperty( "step" ) )
			{
				step = args.step;
			}
			else
			{
				step = 1;
			}	
			return new QuadSpinner( v, "topLeft", "topRight", "bottomLeft", "bottomRight", min, max, step, true );
		}
		static private function getCornersUint ( v : Corners, args : Object ) : *
		{
			var min : uint;
			var max : uint;
			var step : uint;
			
			if( args.hasOwnProperty( "range" ) && args.range is Array )
			{
				min = args.range[0];
				max = args.range[1];
			}
			else
			{
				min = uint.MIN_VALUE;
				max = uint.MAX_VALUE;
			}
			if( args.hasOwnProperty( "step" ) )
			{
				step = args.step;
			}
			else
			{
				step = 1;
			}	
			return new QuadSpinner( v, "topLeft", "topRight", "bottomLeft", "bottomRight", min, max, step, true );
		}
		static private function getIcon ( v : *, args : Object ) : *
		{
			return new IconPicker( v );
		}
		static private function getCornersFloat ( v : Corners, args : Object ) : *
		{
			var min : Number;
			var max : Number;
			var step : Number;
			
			if( args.hasOwnProperty( "range" ) && args.range is Array )
			{
				min = args.range[0];
				max = args.range[1];
			}
			else
			{
				min = Number.NEGATIVE_INFINITY;
				max = Number.POSITIVE_INFINITY;
			}
			if( args.hasOwnProperty( "step" ) )
			{
				step = args.step;
			}
			else
			{
				step = 1;
			}	
			return new QuadSpinner( v, "topLeft", "topRight", "bottomLeft", "bottomRight", min, max, step );
		}

		static private function getURLInput ( v : *, args : Object ) : *
		{
			if( args.hasOwnProperty( "enumeration" ) )
			{
				var combobox : ComboBox = new ComboBox( args.enumeration );
				
				combobox.model.selectedElement = v;
				combobox.popupAlignOnSelection = true;
					
				return combobox;
			}
			else
			{
				var ti : URLInput = new URLInput( args.hasOwnProperty( "length" ) ? args.length : 0 );
				ti.value = v ? v : "";
				return ti;
			}
		}
		static private function getClassPathInput ( v : *, args : Object ) : *
		{
			if( args.hasOwnProperty( "enumeration" ) )
			{
				var combobox : ComboBox = new ComboBox( args.enumeration );
				
				combobox.model.selectedElement = v;
				combobox.popupAlignOnSelection = true;
					
				return combobox;
			}
			else
			{
				var ti : ClassPathInput = new ClassPathInput( args.hasOwnProperty( "length" ) ? args.length : 0 );
				ti.value = v ? v : "";
				return ti;
			}
		}
	}
}
