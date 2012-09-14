
package com.spiders.states
{
	import com.spiders.hero.HeroSprite;
	import com.spiders.map.DungeonMap;
	
	import org.flixel.*;
	
	
	/**
	 * [Description]
	 *
	 * @author Josiah Greene
	 * @email 73@50cubes.com
	 * @since Sep 13, 2012
	 */
	public class DungeonState extends FlxState
	{
		
		//--------------------------------------
		// CONSTANTS
		//--------------------------------------
		public static const FRAMERATE:Number = 60;
		
		public static const TILE_WIDTH:Number = 64;
		public static const TILE_HEIGHT:Number = 64;
		
		//--------------------------------------
		// VARIABLES
		//--------------------------------------
		/*
		* Embed tile image
		*/
		[Embed(source = 'assets/3testBlocks.png')]
		private var _imgTiles:Class;
		/*
		* Embed map data
		*/
		[Embed(source = 'assets/pathfinding_map.txt', mimeType = "application/octet-stream")]
		private var _dataMap:Class;
		
		private var _map:DungeonMap;
		
		private var _hero:HeroSprite;
		
		//--------------------------------------
		// CONSTRUCTOR
		//--------------------------------------
		public function DungeonState()
		{
			super();
		}
		
		//--------------------------------------
		// PUBLIC METHODS
		//--------------------------------------
		override public function create():void{
			super.create();
			
			FlxG.framerate = FRAMERATE;
			FlxG.flashFramerate = FRAMERATE;
			
			_map = new DungeonMap();
			_map.loadMap(new _dataMap, _imgTiles, TILE_WIDTH, TILE_HEIGHT, 0, 1);
			add(_map);
			
			_hero = new HeroSprite(0, 0);
			add(_hero);
			
			FlxG.camera.follow(_hero);
		}
		
		override public function destroy():void{
			super.destroy();
			
			_map.destroy();
			_hero.destroy();
		}
		
		override public function update():void{
			super.update();
			
			var simplePath:FlxPath = new FlxPath();
			simplePath.add(_hero.x + _hero.width/2, _hero.y + _hero.height/2);
			
			if(FlxG.keys.W){
				simplePath.add(_hero.x + _hero.width/2, _hero.y + _hero.height/2 - TILE_HEIGHT);
			}else if(FlxG.keys.A){
				simplePath.add(_hero.x + _hero.width/2 - TILE_WIDTH, _hero.y + _hero.height/2);
			}else if(FlxG.keys.S){
				simplePath.add(_hero.x + _hero.width/2, _hero.y + _hero.height/2 + TILE_HEIGHT);
			}else if(FlxG.keys.D){
				simplePath.add(_hero.x + _hero.width/2 + TILE_WIDTH, _hero.y + _hero.height/2);
			}
			
			if(simplePath.nodes.length > 1){
				_hero.followPath(simplePath);
			}else{
				_hero.stopFollowingPath(true);
				_hero.velocity.x = _hero.velocity.y = 0;
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