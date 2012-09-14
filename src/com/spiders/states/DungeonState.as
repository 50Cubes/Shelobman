
package com.spiders.states
{
	import com.spiders.hero.HeroSprite;
	import com.spiders.map.DungeonMap;
	import com.spiders.monsters.SpiderSprite;
	
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
		private var _spiders:Vector.<SpiderSprite>;
		
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
			
			_spiders = new Vector.<SpiderSprite>();
			var spider:SpiderSprite;
			for(var i:int = 0; i < 20; i++)
			{
				spider = new SpiderSprite(Util.randInclusive(100,Util.STAGE_WIDTH-100), Util.randInclusive(100,Util.STAGE_HEIGHT-100));
				_spiders.push(spider);
				add(spider);
			}
			FlxG.camera.follow(_hero);
		}
		
		override public function destroy():void{
			super.destroy();
			
			_map.destroy();
			_hero.destroy();
		}
		
		override public function update():void{
			super.update();
			
			FlxG.collide(this._map, this._hero);
			moveTowardsHero();
			
			var simplePath:FlxPath = new FlxPath();
			simplePath.add(_hero.x + _hero.width/2, _hero.y + _hero.height/2);
			
			if(FlxG.keys.W){
				//simplePath.add(_hero.x + _hero.width/2, _hero.y + _hero.height/2 - TILE_HEIGHT);
				_hero.velocity.y = -HeroSprite.RUN_SPEED;
				_hero.velocity.x = 0;
			}else if(FlxG.keys.A){
				//simplePath.add(_hero.x + _hero.width/2 - TILE_WIDTH, _hero.y + _hero.height/2);
				_hero.velocity.y = 0;
				_hero.velocity.x = -HeroSprite.RUN_SPEED;
			}else if(FlxG.keys.S){
				//simplePath.add(_hero.x + _hero.width/2, _hero.y + _hero.height/2 + TILE_HEIGHT);
				_hero.velocity.y = HeroSprite.RUN_SPEED;
				_hero.velocity.x = 0;
				
				_hero.play(HeroSprite.ANIM_RUN_DOWN);
			}else if(FlxG.keys.D){
				//simplePath.add(_hero.x + _hero.width/2 + TILE_WIDTH, _hero.y + _hero.height/2);
				_hero.velocity.y = 0;
				_hero.velocity.x = HeroSprite.RUN_SPEED;
			}else{
				_hero.velocity.x = _hero.velocity.y = 0;
				_hero.play(HeroSprite.ANIM_IDLE);
			}
			
			/*
			if(simplePath.nodes.length > 1){
			//_hero.followPath(simplePath, 150);
			_hero.acceleration.x = _hero.acceleration.y = 0;
			_hero.velocity.
			}else{
			//_hero.stopFollowingPath(true);
			_hero.acceleration.x = _hero.acceleration.y = 0;
			_hero.velocity.x = _hero.velocity.y = 0;
			}
			*/
		}
		private function moveTowardsHero():void
		{
			var target:FlxSprite = _hero;
			for each (var spider:SpiderSprite in _spiders)
			{	
				//Find path to goal
				//if (spider.animState == SpiderSprite.ANIM_IDLE)
				
				var path:FlxPath = _map.findPath(new FlxPoint(spider.x + spider.width / 2, spider.y + spider.height / 2), new FlxPoint(target.x + target.width / 2, target.y + target.height / 2));
				
				//Tell unit to follow path
				if(path)
					spider.followPath(path);
				//spider.animState = SpiderSprite.ANIM_RUN_DOWN;
				
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