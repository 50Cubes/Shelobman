package
{
	import com.spiders.states.DungeonState;
	
	import org.flixel.*;

	[SWF(width="800", height="600", backgroundColor="#000000")]
	[Frame(factoryClass="Preloader")]

	public class Shelobman extends FlxGame
	{
		public function Shelobman()
		{
			//super(400, 300, MenuState, 1, 20, 20);
			super(800, 600, DungeonState);
		}
	}
}
