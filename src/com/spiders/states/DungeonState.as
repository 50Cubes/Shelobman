
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
		[Embed(source = 'assets/3testBlocks.png')]
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
			_map.loadMap(new _dataMap, _imgTiles, TILE_WIDTH, TILE_HEIGHT, 0, 1);
			add(_map);
			
			_hero = new HeroSprite(HERO_START_POINT.x, HERO_START_POINT.y);
			add(_hero);
			
			initItems();
			
			_spiders = new FlxGroup();
			var spider:SpiderSprite;

			for(var i:int = 0; i < 20; i++)
			{
				var openTiles:Array = _map.getTileCoords(0);
				var tileIndex:int = Util.randInclusive(0, openTiles.length-1);
				var point:FlxPoint = openTiles[tileIndex] as FlxPoint;
				
				spider = new SpiderSprite(point.x, point.y);
				_spiders.add(spider);
				add(spider);
				
				//spider = new SpiderSprite(Util.randInclusive(100,Util.STAGE_WIDTH-100), Util.randInclusive(100,Util.STAGE_HEIGHT-100));
			
			}
			
			_fires = new FlxGroup();
			
			_statusBar = new StatusBar();
			add(_statusBar);

			FlxG.camera.follow(_hero);
		}
		private function initItems():void
		{
			_items = new FlxGroup();

			var floatingItem:ShoeItemSprite = new ShoeItemSprite(0,90,_bootItem);
			add(floatingItem);
			_items.add(floatingItem);
			
			var candleItem:CandleItemSprite = new CandleItemSprite(0,30,_candleItem);
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
			
			
			
			FlxG.collide(this._map, this._hero);
			
			FlxG.overlap(_spiders, _fires, onSpidersInFire);
			FlxG.overlap(_hero, _fires, onHeroInFire);
			
			FlxG.overlap(_hero, _items, onItemPickup);
			FlxG.overlap(_hero, _fires, onHeroInFire);
			
			_upateCounter++;
			if(_upateCounter % _updateFrequency == 0)
				moveTowardsHero();
			
			_statusBar.updateHealth(_hero.HP);
			
			if(_hero.isAlive)
				handleKeyboardInput();
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
		private function handleKeyboardInput():void{
			if(FlxG.keys.justPressed("F")){
				if(_hero.canFire && _fires.length < MAX_FIRES){
					//Kill them with fire
					//var fireTilePoint:FlxPoint = getTileCoordInFrontOfHero();
					//var fireWorldPoint:FlxPoint = getWorldCoordInFrontOfHero();
					var fireWorldPoint:FlxPoint = getWorldCoordTilesInFrontOfHero(1);
					
					var newFire:Fire = new Fire(fireWorldPoint.x, fireWorldPoint.y, null, onFireSnuff);
					this._fires.add(newFire);
					add(newFire);
				}
			}
			
			if(FlxG.keys.justPressed("R")){
				if(_hero.canJump && !_hero.isJumping){
				//if(!_hero.isJumping){
					//JUMP!
					var jumpPoint:FlxPoint = getWorldCoordTilesInFrontOfHero(2);
					
					_hero.jumpTo(jumpPoint);
					
					return;
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
		private function doDamageToHero($spider:SpiderSprite, $hero:HeroSprite):void
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
				FlxG.overlap(spider, _hero, doDamageToHero);
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
				
				if(isWithinAggroHero == true && _hero.isAlive)
				{
					path = _map.findPath(new FlxPoint(spider.x + spider.width / 2, spider.y + spider.height / 2), new FlxPoint(target.x + target.width / 2, target.y + target.height / 2));
					
					//Tell unit to follow path
					if(path)
					{
						spider.followPath(path);
						spider.isAggro = true;
					}
				}
				else if(isWithinGiveupHero == true && _hero.isAlive)
				{
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
					spider.velocity = new FlxPoint(0, 0);
					path = _map.findPath(new FlxPoint(spider.x + spider.width / 2, spider.y + spider.height / 2), new FlxPoint(spider.spawningPosition.x, spider.spawningPosition.y));
					
					//Tell unit to follow path
					if(path)
					{
						spider.followPath(path);
						
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
//		private function onFirePickup($hero:FlxObject, $powerup:FlxObject):void{
//			firebombItem.kill();
//			_hero.canFire = true;
//		}
		
		private function onFireSnuff(fire:Fire):void{
			fire.kill();
			_fires.remove(fire, true);
		}
		
		private function onSpidersInFire($spider:FlxSprite, $fire:FlxSprite):void{
			$spider.kill();
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
			}
			_items.remove($item, true);
		}
	}
}