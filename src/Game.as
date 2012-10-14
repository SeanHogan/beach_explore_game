package  
{
	import org.flixel.FlxGame;
	import states.GameState;
	
	/**
	 * ...
	 * @author Sean Hogan
	 */
	public class Game extends FlxGame 
	{
		
		public function Game() 
		{
			super(800, 600, GameState, 1);
			
		}
		
	}

}