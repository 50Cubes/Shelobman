/**
 ##########################################################################################
 BossSprite
 
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
package
{
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	
	
	/**
	 * [Description]
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 10.0
	 *
	 * @author 37@50cubes.com
	 * @since Sep 14, 2012
	 */
	public class BossSprite extends FlxSprite
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		public static const ANIM_IDLE_DOWN:String = "idle_down";
		public static const IDLE_DOWN_FRAMES:Array = [0,1,2,3,4,5,6,7,8,9,10,11];
		
		public static const ANIM_DEATH:String = "idle_death";
		public static const DEATH_FRAMES:Array = [12,13,14,15,16,17,18,19];
		
		public static const RANDOM_X_TILE_DESTINATION:Array = [6,8,15,15,12];
		public static const RANDOM_Y_TILE_DESTINATION:Array = [7,11,5,11,9];
		
		//--------------------------------------
		// PUBLIC VARIABLES
		//--------------------------------------
		[Embed(source = 'assets/BossSpider.png')]
		private var _bossAsset:Class;
		public var animState:String = ANIM_IDLE_DOWN;
		
		public var HP:Number = 5;
		//public var HP:Number = 1;
		public var HP_MAX:Number = 5;
		public var isInvulerableState:Boolean = false;
		public var isAlive:Boolean = true;
		public var spawnByFrames:int = 100;
		
		public var minSpawnWebs:int = 3;
		public var maxSpawnWebs:int = 5;
		
		public var isActive:Boolean = false;
		public var aggroDistance:Number = 300;
		
		//--------------------------------------
		// CONSTRUCTOR
		//--------------------------------------
		public function BossSprite(X:Number=0, Y:Number=0, SimpleGraphic:Class=null)
		{
			super(X, Y);
			
			this.loadGraphic(_bossAsset, true);
			
			this.offset.x = 16;
			this.offset.y = 16;
			this.width = 100;
			this.height = 100;
			
			this.acceleration = new FlxPoint(0, 0);
			
			this.addAnimation(ANIM_IDLE_DOWN, IDLE_DOWN_FRAMES, 5, true);
			this.addAnimation(ANIM_DEATH, DEATH_FRAMES, 5, false);
			this.play(ANIM_IDLE_DOWN);
		}
		
		//--------------------------------------
		// PRIVATE VARIABLES
		//--------------------------------------
		public function gotHit(dmg:int = 1):void
		{
			if(flickering == false)
			{
				HP -= dmg;
				
				// keep alpha at least 50%, and just lower the other 50% based on dmg
				//alpha = alpha - (alpha*.5) * HP/HP_MAX;
				if(HP <= 0 && isAlive)
				{
					this.stopFollowingPath(true);
					this.velocity.x = 0;
					this.velocity.y = 0;
					bossDies();				
				}else{
					this.flicker(3.5);
				}
			}
		}
		
		override public function draw():void{
			super.draw();
			
			//drawDebug();
		}
		
		private function bossDies():void
		{
			isAlive = false;
			this.play(ANIM_DEATH);
			// death xD
			//this.angle = 270;
		}

		//--------------------------------------
		// GETTER/SETTERS
		//--------------------------------------
		
		
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