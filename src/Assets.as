package  
{
	import org.flixel.FlxSound;

	public class Assets 
	{
		[Embed(source = "../res/bgs/largescene.png")] public static const largescene:Class;
		
		[Embed(source = "../res/gui/resized_inventory.png")] public static const resized_inventory:Class;
		
		[Embed(source = "../res/items/journal.png")] public static const journal:Class;
		[Embed(source = "../res/items/journalhole.png")] public static const journalhole:Class;
		[Embed(source = "../res/items/keyhole.png")] public static const keyhole:Class;
		
		[Embed(source = "../res/items/keys.png")] public static const  keys:Class;
		[Embed(source = "../res/items/phone.png")] public static const phone:Class;
		[Embed(source = "../res/items/phonehole.png")] public static const phonehole:Class;
		[Embed(source = "../res/items/watch.png")] public static const watch:Class;
		[Embed(source = "../res/items/watchhole.png")] public static const watchhole:Class;
		
		[Embed(source = "../res/intro.png")] public static const popup_intro:Class;
		[Embed(source = "../res/journalfind.png")] public static const popup_fjournal:Class;
		[Embed(source = "../res/journalplace.png")] public static const popup_pjournal:Class;
		[Embed(source = "../res/keyfind.png")] public static const popup_fkeys:Class;
		[Embed(source = "../res/keyplace.png")] public static const popup_pkeys:Class;
		[Embed(source = "../res/phonefind.png")] public static const popup_fphone:Class;
		[Embed(source = "../res/phoneplace.png")] public static const popup_pphone:Class;
		[Embed(source = "../res/watchfind.png")] public static const popup_fwatch:Class;
		[Embed(source="../res/watchplace.png")] public static const popup_pwatch:Class;
		
		
		// mp3s
		
		[Embed(source = "../res/mp3/drop_in.mp3")] private static const embed_snd_drop:Class;
		[Embed(source = "../res/mp3/beach_outro.mp3")] private static const embed_snd_outro:Class;
		[Embed(source = "../res/mp3/beach_intro.mp3")] private static const embed_snd_intro:Class;
		[Embed(source = "../res/mp3/beach_find.mp3")]  private static const embed_snd_pickup:Class;
		[Embed(source = "../res/mp3/beachtracks.mp3")] private static const embed_snd_bg:Class;
		
		public static var snd_drop:FlxSound = new FlxSound();
		public static var snd_outro:FlxSound = new FlxSound();
		public static var snd_intro:FlxSound = new FlxSound();
		public static var snd_pickup:FlxSound = new FlxSound();
		public static var snd_bg:FlxSound = new FlxSound();
		
		public static function init_sound():void {
			snd_drop.loadEmbedded(embed_snd_drop);
			snd_outro.loadEmbedded(embed_snd_outro);
			snd_intro.loadEmbedded(embed_snd_intro);
			snd_pickup.loadEmbedded(embed_snd_pickup);
			snd_bg.loadEmbedded(embed_snd_bg, true);
		}
	}

}