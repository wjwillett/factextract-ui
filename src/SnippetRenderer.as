package
{
	import flare.util.Colors;
	
	import flash.text.TextLineMetrics;
	
	import mx.controls.Text;
	import mx.controls.listClasses.IListItemRenderer;
	import mx.core.UIComponent;
	import mx.events.FlexEvent;

	public class SnippetRenderer extends UIComponent implements IListItemRenderer
	{
		private var snippetText:Text;
		
		public function SnippetRenderer()
		{
			super();
		}
		
		private var _data:Object;
	    
	    // Make the data property bindable.
	    [Bindable("dataChange")]
	    
	    // Define the getter method.
	    public function get data():Object {
	        return _data;
	    }
		
		public function set data(value:Object):void {
	        _data = value;
	    
	    	invalidateProperties();
	        dispatchEvent(new FlexEvent(FlexEvent.DATA_CHANGE));
	    }

		override protected function createChildren() : void
		{
			super.createChildren();
			snippetText = new Text();
			addChild(snippetText);
		}
		
		override protected function commitProperties():void
		{
			super.commitProperties();
	        
	        if(data){
					if(data.p){
						snippetText.htmlText = cleanupText(data.p.toString() as String);
					}
					
					if(data.uri){
						var links:Array = (/\w+\..*(?=.xhtml)/).exec(data.uri.toString());
						if(links && links.length > 0){
							snippetText.htmlText += ("<br/><p align='right'>from <font color='#709CC5'><u><a href='http://" 
								+ links[0] + "' target='_blank'>" + links[0] + "</a></u></font> " 
								+ (data.quality==0?"":((data.quality>0?"+":"") + data.quality)) + "</p>"); 			
						}
						else{
							throw new Error("Unable to extract URI to generate link");
						}
					}
					
					measure();
					this.graphics.lineStyle(1,Colors.gray(200));
					this.graphics.moveTo(0,0);
					this.graphics.lineTo(explicitWidth,0);
					
					//this.toolTip = snippetText.htmlText;
				}
		}
		
		override protected function updateDisplayList( unscaledWidth:Number, unscaledHeight:Number ) : void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			snippetText.move(0,0);
			snippetText.setActualSize(unscaledWidth,unscaledHeight);
		}
		
		 override protected function measure():void {
            super.measure();
   			measuredHeight = getMeasuredHeight();
        }
		
		protected function getMeasuredHeight():Number{
			var lineBreaks:Array = snippetText.htmlText.match( /\r|\n|<br|<p/gi);
   			var measure:TextLineMetrics = measureHTMLText(snippetText.htmlText);
   			
   			return measure.height * ((measure.width / explicitWidth) + lineBreaks.length) - 5;
		}
		
		protected function cleanupText(t:String):String{
			return t.replace(new RegExp("\n|\r|<br/>","gi")," ");
		}
		
	}
}