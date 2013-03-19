package widgets.TimeSlider.components.TimeSliderPrimitives
 {
    import mx.controls.sliderClasses.SliderThumb;
    import mx.core.mx_internal;
    import mx.controls.sliderClasses.Slider;
    import flash.display.Graphics;
    
    public class SliderButton extends SliderThumb{
        use namespace mx_internal;
        
        /*
        override public function set xPosition(value:Number):void{
            $x = value;
            Slider(owner).drawTrackHighlight();
        }
        */
        override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void{
            var gr:Graphics = this.graphics;
            gr.beginFill(0xFF0000);
            gr.drawRect(0,1,2,unscaledHeight);
            gr.endFill();
        }
        
        override protected function measure():void{
            super.measure();
            measuredWidth = 2;
            measuredHeight = 15;
        }
    }
}