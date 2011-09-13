package abe.com.ponents.forms.renderers 
{
    import abe.com.ponents.core.Component;
    import abe.com.ponents.forms.FormObject;
	/**
	 * @author Cédric Néhémie
	 */
	public interface FormRenderer 
	{
		function render ( o : FormObject) : Component;
	}
}
