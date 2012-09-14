
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
		public static const JUMP_DURATION:Number = 500;
		public static const JUMP_Y_PEAK:Number = 50;
		
		
		//--------------------------------------
		// VARIABLES
		//--------------------------------------
		[Embed(source = 'assets/SpriteHero_WalkingAll.png')]
		private var _heroAsset:Class;
		
		public var canFire:Boolean = false;
		public var canJump:Boolean = false;
		public var isJumping:Boolean = false;
		
		private var _jumpStartTime:Number;
		private var _jumpStartWorldPoint:FlxPoint;
		private var _jumpDestWorldPoint:FlxPoint;
		private var _jumpDiffPoint:FlxPoint;
		
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
			
			this.acceleration = new FlxPoint(0, 0);
		}
		
		//--------------------------------------
		// PUBLIC METHODS
		//--------------------------------------
		public function jumpTo($worldPoint:FlxPoint):void{
			this.isJumping = true;
			_jumpStartTime = new Date().time;
			_jumpStartWorldPoint = new FlxPoint(this.x, this.y);
			_jumpDestWorldPoint = $worldPoint;
			
			_jumpDiffPoint = new FlxPoint($worldPoint.x - this.x, $worldPoint.y - this.y);
		}
		
		override public function update():void{
			super.update();
			
			if(this.isJumping){
				//Update the jumping pseudo-tween
				var now:Number = new Date().time;
				var timeOffset:Number = (now - _jumpStartTime) - JUMP_DURATION/2;
				
				if(now - _jumpStartTime >= JUMP_DURATION){
					//stop jumping
					this.isJumping = false;
					
					this.x = _jumpDestWorldPoint.x;
					this.y = _jumpDestWorldPoint.y;
				}else{
					//Make a parabolic y offset for jumping
					var yJumpOffset:Number;
					if(now - _jumpStartTime < JUMP_DURATION/2){
						yJumpOffset = -JUMP_Y_PEAK * (now - _jumpStartTime)/JUMP_DURATION;
					}else{
						yJumpOffset = -JUMP_Y_PEAK * ((_jumpStartTime + JUMP_DURATION) - now)/JUMP_DURATION;
					}
					 //PSEUDO_GRAV_CONST * (timeOffset * timeOffset) + JUMP_Y_PEAK;
					this.y = _jumpStartWorldPoint.y + (now - _jumpStartTime)/JUMP_DURATION * _jumpDiffPoint.y + yJumpOffset;
					this.x = _jumpStartWorldPoint.x + (now - _jumpStartTime)/JUMP_DURATION * _jumpDiffPoint.x;
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