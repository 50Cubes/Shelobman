
package com.spiders.states
{
	import org.flixel.*;
	
	
	/**
	 * [Description]
	 *
	 * @author Josiah Greene
	 * @email 73@50cubes.com
	 * @since Sep 15, 2012
	 */
	public class CreditsState extends FlxState
	{
		
		//--------------------------------------
		// CONSTANTS
		//--------------------------------------
		
		
		//--------------------------------------
		// VARIABLES
		//--------------------------------------
		[Embed(source="assets/creds.png")]
		private var _creditsAsset:Class;
		
		private var delayCount:int = 0;
		private var delayMax:int = 150;
		
		//--------------------------------------
		// CONSTRUCTOR
		//--------------------------------------
		public function CreditsState()
		{
			super();
		}
		
		//--------------------------------------
		// PUBLIC METHODS
		//--------------------------------------
		override public function create():void{
			super.create();
			
			var sprite:FlxSprite = new FlxSprite(0, 0, _creditsAsset);
			add(sprite);
		}
		
		override public function update():void{
			super.update();
			
			delayCount++;
			if(delayCount >= delayMax){
				FlxG.switchState(new TitleState());
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