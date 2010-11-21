package aesia.com.ponents.skinning 
{

	/**
	 * @author Cédric Néhémie
	 */
	public const SkinManagerInstance : SkinManager = new SkinManager( {name:"DefaultSkin"} );
	/*
	 * On enregistre les styles de base présent dans le manager, et qui seront donc disponible
	 * partout dès lors qu'un composant est présent dans un fichier.
	 */
	SkinManagerInstance.registerMetaStyle( SkinManagerInstance );
}
