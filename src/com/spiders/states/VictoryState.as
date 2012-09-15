
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
	public class VictoryState extends FlxState
	{
		
		//--------------------------------------
		// CONSTANTS
		//--------------------------------------
		
		
		//--------------------------------------
		// VARIABLES
		//--------------------------------------
		[Embed(source="assets/victory.png")]
		private var _victoryAsset:Class;
		
		private var delayCount:int = 0;
		private var delayMax:int = 150;
		
		//--------------------------------------
		// CONSTRUCTOR
		//--------------------------------------
		public function VictoryState()
		{
			super();
		}
		
		//--------------------------------------
		// PUBLIC METHODS
		//--------------------------------------
		override public function create():void{
			super.create();
			
			var sprite:FlxSprite = new FlxSprite(0, 0, _victoryAsset);
			add(sprite);
		}
		
		override public function update():void{
			super.update();
			
			delayCount++;
			if(delayCount >= delayMax){
				FlxG.switchState(new CreditsState);
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