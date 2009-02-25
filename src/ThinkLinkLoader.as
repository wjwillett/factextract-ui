package
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	
	import mx.controls.Alert;
	
	public class ThinkLinkLoader
	{
		protected static const API_URL:String = "http://durandal.cs.berkeley.edu/tl/";
		
		
		/**
		 * Searches for nodes using keywords from the query string and loads them from 
		 * the datastore 
		 * @param nodeId
		 * @param onComplete
		 * 
		 */	
		public static function searchNodes(query:String,onComplete:Function=null):void{			
			runQuery(API_URL + "node/search.xml?query=" + query, function(e:Event):void{
					var data:String = (e.currentTarget as URLLoader).data as String;
					if(data != null){
						var results:XML = XML(data);
						var snippets:XMLList = results.to.colitem.colitem;
						if(onComplete!=null)onComplete(snippets);
					}		
				});
		}
		
		/**
		 * Pulls a specific node and its children from the datastore 
		 * @param nodeId
		 * @param onComplete
		 * 
		 */		
		public static function loadNode(nodeId:int, onComplete:Function=null):void{
			runQuery(API_URL + "node/" + nodeId + ".xml", function(e:Event):void{
						var data:String = (e.currentTarget as URLLoader).data as String;
						if(data != null){
							data = data.replace(new RegExp("</*to>","/gi"),"");
							var results:XML = XML(data);
							for each(var x:XML in results..support){
								x.setName("node");
							}					
							var snippets:XMLList = XMLList(results);
							if(onComplete!=null)onComplete(snippets);
					}		
				});
		}
		
		/**
		 * Pull a list of weighted keywords for a given node 
		 * @param id
		 * @param onComplete
		 * 
		 */		
		public static function loadKeywords(id:int,onComplete:Function=null):void{			
			runQuery(API_URL + "node/"+ id + "/keywords.xml", function(e:Event):void{
						var data:String = (e.currentTarget as URLLoader).data as String;
						if(data != null){
							try{
								var results:XML = XML(data);
								var keywords:XMLList = results.children();
								if(onComplete!=null)onComplete(keywords);
							}
							catch(err:Error){
								if(onComplete!=null)onComplete(null);
							}
						}		
					});
		}

	
		public static function login(username:String, password:String):void{
			var postRequest:URLRequest = new URLRequest(API_URL + "api/login");
			var urlVariables:URLVariables = new URLVariables();
			urlVariables.email = username;
			urlVariables.password = password;
			postRequest.data = urlVariables;
			postRequest.method = URLRequestMethod.POST;
			var loader:URLLoader = new URLLoader();
			
			var loginHandler:Function = function(e:Object):void{
					Alert.show(e.text ? e.text : (e.type ? e.type : ""),"");
				};
			
			loader.addEventListener(Event.COMPLETE, loginHandler);
			loader.addEventListener(IOErrorEvent.IO_ERROR, loginHandler);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, loginHandler);
			loader.load(postRequest); 
		}
	
		public static function postSnippet(text:String,url:String,title:String, onComplete:Function=null):void{
			var type:String = "snippet";
			var info:String = "{text:'" + escape(text) + "',url:'" + url + "',realurl:'" + url + "',title:'" + escape(title) + "'}";
			runPostQuery(type,info, 
				function(e:Event):void{
					onComplete(e);
				}, function(e:Event):void{
					trace(e.type);				
				});
		}
		
		public static function postLink(subjectId:String,objectId:String,verb:String, onComplete:Function=null):void{
			var type:String = "node";
			var info:String = "{subject:'" + subjectId + "',object:'" + objectId + "',verb:'" + verb + "'}";
			runPostQuery(type,info, 
				function(e:Event):void{
					onComplete(e);
				},function(e:Event):void{
					trace(e.type);				
				});
			
		}

		/**
		 * Helper method used to execute other load and search queries 
		 * @param q
		 * @param handler
		 * 
		 */		
		public static function runQuery(q:String, handler:Function):void{
			var itemRequest:URLRequest = new URLRequest(q);
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, handler);
			loader.load(itemRequest);
		}
		
		public static function runPostQuery(type:String,info:String, handler:Function, errHandler:Function):void{
			var postRequest:URLRequest = new URLRequest(API_URL + "node/");
			var urlVariables:URLVariables = new URLVariables();
			urlVariables.type = type;
			urlVariables.info = info;
			postRequest.data = urlVariables;
			postRequest.method = URLRequestMethod.POST;
			var loader:URLLoader = new URLLoader();
			
			loader.addEventListener(Event.COMPLETE, handler);
			loader.addEventListener(IOErrorEvent.IO_ERROR, errHandler);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, errHandler);
			loader.load(postRequest); 
		}

	}
}