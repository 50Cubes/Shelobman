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
		
		
		//--------------------------------------
		// PUBLIC VARIABLES
		//--------------------------------------
		[Embed(source = 'assets/spidersheet.png')]
		private var _heroAsset:Class;
		
		private var _spawningPosition:Point;
		
		//--------------------------------------
		// CONSTRUCTOR
		//--------------------------------------
		public function SpiderSprite(X:Number=0, Y:Number=0, SimpleGraphic:Class=null)
		{
			super(X, Y);
			_spawningPosition = new Point(X, Y);
			
			this.loadGraphic(_heroAsset, true);
			
			this.offset.x = 16;
			this.offset.y = 48;
			this.width = 32;
			this.height = 16;
			this.centerOffsets();
			
			this.acceleration = new FlxPoint(0, 0);
		}
		
		//--------------------------------------
		// PRIVATE VARIABLES
		//--------------------------------------
		
		
		//--------------------------------------
		// GETTER/SETTERS
		//--------------------------------------
		public function getSpawningPosition():Point
		{
			return _spawningPosition;
		}
		
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