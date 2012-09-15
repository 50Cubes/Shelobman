
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
	public class TitleState extends FlxState
	{
		
		//--------------------------------------
		// CONSTANTS
		//--------------------------------------
		
		
		//--------------------------------------
		// VARIABLES
		//--------------------------------------
		[Embed(source="assets/titlescreen.png")]
		private var _titleBgAsset:Class;
		
		[Embed(source="assets/clickstart.png")]
		private var _clickAsset:Class;
		
		private var clickDelayCount:int = 0;
		private var clickDelayMax:int = 75;
		
		private var clickStart:FlxSprite;
		
		//--------------------------------------
		// CONSTRUCTOR
		//--------------------------------------
		public function TitleState()
		{
			super();
		}
		
		//--------------------------------------
		// PUBLIC METHODS
		//--------------------------------------
		override public function create():void{
			super.create();
			
			var titleBg:FlxSprite = new FlxSprite(0, 0, _titleBgAsset);
			add(titleBg);
			
			clickStart = new FlxSprite((800 - 396)/2, 600 - 50, _clickAsset);
			clickStart.visible = false;
			add(clickStart);
		}
		
		override public function update():void{
			super.update();
			
			clickDelayCount++;
			
			if(clickDelayCount >= clickDelayMax){
				clickStart.visible = true;
			}
			
			if(FlxG.mouse.justPressed()){
				FlxG.switchState(new DungeonState());
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