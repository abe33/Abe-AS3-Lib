package aesia.com.ponents.builder.actions 
{
	import aesia.com.ponents.utils.Insets;
	import aesia.com.mon.utils.KeyStroke;
	import aesia.com.patibility.lang._;
	import aesia.com.patibility.settings.SettingsManagerInstance;
	import aesia.com.ponents.actions.AbstractAction;
	import aesia.com.ponents.builder.models.BuilderCollections;
	import aesia.com.ponents.containers.Dialog;
	import aesia.com.ponents.containers.Panel;
	import aesia.com.ponents.demos.editors.StyleEditor;
	import aesia.com.ponents.events.DialogEvent;
	import aesia.com.ponents.layouts.components.InlineLayout;
	import aesia.com.ponents.skinning.icons.Icon;
	import aesia.com.ponents.text.Label;
	import aesia.com.ponents.text.TextInput;

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
