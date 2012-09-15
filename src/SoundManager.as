/**
 ##########################################################################################
 SoundManager
 
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
	import org.flixel.FlxSound;
	
	/**
	 * [Description]
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 10.0
	 *
	 * @author 37@50cubes.com
	 * @since Sep 14, 2012
	 */
	public class SoundManager
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		
		//--------------------------------------
		// PUBLIC VARIABLES
		//--------------------------------------
		
		
		//--------------------------------------
		// CONSTRUCTOR
		//--------------------------------------
		public function SoundManager()
		{
		}
		
		//--------------------------------------
		// PRIVATE VARIABLES
		//--------------------------------------
		[Embed(source = 'assets/sounds/LOZ_Die.mp3')]
		private static var _linkDieClip:Class;
		
		[Embed(source = 'assets/sounds/spider_tarantula_walk_on_leaves.mp3')]
		private static var _spiderHiss:Class;
		
		[Embed(source = 'assets/sounds/LOZ_Die.mp3')]
		private static var _fire:Class;

		[Embed(source = 'assets/sounds/LOZ_Die.mp3')]
		private static var _jumping:Class;

		[Embed(source = 'assets/sounds/LOZ_Die.mp3')]
		private static var _itemPickup:Class;
		
		[Embed(source = 'assets/sounds/LOZ_Die.mp3')]
		private static var _jumpingEffect:Class;
		
		[Embed(source = 'assets/sounds/LOZ_Die.mp3')]
		private static var _musicBackgroundClip:Class;
		
		[Embed(source = 'assets/sounds/LOZ_Die.mp3')]
		private static var _musicBossClip:Class;
		
		// effects
		
		private static var _effectHeroDyingEffect:FlxSound;
		private static var _effectSpiderHissing:FlxSound;
		
		
		// boss
		
		private static var _musicBackground:FlxSound;
		private static var _musicBoss:FlxSound;
		
		
		
		//--------------------------------------
		// GETTER/SETTERS
		//--------------------------------------
		
		
		//--------------------------------------
		// PUBLIC METHODS
		//--------------------------------------

		public static function playBossMusic():void
		{
			if(_musicBackground == null)
			{
				_musicBackground = new FlxSound();
				_musicBackground.loadEmbedded(_linkDieClip, true, true);
			}
			
			_musicBackground.play();
		}
		public static function playBackgroundMusic():void
		{
			if(_musicBackground)
			{
				_musicBackground.stop();
				_musicBackground.kill();
			}
			if(_musicBoss == null)
			{
				_musicBoss = new FlxSound();
				_musicBoss.loadEmbedded(_linkDieClip, true, true);
			}
			_musicBoss.play();
		}
		
		public static function playHeroDying():void
		{
			if(_effectHeroDyingEffect == null)
			{
				_effectHeroDyingEffect = new FlxSound();
				_effectHeroDyingEffect.loadEmbedded(_linkDieClip, false, true);
			}
			_effectHeroDyingEffect.play();
		}
		public static function playSpiderHissing():void
		{
			if(_effectSpiderHissing == null)
			{
				_effectSpiderHissing = new FlxSound();
				_effectSpiderHissing.loadEmbedded(_spiderHiss, false, true);
			}
			_effectSpiderHissing.play();
			
		}

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