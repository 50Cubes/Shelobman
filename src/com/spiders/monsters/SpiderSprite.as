/**
 ##########################################################################################
 SpiderSprite
 
 Copyright (c) 2012 Screamstream Interactive. All rights reserved.
 
 The above copyright notice and this permission notice shall be
 included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 OTHER DEALINGS IN THE SOFTWARE.
 ##########################################################################################
 */
package com.spiders.monsters
{
	import com.spiders.characters.WalkingDirectionalCharacter;
	
	import flash.geom.Point;
	
	import org.flixel.FlxG;
	import org.flixel.FlxPath;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	
	
	/**
	 * [Description]
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 10.0
	 *
	 * @author 37@50cubes.com
	 * @since Sep 13, 2012
	 */
	public class SpiderSprite extends WalkingDirectionalCharacter
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		public static const RUN_SPEED:Number = 150;
		
		public static const ANIM_RUN_DOWN:String = "run";
		public static const RUN_DOWN_FRAMES:Array = [8,9,10,11,12,13,14,15];
		
		public static const ANIM_IDLE:String = "idle";
		public static const IDLE_FRAMES:Array = [0,1,2,3,4,5,6,7];
		
		public static const ANIM_FIRE_DEATH:String = "fire death";
		public static const FIRE_DEATH_FRAMES:Array = [19, 20, 21, 22, 23, 24, 25];
		
		private static const CHECK_DELAY_MAX:Number = FlxG.framerate;
		
		//--------------------------------------
		// PUBLIC VARIABLES
		//--------------------------------------
		[Embed(source = 'assets/spidersheet.png')]
		private var _heroAsset:Class;
		
		public var spawningPosition:FlxPoint;
		public var aggroDistance:Number = 100;
		public var giveupDistance:Number = 300;
		public var isAggro:Boolean = false;
		private var _checkDelay:Number = SpiderSprite.CHECK_DELAY_MAX;
		//--------------------------------------
		// CONSTRUCTOR
		//--------------------------------------
		public function SpiderSprite(X:Number=0, Y:Number=0, SimpleGraphic:Class=null, aggroD:Number = 100, giveupD:Number = 300)
		{
			super(X, Y);
			//trace("spawningPosition before ");
			//trace(spawningPosition.x + " " + spawningPosition.y);

			this.loadGraphic(_heroAsset, true);
			this.offset.x = 30;
			this.offset.y = 38;
			this.width = 32;
			this.height = 16;
			aggroDistance = aggroD;
			giveupDistance = giveupD;
			
			this.addAnimation(ANIM_FIRE_DEATH, FIRE_DEATH_FRAMES, 5, false);
			
			//this.acceleration = new FlxPoint(0, 0);
			spawningPosition = new FlxPoint(X+width*0.5,Y+height*0.5);// Util.tileToCoord(Util.coordToTile(new FlxPoint(x, y)));
			//trace("spawningPosition ");
			//trace(spawningPosition.x + " " + spawningPosition.y);
//			spawningPosition.x += width;
//			spawningPosition.y += height;
		}
		public function doneDelay():Boolean
		{
			var doneChecking:Boolean = false;
			if(_checkDelay >= SpiderSprite.CHECK_DELAY_MAX)
			{
				_checkDelay = 0;
				doneChecking = true;
			}
			else
			{
				_checkDelay++;
				doneChecking = false;
			}
			return doneChecking; 
			
		}
		//--------------------------------------
		// PRIVATE VARIABLES
		//--------------------------------------
		
		
		//--------------------------------------
		// GETTER/SETTERS
		//--------------------------------------
//		public function getSpawningPosition():Point
//		{
//			return _spawningPosition;
//		}
		
		//--------------------------------------
		// PUBLIC METHODS
		//--------------------------------------
		
		
		//--------------------------------------
		// EVENT HANDLERS
		//--------------------------------------
		
		
		//--------------------------------------
		// SERVER CALLBACKS
		//--------------------------------------
		
		
		//--------------------------------------
		// PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------								
		
	}
}