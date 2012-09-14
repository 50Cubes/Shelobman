
package com.spiders.misc
{
	import flash.events.Event;
	
	import org.flixel.*;
	
	
	/**
	 * [Description]
	 *
	 * @author Josiah Greene
	 * @email 73@50cubes.com
	 * @since Sep 13, 2012
	 */
	public class Fire extends FlxSprite
	{
		
		//--------------------------------------
		// CONSTANTS
		//--------------------------------------
		public static const FIRE_DURATION:Number = 3000;
		
		public static const ANIM_IDLE:String = "idle";
		public static const IDLE_FRAMES:Array = [0,1,2,3,4,5,6];
		
		//--------------------------------------
		// VARIABLES
		//--------------------------------------
		[Embed(source = 'assets/SpriteFire.png')]
		private var _fireAsset:Class;
		
		private var createTime:Number;
		private var _extinguishFunction:Function;
		
		//--------------------------------------
		// CONSTRUCTOR
		//--------------------------------------
		public function Fire(X:Number=0, Y:Number=0, extinguishFunction:Function = null)
		{
			super(X, Y);
			
			this.loadGraphic(_fireAsset, true);
			
			this.addAnimation(ANIM_IDLE, IDLE_FRAMES, 15, true);
			
			createTime = new Date().time;
			_extinguishFunction = extinguishFunction;
			
			this.play(ANIM_IDLE);
		}
		
		//--------------------------------------
		// PUBLIC METHODS
		//--------------------------------------
		override public function update():void{
			super.update();
			
			var now:Number = new Date().time;
			if(now - createTime >= FIRE_DURATION){
				if(_extinguishFunction != null){
					_extinguishFunction(this);
				}else{
					kill();
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