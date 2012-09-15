
package com.spiders.states
{
	import com.spiders.characters.WalkingDirectionalCharacter;
	import com.spiders.hero.HeroSprite;
	import com.spiders.map.DungeonMap;
	import com.spiders.misc.Fire;
	import com.spiders.monsters.SpiderSprite;
	import com.spiders.powerups.FirePowerup;
	import com.spiders.powerups.JumpPowerup;
	
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
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
		public static const AGGRO_DISTANCE:Number = 512;
		public static const MAX_FIRES:int = 3;
		
		public static var HERO_START_POINT:FlxPoint = new FlxPoint(2 * TILE_WIDTH, 2 * TILE_HEIGHT);
		
		//--------------------------------------
		// VARIABLES
		//--------------------------------------
		/*
		* Embed tile image
		*/
		[Embed(source = 'assets/GameTiles.png')]
		private var _imgTiles:Class;
		/*
		* Embed map data
		*/
		[Embed(source = 'assets/pathfinding_map.txt', mimeType = "application/octet-stream")]
		private var _dataMap:Class;
		
		private var _map:DungeonMap;
		private var _cameraGroup:FlxGroup;
		private var _statusBar:StatusBar;
		
		private var _hero:HeroSprite;
		private var _spiders:FlxGroup;
		private var _items:FlxGroup;
		private var _upateCounter:int = 0;
		private var _updateFrequency:int = FlxG.framerate;
		private var _bossSprite:BossSprite;
		
		private var _pitGroup:FlxGroup;
		
		private var _spidersDeathCount:Dictionary = new Dictionary();
		
		//private var _firePowerup:FirePowerup;
		private var _fires:FlxGroup;
		
		
		[Embed(source = 'assets/bootsheet.png')]
		private var _bootItem:Class;
		
		[Embed(source = 'assets/candlesheet.png')]
		private var _candleItem:Class;
		
		[Embed(source = 'assets/firebombsheet.png')]
		private var _firebombItem:Class;
		
		[Embed(source = 'assets/heartsheet.png')]
		private var _heartItem:Class;
		
		[Embed(source = 'assets/mbootsheet.png')]
		private var _mbootItem:Class;
		
//		[Embed(source = 'assets/torchsheet.png')]
//		private var _torchItem:Class;
		
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
			_map.loadMap(new _dataMap, _imgTiles, TILE_WIDTH, TILE_HEIGHT, FlxTilemap.OFF, 0, 0, 1);
			_map.setTileProperties(DungeonMap.PIT, FlxObject.NONE);
			_map.setTileProperties(DungeonMap.SPIKE_PIT, FlxObject.NONE);
			
			add(_map);
			
			this._pitGroup = new FlxGroup();
			for (var ty:int = 0; ty < _map.heightInTiles; ty++)
			{
				for (var tx:int = 0; tx < _map.widthInTiles; tx++)
				{
					var tile:uint = _map.getTile(tx, ty);
					if (tile == DungeonMap.PIT || tile == DungeonMap.SPIKE_PIT)
					{
						var newPit:FlxSprite = new FlxSprite(TILE_WIDTH * tx + 10, TILE_HEIGHT * ty + 10);
						newPit.makeGraphic(TILE_WIDTH - 20, TILE_HEIGHT - 20, 0x000000);
						add(newPit);
						_pitGroup.add(newPit);
					}
				}
			}
			
			
			add(_pitGroup);
			
			_hero = new HeroSprite(HERO_START_POINT.x, HERO_START_POINT.y);
			add(_hero);
			
			initItems();
			var openTiles:Array = _map.getTileCoords(0);

			_bossSprite = new BossSprite(1230, 100);
			add(_bossSprite);
			
			_spiders = new FlxGroup();
			var spider:SpiderSprite;
			var point:FlxPoint;

			
			for(var i:int = 0; i < 2; i++)
			{
				//var openTiles:Array = _map.getTileCoords(1);
				var tileIndex:int = Util.randInclusive(0, openTiles.length-1);
			//	var tileIndex:int = Util.randInclusive(0, openTiles.length-1);
			//	point = openTiles[tileIndex] as FlxPoint;
				point = openTiles[3+i] as FlxPoint;
				trace("point ");
				trace(point.x + " " + point.y);
				
				spider = new SpiderSprite(point.x, point.y);
				_spiders.add(spider);
				add(spider);
				
				//spider = new SpiderSprite(Util.randInclusive(100,Util.STAGE_WIDTH-100), Util.randInclusive(100,Util.STAGE_HEIGHT-100));
			
			}
			
			_fires = new FlxGroup();
			
			_statusBar = new StatusBar();
			add(_statusBar);

			FlxG.camera.follow(_hero);
			FlxG.worldBounds = new FlxRect(0, 0, _map.width, _map.height);
			
		}
		private function initItems():void
		{
			_items = new FlxGroup();

			var floatingItem:ShoeItemSprite = new ShoeItemSprite(64,150,_bootItem);
			add(floatingItem);
			_items.add(floatingItem);
			
			var candleItem:CandleItemSprite = new CandleItemSprite(64,200,_candleItem);
			add(candleItem);
			_items.add(candleItem);
			
			var heartItem:HeartItemSprite = new HeartItemSprite(3*TILE_WIDTH,2*TILE_HEIGHT,_heartItem);
			add(heartItem);
			_items.add(heartItem);
//			var mbootItem:ShoeItemSprite = new ShoeItemSprite(0,90,_mbootItem);
//			add(mbootItem);
//			_items.add(mbootItem);
			
//			var torchItem:FloatingItemSprite = new FloatingItemSprite(TILE_WIDTH,2*TILE_HEIGHT,_torchItem);
//			add(torchItem);
//			_items.add(torchItem);
			
			var firebombItem:FirePowerup = new FirePowerup(3*TILE_WIDTH,4*TILE_HEIGHT,_firebombItem);

			//firebombItem = new PotionItemSprite(0,150,_firebombItem);

			add(firebombItem);
			_items.add(firebombItem);
			
		}
		private var firebombItem:PotionItemSprite;
		override public function destroy():void{
			super.destroy();
			
			_map.destroy();
			_hero.destroy();
		}
		
		override public function update():void{
			super.update();
			_upateCounter++;
			//FlxG.worldBounds = new FlxRect(_hero.x - 128, _hero.y - 128, Util.STAGE_WIDTH, Util.STAGE_HEIGHT);
			//trace("worldBounds -- " + FlxG.worldBounds.x + " " + FlxG.worldBounds.y);
			
			if(_bossSprite.isActive == false)
			{
				var a:Number = _bossSprite.x - _hero.x;
				var b:Number = _bossSprite.y - _hero.y;
				var pythagorean:Number = Math.sqrt(a*a + b*b) ;
				
				if(pythagorean < _bossSprite.aggroDistance)
				{
					_bossSprite.isActive = true;
				}
			}
			else if(_bossSprite.isActive == true && _bossSprite.isAlive && _upateCounter % _bossSprite.spawnByFrames == 0)
			{
				var spawns:int = Util.randInclusive(1, 3);
				var spider:SpiderSprite;
				for (var i:int = 0; i < spawns; i++)
				{
					spider = new SpiderSprite(_bossSprite.x + _bossSprite.width * 0.5, _bossSprite.y + _bossSprite.health * 0.5, null, 300, 500);
					_spiders.add(spider);
					add(spider);
					
				}
			}
			
			
			updateAndCleanupDeadSpiders();
			
			trace("hero position -- " + _hero.x + " " + _hero.y);
			//FlxG.collide(this._map, this._hero);
			
			FlxG.overlap(_spiders, _fires, onSpidersInFire);
			FlxG.overlap(_bossSprite, _fires, onBossInFire);
			
			if(_hero.isAlive && !_hero.isJumping){
				FlxG.overlap(_hero, _fires, onHeroInFire);
				FlxG.overlap(_hero, _pitGroup, fallIntoPit);
			}
			
			_statusBar.updateHealth(_hero.HP);
			
			
			if(_hero.isAlive){
				FlxG.collide(_map, _hero, onMapCollision);
				FlxG.overlap(_hero, _items, onItemPickup);
				
				if(_upateCounter % _updateFrequency == 0)
					moveTowardsHero();
			
				handleKeyboardInput();
			}
			else
			{
				_hero.velocity = new FlxPoint(0, 0);
				_hero.heroDiesAnimation();
				if(_hero.alpha < .05){
					//All right, you're done dying.
					_hero.revive();
					_hero.x = HERO_START_POINT.x;
					_hero.y = HERO_START_POINT.y;
				}
			}
		}
		
		//--------------------------------------
		// PROTECTED & PRIVATE METHODS
		//--------------------------------------	
		private function updateAndCleanupDeadSpiders():void{
			for(var keySpider:* in this._spidersDeathCount){
				_spidersDeathCount[keySpider]++;
				var count:int = _spidersDeathCount[keySpider]
				if(count >= 60){
					keySpider.kill();
				}
			}
		}
		
		private function handleKeyboardInput():void{
			if(FlxG.keys.justPressed("F")){
				if(_hero.canFire && _fires.length < MAX_FIRES){
					//Kill them with fire
					//var fireTilePoint:FlxPoint = getTileCoordInFrontOfHero();
					//var fireWorldPoint:FlxPoint = getWorldCoordInFrontOfHero();
					var fireWorldPoint:FlxPoint = getWorldCoordTilesInFrontOfHero(1);
					
					var newFire:Fire = new Fire(fireWorldPoint.x, fireWorldPoint.y - 40, onFireSnuff);
					this._fires.add(newFire);
					add(newFire);
				}
			}
			
			if(FlxG.keys.justPressed("R")){
				if(_hero.canJump && !_hero.isJumping){
					var jumpPoint:FlxPoint = getWorldCoordTilesInFrontOfHero(2);
					
					_hero.jumpTo(jumpPoint);
					
					return;
				}
			}
			
			//Don't worry about updating the hero's animations, he will update himself from his velocity.
			
			if(!_hero.isJumping){
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
					
					//Look for little keyboard taps to choose direction
					if(FlxG.keys.justPressed("W") || FlxG.keys.justReleased("W")){
						_hero.orientation = WalkingDirectionalCharacter.UP;
					}else if(FlxG.keys.justPressed("A") || FlxG.keys.justReleased("A")){
						_hero.orientation = WalkingDirectionalCharacter.LEFT;
					}else if(FlxG.keys.justPressed("S") || FlxG.keys.justReleased("S")){
						_hero.orientation = WalkingDirectionalCharacter.DOWN;
					}else if(FlxG.keys.justPressed("D") || FlxG.keys.justReleased("D")){
						_hero.orientation = WalkingDirectionalCharacter.RIGHT;
					}
				}
				_hero.acceleration.x = _hero.acceleration.y = 0;
				_hero.drag.x = _hero.drag.y = 0;
			}
		}
		private function spiderBiteHero($spider:SpiderSprite, $hero:HeroSprite):void
		{
			if($hero.isAlive){
				$hero.gotHit(1);
			}
		}
		private function moveTowardsHero():void
		{
			var target:FlxSprite = _hero;
			for each (var spider:SpiderSprite in _spiders.members)
			{	
				//Find path to goal
				//if (spider.animState == SpiderSprite.ANIM_IDLE)
				FlxG.collide(spider, _spiders);
				FlxG.collide(spider, _map);
				FlxG.overlap(spider, _hero, spiderBiteHero);
				var path:FlxPath;
				
				var a:Number = spider.spawningPosition.x - _hero.x;
				var b:Number = spider.spawningPosition.y - _hero.y;
				var pythagorean:Number = Math.sqrt(a*a + b*b) ;
				
				
				var spiderA:Number = spider.x - _hero.x;
				var spiderB:Number = spider.y - _hero.y;
				var spiderPythagorean:Number = Math.sqrt(spiderA*spiderA + spiderB*spiderB) ;
				
				var isWithinAggroHero:Boolean = pythagorean < spider.aggroDistance ? true : false;
				var isOutOfRange:Boolean = spiderPythagorean > pythagorean;
				// aggro
				var isWithinGiveupHero:Boolean = pythagorean < spider.giveupDistance ? true : false;
				

				try{
					if(isWithinAggroHero == true && _hero.isAlive)
					{
						trace("if isWithinAggroHero");
						path = _map.findPath(new FlxPoint(spider.x + spider.width / 2, spider.y + spider.height / 2), new FlxPoint(target.x + target.width / 2, target.y + target.height / 2));
						
						//Tell unit to follow path
						if(path)
						{
							spider.followPath(path);
							spider.isAggro = true;
						}
					}
					else
					{
						trace("else ");
						if(isWithinGiveupHero == true && _hero.isAlive && spider.isAggro == true)
						{
							trace("else if -- isWithinGiveupHero");
							path = _map.findPath(new FlxPoint(spider.x + spider.width / 2, spider.y + spider.height / 2), new FlxPoint(target.x + target.width / 2, target.y + target.height / 2));
							
							//Tell unit to follow path
							if(path)
							{
								spider.followPath(path);
							}
						}
						else
						{
							
							path = _map.findPath(new FlxPoint(spider.x, spider.y), spider.spawningPosition);
							spider.isAggro = false;
							//Tell unit to follow path
							
							if(path)
							{
								spider.followPath(path);
								
							}
							if(spider.pathSpeed == 0)
							{
								trace("else else");
								spider.velocity = new FlxPoint(0, 0);
							}
						}
					}
				}catch(error:Error){
					//Couldn't move spider :(
				}
				
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
		
		private function getWorldCoordTilesInFrontOfHero(numInFront:int = 2):FlxPoint{
			var returnPoint:FlxPoint = new FlxPoint(_hero.x, _hero.y);
			
			switch(_hero.animState){
				case WalkingDirectionalCharacter.ANIM_IDLE_DOWN:
				case WalkingDirectionalCharacter.ANIM_RUN_DOWN:
					returnPoint.y += numInFront * TILE_HEIGHT;
					break;
				case WalkingDirectionalCharacter.ANIM_IDLE_UP:
				case WalkingDirectionalCharacter.ANIM_RUN_UP:
					returnPoint.y -= numInFront * TILE_HEIGHT;
					break;
				case WalkingDirectionalCharacter.ANIM_IDLE_LEFT:
				case WalkingDirectionalCharacter.ANIM_RUN_LEFT:
					returnPoint.x -= numInFront * TILE_WIDTH;
					break;
				case WalkingDirectionalCharacter.ANIM_IDLE_RIGHT:
				case WalkingDirectionalCharacter.ANIM_RUN_RIGHT:
					returnPoint.x += numInFront * TILE_WIDTH;
					break;
			}
			
			return returnPoint;
		}
		
		private function tileToWorldCoord($tilePoint:FlxPoint):FlxPoint{
			var retPnt:FlxPoint = new FlxPoint($tilePoint.x, $tilePoint.y);
			retPnt.x *= TILE_WIDTH;
			retPnt.y *= TILE_HEIGHT;
			return retPnt;
		}
		
		//--------------------------------------
		// EVENT HANDLERS
		//--------------------------------------
		
		private function onFireSnuff(fire:Fire):void{
			fire.kill();
			_fires.remove(fire, true);
		}
		
		private function onMapCollision($map:DungeonMap, $hero:HeroSprite):void{
			/*
			//Fuck it, just look at the tile i think they're going to
			var destinyTile:FlxPoint = this.getTileCoordInFrontOfHero();
			var destinyType:uint = _map.getTile(destinyTile.x, destinyTile.y);

			if(!_hero.isJumping && destinyType == DungeonMap.PIT || destinyType == DungeonMap.SPIKE_PIT){
				//YOU LOSE! GOOD DAY, SIR!
				//FALL INTO THE PIT YOU BASTARD!
				_hero.x = destinyTile.x * TILE_WIDTH + (TILE_WIDTH - _hero.width)/2;
				_hero.y = destinyTile.y * TILE_HEIGHT + (TILE_HEIGHT + _hero.height)/2;
				_hero.isAlive = false;
			}
			*/
		}
		
		private function fallIntoPit($hero:HeroSprite, $pitSprite:FlxSprite):void{
			_hero.x = $pitSprite.x + ($pitSprite.width - _hero.width)/2;
			_hero.y = $pitSprite.y + ($pitSprite.height + _hero.height)/2;
			_hero.isAlive = false;
		}
		
		private function onBossInFire($boss:BossSprite, $fire:FlxSprite):void{
			if($boss.isAlive){
				$boss.gotHit(1);
			}
		}
		private function onSpidersInFire($spider:SpiderSprite, $fire:FlxSprite):void{
			_spidersDeathCount[$spider] = 0;
			
			$spider.stopFollowingPath(true);
			$spider.velocity.x = 0;
			$spider.velocity.y = 0;
			$spider.autoIdle = false;
			
			$spider.play(SpiderSprite.ANIM_FIRE_DEATH, true);
			
			_spiders.remove($spider, true);
		}
		
		private function onHeroInFire($hero:FlxSprite, $fire:FlxSprite):void{
			if(_hero.isAlive){
				_hero.gotHit(1);
			}
		}
		
		private function onItemPickup($hero:FlxSprite, $item:FlxSprite):void{
			$item.kill();
			if($item is HeartItemSprite)
			{
				_hero.raiseMaxHPBy(($item as HeartItemSprite).health);
				_statusBar.updateHealth(_hero.HP);
			}
			else if ($item is ShoeItemSprite)
			{
				_statusBar.showShoe(true);
				_hero.canJump = true;
			}
			else if ($item is CandleItemSprite)
			{
				_statusBar.showCandle(true);
			}
			else if ($item is PotionItemSprite)
			{
				_statusBar.showPotion(true);
				firebombItem.kill();
				_hero.canFire = true;
			}
			if($item is JumpPowerup){
				_hero.canJump = true;
			}
			if($item is FirePowerup){
				_hero.canFire = true;
				_statusBar.showPotion(true);
			}
			_items.remove($item, true);
		}
	}
}