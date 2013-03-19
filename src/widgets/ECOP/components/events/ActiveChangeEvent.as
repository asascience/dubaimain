package widgets.ECOP.components.events
{
	import flash.events.Event;

	public class ActiveChangeEvent extends Event
	{
		public static const DATA_GET_DONE:String = "dataGetComplete";
		public static const RUN_SIM_DONE:String = "simRunComplete";
		public static const DATA_SAVE_DONE:String = "dataSaveComplete";
		public static const DATA_SAVE_FAIL:String = "dataSaveFailed";
		public static const INIT_COMPLETE:String = "initComplete";
		public static const SIM_INIT_SUCCESS:String = "simInitSuccess";
		public static const SIM_FAILED:String = "simFailed";
		public static const SIM_COMPLETE:String = "simComplete";
	    public static const SIM_IN_PROCESS:String = "simRunning";			
		private var id:int;
		private var dataType:String;
		private var layer:String;
		
		public function ActiveChangeEvent(type:String, newID:int=0, dataObtained:String="", bubbles:Boolean=false, cancelable:Boolean=false)
		{
			this.id=newID;
			this.dataType=dataObtained;
			super(type, bubbles, cancelable);
		}
				
		public function get recID():int {
        return this.id;
    	}
    
    	public function set recID(newRecID:int):void {
        this.id = newRecID;    
    	}
		
		public function get dataReturnedType():String {
        return this.dataType;
    	}
    
    	public function set dataReturnedType(dataGet:String):void {
        this.dataType = dataGet;    
    	}
		// Override the inherited clone() method.
        override public function clone():Event {
            return new ActiveChangeEvent(type);
        }
	}
}