package
{
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	public class FactExtractLoader
	{

		protected static const BASE_API_URL:String = "http://durandal.cs.berkeley.edu:9000/";

		public static function loadSnippets(keywords:String, weights:String, type:String="and",
			offset:int=undefined,limit:int=undefined,useSynonyms:Boolean=false,onComplete:Function=null):String{			
				
			var itemRequest:URLRequest = new URLRequest(BASE_API_URL + "search.xqy?" +
				"query=" + keywords +
				"&weights=" + weights +
				"&type=" + type +
				"&thsr=" + (useSynonyms?'yes':'no') +
				(offset != undefined ? "&offset="+offset : "") +
				(limit > 0 ? "&limit="+limit : ""));
				
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, function(e:Event):void{
						var data:String = (e.currentTarget as URLLoader).data as String;
						if(data != null){
							var results:XML = stripNamespaces(data);	
										
							var snippets:XMLList = results.result;
							
							if(onComplete!=null)onComplete(snippets);
						}		
					});
			loader.load(itemRequest);
			return itemRequest.url;
		}

		protected static function stripNamespaces(xmlString:String):XML{
			
			// define the regex pattern to remove the namespaces from the string
			var xmlnsPattern:RegExp = new RegExp("xmlns[^\"]*\"[^\"]*\"", "gi");
			
			// remove the namespaces from the string representation of the XML
			var namespaceRemovedXML:String = xmlString.replace(xmlnsPattern, "");
			
			// set the string rep. of the XML back to real XML
			return new XML(namespaceRemovedXML);
		}
		
		public static function setQuality(uri:String, quality:int, onComplete:Function=null):void{
			var qualityRequest:URLRequest = new URLRequest(BASE_API_URL + "quality.xqy?" +
				"uri=" + uri +
				"&qual=" + quality);
				
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, function(e:Event):void{
						if(onComplete!=null)onComplete(e);
					});
			loader.load(qualityRequest);
			return;
		}

	}
}