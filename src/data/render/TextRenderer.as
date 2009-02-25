package data.render
{
	import flare.display.TextSprite;
	import flare.vis.data.DataSprite;
	import flare.vis.data.render.IRenderer;
	
	import flash.display.Graphics;

	/**
	 * Renderer that draws text.
	 * @see flare.vis.palette.ShapePalette
	 */
	public class TextRenderer implements IRenderer
	{
		private static var _instance:TextRenderer = new TextRenderer("keyword");
		/** Static TextRenderer instance. */
		public static function get instance():TextRenderer { return _instance; }
		
		/** The default size value for drawn text. This value is multiplied
		 *  by a DataSprite's size property to determine the final size. */
		public var defaultSize:Number;
		
		public var defaultFont:String;
		
		public var textField:String;
		
		/**
		 * Creates a new TextRenderer 
		 * @param defaultSize the default size (radius) for shapes
		 */
		public function TextRenderer(textField:String,defaultSize:Number=12) {
			this.textField = textField;
			this.defaultSize = defaultSize;
		}
		
		/** @inheritDoc */
		public function render(d:DataSprite):void
		{
			
			var size:Number = d.size * defaultSize;
			
			var textColor:uint = d.fillColor;
			
			var t:TextSprite;
			if(!d.props.textSprite){
				t = new TextSprite(d.data[textField]);
				d.props["textSprite"] = t;
				d.addChild(t);
			}
			else t = d.props.textSprite;
			t.color = d.lineColor;
			t.textMode = TextSprite.DEVICE;
			t.size = size;
			
			//Draw the Background
			var g:Graphics = d.graphics;
			g.clear();
			if (d.fillAlpha > 0) g.beginFill(d.fillColor, 0.1);// d.fillAlpha); //FIXME: FillAlpha doesn't seem to be returning the value set w/ setDefaults
			g.drawRect(t.x, t.y, t.width, t.height);
			if (d.fillAlpha > 0) g.endFill();
		}
		
	} // end of class TextRenderer
}