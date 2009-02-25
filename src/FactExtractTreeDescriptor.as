package
{
	import mx.collections.ICollectionView;
	import mx.collections.XMLListCollection;
	import mx.controls.treeClasses.DefaultDataDescriptor;
	import mx.effects.easing.Elastic;

	public class FactExtractTreeDescriptor extends DefaultDataDescriptor
	{
		public function FactExtractTreeDescriptor()
		{
			super();
		}
		
		
		override public function getChildren(node:Object, model:Object=null):ICollectionView{
			if(!(node is XML))node = XML(node);
			trace(node.nodeKind());
			trace((node as XML).name());
			trace((node as XML).localName());
			var xmll:XMLList = node.children().(name()=="hash" || name()=="to"|| name()=="from" 
				|| name()=="about" || name()=="refines" || name()=="supports" || name()=="opposite"	
				|| hasOwnProperty("type"));
			var xmllc:XMLListCollection = new XMLListCollection(xmll);
			return xmllc;
			
		}
		
		override public function isBranch(node:Object, model:Object=null):Boolean{
			if(!(node is XML))node = XML(node); 
			if(node.hasSimpleContent()) return false;
			else if(node.hasOwnProperty("type") && node.name() != "hash" && node.name() != "from" && node.name() != "supports") return false;
			else return true;
		}
		
	}
}