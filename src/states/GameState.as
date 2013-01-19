package states 
{
	import flash.geom.Point;
	import flash.text.engine.FontPosture;
	import mx.core.FlexSprite;
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxObject;
	import org.flixel.FlxSprite;
	import org.flixel.FlxState;
	import org.flixel.FlxU;
	
	public class GameState extends FlxState 
	{

		private var largescene:FlxSprite;
		
		private const INTRO:int = -1;
		private const OUTRO:int = -1;
		private const I_JOURNAL:int = 0;
		private const I_KEYS:int = 1;
		private const I_PHONE:int = 2;
		private const I_WATCH:int = 3;
		
		private var item_1:FlxSprite = new FlxSprite(2110, 680,Assets.journal);
		private var item_2:FlxSprite = new FlxSprite(3742, 190,Assets.keys);
		private var item_3:FlxSprite = new FlxSprite(110, 930,Assets.phone);
		private var item_4:FlxSprite = new FlxSprite(3028, 3160, Assets.watch);
		
		
		// Places to drop items
		private var target_journal:FlxSprite = new FlxSprite(3908, 2724,Assets.journalhole);
		private var target_keys:FlxSprite = new FlxSprite(1862, 2772,Assets.keyhole);
		private var target_phone:FlxSprite = new FlxSprite(3168, 950,Assets.phonehole);
		private var target_watch:FlxSprite = new FlxSprite(490, 500, Assets.watchhole);
		
		private var on_world_group:FlxGroup = new FlxGroup();
		private var on_inventory_group:FlxGroup = new FlxGroup();
		
		private var inventory:FlxSprite;
		
		private var player:FlxSprite;
		
		private var mouse_sentinel:FlxObject;
		private var sticky_item:FlxSprite;
		private var sticky_item_idx:int = 0;
		
		// The dialogue/intro/outro popups
		private var popup:FlxSprite;
		
		private var state:int = 0;
		private const s_moving:int = 0; // Player moving about
		private const s_dropping:int = 1; // Dropping something
		private const s_dialogue:int = 2;
		private const s_end:int = 3;
		private const s_intro:int = 4;
		
		private var just_placed_idx:int = -1;
		
		private var inventory_positions:Array; // Where items should go when picked up 
		private var picked_up_positions:Array; // Where items were picked up/dropped
		
		private const SCROLL_SPEED:int = 800;
		
		private var INVENTORY_HEIGHT:int;
		
		override public function create():void 
		{
			
			largescene = new FlxSprite(0, 0);
			largescene.loadGraphic(Assets.largescene, false, false, 4286, 3297);
			add(largescene);
			
			inventory = new FlxSprite;
			inventory.loadGraphic(Assets.resized_inventory, false, false, 720, 120);
			
			inventory.scrollFactor.x = inventory.scrollFactor.y = 0;
			inventory.x = (FlxG.width - inventory.width) / 2;
			inventory.y = FlxG.height - inventory.height;
			INVENTORY_HEIGHT = inventory.height;
			
			
			
			add(target_journal);
			add(target_phone);
			add(target_keys);
			add(target_watch);
			
			on_world_group.add(item_1);
			on_world_group.add(item_2);
			on_world_group.add(item_3);
			on_world_group.add(item_4);
			
			add(on_world_group);
     
			player = new FlxSprite(400, 400);
			player.makeGraphic(16, 16, 0xff123123);
			player.visible = false;
			add(player);
			
			
			add(inventory);
			
			add(on_inventory_group);
			
			// Load intro graphic.
			popup = new FlxSprite( -140, 0);
			popup.loadGraphic(Assets.popup_intro);
			popup.scrollFactor.x = popup.scrollFactor.y = 0;
			popup.visible = true;
			add(popup);
			
			mouse_sentinel = new FlxObject(0, 0, 16, 16);
			mouse_sentinel.scrollFactor.x = mouse_sentinel.scrollFactor.y = 0;
			
			inventory_positions = new Array(new Point(500, FlxG.height - 70), new Point(380, FlxG.height - 70), new Point(260, FlxG.height - 70), new Point(150, FlxG.height - 50));
			picked_up_positions = new Array();
			for (var i:int = 0; i < 4; i++) {
				picked_up_positions.push(new Point(0, 0));
			}
			
			
			state = s_intro;
			Assets.init_sound();
			Assets.snd_bg.play();
			
			FlxG.camera.setBounds(0, 0, 4286, 3297, true);
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
			} else if (state == s_dialogue) {
				dialogue_state();
			} else if (state == s_intro) {
				if (FlxG.mouse.justPressed()) {
					Assets.snd_intro.play();
					popup.alpha -= 0.02;
				}
				if (popup.alpha < 1) {
					popup.alpha -= 0.02;
				}
				if (popup.alpha <= 0) {
					popup.visible = false;
					popup.alpha = 1;
					state = s_moving;
				}
			} else if (state == s_end) {
				
			}
			super.update();
		}
		
		override public function destroy():void 
		{
			
		
			super.destroy();
			player = null;
			
		}
		
		/**
		 * Loads the dialogue image and sets it to visible, switches to dialogue state.
		 * @param	type	enum for the type of image
		 * @param	is_set  is this the popup for setting an item correclty
		 */
		private function load_popup(type:int, is_set:Boolean = false):void {
			
			if (is_set) {
				Assets.snd_pickup.play();
			} else {
				Assets.snd_drop.play();
			}
			switch (type) {
				case OUTRO:
					popup.makeGraphic(200, 200, 0xffff0000);
					break;
				case I_JOURNAL:
					is_set ? popup.loadGraphic(Assets.popup_pjournal) : popup.loadGraphic(Assets.popup_fjournal);
					break;
				case I_KEYS:
					is_set ? popup.loadGraphic(Assets.popup_pkeys) : popup.loadGraphic(Assets.popup_fkeys);
					break;
				case I_PHONE:
					is_set ? popup.loadGraphic(Assets.popup_pphone) : popup.loadGraphic(Assets.popup_fphone);
					break;
				case I_WATCH:
					is_set ? popup.loadGraphic(Assets.popup_pwatch) : popup.loadGraphic(Assets.popup_fwatch);
					break;
			}
			
			popup.visible = true;
			
		}
		
		private var leave_dialogue:Boolean = false;
		private function dialogue_state():void {
			// check and reset index
			mouse_sentinel.x = FlxG.mouse.screenX - 4;
			mouse_sentinel.y = FlxG.mouse.screenY - 4;
			
			if (FlxG.mouse.justPressed()) {
				if (mouse_sentinel.overlaps(popup, true)) { 
					just_placed_idx = -1;
					leave_dialogue = true;
				}
			}
			
			if (leave_dialogue) {
				popup.alpha -= 0.03;
				if (popup.alpha <= 0) {
					leave_dialogue = false;
					popup.alpha = 1;
					popup.visible = false;
					state = s_moving;
				}
			}
		}
		private function moving_state():void 
		{
			
			if (just_placed_idx != -1) {
				state = s_dialogue;
			}
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
			
			// Check to send things to inventory, only if we don't have them, we touch them, and we haven't correclty placed them
			
		//	if (!R.inventory[0] && !R.item_placed_list[0] && player.overlaps(item_1)) {
		
		
		/*	if (!R.inventory[0] && !R.item_placed_list[0] && mouse_sentinel.overlaps(item_1)) {
				send_item_to_inventory(item_1, 0);
			}
			if (!R.inventory[1] && !R.item_placed_list[1] && player.overlaps(item_2)) {
				send_item_to_inventory(item_2, 1);
			}
			if (!R.inventory[2] && !R.item_placed_list[2] && player.overlaps(item_3)) {
				send_item_to_inventory(item_3, 2);
			}
			if (!R.inventory[3] && !R.item_placed_list[3] && player.overlaps(item_4)) {
				send_item_to_inventory(item_4, 3);
			}*/
			
			// Mouse logic
			
			if (FlxG.mouse.justPressed()) {
				mouse_sentinel.x = FlxG.mouse.screenX - 8;
				mouse_sentinel.y = FlxG.mouse.screenY - 8;
				
				// Try to pick up items from ground
				if (!R.inventory[0] && !R.item_placed_list[0] && mouse_sentinel.overlaps(item_1,true)) {
					send_item_to_inventory(item_1, 0);
					return;
				}
				if (!R.inventory[1] && !R.item_placed_list[1] && mouse_sentinel.overlaps(item_2,true)) {
					send_item_to_inventory(item_2, 1);
					return;
				}
				if (!R.inventory[2] && !R.item_placed_list[2] && mouse_sentinel.overlaps(item_3,true)) {
					send_item_to_inventory(item_3, 2);
					return;
				}
				if (!R.inventory[3] && !R.item_placed_list[3] && mouse_sentinel.overlaps(item_4,true)) {
					send_item_to_inventory(item_4, 3);
					return;
				}
				
				// Try to pick up items from inventory
				try_grab_item(item_1, 0);
				try_grab_item(item_2, 1);
				try_grab_item(item_3, 2);
				try_grab_item(item_4, 3);
			}
			
			// Check for win condition
			
			var i:int = 0;
			while (i < 4) {
				if (!R.item_placed_list[i]) {
					break;
				}
				
				if (i == 3) {
					Assets.snd_outro.play();
					popup.visible = false;
					player.velocity.x = player.velocity.y = 0;
					state = s_end;
					FlxU.openURL("http://luciditygame.com/100.html");
				}
				i++;
			}
		}
		
		/**
		 * If we have the item and it's clicked on in the inventory then stick it to the cursor
		 * @param	item
		 * @param	index
		 */
		private function try_grab_item(item:FlxSprite, index:int):void {
			if (mouse_sentinel.overlaps(item, true) && R.inventory[index]) {
				state = s_dropping;
				
				player.velocity.x = player.velocity.y = 0;
				
				R.inventory[index] = false;
				
				sticky_item = item;
				sticky_item_idx = index;
			}
		}
		
		/**
		 * Sends ITEM to the inventory, based its INDEX into the inventory position array
		 * @param	item
		 * @param	index
		 */
		private function send_item_to_inventory(item:FlxSprite,index:int):void 
		{
			// Switch draw groups
			on_world_group.remove(item, true);
			on_inventory_group.add(item);
			
			R.inventory[index] = true;
			
			picked_up_positions[index].x = item.x;
			picked_up_positions[index].y = item.y;
			
			item.x = inventory_positions[index].x;
			item.y = inventory_positions[index].y;
			item.scrollFactor.x = 0;
			item.scrollFactor.y = 0;
			
			if (!R.got_item_at_least_once[index]) {
				load_popup(index, false);
				R.got_item_at_least_once[index] = true;
				
				player.velocity.x = player.velocity.y = 0;
				state = s_dialogue;
			}
		}
		
		private function dropping_state():void {
			sticky_item.x = FlxG.mouse.screenX - 8;
			sticky_item.y = FlxG.mouse.screenY - 8;
			
			if (FlxG.mouse.justPressed()) {
				// Switch draw groups, coordinate transform..
				on_inventory_group.remove(sticky_item, true);
				on_world_group.add(sticky_item);
				
				sticky_item.scrollFactor.x = sticky_item.scrollFactor.y = 1;
				sticky_item.x = FlxG.mouse.x;
				sticky_item.y = FlxG.mouse.y;
				
				state = s_moving;
				
				// Check if item overlaps target, if so then...also set up signals
				switch (sticky_item_idx) {
					case I_JOURNAL:
						if (sticky_item.overlaps(target_journal)) {
							R.item_placed_list[I_JOURNAL] = true;
							just_placed_idx = I_JOURNAL;
							load_popup(I_JOURNAL, true);
							state = s_dialogue;
						}
						break;
					case I_WATCH:
						if (sticky_item.overlaps(target_watch)) {
							R.item_placed_list[I_WATCH] = true;
							just_placed_idx = I_WATCH;
							load_popup(I_WATCH, true);
							state = s_dialogue;
						}
						break;
					case I_PHONE:
						if (sticky_item.overlaps(target_phone)) {
							R.item_placed_list[I_PHONE] = true;
							just_placed_idx = I_PHONE;
							load_popup(I_PHONE, true);
							state = s_dialogue;
						}
						break;
					case I_KEYS:
						if (sticky_item.overlaps(target_keys)) {
							R.item_placed_list[I_KEYS] = true;
							just_placed_idx = I_KEYS;
							load_popup(I_KEYS, true);
							state = s_dialogue;
						}
						break;
				}
				
				sticky_item = null;
			}
		}
		
		
	
	}

}