package widgets.OilSpill.components.util
{
	import flash.events.Event;
	
	public class SpillEvent extends Event
	{
		
		private var _mode:String = null;
		
		public static const SPILL_SELECT:String = "asa.spillselected";
		
		public static const RUN_MODEL:String = "asa.modelrunning";
		
		public static const MODEL_ERROR:String = "asa.modelerror";
		
		public static const MODEL_COMPLETE:String = "asa.modelcomplete";
		
		public static const PARAM_CHANGE:String = "asa.paramchanged";
		
		public static const NEW_SCENARIO_CREATED:String = "asa.newspill";
		
		public static const VALIDATION_FAILED:String = "asa.validationfailed";

		public static const TIME_CHANGE:String = "asa.timechanged";
		
		public static const CASENAME_CHANGE:String = "asa.casenamechanged";
		
		public static const VOLUME_CHANGE:String = "asa.volumechanged";
		
		public static const DURATION_CHANGE:String = "asa.durationchanged";
		
		public function SpillEvent(type:String, mode:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			this._mode = mode;
			super(type, bubbles, cancelable);
		}
		
		public function get mode():String {
			return this._mode;
		}
		
		[Inspectable(category="Other", enumeration="oil,chem,larva,si,sar", type="String")]
		public function set mode(mode:String):void {
			this._mode = mode;    
		}
	}
}