package abe.com.ponents.forms.renderers 
{
	import abe.com.ponents.forms.FormObject;
	import abe.com.ponents.core.Component;

	/**
	 * @author Cédric Néhémie
	 */
	public interface FormRenderer 
	{
		function render ( o : FormObject) : Component;
	}
}
