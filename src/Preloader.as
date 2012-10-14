package  
{
	import org.flixel.system.FlxPreloader;
	import Main;
	
	[SWF(width="800", height="600", backgroundColor="#000000")]
	public class Preloader extends FlxPreloader 
	{
		private var main:Main;
		public function Preloader() 
		{
			className = "Main";		  
			super();
		}
		
	}

}