package widgets.TimeSlider.components
{
	import com.esri.viewer.AppEvent;
	
	public class AsaAppEvent extends AppEvent
	{
		//ASA TIME SLIDER
		public static const TIME_SLIDER_TIME_CHANGED:String = 'timeSliderTimeChanged';
		
		//ASA START DATE PICKER
		public static const START_DATE_CHANGED:String = 'startTimeChanged';
		
		//ASA END DATE PICKER
		public static const END_DATE_CHANGED:String = 'endTimeChanged';
		
		//ASA OIL NAME CHANGE
		public static const OIL_MODEL_NAME_CHANGE:String = 'oilNameChange';
		
		//ASA OIL PARTS VISIBILITY CHANGE
		public static const OIL_MODEL_VIS_CHANGE:String = 'oilVisChange';
		
		//ASA WINDS NAME CHANGE
		public static const WINDS_NAME_CHANGE:String = 'windsNameChange';
		
		//ASA CURRENTS NAME CHANGE
		public static const CURRENTS_NAME_CHANGE:String = 'currentsNameChange';
		
		//ASA LOAD COMPLETE
		public static const MODEL_LOAD_COMPLETE:String = 'modelLoadComplete';
		
		public static const SODA_WATER_REFRESH:String = 'sodaWaterRefresh';
		
		public function AsaAppEvent(type:String, data:Object=null, callback:Function=null)
		{
			super(type, data, callback);
			_data = data;
			_callback = callback;
		}
		
		private var _data:Object;
		
		private var _callback:Function;
	}
}