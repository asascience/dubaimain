package widgets.TimeSlider.components.TimeSliderPrimitives
{
  import flash.events.Event;
  
  public class TimeSlideEvent extends Event
  {
  	
  	private var _time:String = null;
  	private var _show:Boolean;
  	private var _fire:Boolean;
  	
    public static const TIME_CHANGED:String = "asa.timechanged";
    
    public static const TIME_CHANGED_START:String = "asa.timechangedstart";
    
    public static const TIME_CHANGED_END:String = "asa.timechangedend";
    
    public static const SET_START_TIME:String = "asa.setstarttime";
    
    public static const SET_END_TIME:String = "asa.setendtime";
    
    public static const SET_TICK_DURATION:String = "asa.settickduration";
    
    public function TimeSlideEvent(type:String, time:String, show:Boolean = true, fire:Boolean = true, bubbles:Boolean=false, cancelable:Boolean=false)
    {
      this._time = time;
      this._show = show;
      this._fire = fire;
      super(type, bubbles, cancelable);
    }
    
    public function get time():String {
        return this._time;
    }
    
    public function set time(time:String):void {
        this._time = time;    
    }
    
    public function get show():Boolean {
        return this._show;
    }
    
    public function set show(show:Boolean):void {
        this._show = show;    
    }
    
    public function get fire():Boolean {
        return this._fire;
    }
    
    public function set fire(fire:Boolean):void {
        this._fire = fire;    
    }
  }
}