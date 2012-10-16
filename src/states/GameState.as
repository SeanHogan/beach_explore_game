package states 
{
	import flash.geom.Point;
	import mx.core.FlexSprite;
	import org.flixel.FlxG;
	import org.flixel.FlxObject;
	import org.flixel.FlxSprite;
	import org.flixel.FlxState;
	
	public class GameState extends FlxState 
	{

		private var largescene:FlxSprite;
		
	
		private var item_1:FlxSprite = new FlxSprite(100, 100);
		private var item_2:FlxSprite = new FlxSprite(200, 200);
		private var item_3:FlxSprite = new FlxSprite(300, 300);
		private var item_4:FlxSprite = new FlxSprite(400, 400);
		
		// Places to drop items
		private var target_1:FlxSprite = new FlxSprite(100, 200);
		private var target_2:FlxSprite = new FlxSprite(200, 300);
		private var target_3:FlxSprite = new FlxSprite(300, 400);
		private var target_4:FlxSprite = new FlxSprite(400, 500);
		
		private var inventory:FlxSprite;
		
		private var player:FlxSprite;
		
		private var mouse_sentinel:FlxObject;
		private var sticky_item:FlxSprite;
		private var sticky_item_idx:int = 0;
		
		private var state:int = 0;
		private const s_moving:int = 0; // Player moving about
		private const s_dropping:int = 1; // Dropping something
		
		private var inventory_positions:Array; // Where items should go when picked up 
		private var picked_up_positions:Array; // Where items were picked up/dropped
		
		private const SCROLL_SPEED:int = 300;
		
		private const INVENTORY_HEIGHT:int = 100;
		
		override public function create():void 
		{
			
			largescene = new FlxSprite(0, 0);
			largescene.loadGraphic(Assets.largescene, false, false, 4286, 3297);
			add(largescene);
			
			inventory = new FlxSprite(0, FlxG.height - INVENTORY_HEIGHT);
			inventory.makeGraphic(FlxG.width, INVENTORY_HEIGHT);
			inventory.scrollFactor.x = inventory.scrollFactor.y = 0;
			add(inventory);
			
			item_1.makeGraphic(50, 50, 0xff000000);
			item_2.makeGraphic(50, 50, 0xff000000);
			item_3.makeGraphic(50, 50, 0xff000000);
			item_4.makeGraphic(50, 50, 0xff000000);
			
			target_1.makeGraphic(50, 50, 0xffffffff);
			target_2.makeGraphic(50, 50, 0xffffffff);
			target_3.makeGraphic(50, 50, 0xffffffff);
			target_4.makeGraphic(50, 50, 0xffffffff);
			
			add(item_1);
			add(item_2);
			add(item_3);
			add(item_4);
			
			add(target_1);
			add(target_2);
			add(target_3);
			add(target_4);
     
			player = new FlxSprite(400, 400);
			player.makeGraphic(16, 16, 0xff123123);
			add(player);
			
			mouse_sentinel = new FlxObject(0, 0, 16, 16);
			mouse_sentinel.scrollFactor.x = mouse_sentinel.scrollFactor.y = 0;
			
			inventory_positions = new Array(new Point(10, FlxG.height - 50), new Point(70, FlxG.height - 50), new Point(130, FlxG.height - 50), new Point(190, FlxG.height - 50));
			picked_up_positions = new Array();
			for (var i:int = 0; i < 4; i++) {
				picked_up_positions.push(new Point(0, 0));
			}
			
			
			
			
			FlxG.camera.setBounds(0, 0, 4286, 3297 + INVENTORY_HEIGHT , true);
			FlxG.camera.follow(player);
			FlxG.setDebuggerLayout(FlxG.DEBUGGER_STANDARD);
			FlxG.mouse.show();
			
		}
		
		override public function update():void 
		{
			//Move screens
			// Pick up stuff (states)
			
			if (state == s_dropping) {
				dropping_state();
			} else if (state == s_moving) {
				moving_state();
			}
			super.update();
		}
		
		override public function destroy():void 
		{
			
		
			super.destroy();
			player = null;
			
		}
		
		private function moving_state():void 
		{
			// Move player
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
			
			// Stop player at borders
			if (player.x < 0) {
				player.velocity.x = 0;
				player.x = 0;
			} else if (player.x + player.width > largescene.width) {
				player.velocity.x = 0;
				player.x = largescene.width - player.width; 
			}
			
			if (player.y < 0) {
				player.velocity.y = 0;
				player.y = 0;
			} else if (player.y > largescene.height - player.height) {
				player.y = largescene.height - player.height;
				player.velocity.y = 0;
			}
			
			// Check to send things to inventory 
			
			if (!R.inventory[0] && player.overlaps(item_1)) {
				send_item_to_inventory(item_1, 0);
			}
			if (!R.inventory[1] && player.overlaps(item_2)) {
				send_item_to_inventory(item_2, 1);
			}
			if (!R.inventory[2] && player.overlaps(item_3)) {
				send_item_to_inventory(item_3, 2);
			}
			if (!R.inventory[3] && player.overlaps(item_4)) {
				send_item_to_inventory(item_4, 3);
			}
			
			// Mouse logic
			
			if (FlxG.mouse.justPressed()) {
				mouse_sentinel.x = FlxG.mouse.screenX - 8;
				mouse_sentinel.y = FlxG.mouse.screenY - 8;
				
				if (mouse_sentinel.overlaps(item_1, true) && R.inventory[0]) {
					state = s_dropping;
					sticky_item = item_1;
					R.inventory[0] = false;
					sticky_item_idx = 0;
				}
			}
		}
		
		/**
		 * Sends ITEM to the inventory, based its INDEX into the inventory position array
		 * @param	item
		 * @param	index
		 */
		private function send_item_to_inventory(item:FlxSprite,index:int):void 
		{
			R.inventory[index] = true;
			picked_up_positions[index].x = item.x;
			picked_up_positions[index].y = item.y;
			item.x = inventory_positions[index].x;
			item.y = inventory_positions[index].y;
			item.scrollFactor.x = 0;
			item.scrollFactor.y = 0;
		}
		
		private function dropping_state():void {
			sticky_item.x = FlxG.mouse.screenX - 8;
			sticky_item.y = FlxG.mouse.screenY - 8;
			
			if (FlxG.mouse.justPressed()) {
				sticky_item.scrollFactor.x = sticky_item.scrollFactor.y = 1;
				sticky_item.x = FlxG.mouse.x;
				sticky_item.y = FlxG.mouse.y;
				sticky_item = null;
				state = s_moving;
				
			}
		}
		
		
	
	}

}