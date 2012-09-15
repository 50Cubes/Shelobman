
package com.spiders.states
{
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;
	import org.flixel.FlxState;
	
	
	/**
	 * [Description]
	 *
	 * @author Josiah Greene
	 * @email 73@50cubes.com
	 * @since Sep 15, 2012
	 */
	public class BrandState extends FlxState
	{
		
		//--------------------------------------
		// CONSTANTS
		//--------------------------------------
		
		
		//--------------------------------------
		// VARIABLES
		//--------------------------------------
		//[Embed(source="assets/b35.png")]
		[Embed(source="assets/brandsequencesheet.png")]
		private var _brandAsset:Class;
		
		private var delayCount:int = 0;
		private var delayMax:int = 100;
		
		//--------------------------------------
		// CONSTRUCTOR
		//--------------------------------------
		public function BrandState()
		{
			super();
		}
		
		//--------------------------------------
		// PUBLIC METHODS
		//--------------------------------------
		override public function create():void{
			super.create();
			
			
			var sprite:FlxSprite = new FlxSprite(0, 0);
			sprite.loadGraphic(_brandAsset, true, false, 800, 600);
			var arr:Array = [];
			for(var i:int=0 ; i<33 ; i++){
				arr.push(i);
			}
			sprite.addAnimation("brand", arr, 20, false);
			
			add(sprite);
			
			sprite.play("brand", true);
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