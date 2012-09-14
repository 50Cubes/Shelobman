
package com.spiders.hero
{
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
	public class HeroSprite extends FlxSprite
	{
		
		//--------------------------------------
		// CONSTANTS
		//--------------------------------------
		public static const RUN_SPEED:Number = 150;
		
		public static const ANIM_RUN:String = "run";
		public static const RUN_FRAMES:Array = [0,1,2];
		
		public static const ANIM_IDLE:String = "idle";
		public static const IDLE_FRAMES:Array = [3];
		
		
		//--------------------------------------
		// VARIABLES
		//--------------------------------------
		[Embed(source = 'assets/SpriteHero_WalkFront.png')]
		private var _heroAsset:Class;
		
		public var animState:String = ANIM_IDLE;
		
		//--------------------------------------
		// CONSTRUCTOR
		//--------------------------------------
		public function HeroSprite(X:Number=0, Y:Number=0)
		{
			super(X, Y);
			
			this.loadGraphic(_heroAsset, true);
			
			this.addAnimation(ANIM_RUN, RUN_FRAMES, 30, true);
			this.addAnimation(ANIM_IDLE, IDLE_FRAMES, 30, true);
			
			this.offset.x = 32;
			this.offset.y = 32;
			this.width = 32;
			this.height = 32;
			this.centerOffsets();
			
			this.acceleration = new FlxPoint(0, 0);
			
			this.play(ANIM_IDLE);
		}
		
		//--------------------------------------
		// PUBLIC METHODS
		//--------------------------------------
		
		override public function followPath(Path:FlxPath, Speed:Number=100, Mode:uint=PATH_FORWARD, AutoRotate:Boolean=false):void{
			if(animState != ANIM_RUN){
				animState = ANIM_RUN;
				this.play(ANIM_RUN);
			}
			
			Path.drawDebug();
			super.followPath(Path, Speed, Mode, AutoRotate);
		}
		
		override public function stopFollowingPath(DestroyPath:Boolean=false):void{
			if(animState != ANIM_IDLE){
				animState = ANIM_IDLE;
				this.play(ANIM_IDLE);
			}
			
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