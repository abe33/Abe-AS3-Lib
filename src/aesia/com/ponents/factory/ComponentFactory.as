package aesia.com.ponents.factory 
{
	/**
	 * L'interface <code>ComponentFactory</code> définie les méthodes disponibles
	 * sur les objets de la factory de composants.
	 * <p>
	 * Les classes implémentant cette interface participent à la constitution
	 * d'une séquence de construction de composants. La construction concrète
	 * étant réalisée quant à elle au sein de la classe <code>ComponentFactoryProcessor</code>
	 * qui implémente l'interface <code>ComponentFactory</code> et sert de racine
	 * pour la structure de construction.
	 * </p>
	 * 
	 * @author	Cédric Néhémie
	 * @see ComponentFactoryProcessor
	 */
	public interface ComponentFactory 
	{
		/**
		 * Un entier indiquant le nombre de composants restant à construire pour l'instance
		 * courante de <code>ComponentFactory</code>.
		 */
		function get componentsToBuild() : uint;
		/**
		 * Renvoie une référence vers un sous-ensemble d'entrées dans la factory.
		 * <p>
		 * Si le paramètre <code>id</code> est non-nul, et qu'un groupe existe déjà
		 * avec cet identifiant dans la liste des groupes de la factory racine, alors
		 * ce groupe est renvoyé. Dans le cas contraire, un groupe est créer, et si
		 * un identifiant a été fournit, ce groupe est enregistré dans la factory
		 * racine.
		 * </p>
		 * 
		 * @param	id			un identifiant pour le groupe	
		 * @param	callback	une fonction qui sera appelée lorsque la construction
		 * 						des entrées du groupe aura pris fin
		 * @return	une référence vers un sous-ensemble d'entrées dans la factory
		 * @example	Les groupes sont très utiles pour structurer les différentes phases 
		 * de construction.
		 * <p>
		 * Prenons le cas d'une interface d'applications que l'on souhaite personnalisable 
		 * ; par exemple en déplacant des éléments dans l'interface ou en paramétrant l'affichage
		 * de certains autres. Il est nécessaire de dissocier la création des éléments manipulables
		 * (boutons, onglets, etc...), des éléments sensés contenir ces éléments (panneau, groupe
		 * d'onglets, barre d'outils) : 
		 * </p>
		 * <listing>ComponentFactoryInstance.group("movables");
		 * ComponentFactoryInstance.group("containers");
		 * </listing>
		 * <p>
		 * Une fois les groupes crées, les demande de construction des containers et de leur contenu
		 * peuvent être réalisée de manière complètement arbitraire : 
		 * </p>
		 * <listing>function init1 () : void
		 * {
		 * 	ComponentFactoryInstance
		 * 				.group("movables").build( Button,"button1" )
		 * 				.group("containers").build( Panel, "panel1", null, null, function(p:Panel,c:Context){ p.addComponent(c["button2"]);} );
		 * }
		 * function init2 () : void
		 * {
		 * 	ComponentFactoryInstance
		 * 				.group("movables").build( Button,"button2" )
		 * 				.group("containers").build( Panel, "panel2", null, null, function(p:Panel,c:Context){ p.addComponent(c["button1"]);} );
		 * }
		 * init1();		 * init2();
		 * </listing>
		 * <p>
		 * Ci-dessus, les deux boutons <code>button1</code> et <code>button2</code> seront construit avant les 
		 * deux containers <code>panel1</code> et <code>panel2</code>. Ainsi, la fonction qui déclare concrètement
		 * un élément peut être executé après que celle chargée de déclarer la construction de l'élément chargé de
		 * le contenir
		 * </p>
		 * <p>
		 * Des groupes peuvent être imbriqués entre eux, cependant les identifiants
		 * sont gérés de manière globale. Ainsi, il est tout à fait possible de 
		 * changer de groupe directement dans une chaîne d'opération, telle que : 
		 * </p>
		 * <listing>ComponentFactoryInstance
		 * 			// 1er groupe
		 * 			.group("group1")
		 * 			// second groupe, situé à l'intérieur du groupe 1
		 * 			.group("group2")
		 * 			// on ajoute un bouton dans le groupe 2
		 * 			.build(Button)
		 * 			// on récupère de nouveau une référence au groupe 1 
		 * 			.group("group1")
		 * 			// on ajoute un bouton au groupe 1
		 * 			.build(Button)
		 * 			// on récupère la racine
		 * 			.group("root")
		 * 			// on ajoute un bouton à la racine
		 * 			.build( Button );
		 * // la structure de construction ressemble désormais à ça : 
		 * //	+ root
		 * //		+ group1
		 * //			+ group2
		 * //				- button
		 * //			- button
		 * // 		- button
		 * </listing>
		 */
		function group ( id : String = null, callback : Function = null ) : ComponentFactory;
		/**
		 * [fluent] Ajoute une entrée dans la liste des instances à créer.
		 * <p>
		 * L'instance n'est pas créée lors de l'appel à la méthode <code>build</code>,
		 * à la place, les informations de créations sont stockées dans un objet
		 * <code>ComponentFactoryProcessEntry</code>. Toutes ces informations
		 * seront évaluées seulement lors de la construction.
		 * </p>
		 * 
		 * @param	c				une référence vers la <code>Class</code> à instancier
		 * @param	id				une chaîne permettant d'enregistrer l'instance dans 
		 * 							le contexte de construction. Cette instance sera accessible
		 * 							dans la suite de la construction à l'aide de cette chaîne.
		 * @param	args			un <code>Array</code> d'arguments pour le constructeur,
		 * 							ou alternativement une <code>Function</code> renvoyant
		 * 							un <code>Array</code>.
		 * 							<p>
		 * 							Dans le cas d'une fonction, celle-ci doit avoir la signature
		 * 							suivante : </p>
		 * 							<listing>function( context : Object ) : Array;</listing>
		 * @param	kwargs			un <code>Object</code> d'initialisation pour l'instance créée,
		 * 							ou alternativement une <code>Function</code> renvoyant
		 * 							un <code>Object</code>. 
		 * 							<p>
		 * 							Il est possible d'appeler aussi bien une propriété qu'une
		 * 							méthode sur l'objet.
		 * 							</p><p>
		 * 							Dans le cas d'une fonction, celle-ci doit avoir la signature
		 * 							suivante : </p>
		 * 							<listing>function( o : &lt;TheTypeOfTheCreatedObject&gt;, context : Object ) : Object;</listing>
		 * 							<p>
		 * 							Les valeurs utilisées pour initialiser une propriétés peuvent
		 * 							être soit la valeur directement, soit une <code>Fonction</code>
		 * 							renvoyant la valeur à affecter. 
		 * 							</p>
		 * 							<p>
		 * 							Dans le cas d'une fonction, celle-ci doit avoir la signature
		 * 							suivante : </p>
		 * 							<listing>function( o : &lt;TheTypeOfTheCreatedObject&gt;, key : String, context : Object ) : &lt;ThePropertyTypeOrArray&gt;;</listing>
		 * @param	callback		une <code>Fonction</code> à appeller en fin de création. Cette
		 * 							fonction reçoit l'objet crée ainsi que le contexte en arguments.
		 * 							<p>
		 * 							Cette fonction doit avoir la signature suivante : 
		 * 							</p> 
		 * 							<listing>function( o : &lt;TheTypeOfTheCreatedObject&gt;, context : Object ) : void;</listing>
		 * @param	kwargsOrder		un <code>Array</code> optionnel permettant de définir un ordre
		 * 							pour le traitement de <code>kwargs</code>. Ce tableau doit contenir
		 * 							les noms des propriétés à traiter, dans l'ordre souhaité de traitement.
		 * 							Toutes les propriétés présentes dans <code>kwargs</code> mais qui ne 
		 * 							sont pas présentes dans <code>kwargsOrder</code> seront traitées à la fin.
		 * @return	une référence vers l'instance courante de <code>ComponentFactory</code> afin de satisfaire
		 * 			l'interface fluide de la méthode <code>build</code>
		 * @example Le code suivant permet de créer un simple bouton avec un texte en argument : 
		 * <listing>ComponentFactoryInstance.build(Button, "button", ["My Button Label"]);</listing>
		 * <p>
		 * Dans l'exemple ci-dessous, on utilise une fonction personalisée pour définir les arguments
		 * du dernier composant en lui transmettant les deux premiers objets crées : 
		 * </p>
		 * <listing>ComponentFactoryInstance
		 * 			.build( Button, 
		 * 				"button", 
		 * 				["My Button Label"] )
		 * 	
		 * 			.build( TextInput, 
		 * 				"input" )
		 * 	
		 * 			.build( SplitPane, 
		 * 				"splitpane", 
		 * 				function( context : Object ) : Array
		 * 				{ 
		 * 					return [ context["button"], context["input"] ]; 
		 * 				} );</listing>
		 * <p>
		 * <strong>Note : </strong> On peut observer dans l'exemple précédent l'utilisation de l'interface
		 * fluide de la fonction dans l'enchaînement des appels à la méthode <code>build</code>.
		 * </p>
		 * <p>Enfin, dans ce dernier exemple, on peut voir comment procéder à la création d'une barre d'outils
		 * en récupérant la liste des actions à partir d'un gestionnaire de paramètres personnalisé :</p>
		 * <listing>
		 * // on récupère la liste des actions de la barre d'outils depuis le gestionnaire de paramètres
		 * // on fournit aussi une valeur par défaut pour la première instanciation
		 * var actionsList : Array = MySettingsManager.get( "toolbar", ["open","-","save","saveas","-","undo","redo"] );
		 * 	
		 * // on créer un bouton pour chaque action
		 * var l : uint = actionsList.length;
		 * for( var i : uint = 0; i &lt; l; i++ ) 
		 * {
		 * 	var actionId : String = actionsList[ i ];
		 * 	// si on a '-' c'est un séparateur, on ignore et on continue
		 * 	if( actionId == "-" )
		 * 		continue; 
		 * 	
		 * 	// on assume que la liste ne contient que des identifiants
		 * 	// d'actions préalablement enregistrées dans le gestionnaire d'actions
		 * 	var action : Action = ActionManagerInstance.get( actionId );
		 * 	ComponentFactoryInstance.build ( 
		 * 			Button, 
		 * 			actionId,
		 * 			[ action ] );
		 * }
		 * // on créer la barre d'outils
		 * ComponentFactoryInstance.build ( 
		 * 			ToolBar, 
		 * 			"toolbar", 
		 * 			null, 
		 * 			{
		 * 				// là on prépare un appel de fonction sur l'objet
		 * 				// avec un tableau d'arguments définit en fonction du contexte
		 * 				// et de la liste des actions précédemment récupérée
		 * 				addComponents:function( t : ToolBar, key : String, context : Object ) : Array
		 * 				{
		 * 					var m : uint = actionsList.length;
		 * 					var a : Array = [];
		 * 					for( var j : uint = 0; j &lt; m; j++ ) 
		 * 					{
		 * 						// c'est ici que l'on créer les séparateurs concrets de la barre d'outils
		 * 						if( actionsList[ j ] == "-" )
		 * 							a.push( new ToolBarSeparator( t ) );
		 * 						else
		 * 							a.push( context[ actionsList[ j ] ] );
		 * 					}
		 * 					return a;
		 * 				},
		 * 				styleKey:'MyCustomToolBar',
		 * 				// on peut bien entendu s'enregistrer en écouteur directement ici
		 * 				addEventListener:[ ComponentEvent.REPAINT, function(e:ComponentEvent):void { Log.debug( "ToolBar " + event.target + " repaint" ); } ]
		 * 			},
		 * 			// on notifie la fin de la construction
		 * 			function( t : ToolBar, context : Context ) : void
		 * 			{
		 * 				Log.debug("ToolBar " + t + " created successfully");
		 * 			},
		 * 			// on souhaite traiter le style avant d'entreprendre les appels de fonctions
		 * 			["styleKey"] );</listing>
		 */
		function build( c : Class, 
					    id : String = null,
					    args : * = null, 
					    kwargs : * = null, 
					    callback : Function = null, 
					    kwargsOrder : Array = null ) : ComponentFactory;
	}
}
