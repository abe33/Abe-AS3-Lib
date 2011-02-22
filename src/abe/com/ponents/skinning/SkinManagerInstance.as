package abe.com.ponents.skinning 
{
	import abe.com.mon.utils.Reflection;
	/**
	 * @author Cédric Néhémie
	 */
	public const SkinManagerInstance : SkinManager = new SkinManager( {name:"DefaultSkin"} );
	/*
	 * On enregistre les raccourcis pour les requêtes de styles des composants
	 */
	Reflection.addCustomShortcuts(/(^|[\s\(\[\{]+)icon\(/g, "$1abe.com.ponents.skinning.icons::magicIconBuild(");
	Reflection.addCustomShortcuts(/(^|[\s\(\[\{]+)cutils/g, "$1abe.com.ponents.utils" );
	Reflection.addCustomShortcuts(/(^|[\s\(\[\{]+)utils/g, "$1abe.com.mon.utils" );
	Reflection.addCustomShortcuts(/(^|[\s\(\[\{]+)deco/g, "$1abe.com.ponents.skinning.decorations" );
	Reflection.addCustomShortcuts(/(^|[\s\(\[\{]+)txt/g, "$1flash.text" );
	Reflection.addCustomShortcuts(/(^|[\s\(\[\{]+)skin/g, "$1abe.com.ponents.skinning::DefaultSkin" );	
	/*
	 * On enregistre les styles de base présent dans le skin par défaut, et qui seront donc disponible
	 * partout dès lors qu'un composant est présent dans un fichier.
	 */
	SkinManagerInstance.registerMetaStyle( DefaultSkin );
}