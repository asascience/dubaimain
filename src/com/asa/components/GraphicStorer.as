package com.asa.components
{
	public class GraphicStorer implements IGraphicStorer
	{
		import com.esri.ags.Graphic;
		import com.esri.ags.geometry.Geometry;
		
		import mx.controls.Alert;
		//fields
		private var _graphic:Graphic;
		private var _coordinates:String;
		//properties
		public function set  graphic(value:Object):void
		{
			_graphic=value as Graphic;
		}
		public function get graphic():Graphic
		{
			return _graphic;
		}
		public function set  Coordinates(value:Object):void
		{
			_coordinates=new String(value);
		}
		public function get Coordinates():String
		{
			return _coordinates;
		}
		//methods
		public function GraphicStorer(graphicRef:Graphic)
		{
		}
		public function GraphicToCoordinates():string
		{
			try
			{
				switch(_graphic.geometry.type)
				{
					case Geometry.MAPPOINT:
						break;
					case Geometry.MULTIPOINT:
						break;
					case Geometry.POLYLINE:
						break;
					case Geometry.EXTENT:
						break;
					case Geometry.POLYGON:
						break;
					default:
						break;
				}
			}
			catch(e:Error)
			{
				Alert.show(e.message.toString());
			}
		}
		public function CoordinatesToGraphic():Graphic
		{
		}
	}
}