package com.asa.components
{
	public class ASAScenario extends Object
	{
		public var sceID:int;
		public var toc_id:int;
		public var name:String;
		public var nameAlias:String;
		public var shortDesc:String;
		public var modelTypeID:int;
		public var isStepSummary:Boolean;
		public var isDayNight:Boolean;
		public var modelType:String;
		public var basemapID:int;
		public var basemapName:String;
		//public var spillSource:int;
		//lon,lat
		//public var spillSiteTypeID:int;
		public var spillSiteString:String;
		//format:2011-10-30T12:00:00
		public var startTime:String;
		public var simLength:int;
		public var creator:Array;
		public var oilDBID:int;
		public var oilType:String;
		public var oilAmount:Number;
		public var oilAmountUnit:String;
		public var airTemp:int;
		public var waterTemp:int;
		public var releaseDuration:Number;
		public var modelStep:int;
		public var outInterval:int;
		public var SpilletNum:int;
		public var dispersion:Number;
		public var windsSource:String;
		public var currentsSource:String;
		public var manualWinds:Array;
		public var manualCurrents:Array;
		public var constWindsSp:Number;
		public var constWindsDir:int;
		public var constCurrentsSp:Number;
		public var constCurrentsDir:int;
		public var createTime:String;
		public var updateTime:String;
		public var locationID:int;
		public var location:String;
		public var hadRun:Boolean;
        public var layerCheckedArray:Array;
		public function ASAScenario()
		{
			super();
			shortDesc="";
			modelTypeID=1;
			isStepSummary=true;
			isDayNight=true;
			modelType="oilmodel";
			//startTime. 
			simLength=24;
			oilDBID=0;
			oilType="";
			oilAmount=1000;
			waterTemp=15;
			releaseDuration=0;
			modelStep=20;
			outInterval=20;
			SpilletNum=100;
			dispersion=3;
			windsSource="EDS";
			currentsSource="EDS";
			hadRun=false;
			toc_id=0;
		}
		public function CheckNecessaryField():Boolean
		{
			return false;
		}
		public function GenerateServerString():String
		{
			return "";
		}
	}
}