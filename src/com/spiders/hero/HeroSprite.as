
package com.spiders.hero
{
	import org.flixel.FlxPath;
	import org.flixel.FlxSprite;
	
	
	/**
	 * [Description]
	 *
	 * @author Josiah Greene
	 * @email 73@50cubes.com
	 * @since Sep 13, 2012
	 */
	public class HeroSprite extends FlxSprite
	{
		
		//--------------------------------------
		// CONSTANTS
		//--------------------------------------
		public static const ANIM_RUN:String = "run";
		public static const RUN_FRAMES:Array = [0,1,2];
		
		public static const ANIM_IDLE:String = "idle";
		public static const IDLE_FRAMES:Array = [3];
		
		
		//--------------------------------------
		// VARIABLES
		//--------------------------------------
		[Embed(source = 'assets/SpriteHero_WalkFront.png')]
		private var _heroAsset:Class;
		
		//--------------------------------------
		// CONSTRUCTOR
		//--------------------------------------
		public function HeroSprite(X:Number=0, Y:Number=0)
		{
			super(X, Y, _heroAsset);
			
			this.addAnimation(ANIM_RUN, RUN_FRAMES);
			this.addAnimation(ANIM_IDLE, IDLE_FRAMES);
			
			this.play(ANIM_IDLE);
		}
		
		//--------------------------------------
		// PUBLIC METHODS
		//--------------------------------------
		override public function followPath(Path:FlxPath, Speed:Number=100, Mode:uint=PATH_FORWARD, AutoRotate:Boolean=false):void{
			this.play(ANIM_RUN);
			
			Path.drawDebug();
			super.followPath(Path, Speed, Mode, AutoRotate);
		}
		
		override public function stopFollowingPath(DestroyPath:Boolean=false):void{
			this.play(ANIM_IDLE);
			
			super.stopFollowingPath(DestroyPath);
		}
		
		//--------------------------------------
		// PROTECTED & PRIVATE METHODS
		//--------------------------------------							
		
		
		//--------------------------------------
		// EVENT HANDLERS
		//--------------------------------------
		
	}
}