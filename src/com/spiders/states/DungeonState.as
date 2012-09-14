
package com.spiders.states
{
	import com.spiders.characters.WalkingDirectionalCharacter;
	import com.spiders.hero.HeroSprite;
	import com.spiders.map.DungeonMap;
	import com.spiders.misc.Fire;
	import com.spiders.monsters.SpiderSprite;
	import com.spiders.powerups.FirePowerup;
	
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
		private var _spiders:FlxGroup;
		
		private var _firePowerup:FirePowerup;
		private var _fires:FlxGroup;
		
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
			
			_map = new DungeonMap();
			_map.loadMap(new _dataMap, _imgTiles, TILE_WIDTH, TILE_HEIGHT, 0, 1);
			add(_map);
			
			_hero = new HeroSprite(0, 0);
			add(_hero);
			
			_firePowerup = new FirePowerup(2 * TILE_WIDTH, 0);
			add(_firePowerup);
			
			_spiders = new FlxGroup();
			var spider:SpiderSprite;
			for(var i:int = 0; i < 20; i++)
			{
				spider = new SpiderSprite(Util.randInclusive(100,Util.STAGE_WIDTH-100), Util.randInclusive(100,Util.STAGE_HEIGHT-100));
				_spiders.add(spider);
				add(spider);
			}
			
			_fires = new FlxGroup();
			
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
			FlxG.overlap(_hero, _firePowerup, onFirePickup);
			FlxG.overlap(_spiders, _fires, onSpidersInFire);
			
			moveTowardsHero();
			
			handleKeyboardInput();
		}
		
		//--------------------------------------
		// PROTECTED & PRIVATE METHODS
		//--------------------------------------							
		private function handleKeyboardInput():void{
			if(FlxG.keys.F){
				if(_hero.canFire){
					var fireTilePoint:FlxPoint = getTileCoordInFrontOfHero();
					var fireWorldPoint:FlxPoint = tileToWorldCoord(fireTilePoint);
					
					var newFire:Fire = new Fire(fireWorldPoint.x, fireWorldPoint.y, null, onFireSnuff);
					this._fires.add(newFire);
					add(newFire);
				}
			}
			
			//Don't worry about updating the hero's animations, he will update himself from his velocity.
			if(FlxG.keys.W){
				_hero.velocity.y = -HeroSprite.RUN_SPEED;
				_hero.velocity.x = 0;
			}else if(FlxG.keys.A){
				_hero.velocity.y = 0;
				_hero.velocity.x = -HeroSprite.RUN_SPEED;
			}else if(FlxG.keys.S){
				_hero.velocity.y = HeroSprite.RUN_SPEED;
				_hero.velocity.x = 0;
			}else if(FlxG.keys.D){
				_hero.velocity.y = 0;
				_hero.velocity.x = HeroSprite.RUN_SPEED;
			}else{
				_hero.velocity.x = _hero.velocity.y = 0;
			}
			
			_hero.acceleration.x = _hero.acceleration.y = 0;
			_hero.drag.x = _hero.drag.y = 0;
		}
		private function moveTowardsHero():void
		{
			var target:FlxSprite = _hero;
			for each (var spider:SpiderSprite in _spiders)
			{	
				//Find path to goal
				//if (spider.animState == SpiderSprite.ANIM_IDLE)
				
				try{
					var path:FlxPath = _map.findPath(new FlxPoint(spider.x + spider.width / 2, spider.y + spider.height / 2), new FlxPoint(target.x + target.width / 2, target.y + target.height / 2));
				}catch(error:Error){
					//Couldn't find the path :(
				}
				
				//Tell unit to follow path
				if(path)
					spider.followPath(path);
				//spider.animState = SpiderSprite.ANIM_RUN_DOWN;
			}
		}
		
		private function getTileCoordInFrontOfHero():FlxPoint{
			var heroTileX:int = Math.floor(_hero.x / TILE_WIDTH);
			var heroTileY:int = Math.floor(_hero.y / TILE_HEIGHT);
			
			var returnPoint:FlxPoint = new FlxPoint(heroTileX, heroTileY);
			
			switch(_hero.animState){
				case WalkingDirectionalCharacter.ANIM_IDLE_DOWN:
				case WalkingDirectionalCharacter.ANIM_RUN_DOWN:
					returnPoint.y += 1;
					break;
				case WalkingDirectionalCharacter.ANIM_IDLE_UP:
				case WalkingDirectionalCharacter.ANIM_RUN_UP:
					returnPoint.y -= 1;
					break;
				case WalkingDirectionalCharacter.ANIM_IDLE_LEFT:
				case WalkingDirectionalCharacter.ANIM_RUN_LEFT:
					returnPoint.x -= 1;
					break;
				case WalkingDirectionalCharacter.ANIM_IDLE_RIGHT:
				case WalkingDirectionalCharacter.ANIM_RUN_RIGHT:
					returnPoint.x += 1;
					break;
			}
			
			return returnPoint;
		}
		
		private function tileToWorldCoord($tilePoint:FlxPoint):FlxPoint{
			var retPnt:FlxPoint = new FlxPoint($tilePoint.x, $tilePoint.y);
			retPnt.x *= TILE_WIDTH;
			retPnt.y *- TILE_HEIGHT;
			return retPnt;
		}
		
		//--------------------------------------
		// EVENT HANDLERS
		//--------------------------------------
		private function onFirePickup($hero:FlxObject, $powerup:FlxObject):void{
			_firePowerup.kill();
			_hero.canFire = true;
		}
		
		private function onFireSnuff(fire:Fire):void{
			_fires.remove(fire, true);
			fire.kill();
		}
		
		private function onSpidersInFire($spider:FlxSprite, $fire:FlxSprite):void{
			this._spiders
		}
	}
}