package abe.com.ponents.forms 
{
    import abe.com.mon.utils.Reflection;
    import abe.com.mon.utils.StringUtils;
    import abe.com.mon.utils.XMLUtils;
    import abe.com.patibility.lang._;
    import abe.com.ponents.buttons.HexaColorPicker;
    import abe.com.ponents.core.Component;
    import abe.com.ponents.lists.ListEditor;
    import abe.com.ponents.models.SpinnerNumberModel;
    import abe.com.ponents.spinners.Spinner;

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
			return d;
		}
		
		static private function createFormMap () : Object 
		{
			var o : Object = {};
			
			o[ Object ] = getObjectForm;
			
			return o;
		}
		
		static private var _typesMap : Object = createTypesMap();
		static private var _formMap : Object = createFormMap();		static private var _newMap : Object = createNewMap( );
        
        static public function get typesMap (): Object{ return _typesMap; }
		
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
							categories[ category ] = new FormCategory(category, [ formField ], categoryOrder );
							categoriesNames.push( category );
						}
						else if( hasCategories )
						{
							if( category && !categories[ category ] )
							{
								categories[ category ] = new FormCategory( category, [ formField ], categoryOrder );
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
	}
}
