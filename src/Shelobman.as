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
			super(Util.STAGE_WIDTH, Util.STAGE_HEIGHT, DungeonState,1, 30, 30);
		}
	}
}
