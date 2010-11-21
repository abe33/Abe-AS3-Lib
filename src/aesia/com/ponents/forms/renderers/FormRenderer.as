package aesia.com.ponents.forms.renderers 
{
	import aesia.com.ponents.forms.FormObject;
	import aesia.com.ponents.core.Component;

	/**
	 * @author Cédric Néhémie
	 */
	public interface FormRenderer 
	{
		function render ( o : FormObject) : Component;
	}
}
