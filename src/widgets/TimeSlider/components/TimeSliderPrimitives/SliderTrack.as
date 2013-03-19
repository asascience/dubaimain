package widgets.TimeSlider.components.TimeSliderPrimitives
{
	import mx.core.UIComponent;

	public class SliderTrack extends UIComponent
	{
			override public function get height():Number{
	            return 15;
	        }

        override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void{
            super.updateDisplayList(unscaledWidth, unscaledHeight);
            
            this.graphics.beginFill(0xFFFFFF);
            this.graphics.drawRect(0,0,unscaledWidth,15);
            this.graphics.endFill();

        }

	}
}

