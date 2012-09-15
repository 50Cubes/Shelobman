
package com.spiders.tiles
{
	import org.flixel.FlxTileblock;
	
	
	/**
	 * [Description]
	 *
	 * @author Josiah Greene
	 * @email 73@50cubes.com
	 * @since Sep 13, 2012
	 */
	public class WebTile extends FlxTileblock
	{
		
		//--------------------------------------
		// CONSTANTS
		//--------------------------------------
		
		
		//--------------------------------------
		// VARIABLES
		//--------------------------------------
		[Embed(source = 'assets/webtile.png')]
		private var _webtile:Class;
		
		//--------------------------------------
		// CONSTRUCTOR
		//--------------------------------------
		public function WebTile(X:int, Y:int, Width:uint, Height:uint)
		{
			super(X, Y, Width, Height);
			this.loadGraphic(_webtile, true);
			

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