package states 
{
	
	/**
	 * Registry class (global context)
	 */
	public class R 
	{
		
		/**
		 * Whether we have this item or not.
		 */
		public static var inventory:Array = new Array(false, false, false, false);
		
		/**
		 * Whether this item has been correctly placed.
		 */
		public static var item_placed_list:Array = new Array(false, false, false, false);
		
		public static var got_item_at_least_once:Array = new Array(false, false, false, false);
		
	}

}