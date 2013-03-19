package widgets.HeaderController
{
	
	import mx.controls.Image;
	import mx.controls.menuClasses.MenuBarItem;
	
	public class menuItemRender extends MenuBarItem
	{
		private var image:Image;
		
		public function menuItemRender()
		{
		}
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			
			if (data)
			{
				// <item label="Three" icon="assets/accessories-text-editor.png"/>
				var icon:String = data.@icon;
				image = new Image();
				image.source = icon;
				addChild(image);
			}
		}
		
		override protected function measure():void
		{
			super.measure();
			
			if (image)
			{
				measuredWidth = image.measuredWidth-1;
				measuredHeight = Math.max(image.measuredHeight, measuredHeight);
			}
		}
		
		override protected function updateDisplayList(unscaledWidth:Number,
													  unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			if (image)
			{
				//image.x = image.measuredWidth;
				image.setActualSize(image.measuredWidth, image.measuredHeight);
				//label.x = 20;
			}
		}
	}
}