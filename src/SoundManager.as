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
		[Embed(source = 'assets/LOZ_Die.mp3')]
		private static var _linkDieClip:Class;
		
		[Embed(source = 'assets/sounds/spider_tarantula_hiss.mp3')]
		private static var _spiderHiss:Class;
		
		
		//--------------------------------------
		// GETTER/SETTERS
		//--------------------------------------
		
		
		//--------------------------------------
		// PUBLIC METHODS
		//--------------------------------------
		
		public static function playHeroDying():void
		{
			var sound:FlxSound = new FlxSound();
			sound.loadEmbedded(_linkDieClip, false, true);
			sound.play();
		}
		public static function playSpiderHissing():void
		{
			var sound:FlxSound = new FlxSound();
			sound.loadEmbedded(_spiderHiss, false, true);
			sound.play();
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