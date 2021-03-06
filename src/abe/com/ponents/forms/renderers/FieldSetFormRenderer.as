package abe.com.ponents.forms.renderers 
{
	import abe.com.ponents.containers.FieldSet;
	import abe.com.ponents.containers.Panel;
	import abe.com.ponents.containers.ScrollablePanel;
	import abe.com.ponents.core.Component;
	import abe.com.ponents.forms.FormCategory;
	import abe.com.ponents.forms.FormField;
	import abe.com.ponents.forms.FormObject;
	import abe.com.ponents.layouts.components.BoxSettings;
	import abe.com.ponents.layouts.components.HBoxLayout;
	import abe.com.ponents.layouts.components.InlineLayout;
	import abe.com.ponents.text.Label;
	/**
	 * @author Cédric Néhémie
	 */
	public class FieldSetFormRenderer implements FormRenderer 
	{
		static protected var _instance : FieldSetFormRenderer;
		
		static public function get instance () : FieldSetFormRenderer
		{
			if( !_instance )
				_instance = new FieldSetFormRenderer();
			
			return _instance;
		}

		protected var _tmpMaxCompSize : Number;
		protected var _tmpMaxLabelSize : Number;
		protected var _tmpFieldsLines : Array;
		
		public function render ( o : FormObject ) : Component
		{
			_tmpMaxCompSize = 0;
			_tmpMaxLabelSize = 0;
			_tmpFieldsLines = [];
			var p : ScrollablePanel = new ScrollablePanel();
			p.childrenLayout = new InlineLayout(p, 5, "center", "top", "topToBottom", true );
			
			var l : int;
			var i : int;
			var c : Component;
			
			if( o.hasCategories )
			{
				l = o.categories.length;
				for( i=0; i<l; i++ )
				{
					if( o.categories[i].fields.length > 0 )
					{
						c = createFieldSetForCategory( o.categories[i] );
						p.addComponent( c );
					}
				}
			}
			else
			{
				l = o.fields.length;
				for( i=0; i<l; i++ )
				{
					c = createPanelForField( o.fields[i] );
					_tmpFieldsLines.push(c);
					p.addComponent( c );
				}
			}
			harmonizeBoxes( _tmpFieldsLines);
			return p;
		}

		protected function createPanelForField ( field : FormField ) : Panel
		{
			var l : Label = new Label( field.name + " : ", field.component );
			
			if( field.description && field.description != "" )
				l.tooltip = field.description;
			
			if( field.component )
			{
				l.enabled = field.component.enabled;
				field.component.componentEnableChanged.add( function( c : Component, b : Boolean ) : void
				{
					if( c == l.forComponent )
						l.enabled = b;
				} );
				
				_tmpMaxCompSize = Math.max( field.component.preferredSize.width, _tmpMaxCompSize );
			}
			_tmpMaxLabelSize = Math.max( l.preferredSize.width, _tmpMaxLabelSize );
			
			var p : Panel = new Panel();
			p.childrenLayout = new HBoxLayout(p,
												 3, 
												 new BoxSettings(NaN, "right", "center", l ),
												 new BoxSettings(NaN, "left", "center", field.component, true, false, true )
												 );
			p.addComponents( l, field.component );
			
			_tmpFieldsLines.push(p);
			return p;
		}
		
		protected function createFieldSetForCategory ( category : FormCategory ) : FieldSet
		{
			var fd : FieldSet = new FieldSet( category.name );
			
			fd.childrenLayout = new InlineLayout(fd, 5, "center", "top", "topToBottom", true, true );
			var l : int = category.fields.length;
			for( var i : int = 0; i<l; i++ )
				fd.addComponent( createPanelForField( category.fields[i] ) );
			
			return fd;
		}

		public function harmonizeBoxes ( lines : Array ) : void
		{
			for each( var line : Panel in lines )
			{
				( line.childrenLayout as HBoxLayout ).boxes[0].size = _tmpMaxLabelSize;
				( line.childrenLayout as HBoxLayout ).boxes[1].size = _tmpMaxCompSize;
			}
		}
	}
}
