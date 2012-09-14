
package com.spiders.hero
{
	import com.spiders.characters.WalkingDirectionalCharacter;
	
	import org.flixel.FlxPath;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	
	
	/**
	 * [Description]
	 *
	 * @author Josiah Greene
	 * @email 73@50cubes.com
	 * @since Sep 13, 2012
	 */
	public class HeroSprite extends WalkingDirectionalCharacter
	{
		
		//--------------------------------------
		// CONSTANTS
		//--------------------------------------
		public static const RUN_SPEED:Number = 150;
		
		
		
		//--------------------------------------
		// VARIABLES
		//--------------------------------------
		[Embed(source = 'assets/SpriteHero_WalkingAll.png')]
		private var _heroAsset:Class;
		
		public var canFire:Boolean = false;
		
		//--------------------------------------
		// CONSTRUCTOR
		//--------------------------------------
		public function HeroSprite(X:Number=0, Y:Number=0)
		{
			super(X, Y);
			
			this.loadGraphic(_heroAsset, true);
			
			this.offset.x = 16;
			this.offset.y = 42;
			this.width = 32;
			this.height = 16;
			//this.centerOffsets();
			
			this.acceleration = new FlxPoint(0, 0);
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