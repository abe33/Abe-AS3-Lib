/**
 * @license
 */
package abe.com.ponents.core.edit 
{
    import abe.com.mon.colors.Color;
    import abe.com.ponents.actions.builtin.ColorPickerAction;
    import abe.com.ponents.models.SpinnerNumberModel;
    import abe.com.ponents.spinners.Spinner;
    import abe.com.ponents.text.TextEditor;

    import flash.utils.getQualifiedClassName;



	/**
	 * Instance globale de la classe <code>EditorFactory</code>.
	 * <p>
	 * Les implémentations de l'interface <code>Editor</code> dans le set de composants
	 * font à l'heure actuelle appelle à cette instance pour récupérer les objets
	 * <code>Editor</code> utilisé dans leur séquence d'édition respectives.
	 * </p>
	 * @author Cédric Néhémie
	 */
	public const EditorFactoryInstance : EditorFactory = new EditorFactory();
	
	EditorFactoryInstance.registerClass( "*", ObjectPropertiesEditor );
	
	EditorFactoryInstance.register( null , new TextEditor() );
	EditorFactoryInstance.register( getQualifiedClassName(String), new TextEditor() );	EditorFactoryInstance.register( getQualifiedClassName(Number), new Spinner( new SpinnerNumberModel(0) ) );	//EditorFactoryInstance.register( getQualifiedClassName(Boolean), new ComboBox(true, false) );	EditorFactoryInstance.register( getQualifiedClassName(uint), new Spinner( new SpinnerNumberModel(0,uint.MIN_VALUE, uint.MAX_VALUE, 1, true) ) );	EditorFactoryInstance.register( getQualifiedClassName(int), new Spinner( new SpinnerNumberModel(0,int.MIN_VALUE, int.MAX_VALUE, 1, true) ) );	EditorFactoryInstance.register( getQualifiedClassName(Color), new ColorPickerAction() );}
