////////////////////////////////////////////////////////////////////////////////
//
// Copyright (c) 2010 ESRI
//
// All rights reserved under the copyright laws of the United States.
// You may freely redistribute and use this software, with or
// without modification, provided you include the original copyright
// and use restrictions.  See use restrictions in the file:
// <install location>/License.txt
//
////////////////////////////////////////////////////////////////////////////////
package com.esri.viewer
{

import com.esri.viewer.components.TitlebarButton;

import flash.events.Event;
import flash.events.MouseEvent;

import mx.controls.Button;
import mx.controls.Image;
import mx.core.FlexGlobals;
import mx.core.UIComponent;
import mx.events.FlexEvent;
import mx.managers.CursorManager;
import mx.managers.DragManager;

import spark.components.Group;
import spark.components.SkinnableContainer;

[Event(name="open", type="flash.events.Event")]
[Event(name="minimized", type="flash.events.Event")]
[Event(name="closed", type="flash.events.Event")]

[SkinState("open")]
[SkinState("minimized")]
[SkinState("closed")]

public class WidgetTemplate extends SkinnableContainer implements IWidgetTemplate
{
    [SkinPart(required="false")]
    public var widgetFrame:Group;

    [SkinPart(required="false")]
    public var header:Group;

    [SkinPart(required="false")]
    public var headerToolGroup:Group;

    [SkinPart(required="false")]
    public var icon:Image;

    [SkinPart(required="false")]
    public var closeButton:Image;

    [SkinPart(required="false")]
    public var minimizeButton:Image;

    [SkinPart(required="false")]
    public var resizeButton:Image = new Image;

    [Bindable]
    public var enableCloseButton:Boolean = true;

    [Bindable]
    public var enableMinimizeButton:Boolean = true;

    [Bindable]
    public var enableResizeButton:Boolean = true;

    [Bindable]
    public var enableDraging:Boolean = true;

    [Bindable]
    public var widgetWidth:Number;
	[Bindable]
	public var origWidth:Number;
	[Bindable]
	public var origHeight:Number;
	
    [Bindable]
    public var widgetHeight:Number;

    [Embed(source="assets/images/w_resizecursor.png")]
    public var resizeCursor:Class;

    [embed(source="assets/images/w_drag.png")]
    public var dragCursor:Class;

    [Bindable]
    public var enableIcon:Boolean = true;
	
	[Bindable]
	public var iconWidth:Number = 40;
	[Bindable]
	public var leftPadding:Number = -20;
	

    private static const WIDGET_OPENED:String = "open";
    private static const WIDGET_MINIMIZED:String = "minimized";
    private static const WIDGET_CLOSED:String = "closed";

    private var _widgetId:Number;
    private var _widgetState:String = WIDGET_OPENED;
    private var _cursorID:int = 0;
    private var _widgetTitle:String = "";
    private var _widgetIcon:String = "assets/images/i_widget.png";

    [Bindable]
    private var _draggable:Boolean = true;
	[Bindable]
    private var _resizable:Boolean = true;
	
    private var _baseWidget:IBaseWidget;
	
	//added this to allow a "docked" widget, which doesn't get bumped left on mouse up
	//Changes the bounce back when widget is dragged out of window
	public var _rightDockGap:Number = new Number(5);

    public function set baseWidget(value:IBaseWidget):void
    {
        _baseWidget = value;
        this.resizable = value.isResizeable;
        this.draggable = value.isDraggable;
        this.widgetId = value.widgetId;
        this.widgetTitle = value.widgetTitle;
        this.widgetIcon = value.widgetIcon;
    }

    public function get baseWidget():IBaseWidget
    {
        return _baseWidget;
    }

    public function set resizable(value:Boolean):void
    {
        if (enableResizeButton)
        {
            _resizable = value;
            resizeButton.visible = _resizable;
        }
    }

    [Bindable]
    public function get resizable():Boolean
    {
        return _resizable;
    }

    public function set draggable(value:Boolean):void
    {
        if (enableDraging)
        {
            _draggable = value;
        }
        else
        {
            _draggable = false;
        }
    }
	public function set rightDockGap(value:Number):void 
	{
		_rightDockGap = value;
	}

    public function get widgetId():Number
    {
        return _widgetId;
    }

    public function set widgetId(value:Number):void
    {
        _widgetId = value;
    }

    [Bindable]
    public function get widgetTitle():String
    {
        return _widgetTitle;
    }

    public function set widgetTitle(value:String):void
    {
        _widgetTitle = value;
    }

    [Bindable]
    public function get widgetIcon():String
    {
        return _widgetIcon;
    }

    public function set widgetIcon(value:String):void
    {
       _widgetIcon = value;
    }

    public function set widgetState(value:String):void
    {
        _widgetState = value;
        invalidateSkinState();

        dispatchEvent(new Event(value));
    }

    public function get widgetState():String
    {
        return _widgetState;
    }

    private var _selectedTitlebarButtonIndex:int = -1;
    private var _selectedTitlebarButtonIndexChanged:Boolean = false;

    public function get selectedTitlebarButtonIndex():int
    {
        return _selectedTitlebarButtonIndex;
    }

    public function set selectedTitlebarButtonIndex(value:int):void
    {
        if (_selectedTitlebarButtonIndex != value)
        {
            _selectedTitlebarButtonIndex = value;
            _selectedTitlebarButtonIndexChanged = true;
            invalidateProperties();
        }
    }

    public function WidgetTemplate()
    {
        super();

        this.width = 300;
        this.height = 300;
        this.addEventListener(FlexEvent.CREATION_COMPLETE, creationCompleteHandler);
    }

    private function creationCompleteHandler(event:Event):void
    {
        widgetWidth = width;
        widgetHeight = height;
		origWidth = widgetWidth;
		origHeight = widgetHeight;
		
        this.closeButton.toolTip = resourceManager.getString("ViewerStrings", "close");
        this.minimizeButton.toolTip = resourceManager.getString("ViewerStrings", "minimize");
    }

    protected override function partAdded(partName:String, instance:Object):void
    {
        super.partAdded(partName, instance);
        if (instance == icon)
        {
            icon.addEventListener(MouseEvent.CLICK, icon_clickHandler);
        }
        if (instance == widgetFrame)
        {
            widgetFrame.addEventListener(MouseEvent.MOUSE_DOWN, mouse_downHandler);
            widgetFrame.addEventListener(MouseEvent.MOUSE_UP, mouse_upHandler);

            widgetFrame.stage.addEventListener(MouseEvent.MOUSE_UP, mouse_upHandler);
            widgetFrame.stage.addEventListener(Event.MOUSE_LEAVE, stageout_Handler);
        }
        if (instance == header)
        {
            header.addEventListener(MouseEvent.MOUSE_DOWN, mouse_downHandler);
            header.addEventListener(MouseEvent.MOUSE_UP, mouse_upHandler);
        }
        if (instance == closeButton)
        {
            closeButton.addEventListener(MouseEvent.CLICK, close_clickHandler);
        }
        if (instance == minimizeButton)
        {
            minimizeButton.addEventListener(MouseEvent.CLICK, minimize_clickHandler);
        }
        if (instance == resizeButton)
        {
            resizeButton.addEventListener(MouseEvent.MOUSE_OVER, resize_overHandler);
            resizeButton.addEventListener(MouseEvent.MOUSE_OUT, resize_outHandler);
            resizeButton.addEventListener(MouseEvent.MOUSE_DOWN, resize_downHandler);
        }
        if (instance == contentGroup)
        {
            //addWidgetChildren();  
        }
    }

    override protected function getCurrentSkinState():String
    {
        return _widgetState;
    }

    override protected function commitProperties():void
    {
        super.commitProperties();
		
		if(widgetState == "open")
		{
			widgetWidth = origWidth;
		}
		var selectionColor:uint = 0xCC0000;
		var selectionColor2:uint = 0xCC0000;
		
        if (_selectedTitlebarButtonIndexChanged)
        {
            _selectedTitlebarButtonIndexChanged = false;
            for (var i:int = 0, n:int = headerToolGroup.numElements; i < n; i++)
            {
				//toggle of seleceted buttons in widget header group
				var btn:Button = Button(headerToolGroup.getElementAt(i));
				btn.buttonMode = true;
				btn.useHandCursor = true;
				if (i == _selectedTitlebarButtonIndex)
                {
                    //btn.selected = true;
					//btn.drawRoundRect(0,0,btn.width,btn.height,3,selectionColor,1);
					btn.setStyle("textDecoration",'underline');
					btn.setStyle("color",'0xfffff9');
					//btn.setStyle("fontWeight",'bold');
                }
                else
                {
                    //btn.selected = false;
					//btn.drawRoundRect(0,0,btn.width,btn.height,3,selectionColor2,1);
					btn.setStyle("textDecoration",'none');
					btn.setStyle("color",'0x58595b');
					//btn.setStyle("fontWeight",'normal');
                }
            }
        }
    }

    public function mouse_downHandler(event:MouseEvent):void
    {
        if (_draggable && enableDraging)
        {
            header.addEventListener(MouseEvent.MOUSE_MOVE, mouse_moveHandler);
            widgetFrame.addEventListener(MouseEvent.MOUSE_MOVE, mouse_moveHandler);
        }
    }

    private var widgetMoveStarted:Boolean = false;

    private function mouse_moveHandler(event:MouseEvent):void
    {
        if (!widgetMoveStarted)
        {
            widgetMoveStarted = true;

            //TODO: not for V2.0
            //ViewerContainer.dispatchEvent(new AppEvent(AppEvent.CHANGE_LAYOUT, LAYOUT_BASIC));

            this.alpha = 0.7;
            var widget:UIComponent = parent as UIComponent;

            if (!DragManager.isDragging)
            {
                widget.startDrag();
            }

            if (_resizable)
            {
                ViewerContainer.dispatchEvent(new AppEvent(AppEvent.WIDGET_FOCUS, widgetId));
            }
        }
    }

    private function mouse_upHandler(event:MouseEvent):void
    {
        header.removeEventListener(MouseEvent.MOUSE_MOVE, mouse_moveHandler);
        widgetFrame.removeEventListener(MouseEvent.MOUSE_MOVE, mouse_moveHandler);

        this.alpha = 1;
        var widget:UIComponent = parent as UIComponent;

        widget.stopDrag();

        var appHeight:Number = FlexGlobals.topLevelApplication.height;
		var appWidth:Number = FlexGlobals.topLevelApplication.width;
		
		//Sets the bounce back when the wid
        if (widget.y < 0)
        {
            widget.y = 0;
        }
        if (widget.y > (appHeight - 40))
        {
            widget.y = appHeight - 40;
        }
        if (widget.x < 0)
        {
			//FlexGlobals.topLevelApplication.sideBar.addChild(widgetFrame);
			//widget.x = 20;
        }
        if (widget.x > appWidth-20)
        {
			widget.x = appWidth - 40;
        }

        // clear constraints since x and y have been set
        widget.left = widget.right = widget.top = widget.bottom = undefined;
		
        widgetMoveStarted = false;

        //CursorManager.removeCursor(CursorManager.currentCursorID);
    }

    private function stageout_Handler(event:Event):void
    {
        if (widgetMoveStarted)
        {
            mouse_upHandler(null);
        }
    }

    private function notifyStateChanged(widgetState:String):void
    {
		var data:Object =
            {
                id: _widgetId,
                state: widgetState
            };
        ViewerContainer.dispatchEvent(new AppEvent(AppEvent.WIDGET_STATE_CHANGED, data));
    }

    protected function icon_clickHandler(event:MouseEvent):void
    {
        widgetState = WIDGET_OPENED;
		
        this.widgetFrame.toolTip = "";
        this.icon.toolTip = "";
		this.width = origWidth;
		this.height = origHeight;
		widgetWidth = origWidth;
        notifyStateChanged(BaseWidget.WIDGET_OPENED);
    }

    protected function close_clickHandler(event:MouseEvent):void
    {
        widgetState = WIDGET_CLOSED;

        notifyStateChanged(BaseWidget.WIDGET_CLOSED);
    }

    protected function minimize_clickHandler(event:MouseEvent):void
    {
        widgetState = WIDGET_MINIMIZED;
        //dispatchEvent(new Event(WIDGET_MINIMIZED));
		//default size of icon minimize window ******
		widgetWidth = 160;
		this.width = 160;
		//widgetHeight = height;
		this.height = 30;
		
        this.widgetFrame.toolTip = this.widgetTitle;
        this.icon.toolTip = this.widgetTitle;

        notifyStateChanged(BaseWidget.WIDGET_MINIMIZED);
    }

    private function resize_overHandler(event:MouseEvent):void
    {
        _cursorID = CursorManager.setCursor(resizeCursor, 2, -10, -10);
    }

    private function resize_outHandler(event:MouseEvent):void
    {
        CursorManager.removeCursor(_cursorID);
    }

    private function resize_downHandler(event:MouseEvent):void
    {
        var bwidget:BaseWidget = this.parent as BaseWidget;

        if (_resizable && this.enableResizeButton)
        {
            /*TODO: for now, it can't be resized when is not basic layout*/
            stage.addEventListener(MouseEvent.MOUSE_MOVE, resize_moveHandler);
            stage.addEventListener(MouseEvent.MOUSE_UP, resize_upHandler);
        }
    }

    private function resize_moveHandler(event:MouseEvent):void
    {
        // if there is minWidth and minHeight specified on the container, use them while resizing
        const minimumResizeWidth:Number = minWidth ? minWidth : 200;
        const minimumResizeHeight:Number = minHeight ? minHeight : 100;

        if ((stage.mouseX < stage.width - 20) && (stage.mouseY < stage.height - 20))
        {
            if ((stage.mouseX - parent.x) > minimumResizeWidth)
            {
                width = (stage.mouseX - parent.x);
            }
            if ((stage.mouseY - parent.y) > minimumResizeHeight)
            {
                height = (stage.mouseY - parent.y);
            }
        }
    }

    private function resize_upHandler(event:MouseEvent):void
    {
        widgetWidth = width;
        widgetHeight = height;
        stage.removeEventListener(MouseEvent.MOUSE_MOVE, resize_moveHandler);
        stage.removeEventListener(MouseEvent.MOUSE_UP, resize_upHandler);

        var p:UIComponent = parent as UIComponent;
        p.stopDrag();
    }

    public function addTitlebarButton(btnIcon:String, btnTip:String, btnFunction:Function, selectable:Boolean = true,buttonText:Boolean = false,buttonString:String= "",butWidth:Number = 0):void
    {
        if(buttonText == true)
		{
			var btnText:Button = new Button();
			var selectionColor:uint = 0xCC0000;
			btnText.setStyle('skin',null);
			//btnText.alpha = 0;
			
			btnText.addEventListener(MouseEvent.CLICK,clickButton);
			btnText.enabled = selectable;
			btnText.label = buttonString;
			btnText.useHandCursor = true;
			btnText.toolTip = btnTip;
			btnText.width = butWidth;
			btnText.setStyle("cornerRadius",0);
			btnText.setStyle("fontSize",12);
			btnText.setStyle("backgroundColor","0xFF0000");
			//btnText.skin. = "com.esri.viewer.skins.ButtonSkinHeader";
			
			/*if(buttonString == "Scenario")
			{
				btnText.selected = true;
				btnText.drawRoundRect(0,0,btnText.width,btnText.height,3,selectionColor,1);
			}*/
			if (selectable)
			{
				btnText.addEventListener(MouseEvent.CLICK, titlebarButton_clickHandler);
				if (headerToolGroup.numElements == 0)
				{
					selectedTitlebarButtonIndex = 0; // automatically select the first button added
				}
			}
			function clickButton(event:MouseEvent):void
			{
				btnFunction();
			}
			
			/*var bg:Rect = new Rect();
			bg.fill = new SolidColor(0xFF0000);
			bg.left = 0;
			bg.right = 0;
			bg.top = 0;
			bg.bottom = 0;
			widgetFrame.addElement(bg);*/
			
			headerToolGroup.addElement(btnText);
		}
		else
		{
			var btn:TitlebarButton = new TitlebarButton();
			btn.callback = btnFunction;
			btn.selectable = selectable;
			btn.source = btnIcon;
			btn.toolTip = btnTip;
			if (selectable)
			{
				btn.addEventListener(MouseEvent.CLICK, titlebarButton_clickHandler);
				if (headerToolGroup.numElements == 0)
				{
					selectedTitlebarButtonIndex = 0; // automatically select the first button added
				}
			}
			headerToolGroup.addElement(btn);
		}
	}

    private function titlebarButton_clickHandler(event:MouseEvent):void
    {
        selectedTitlebarButtonIndex = headerToolGroup.getElementIndex(Button(event.currentTarget));
    }
}
}
