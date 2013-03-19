package com.esri.viewer.skins
{
	import flash.events.FocusEvent;
	
	import spark.components.TextInput;
	import spark.components.TextArea;
	
	public class AdvTextInputSkin extends TextInput
	{
		//--------------------------------------------------------------------------
		//
		//	Constructor
		//
		//--------------------------------------------------------------------------
		
		public function AdvTextInputSkin()
		{
			super();
		}
		
		//--------------------------------------------------------------------------
		//
		//	Skin Parts
		//
		//--------------------------------------------------------------------------
		
		[SkinPart(required="true")]
		
		public var promptView:TextArea;
		
		//--------------------------------------------------------------------------
		//
		//	Skin States
		//
		//--------------------------------------------------------------------------
		
		[SkinState("focused")];
		
		//--------------------------------------------------------------------------
		//
		//	Properties
		//
		//--------------------------------------------------------------------------
		
		private var _prompt:String
		
		[Bindable()]
		
		public function get prompt():String
		{
			return _prompt;
		}
		
		public function set prompt(v:String):void
		{
			_prompt = v;
		}
		
		//--------------------------------------------------------------------------
		//
		//	Variables
		//
		//--------------------------------------------------------------------------
		
		protected var focused:Boolean;
		
		//--------------------------------------------------------------------------
		//
		//	Overridden Methods
		//
		//--------------------------------------------------------------------------
		
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName, instance);
			
			if (instance == this.textDisplay)
			{
				this.textDisplay.addEventListener(FocusEvent.FOCUS_IN, onFocusInHandler);
				this.textDisplay.addEventListener(FocusEvent.FOCUS_OUT, onFocusOutHandler);
			}
		}
		
		override protected function partRemoved(partName:String, instance:Object):void
		{
			super.partRemoved(partName, instance);
			
			if (instance == this.textDisplay)
			{
				this.textDisplay.removeEventListener(FocusEvent.FOCUS_IN, onFocusInHandler);
				this.textDisplay.removeEventListener(FocusEvent.FOCUS_OUT, onFocusOutHandler);
			}
		}
		
		override protected function getCurrentSkinState():String
		{
			if (focused)
			{
				return "focused";
			}
			else
			{
				return super.getCurrentSkinState();
			}
		}
		
		//--------------------------------------------------------------------------
		//
		//	Event Handlers
		//
		//--------------------------------------------------------------------------
		
		private function onFocusInHandler(event:FocusEvent):void
		{
			focused = true;
			invalidateSkinState();
		}
		
		private function onFocusOutHandler(event:FocusEvent):void
		{
			focused = false;
			invalidateSkinState();
		}
		
	}
}