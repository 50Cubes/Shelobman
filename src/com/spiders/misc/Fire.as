
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
		
		//--------------------------------------
		// VARIABLES
		//--------------------------------------
		[Embed(source = 'assets/Spell_fire_flamebolt.png')]
		private var _fireAsset:Class;
		
		private var createTime:Number;
		private var _extinguishFunction:Function;
		
		//--------------------------------------
		// CONSTRUCTOR
		//--------------------------------------
		public function Fire(X:Number=0, Y:Number=0, SimpleGraphic:Class=null, extinguishFunction:Function = null)
		{
			super(X, Y);
			
			this.loadGraphic(_fireAsset);
			
			createTime = new Date().time;
			_extinguishFunction = extinguishFunction;
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