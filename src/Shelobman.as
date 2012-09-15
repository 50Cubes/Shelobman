package
{
	import com.spiders.states.*;
	
	import flash.display.Loader;
	import flash.events.Event;
	import flash.net.URLRequest;
	
	import org.flixel.*;

	[SWF(width="800", height="600", backgroundColor="#808080")]
	[Frame(factoryClass="Preloader")]
	
	

	public class Shelobman extends FlxGame
	{
		
		public function Shelobman()
		{
			//super(Util.STAGE_WIDTH, Util.STAGE_HEIGHT, DungeonState, 1, 30, 30);
			//super(Util.STAGE_WIDTH, Util.STAGE_HEIGHT, TitleState, 1, 30, 30);
			super(Util.STAGE_WIDTH, Util.STAGE_HEIGHT, BrandState, 1, 30, 30);
		}
	}
}
