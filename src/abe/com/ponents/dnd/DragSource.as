/**
 * @license
 */
package  abe.com.ponents.dnd 
{
    import abe.com.mon.core.IInteractiveObject;
    import abe.com.ponents.dnd.gestures.DragGesture;
    import abe.com.ponents.transfer.Transferable;

    import flash.display.DisplayObject;
    import flash.display.InteractiveObject;
	public interface DragSource extends IInteractiveObject
	{
		 /*FDT_IGNORE*/ FEATURES::DND { /*FDT_IGNORE*/
		 /**
 		 * [conditional-compile] Retroune un objet <code>Transferable</code> contenant les informations susceptibles
 		 * d'être utilisé dans les différentes opérations de glisser/déposer de ce composant.
 		 * <p>
		 * <strong>Note :</strong> Cette fonction est soumise à la constante
		 * <a href="../../../../components/Conditional-Compilation.html#DND">FEATURES::DND</a>
		 * dans le cadre de la <a href="../../../../components/Conditional-Compilation.html">compilation conditionnelle</a>.
		 * Veillez donc à conditionner l'usage de cette fonctionnalité à l'usage de la constante de compilation associée. 
		 * </p>
		 * 
		 * @see ../../../../components/Conditional-Compilation.html#DND Constante FEATURES::DND
 		 */
		function get transferData () : Transferable;
		/**
		 * [conditional-compile] Une référence vers le <code>DisplayObject</code> qui sera utilisé comme apparence
		 * pour les phases de glisser/déposer.
 		 * <p>
		 * <strong>Note :</strong> Cette fonction est soumise à la constante
		 * <a href="../../../../components/Conditional-Compilation.html#DND">FEATURES::DND</a>
		 * dans le cadre de la <a href="../../../../components/Conditional-Compilation.html">compilation conditionnelle</a>.
		 * Veillez donc à conditionner l'usage de cette fonctionnalité à l'usage de la constante de compilation associée. 
		 * </p>
		 * 
		 * @see ../../../../components/Conditional-Compilation.html#DND Constante FEATURES::DND
		 */
		function get dragGeometry () : DisplayObject;
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
		 * <a href="../../../../components/Conditional-Compilation.html#DND">FEATURES::DND</a>
		 * dans le cadre de la <a href="../../../../components/Conditional-Compilation.html">compilation conditionnelle</a>.
		 * Veillez donc à conditionner l'usage de cette fonctionnalité à l'usage de la constante de compilation associée. 
		 * </p>
		 * 
		 * @see ../../../../components/Conditional-Compilation.html#DND Constante FEATURES::DND
		 */		function get dragGestureGeometry () : InteractiveObject;
		
		function get allowDrag () : Boolean;
		function set allowDrag ( b : Boolean ) : void;		
		function get gesture () : DragGesture;
		function set gesture ( gesture : DragGesture ) : void;
		/*FDT_IGNORE*/ } /*FDT_IGNORE*/
	}
}
