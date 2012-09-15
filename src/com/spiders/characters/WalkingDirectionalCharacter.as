
package com.spiders.characters
{
	import org.flixel.FlxSprite;
	
	
	/**
	 * [Description]
	 *
	 * @author Josiah Greene
	 * @email 73@50cubes.com
	 * @since Sep 13, 2012
	 */
	public class WalkingDirectionalCharacter extends FlxSprite
	{
		
		//--------------------------------------
		// CONSTANTS
		//--------------------------------------
		public static const ANIM_RUN_DOWN:String = "run_down";
		public static const RUN_DOWN_FRAMES:Array = [12,13,14,15];
		
		public static const ANIM_RUN_UP:String = "run_up";
		public static const RUN_UP_FRAMES:Array = [8,9,10,11];
		
		public static const ANIM_RUN_LEFT:String = "run_left";
		public static const RUN_LEFT_FRAMES:Array = [0,1,2,3];
		
		public static const ANIM_RUN_RIGHT:String = "run_right";
		public static const RUN_RIGHT_FRAMES:Array = [4,5,6,7];
		
		
		public static const ANIM_IDLE_DOWN:String = "idle_down";
		public static const IDLE_DOWN_FRAMES:Array = [15];
		
		public static const ANIM_IDLE_UP:String = "idle_up";
		public static const IDLE_UP_FRAMES:Array = [11];
		
		public static const ANIM_IDLE_LEFT:String = "idle_left";
		public static const IDLE_LEFT_FRAMES:Array = [3];
		
		public static const ANIM_IDLE_RIGHT:String = "idle_right";
		public static const IDLE_RIGHT_FRAMES:Array = [7];
		
		public static const UP:String = "up";
		public static const DOWN:String = "down";
		public static const LEFT:String = "left";
		public static const RIGHT:String = "right";
		
		//--------------------------------------
		// VARIABLES
		//--------------------------------------
		public var animState:String = ANIM_IDLE_DOWN;
		
		public var autoIdle:Boolean = true;
		public var autoVelocityAnimate:Boolean = true;
		
		protected var _orientation:String = DOWN;
		
		
		//--------------------------------------
		// CONSTRUCTOR
		//--------------------------------------
		public function WalkingDirectionalCharacter(X:Number=0, Y:Number=0, SimpleGraphic:Class=null)
		{
			super(X, Y, SimpleGraphic);
			
			this.addAnimation(ANIM_RUN_UP, RUN_UP_FRAMES, 5, true);
			this.addAnimation(ANIM_RUN_DOWN, RUN_DOWN_FRAMES, 5, true);
			this.addAnimation(ANIM_RUN_LEFT, RUN_LEFT_FRAMES, 5, true);
			this.addAnimation(ANIM_RUN_RIGHT, RUN_RIGHT_FRAMES, 5, true);
			
			this.addAnimation(ANIM_IDLE_UP, IDLE_UP_FRAMES, 5, true);
			this.addAnimation(ANIM_IDLE_DOWN, IDLE_DOWN_FRAMES, 5, true);
			this.addAnimation(ANIM_IDLE_LEFT, IDLE_LEFT_FRAMES, 5, true);
			this.addAnimation(ANIM_IDLE_RIGHT, IDLE_RIGHT_FRAMES, 5, true);
			
			this.animState = ANIM_IDLE_DOWN;
			_orientation = DOWN;
			this.play(ANIM_IDLE_DOWN);
		}
		
		//--------------------------------------
		// PUBLIC METHODS
		//--------------------------------------
		override public function update():void{
			super.update();
			
			if(this.autoVelocityAnimate){
				if(this.velocity.x > 0){
					if(animState != ANIM_RUN_RIGHT){
						_orientation = RIGHT
						animState = ANIM_RUN_RIGHT;
						this.play(ANIM_RUN_RIGHT);
					}
				}else if(this.velocity.x < 0){
					if(animState != ANIM_RUN_LEFT){
						_orientation = LEFT;
						animState = ANIM_RUN_LEFT;
						this.play(ANIM_RUN_LEFT);
					}
				}else if(this.velocity.y > 0){
					if(animState != ANIM_RUN_DOWN){
						_orientation = DOWN;
						animState = ANIM_RUN_DOWN;
						this.play(ANIM_RUN_DOWN);
					}
				}else if(this.velocity.y < 0){
					if(animState != ANIM_RUN_UP){
						_orientation = UP;
						animState = ANIM_RUN_UP;
						this.play(ANIM_RUN_UP);
					}
				}
			}
			
			if(velocity.x == 0 && velocity.y == 0){
				if(autoIdle){
					switch(_orientation){
						case RIGHT:
							_orientation = RIGHT;
							animState = ANIM_IDLE_RIGHT;
							this.play(ANIM_IDLE_RIGHT);
							break;
						case LEFT:
							_orientation = LEFT;
							animState = ANIM_IDLE_LEFT;
							this.play(ANIM_IDLE_LEFT);
							break;
						case DOWN:
							_orientation = DOWN;
							animState = ANIM_IDLE_DOWN;
							this.play(ANIM_IDLE_DOWN);
							break;
						case UP:
							_orientation = UP;
							animState = ANIM_IDLE_UP;
							this.play(ANIM_IDLE_UP);
							break;
						default:
							_orientation = DOWN;
							animState = ANIM_IDLE_DOWN;
							this.play(ANIM_IDLE_DOWN);
							break;
					}
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