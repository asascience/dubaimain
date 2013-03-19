package widgets.ECOP.components.events
{
	import flash.events.Event;
	
	public class RiskLevelEvent extends Event
	{
		public static const CHANGE:String = "change";
		private var _item:Object;
		private var _riskLevel:String;
		public function RiskLevelEvent(type:String, item:Object, riskLevel:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			_item = item;
			_riskLevel = riskLevel;
		}
		
		//getter function for item object
		public function get item():Object
		{
			return _item;
		}
		//getter function for riskLevel
		public function get riskLevel():String
		{
			return _riskLevel;
		}
		
	}
}