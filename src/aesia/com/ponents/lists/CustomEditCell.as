package aesia.com.ponents.lists 
{
	import aesia.com.mon.utils.Reflection;
	import aesia.com.ponents.core.edit.EditorFactoryInstance;
	import aesia.com.ponents.events.EditEvent;

	import flash.display.DisplayObject;

	/**
	 * @author cedric
	 */
	public class CustomEditCell extends DefaultListCell 
	{
		public function CustomEditCell ()
		{
			super( );
		}
		override public function startEdit () : void
		{
			if( allowEdit )
			{
				_owner.ensureIndexIsVisible( _index );
				
				_isEditing = true;
				
				if( _value is Number || _value is String || _value is Boolean )
					_editor = EditorFactoryInstance.getForType( Reflection.getClass(_value) );
				else						_editor = EditorFactoryInstance.get( "*" );
				
				_editor.initEditState( this, _value, _labelTextField as DisplayObject );
				
				fireComponentEvent( EditEvent.EDIT_START );
				
				/*FDT_IGNORE*/ FEATURES::TOOLTIP { /*FDT_IGNORE*/
					hideToolTip();
				/*FDT_IGNORE*/ } /*FDT_IGNORE*/
			}
		}
	}
}
