package abe.com.ponents.builder.actions 
{
	import abe.com.ponents.utils.Insets;
	import abe.com.mon.utils.KeyStroke;
	import abe.com.patibility.lang._;
	import abe.com.patibility.settings.SettingsManagerInstance;
	import abe.com.ponents.actions.AbstractAction;
	import abe.com.ponents.builder.models.BuilderCollections;
	import abe.com.ponents.containers.Dialog;
	import abe.com.ponents.containers.Panel;
	import abe.com.ponents.demos.editors.StyleEditor;
	import abe.com.ponents.events.DialogEvent;
	import abe.com.ponents.layouts.components.InlineLayout;
	import abe.com.ponents.skinning.icons.Icon;
	import abe.com.ponents.text.Label;
	import abe.com.ponents.text.TextInput;

	import flash.events.Event;
	/**
	 * @author cedric
	 */
	public class LoadExternalRessource extends AbstractAction 
	{
		protected var _tmpInput : TextInput;

		public function LoadExternalRessource (name : String = "", icon : Icon = null, longDescription : String = null, accelerator : KeyStroke = null)
		{
			super( name, icon, longDescription, accelerator );
		}
		override public function execute (e : Event = null) : void 
		{
			inputRessource();
		}
		protected function inputRessource () : void
		{
			var p : Panel = new Panel();
			p.childrenLayout = new InlineLayout(p, 3, "left", "top", "topToBottom", true );
			
			_tmpInput = new TextInput( 0, false, "externalRessourceInput" );
			_tmpInput.value = "";
			
			p.addComponents( new Label( _("Input the path to the *.swf ressources file.\nThe path will be saved for the next\nlauch.") ), _tmpInput );
			p.style.insets = new Insets(3);

			var d : Dialog = new Dialog(_("Set new skin name") , Dialog.CANCEL_BUTTON + Dialog.OK_BUTTON, p, Dialog.OK_BUTTON );
			d.addEventListener( DialogEvent.DIALOG_RESULT, inputRessourceResult );
			d.open( Dialog.CLOSE_ON_RESULT );
		}
		protected function inputRessourceResult (event : DialogEvent) : void 
		{
			switch(event.result)
			{
				case Dialog.RESULTS_OK :

					var url : String = _tmpInput.value as String;
					
					BuilderCollections.loadCollection( url );
					if( BuilderCollections.size > 0 )
						BuilderCollections.execute();
					
					var collections : Array = SettingsManagerInstance.get( this, "collections", StyleEditor.DEFAULT_DECORATIONS_COLLECTIONS );	
					collections.push( url );
					SettingsManagerInstance.set( StyleEditor.instance, "collections", collections );
					
					break;

				default :
					break;
			}
			_tmpInput = null;
		}
	}
}
