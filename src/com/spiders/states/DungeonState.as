
package com.spiders.states
{
	import com.spiders.characters.WalkingDirectionalCharacter;
	import com.spiders.hero.HeroSprite;
	import com.spiders.map.DungeonMap;
	import com.spiders.misc.DarkFilter;
	import com.spiders.misc.Fire;
	import com.spiders.misc.FlxDialog;
	import com.spiders.monsters.SpiderSprite;
	import com.spiders.powerups.FirePowerup;
	import com.spiders.powerups.JumpPowerup;
	import com.spiders.tiles.WebTile;
	
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
		
		public static var HERO_START_POINT:FlxPoint = new FlxPoint(30 * TILE_WIDTH, 34 * TILE_HEIGHT);
		
		//DEBUG: For testing boss fight
		//public static var HERO_START_POINT:FlxPoint = new FlxPoint(11 * TILE_WIDTH, 9 * TILE_HEIGHT);
		
		public static var BOSS_START_TILE:FlxPoint = new FlxPoint(10, 7);
		
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
		//[Embed(source = 'assets/pathfinding_map.txt', mimeType = "application/octet-stream")]
		[Embed(source = 'assets/tilemap_final.csv', mimeType = "application/octet-stream")]
		private var _dataMap:Class;
		
		private var _map:DungeonMap;
		private var _spiderPathMap:DungeonMap;
		private var _cameraGroup:FlxGroup;
		private var _statusBar:StatusBar;
		
		private var _hero:HeroSprite;
		private var _spiders:FlxGroup;
		private var _items:FlxGroup;
		private var _updateCounter:int = 0;
		private var _updateFrequency:int = FlxG.framerate;
		private var _bossSprite:BossSprite;
		
		private var _pitGroup:FlxGroup;
		private var _webGroup:FlxGroup;
		
		private var _spidersDeathCount:Dictionary = new Dictionary();
		
		private var _darkFilter:DarkFilter;
		
		private var _dialogBox:FlxDialog;
		private var _firstSpiderEncountered:Boolean = false;
		
		private var _fires:FlxGroup;
		
		private var _fadeToWhite:Boolean = false;
		private var _fadeToWhiteSprite:FlxSprite;
		private var _whiteFadeCounter:int = 0;
		
		
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
		
		private var lampXLocations:Array = [27, 42, 44];
		private var lampYLocations:Array = [48, 50, 28];
		
		private var bootXLocations:Array = [9, 47, 42];
		private var bootYLocations:Array = [33, 33, 50];
		
		private var firePotionXLocations:Array = [18, 39, 56];
		private var firePotionYLocations:Array = [24, 61, 36];
		
		private var heartXLocations:Array = [36, 46, 39, 59, 54, 48, 22, 30];
		private var heartYLocations:Array = [24, 28, 54, 19, 46, 40, 41, 30];
		
		private var spiderXStartLocations:Array = [36,58,61,39,39,38,18,46,61,54,25,26,26,33,32];
		private var spiderYStartLocations:Array = [22,20,37,54,57,59,27,29,25,38,14,11,9,11,14];
		
		private var webXStartLocations:Array = [36,58,61,39,39,38,18,46,61,54,25,26,26,33,32,29,25,31,34,29];
		private var webYStartLocations:Array = [22,20,37,54,57,59,27,29,25,38,14,11,9,11,14,17,15,9,7,35];
		
		private var bossLairUL:FlxPoint = new FlxPoint(4,4);
		private var bossLairLR:FlxPoint = new FlxPoint(19,13);
		
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
			turnOffPitCollision();
			
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
			
			
	
			
			_webGroup = new FlxGroup();
			add(_webGroup);
			
			_hero = new HeroSprite(HERO_START_POINT.x, HERO_START_POINT.y);
			add(_hero);
			
			var openTiles:Array = _map.getTileCoords(0);

			_bossSprite = new BossSprite(BOSS_START_TILE.x * TILE_WIDTH, BOSS_START_TILE.y * TILE_HEIGHT);
			add(_bossSprite);
			
			_spiders = new FlxGroup();
			var spider:SpiderSprite;
			var point:FlxPoint;
			var web:WebTile;
			/*
			//Debug spiders
			var spiderXValues:Array = []; //[30 * TILE_WIDTH];
			var spiderYValues:Array = []; //[41 * TILE_HEIGHT + TILE_HEIGHT/2];
			
			for(var i:int=0 ; i<spiderXValues.length ; i++){
				var spiderX:Number = spiderXValues[i];
				var spiderY:Number = spiderYValues[i];
				
				spider = new SpiderSprite(spiderX, spiderY);
				_spiders.add(spider);
				add(spider);
			}
			*/
			
			//Add spiders
			for(var i:int=0 ; i<spiderXStartLocations.length ; i++){
				spider = new SpiderSprite(spiderXStartLocations[i] * TILE_WIDTH + 16, spiderYStartLocations[i] * TILE_HEIGHT + 8);
				_spiders.add(spider);
				add(spider);
			}
				
				/////
			

			//Add webs
			for(var w:int=0 ; w<webXStartLocations.length ; w++){
				web = new WebTile(webXStartLocations[w] * TILE_WIDTH, webYStartLocations[w] * TILE_HEIGHT, TILE_WIDTH, TILE_HEIGHT);
				_webGroup.add(web);
				add(web);
			}
			
			/////

			
	
			//THIS WORKS:
			_darkFilter = new DarkFilter(-TILE_WIDTH/4 - 5, 0);
			_darkFilter.scale = new FlxPoint(1.2, 1.2);
			add(_darkFilter);
			
			initItems();
			
			_fires = new FlxGroup();
			
			
			
			_statusBar = new StatusBar();
			add(_statusBar);

			FlxG.camera.follow(_hero);
			FlxG.worldBounds = new FlxRect(0, 0, _map.width, _map.height);
			
			//Show a dialog box
			_dialogBox = new FlxDialog();
			_dialogBox.message = ["Where am I? Why is it so dark?", "I need to find a light source!"];
			this.add(_dialogBox);
			
			this._fadeToWhiteSprite = new FlxSprite(0, 0)
			_fadeToWhiteSprite.makeGraphic(800, 600, 0xFFFFFFFF); //0xFFFFFFFF);
			_fadeToWhiteSprite.scrollFactor.x = 0;
			_fadeToWhiteSprite.scrollFactor.y = 0;
			_fadeToWhiteSprite.alpha = .01;
			_fadeToWhiteSprite.visible = false;
			add(_fadeToWhiteSprite);
			
			/////
			//hack();
			/////
			
		}
		private function hack():void
		{
			//Boss battle start point
			HERO_START_POINT = new FlxPoint(11 * TILE_WIDTH, 9 * TILE_HEIGHT);
			_hero.x = HERO_START_POINT.x;
			_hero.y = HERO_START_POINT.y;
			_hero.canFire = true;
			_statusBar.showPotion(true);
			
			_darkFilter.x = -100
			_darkFilter.y = -25;
			_darkFilter.scale = new FlxPoint(4.5, 4.5);
			_darkFilter.alpha = .75;
			_hero.canSee = true;
		}
		private function initItems():void
		{
			_items = new FlxGroup();
			
			var i:int;
			
			for(i=0 ; i<this.bootXLocations.length ; i++){
				var shoe:ShoeItemSprite = new ShoeItemSprite(bootXLocations[i] * TILE_WIDTH, bootYLocations[i] * TILE_HEIGHT, _bootItem);
				add(shoe);
				_items.add(shoe);
			}
			
			for(i=0 ; i<this.lampXLocations.length ; i++){
				var candle:CandleItemSprite = new CandleItemSprite(lampXLocations[i] * TILE_WIDTH, lampYLocations[i] * TILE_HEIGHT, _candleItem);
				add(candle);
				_items.add(candle);
			}
			
			for(i=0 ; i<firePotionXLocations.length ; i++){
				var firePotion:FirePowerup = new FirePowerup(firePotionXLocations[i] * TILE_WIDTH, firePotionYLocations[i] * TILE_HEIGHT, _firebombItem);
				add(firePotion);
				_items.add(firePotion);
			}
			
			for(i=0 ; i<heartXLocations.length ; i++){
				var heart:HeartItemSprite = new HeartItemSprite(heartXLocations[i] * TILE_WIDTH, heartYLocations[i] * TILE_HEIGHT, _heartItem);
				add(heart);
				_items.add(heart);
			}
			
			/*
			var floatingItem:ShoeItemSprite = new ShoeItemSprite(31 * TILE_WIDTH, 34 * TILE_HEIGHT,_bootItem);
			add(floatingItem);
			_items.add(floatingItem);
			
			var candleItem:CandleItemSprite = new CandleItemSprite(31 * TILE_WIDTH, 35 * TILE_HEIGHT,_candleItem);
			add(candleItem);
			_items.add(candleItem);
			
			var heartItem:HeartItemSprite = new HeartItemSprite(29 * TILE_WIDTH, 34 * TILE_HEIGHT,_heartItem);
			add(heartItem);
			_items.add(heartItem);
			
			var firebombItem:FirePowerup = new FirePowerup(29 * TILE_WIDTH, 35 * TILE_HEIGHT,_firebombItem);
			add(firebombItem);
			_items.add(firebombItem);
			*/
		}

		override public function destroy():void{
			super.destroy();
			
			_map.destroy();
			_hero.destroy();
		}
		
		override public function update():void{
			super.update();
			
			if(_fadeToWhite){
				if(_whiteFadeCounter == 0){
					_fadeToWhiteSprite.visible = true;
					_fadeToWhiteSprite.alpha = .01;
					//Kill 'em all
					for each(var spider:SpiderSprite in _spiders.members){
						this.onSpidersInFire(spider, null);
					}
				}
				_whiteFadeCounter++;
				
				_fadeToWhiteSprite.alpha = Math.min(1, _whiteFadeCounter/50.0);
				
				if(_fadeToWhiteSprite.alpha >= 1){
					_fadeToWhite = false;
					trace("congratulations!");
				}
			}
			
			_updateCounter++;
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
			else if(_bossSprite.isActive == true && _bossSprite.isAlive && _updateCounter % _bossSprite.spawnByFrames == 0)
			{
				var spawns:int = Util.randInclusive(1, 3);
				var spawnSpider:SpiderSprite;
				var i:int;
				for (i = 0; i < spawns; i++)
				{
					var randX:Number = Math.random() * TILE_WIDTH * 2 - TILE_WIDTH;
					var randY:Number = Math.random() * TILE_HEIGHT * 2 - TILE_HEIGHT;
					
					spawnSpider = new SpiderSprite(_bossSprite.x + _bossSprite.width * 0.5 + randX, _bossSprite.y + _bossSprite.health * 0.5 + randY, null, 300, 500);
					_spiders.add(spawnSpider);
					add(spawnSpider);
				}
				
				var webSpawns:int = Util.randInclusive(_bossSprite.minSpawnWebs, _bossSprite.maxSpawnWebs);
				var spawnWeb:WebTile;
				for(i=0 ; i<webSpawns ; i++){
					var randomTileX:int = Util.randInclusive(bossLairUL.x, bossLairLR.x);
					var randomTileY:int = Util.randInclusive(bossLairUL.y, bossLairLR.y);
					
					spawnWeb = new WebTile(randomTileX * TILE_WIDTH, randomTileY * TILE_HEIGHT, TILE_WIDTH, TILE_HEIGHT);
					if(spawnWeb.overlaps(_hero)){
						//that's bad, don't trap him in place, just continue
						continue;
					}
					if(spawnWeb.overlaps(_webGroup)){
						//Don't put double webs
						continue;
					}
					this._webGroup.add(spawnWeb);
					this.add(spawnWeb);
				}
			}
			
			if(_bossSprite.isActive && _bossSprite.isAlive){
				//Move around randomly!
				if(_bossSprite.pathSpeed == 0){
					var rand:int = Math.floor(Math.random() * BossSprite.RANDOM_X_TILE_DESTINATION.length);
					var randXTile:int = int(BossSprite.RANDOM_X_TILE_DESTINATION[rand]);
					var randYTile:int = int(BossSprite.RANDOM_Y_TILE_DESTINATION[rand]);
					
					var bossPath:FlxPath = _map.findPath(new FlxPoint(_bossSprite.x + _bossSprite.width/2, _bossSprite.y + _bossSprite.height/2),
						new FlxPoint(randXTile * TILE_WIDTH, randYTile * TILE_HEIGHT));
					_bossSprite.followPath(bossPath);
				}
				
			}
			
			if(!_bossSprite.isAlive){
				this._fadeToWhite = true;
			}
			
			
			updateAndCleanupDeadSpiders();
			
			//trace("hero position -- " + _hero.x + " " + _hero.y);
			//FlxG.collide(this._map, this._hero);
			
			FlxG.overlap(_spiders, _fires, onSpidersInFire);
			FlxG.overlap(_bossSprite, _fires, onBossInFire);
			FlxG.overlap(_webGroup, _fires, onWebsInFire);
			
			if(_hero.isAlive && !_hero.isJumping){
				FlxG.overlap(_hero, _fires, onHeroInFire);
				FlxG.overlap(_hero, _pitGroup, fallIntoPit);
				FlxG.collide(_hero, _webGroup);
				FlxG.overlap(_hero, this._bossSprite, bossBiteHero);

			}
			
			_statusBar.updateHealth(_hero.HP);
			
			
			if(_hero.isAlive){
				FlxG.collide(_map, _hero);
				FlxG.overlap(_hero, _items, onItemPickup);
				
				//spiders need to stop immediately, also collide and bite >:)
				for each (var updateSpider:SpiderSprite in _spiders.members)
				{
					//No need to collide the map with the spider,
					// they should only move on mapped paths.
					//FlxG.collide(updateSpider, _map);
					FlxG.overlap(updateSpider, _hero, spiderBiteHero);
					
					if(updateSpider.pathSpeed == 0){
						updateSpider.stopFollowingPath(true);
						updateSpider.velocity.x = updateSpider.velocity.y = 0;
					}
				}
				
				if(_updateCounter % _updateFrequency == 0){
					handleSpiderAggroAndPathing();
				}
			
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
		private function turnOffPitCollision():void{
			_map.setTileProperties(DungeonMap.PIT, FlxObject.NONE);
			_map.setTileProperties(DungeonMap.SPIKE_PIT, FlxObject.NONE);
		}
		
		private function turnOnPitCollision():void{
			_map.setTileProperties(DungeonMap.PIT, FlxObject.ANY);
			_map.setTileProperties(DungeonMap.SPIKE_PIT, FlxObject.ANY);
		}
		
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
					var fireWorldPoint:FlxPoint = getWorldCoordTilesInFrontOfHero(1);
					
					var newFire:Fire = new Fire(fireWorldPoint.x - 13, fireWorldPoint.y - 40, onFireSnuff);
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
		
		private function spiderGoHome(spider:SpiderSprite):void{
			spider.isAggro = false;
			this.turnOnPitCollision();
			var path:FlxPath = _map.findPath(new FlxPoint(spider.x + spider.width/2, spider.y + spider.height/2), spider.spawningPosition);
			if(path){
				spider.followPath(path);
			}
			this.turnOffPitCollision();
		}
		
		private function spiderBiteHero($spider:SpiderSprite, $hero:HeroSprite):void
		{
			if($hero.isAlive){
				$hero.gotHit(1);
			}
			
			if($hero.isAlive){
				$spider.stopFollowingPath(true);
				$spider.velocity.x = $spider.velocity.y = 0;
			}else{
				spiderGoHome($spider);
			}
		}
		
		private function bossBiteHero($hero:HeroSprite, $boss:BossSprite):void{
			if($hero.isAlive){
				$hero.gotHit(1);
			}
		}
		
		private function handleSpiderAggroAndPathing():void
		{
			if(!_hero.isAlive){
				return;
			}
			
			var target:FlxSprite = _hero;
			for each (var spider:SpiderSprite in _spiders.members)
			{	
				//Find path to goal
				var path:FlxPath;
				var a:Number = Math.abs(spider.spawningPosition.x - spider.x);
				var b:Number = Math.abs(spider.spawningPosition.y - spider.y);
				var spiderDistanceFromSpawn:Number = Math.sqrt(a*a + b*b) ;
				
				var spiderA:Number = Math.abs(spider.x - _hero.x);
				var spiderB:Number = Math.abs(spider.y - _hero.y);
				var spiderDistanceFromHero:Number = Math.sqrt(spiderA*spiderA + spiderB*spiderB) ;
				
				var isWithinAggroHero:Boolean = spiderDistanceFromHero < spider.aggroDistance ? true : false;
				var isOutOfRange:Boolean = spiderDistanceFromSpawn > spider.giveupDistance;
				
				//////
				if(spider.isAggro || isWithinAggroHero){
					if(isOutOfRange){
						//Give up and go back home to your spawn.
						//(But I'm le tired.)
						spiderGoHome(spider);
					}else{
						//Update path to the hero, aggro on the hero
						//Gotta make sure they don't path over the damn pits...
						this.turnOnPitCollision();
						path = _map.findPath(new FlxPoint(spider.x + spider.width/2, spider.y + spider.height/2),
							new FlxPoint(target.x + target.width/2, target.y + target.height/2));
						this.turnOffPitCollision();
						if(path){
							spider.stopFollowingPath(true);
							spider.followPath(path);
							spider.isAggro = true;
						}
					}
				}else{
					if(spider.path != null && spider.path.nodes != null && spider.path.nodes.length > 0){
						//You have a path home already, no need to update it.
						return;
					}else{
						//Find a path home, follow it.
						spiderGoHome(spider);
					}
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
		
		private function onWebsInFire($webs:WebTile, $fire:FlxSprite):void
		{
			_webGroup.remove($webs, true);
			$webs.kill();
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
			var message:Array = [];
			
			$item.kill();
			if($item is HeartItemSprite)
			{
				_hero.raiseMaxHPBy(($item as HeartItemSprite).health);
				_statusBar.updateHealth(_hero.HP);
				message.push("I feel stronger!");
			}
			else if ($item is ShoeItemSprite)
			{
				_statusBar.showShoe(true);
				_hero.canJump = true;
				message.push("I feel lighter! (Press R to jump)");
			}
			else if ($item is CandleItemSprite)
			{
				_statusBar.showCandle(true);
				//this._darkFilter.visible = false;
				_darkFilter.x = -100
				_darkFilter.y = -25;
				_darkFilter.scale = new FlxPoint(4.5, 4.5);
				_darkFilter.alpha = .75;
				_hero.canSee = true;
				message.push("I can see!");
			}
			else if($item is FirePowerup){
				_hero.canFire = true;
				_statusBar.showPotion(true);
				message.push("I have a weapon! (Press F to throw fire)");
			}
			
			_items.remove($item, true);
			
			message = message.concat(getReadinessMessage());
			
			this._dialogBox.message = message;
		}
		
		private function getReadinessMessage():Array{
			if(_hero.canSee && _hero.canFire && _hero.canJump && _hero.HP_MAX >= 3){
				return ["I am ready.", "Head north to end these spiders, once and for all!"];
			}else{
				return ["But I am not yet ready."];
			}
		}
	}
}