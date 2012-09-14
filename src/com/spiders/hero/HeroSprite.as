
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
		
		public static const ANIM_RUN_DOWN:String = "run";
		public static const RUN_DOWN_FRAMES:Array = [0,1,2,3];
		
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
			
			this.addAnimation(ANIM_RUN_DOWN, RUN_DOWN_FRAMES, 5, true);
			this.addAnimation(ANIM_IDLE, IDLE_FRAMES, 5, true);
			
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
		
		override public function update():void{
			super.update();
			
			if(this.velocity.x > 0){
				
			}else if(this.velocity.x < 0){
				
			}else if(this.velocity.y > 0){
				if(animState != ANIM_RUN_DOWN){
					animState = ANIM_RUN_DOWN;
					this.play(ANIM_RUN_DOWN);
				}
			}else if(this.velocity.y < 0){
				
			}else{
				if(animState != ANIM_IDLE){
					animState = ANIM_IDLE;
					this.play(ANIM_IDLE);
				}
			}
		}
		
		//--------------------------------------
		// PROTECTED & PRIVATE METHODS
		//--------------------------------------							
		
		
		//--------------------------------------
		// EVENT HANDLERS
		//--------------------------------------
		
	}
}