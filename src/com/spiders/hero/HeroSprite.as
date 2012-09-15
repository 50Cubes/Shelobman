
package com.spiders.hero
{
	import com.spiders.characters.WalkingDirectionalCharacter;
	
	import flash.display.Stage;
	import flash.sampler.startSampling;
	
	import org.flixel.FlxG;
	import org.flixel.FlxObject;
	import org.flixel.FlxPath;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import org.flixel.FlxTimer;
	
	
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
		
		public static const JUMP_Y_VEL:Number = 70;
		
		public static const ANIM_JUMP_DOWN:String = "jump down";
		public static const JUMP_DOWN_FRAMES:Array = [16];
		public static const ANIM_JUMP_UP:String = "jump up";
		public static const JUMP_UP_FRAMES:Array = [17];
		public static const ANIM_JUMP_RIGHT:String = "jump right";
		public static const JUMP_RIGHT_FRAMES:Array = [18];
		public static const ANIM_JUMP_LEFT:String = "jump left";
		public static const JUMP_LEFT_FRAMES:Array = [19];
		
		
		//--------------------------------------
		// VARIABLES
		//--------------------------------------
		[Embed(source = 'assets/SpriteHero_Final.png')]
		private var _heroAsset:Class;
		
		public var canSee:Boolean = false;
		public var canFire:Boolean = false;
		public var canJump:Boolean = false;
		public var isJumping:Boolean = false;
		
		private var _jumpStartTime:Number;
		private var _jumpStartWorldPoint:FlxPoint;
		private var _jumpDestWorldPoint:FlxPoint;
		private var _jumpDiffPoint:FlxPoint;
		
		public var HP:int = 1;
		public var HP_MAX:int = 1;
		public var HP_REGEN:Number = 500;
		public var isInvulerableState:Boolean = false;
		private var _invulnerableTimer:FlxTimer  = new FlxTimer();
		public var isAlive:Boolean = true;
		
		private var _frame:int = 0;
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
			
			this.addAnimation(ANIM_JUMP_UP, JUMP_UP_FRAMES, 5, true);
			this.addAnimation(ANIM_JUMP_DOWN, JUMP_DOWN_FRAMES, 5, true);
			this.addAnimation(ANIM_JUMP_LEFT, JUMP_LEFT_FRAMES, 5, true);
			this.addAnimation(ANIM_JUMP_RIGHT, JUMP_RIGHT_FRAMES, 5, true);
		}
		public function gotHit(dmg:int = 1):void
		{
			if(flickering == false)
			{
				isInvulerableState = true;
				HP -= dmg;
				if(HP <= 0)
				{
					heroDies();
					this.scale = new FlxPoint(40, 40);					
				}
				trace(HP);
				this.flicker(1);
			}
			
	
		}
		public function raiseMaxHPBy(hp:int):void
		{
			HP_MAX += hp;
			this.HP = HP_MAX;
		}
		public function heroDiesAnimation():void
		{
			//Stop flickering
			this._flickerTimer = 0;
			this._flicker = false;
			
			this.scale.x *= 0.90;		
			this.scale.y *= 0.90;		
			this.angle += 20;
			this.alpha -= 0.01;
		}
		
		override public function revive():void{
			super.revive();
			this.isAlive = true;
			HP = HP_MAX;
			
			this.scale.x = this.scale.y = 1;
			this.angle = 0;
			this.alpha = 1;
		}
		
		private function heroDies():void
			
		{
			isAlive = false;
			// death xD
			this.angle = 270;
			SoundManager.playHeroDying();
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
			
			//Turn off animation automatically from velocity.
			this.autoVelocityAnimate = false;
			this.autoIdle = false;
			switch(this.orientation){
				case WalkingDirectionalCharacter.UP:
					animState = ANIM_JUMP_UP;
					this.play(ANIM_JUMP_UP, true);
					break;
				case WalkingDirectionalCharacter.DOWN:
					animState = ANIM_JUMP_DOWN;
					this.play(ANIM_JUMP_DOWN, true);
					break;
				case WalkingDirectionalCharacter.LEFT:
					animState = ANIM_JUMP_LEFT;
					this.play(ANIM_JUMP_LEFT, true);
					break;
				case WalkingDirectionalCharacter.RIGHT:
					animState = ANIM_JUMP_RIGHT;
					this.play(ANIM_JUMP_RIGHT, true);
					break;
			}
		}
		
		override public function update():void{
			super.update();
			
			trace("animState: " + animState);
			trace("orientation: " + this.orientation);
			
			_frame++;
			if(isAlive && HP < HP_MAX)
			{
				if(_frame % HP_REGEN == 0)
					HP++;
			}
				
			if(this.isJumping){
				//Update the jumping pseudo-tween
				var now:Number = new Date().time;
				var timeOffset:Number = (now - _jumpStartTime) - JUMP_DURATION/2;
				
				if(now - _jumpStartTime >= JUMP_DURATION){
					//stop jumping
					this.isJumping = false;
					this.velocity.x = 0;
					this.velocity.y = 0;
					autoVelocityAnimate = true;
					autoIdle = true;
				}else{
					//Make a y offset for jumping
					var yVelOffset:Number;
					if(now - _jumpStartTime < JUMP_DURATION/2){
						yVelOffset = -JUMP_Y_VEL;
					}else{
						yVelOffset = JUMP_Y_VEL;
					}
					this.velocity.y = _jumpDiffPoint.y / JUMP_DURATION * 1100 + yVelOffset;
					this.velocity.x = _jumpDiffPoint.x / JUMP_DURATION * 1100;
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