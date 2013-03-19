package widgets.TimeSlider.components.TimeSliderPrimitives
 {
    import flash.events.Event;
    import flash.utils.Timer;
    
    public class BindableTimer extends Timer
    {
       
       public function BindableTimer(delay:Number, repeatCount:int=0)
       {
          super(delay, repeatCount);
       }
       
       [Bindable(event="timerChange")]
       override public function get running():Boolean
       {
          return super.running;
       }
 
       override public function stop():void
       {
          super.stop();
          dispatchEvent(new Event("timerChange"));
       }
       
       override public function start():void
       {
          super.start();
          dispatchEvent(new Event("timerChange"));
       } 
    }
 }