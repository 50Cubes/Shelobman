/**
 ##########################################################################################
 StatusBar
 
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
	import flash.net.FileFilter;
	import flash.sampler.NewObjectSample;
	
	import org.flixel.FlxGroup;
	import org.flixel.FlxObject;
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
	public class StatusBar extends FlxGroup
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		
		//--------------------------------------
		// PUBLIC VARIABLES
		//--------------------------------------
		[Embed(source = 'assets/woodboard.png')] private var _woodboard:Class;
		[Embed(source = 'assets/1health.png')] private var _health1:Class;
		[Embed(source = 'assets/2health.png')] private var _health2:Class;
		[Embed(source = 'assets/3health.png')] private var _health3:Class;
		[Embed(source = 'assets/4health.png')] private var _health4:Class;
		[Embed(source = 'assets/candle.png')] private var _candle:Class;
		[Embed(source = 'assets/potion.png')] private var _potion:Class;
		[Embed(source = 'assets/shoe.png')] private var _shoe:Class;
		
		private var woodboard:FlxSprite;
		private var health1:FlxSprite;
		private var health2:FlxSprite;
		private var health3:FlxSprite;
		private var health4:FlxSprite;
		private var candle:FlxSprite;
		private var potion:FlxSprite;
		private var shoe:FlxSprite;
		//--------------------------------------
		// CONSTRUCTOR
		//--------------------------------------
		public function StatusBar(X:Number=0, Y:Number=0, SimpleGraphic:Class=null)
		{
			super();
			woodboard = new FlxSprite(0, 0, _woodboard);
			add(woodboard);
			woodboard.scrollFactor = new FlxPoint(0, 0);
			
			health1 = new FlxSprite(0, 0, _health1);
			add(health1);
			health1.scrollFactor = new FlxPoint(0, 0);
			health1.visible = false;
			
			health2 = new FlxSprite(0, 0, _health2);
			add(health2);
			health2.scrollFactor = new FlxPoint(0, 0);
			health2.visible = false;
			
			health3 = new FlxSprite(0, 0, _health3);
			add(health3);
			health3.scrollFactor = new FlxPoint(0, 0);
			health3.visible = false;
			
			health4 = new FlxSprite(0, 0, _health4);
			add(health4);
			health4.scrollFactor = new FlxPoint(0, 0);
			health4.visible = false;
			
			candle = new FlxSprite(0, 0, _candle);
			add(candle);
			candle.scrollFactor = new FlxPoint(0, 0);
			candle.visible = false;
			
			potion = new FlxSprite(0, 0, _potion);
			add(potion);
			potion.scrollFactor = new FlxPoint(0, 0);
			potion.visible = false;
			
			shoe = new FlxSprite(0, 0, _shoe);
			add(shoe);
			shoe.scrollFactor = new FlxPoint(0, 0);
			shoe.visible = false;
			
		    
		}
		
		//--------------------------------------
		// PRIVATE VARIABLES
		//--------------------------------------
		public function showShoe(visible:Boolean):void
		{
			shoe.visible = visible;
		}
		public function showPotion(visible:Boolean):void
		{
			potion.visible = visible;
		}
		public function showCandle(visible:Boolean):void
		{
			candle.visible = visible;
		}
		public function updateHealth(hp:int):void
		{
			switch(hp)
			{
				case 1:
					health1.visible = true;
					health2.visible = false;
					health3.visible = false;
					health4.visible = false;
					break;
				case 2:
					health1.visible = true;
					health2.visible = true;
					health3.visible = false;
					health4.visible = false;
					break;
				case 3:
					health1.visible = true;
					health2.visible = true;				
					health3.visible = true;
					health4.visible = false;
					break;
				case 4:
					health1.visible = true;
					health2.visible = true;				
					health3.visible = true;
					health4.visible = true;
					break;
				default:
					health1.visible = false;
					health2.visible = false;
					health3.visible = false;
					health4.visible = false;
					break;
				
			}
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