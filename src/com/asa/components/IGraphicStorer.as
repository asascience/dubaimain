package com.asa.components
{
	import com.esri.ags.Graphic;

	public interface IGraphicStorer
	{
		function set graphic(value:Object):void;
		function get graphic():Graphic;
		function GenerateXML():XML;
	}
}