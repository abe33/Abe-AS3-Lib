package abe.com.ponents.ressources.actions 
{
	import abe.com.mands.Command;
	import abe.com.mon.utils.KeyStroke;
	import abe.com.patibility.lang._;
	import abe.com.patibility.settings.SettingsManagerInstance;
	import abe.com.ponents.actions.AbstractAction;
	import abe.com.ponents.actions.ProxyAction;
	import abe.com.ponents.actions.builtin.OpenSWFFileAction;
	import abe.com.ponents.buttons.Button;
	import abe.com.ponents.containers.Dialog;
	import abe.com.ponents.containers.Panel;
	import abe.com.ponents.events.DialogEvent;
	import abe.com.ponents.layouts.components.InlineLayout;
	import abe.com.ponents.ressources.ClassCollection;
	import abe.com.ponents.ressources.CollectionsLoader;
	import abe.com.ponents.skinning.icons.Icon;
	import abe.com.ponents.text.Label;
	import abe.com.ponents.text.TextInput;
	import abe.com.ponents.utils.Insets;
	import abe.com.prehension.tools.StyleEditor;

	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	/**
	 * @author cedric
	 */
	public class LoadExternalRessource extends AbstractAction 
	{
		protected var _tmpInput : TextInput;
		protected var _collectionsLoader : CollectionsLoader;

		static private var _dialog : Dialog;
		static private var _loader : Loader;
		static private var _lastAction : OpenSWFFileAction;

		public function LoadExternalRessource ( collectionsLoader : CollectionsLoader,
												name : String = "", 
												icon : Icon = null, 
												longDescription : String = null, 
												accelerator : KeyStroke = null)
		{
			super( name, icon, longDescription, accelerator );
			_collectionsLoader = collectionsLoader;
		}
		override public function execute( ... args ) : void 
		{
			inputRessource();
		}
		protected function inputRessource () : void
		{
			if( !_dialog)
			{
				_tmpInput = new TextInput( 0, false, "externalRessourceInput" );
				var p : Panel = new Panel();
				p.childrenLayout = new InlineLayout(p, 3, "left", "top", "topToBottom", true );
				p.addComponents( new Label( _("Input the path to the *.swf ressources file.\nThe path will be saved for the next launch.\nOr use the <i>Browse</i> button to load\na file from your computer that will not\nbe saved for the next launch.") ), 
								 _tmpInput,
								 new Button( new ProxyAction( loadTmpFile, _("Browse") )) );
				p.style.insets = new Insets( 3  );
				_dialog = new Dialog(_("Set new skin name") , Dialog.CANCEL_BUTTON + Dialog.OK_BUTTON, p, Dialog.OK_BUTTON );
			}
			_tmpInput.value = "";
			
			_dialog.dialogResponded.add( inputRessourceResult );
			_dialog.open( Dialog.CLOSE_ON_RESULT );
		}
		protected function loadTmpFile () : void 
		{
			_dialog.close();
			_dialog.dialogResponded.remove( inputRessourceResult );
			
			_lastAction = new OpenSWFFileAction("");
			_lastAction.commandEnded.add( openTmpCompleted );
			_lastAction.commandFailed.add( openTmpFailed );
			_lastAction.execute();
		}
		protected function openTmpCompleted ( c : Command ) : void 
		{
			_lastAction.commandEnded.remove( openTmpCompleted );
			_lastAction.commandFailed.remove( openTmpFailed );
			
			_loader = new Loader();
			_loader.contentLoaderInfo.addEventListener(Event.INIT, loaderInit );
			_loader.loadBytes( _lastAction.bytes , new LoaderContext(false, new ApplicationDomain() ) );
		}
		protected function loaderInit (event : Event) : void 
		{
			var col : ClassCollection = CollectionsLoader.getCollectionFromSWF( _lastAction.swf, _lastAction.fileReference.name, ( event.target as LoaderInfo ).loader );
			_collectionsLoader.collections.push( col );
			_collectionsLoader.commandEnded.dispatch( _collectionsLoader );
			
			_commandEnded.dispatch( this );
		}
		protected function openTmpFailed ( c : Command ) : void 
		{
			_lastAction.commandEnded.remove( openTmpCompleted );
			_lastAction.commandFailed.remove( openTmpFailed );
		}
		protected function inputRessourceResult ( d : Dialog, result : uint ) : void 
		{
			_dialog.dialogResponded.remove( inputRessourceResult );
			switch(result)
			{
				case Dialog.RESULTS_OK :

					var url : String = _tmpInput.value as String;
					
					_collectionsLoader.loadCollection( url );
					if( _collectionsLoader.size > 0 )
						_collectionsLoader.execute();
					
					var collections : Array = SettingsManagerInstance.get( this, "collections", StyleEditor.DEFAULT_DECORATIONS_COLLECTIONS );	
					collections.push( url );
					SettingsManagerInstance.set( StyleEditor.instance, "collections", collections );
					
					break;

				default :
					break;
			}
		}
	}
}
