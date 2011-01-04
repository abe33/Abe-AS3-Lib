package aesia.com.ponents.skinning 
{
	import aesia.com.mon.utils.Reflection;
	/**
	 * @author Cédric Néhémie
	 */
	public const SkinManagerInstance : SkinManager = new SkinManager( {name:"DefaultSkin"} );
	/*
	 * On enregistre les raccourcis pour les requêtes de styles des composants
	 */
	Reflection.addCustomShortcuts(/(^|[\s\(\[\{]+)icon\(/g, "$1aesia.com.ponents.skinning.icons::magicIconBuild(");
	Reflection.addCustomShortcuts(/(^|[\s\(\[\{]+)cutils/g, "$1aesia.com.ponents.utils" );
	Reflection.addCustomShortcuts(/(^|[\s\(\[\{]+)utils/g, "$1aesia.com.mon.utils" );
	Reflection.addCustomShortcuts(/(^|[\s\(\[\{]+)deco/g, "$1aesia.com.ponents.skinning.decorations" );
	Reflection.addCustomShortcuts(/(^|[\s\(\[\{]+)txt/g, "$1flash.text" );
	Reflection.addCustomShortcuts(/(^|[\s\(\[\{]+)skin/g, "$1aesia.com.ponents.skinning::DefaultSkin" );	
	/*
	 * On enregistre les styles de base présent dans le skin par défaut, et qui seront donc disponible
	 * partout dès lors qu'un composant est présent dans un fichier.
	 */
	SkinManagerInstance.registerMetaStyle( DefaultSkin );
}