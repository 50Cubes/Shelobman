
package com.spiders.misc
{
	import org.flixel.FlxSprite;
	
	
	/**
	 * [Description]
	 *
	 * @author Josiah Greene
	 * @email 73@50cubes.com
	 * @since Sep 14, 2012
	 */
	public class DarkFilter extends FlxSprite
	{
		
		//--------------------------------------
		// CONSTANTS
		//--------------------------------------
		
		
		//--------------------------------------
		// VARIABLES
		//--------------------------------------
		[Embed(source = 'assets/BlackBackgroundTile.png')]
		private var _darkFilterAsset:Class;
		
		//--------------------------------------
		// CONSTRUCTOR
		//--------------------------------------
		public function DarkFilter(X:Number=0, Y:Number=0)
		{
			super(X, Y, _darkFilterAsset);
			
			this.scrollFactor.x = 0;
			this.scrollFactor.y = 0;
		}
		
		//--------------------------------------
		// PUBLIC METHODS
		//--------------------------------------
		
		
		//--------------------------------------
		// PROTECTED & PRIVATE METHODS
		//--------------------------------------							
		
		
		//--------------------------------------
		// EVENT HANDLERS
		//--------------------------------------
		
	}
}