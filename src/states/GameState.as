package states 
{
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;
	import org.flixel.FlxState;
	
	public class GameState extends FlxState 
	{
		
		private var bg_0_0:FlxSprite;
		private var bg_1_0:FlxSprite; 
		private var bg_2_0:FlxSprite; 
		
		private var player:FlxSprite;
		
		private const SCROLL_SPEED:int = 200;
		
		private const INVENTORY_HEIGHT:int = 50;
		
		override public function create():void 
		{
			bg_0_0 = new FlxSprite(0, 0);
			bg_1_0 = new FlxSprite(1439, 0);
			bg_2_0 = new FlxSprite(-1 + 1440*2, 0);
			
			bg_0_0.loadGraphic(Assets.bg_0_0, false, false, 1444, 1080);
			bg_1_0.loadGraphic(Assets.bg_1_0, false, false, 1440, 1080);
			bg_2_0.loadGraphic(Assets.bg_2_0, false, false, 1440, 1080);
			
			add(bg_0_0);
			add(bg_1_0);
			add(bg_2_0);
     
			player = new FlxSprite(400, 400);
			player.makeGraphic(16, 16, 0xff123123);
			add(player);
			
			FlxG.camera.setBounds(0, 0, 1440*3, 1080*3 + INVENTORY_HEIGHT , true);
			FlxG.camera.follow(player);
			FlxG.setDebuggerLayout(FlxG.DEBUGGER_STANDARD);
			
		}
		
		override public function update():void 
		{
			//Move screens
			// Pick up stuff (states)
			
	
			if (FlxG.keys.RIGHT) {
				player.velocity.x = SCROLL_SPEED;
			} else if (FlxG.keys.LEFT) {
				player.velocity.x = -SCROLL_SPEED;
			} else {
				player.velocity.x = 0;
			}
						
			if (FlxG.keys.DOWN) {
				player.velocity.y = SCROLL_SPEED;
			} else if (FlxG.keys.UP) {
				player.velocity.y = -SCROLL_SPEED;
			} else {
				player.velocity.y = 0;
			}
			
			
			
			
			
			super.update();
		}
		
		override public function destroy():void 
		{
			
		
			super.destroy();
			bg_0_0 = null;
			bg_1_0 = null;
			bg_2_0 = null;
			player = null;
			
		}
		
		
	
	}

}