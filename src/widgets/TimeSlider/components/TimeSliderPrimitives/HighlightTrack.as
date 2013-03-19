package widgets.TimeSlider.components.TimeSliderPrimitives
 {
   import mx.core.UIComponent;
    import flash.display.Graphics;
    public class HighlightTrack extends UIComponent{
        
        /**
         * Line 1926 on Slider puts the highlight 
         * 1 px below the Slider's track
         * */
        override public function get height():Number{
            return 15;
        }
        override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void{
            this.graphics.clear();
            super.updateDisplayList(unscaledWidth, unscaledHeight);
            var gr:Graphics = this.graphics;
            gr.beginFill(0x656b6e); //(0x252525);  //gr.beginFill(0x000099);
            gr.drawRect(0,-1, unscaledWidth,unscaledHeight);   //gr.drawRect(0,-1, unscaledWidth, 15);
            gr.endFill();
        }
    
    }
}
