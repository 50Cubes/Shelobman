
package com.spiders.hero
{
	import com.spiders.characters.WalkingDirectionalCharacter;
	
	import flash.display.Stage;
	import flash.sampler.startSampling;
	
	import org.flixel.FlxG;
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
		}
		
		override public function update():void{
			super.update();
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
					
					this.x = _jumpDestWorldPoint.x;
					this.y = _jumpDestWorldPoint.y;
				}else{
					//Make a y offset for jumping
					var yJumpOffset:Number;
					if(now - _jumpStartTime < JUMP_DURATION/2){
						yJumpOffset = -JUMP_Y_PEAK * (now - _jumpStartTime)/JUMP_DURATION;
					}else{
						yJumpOffset = -JUMP_Y_PEAK * ((_jumpStartTime + JUMP_DURATION) - now)/JUMP_DURATION;
					}
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