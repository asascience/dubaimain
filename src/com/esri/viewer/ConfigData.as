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
	import mx.collections.ArrayCollection;

/**
 * ConfigData class is used to store configuration information from the config.xml file.
 */
public class ConfigData
{
    public var viewerUI:Array;
    public var controls:Array;
    public var mapAttrs:Array;
    public var basemaps:Array;
	public var lods:Array;
    public var opLayers:Array;
    public var widgetContainers:Array;
    public var widgets:Array;
	public var welcome:Array;
    public var widgetIndex:Array;
    public var styleAlpha:Number;
    public var styleColors:Array;
	public var minButtonSource:String;
	public var closeButtonSource:String;
	public var managementservices:Array;
	public var serverURL:String;
	
	public var font:Object;
	public var titleFont:Object;
	public var geometryService:Object;
	public var webMapLayers:ArrayCollection;

    public var bingKey:String;
    public var proxyUrl:String;
	
	public var tocInfo:Array;
	public var layerLabels:Object;

    public function ConfigData()
    {
        viewerUI = [];
        controls = [];
        mapAttrs = [];
        basemaps = [];
		lods = [];
        opLayers = [];
        widgets = [];
		welcome = [];
        widgetContainers = []; //[i]={container, widgets]
        widgetIndex = []; //[i]={container, inx}
        styleAlpha = 0.8;
        styleColors = [];
		minButtonSource = "";
		closeButtonSource = "";
		tocInfo = [];
		layerLabels = new Object();
		tocInfo = [];
		managementservices=[];
		serverURL="";
    }
}

}
