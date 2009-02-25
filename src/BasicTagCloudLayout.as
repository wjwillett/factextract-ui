package
{
	import data.render.TextRenderer;
	
	import flare.util.Property;
	import flare.util.Sort;
	import flare.vis.data.Data;
	import flare.vis.data.NodeSprite;
	import flare.vis.data.ScaleBinding;
	import flare.vis.operator.layout.Layout;
	
	import flash.geom.Rectangle;

	public class BasicTagCloudLayout extends Layout
	{
		
		protected var _group:String;
		protected var _sField:Property;
		protected var _sBinding:ScaleBinding;
		protected var _sort:Sort = null;
		
		public var group:String = Data.NODES;
		public var padding:Number = 6;


		public function BasicTagCloudLayout(sizeField:String=null, group:String=Data.NODES):void
		{
			super();
		}
		
		/** @inheritDoc */
		public override function setup():void
		{
			if (visualization==null) return;
			//_sBinding.data = visualization.data;
		}
		
		override protected function layout():void
		{
			visualization.data.nodes.setProperty("renderer", TextRenderer.instance,_t);
			var list:Array = []; visualization.data.group(group).visit(list.push);
			visualization.data.group(group).sortBy("data.keyword");
			
			var curX:Number = padding;
			var curY:Number = padding;
			var lineHeight:Number = 0;
			var visBounds:Rectangle = visualization.getBounds(visualization);
			
			var visitor:Function = function(n:NodeSprite):void{
					var nodeBounds:Rectangle = n.getBounds(visualization);
					lineHeight = Math.max(lineHeight,nodeBounds.height);
					//word-wrap if necessary
					if(curX + nodeBounds.width + padding > visBounds.width){
						curY += (lineHeight + padding);
						curX = padding;
						lineHeight = 0;
					}
					//place node
					update(n,curX,curY,n.data["adjustedWeight"],n.alpha);
					curX += (nodeBounds.width + padding);
				};
				
			visualization.data.nodes.visit(visitor);
		}
		
		/** Set the final position, size, and visibility */
		private function update(n:NodeSprite, x:Number, y:Number, scale:Number, alpha:Number):void
		{
			var o:Object = _t.$(n);
			o.x = x;
			o.y = y;
			o.alpha = alpha;
		}
		
	}
}