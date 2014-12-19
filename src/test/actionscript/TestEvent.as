package  
{
	import flash.events.Event;
	
	public class TestEvent extends Event 
	{
		
		private var _data:*;
		
		public function TestEvent(type:String, data:*) 
		{ 
			super(type);
			_data = data;
		} 
		
		public function get data():* 
		{
			return _data;
		}
		
		public override function clone():Event 
		{ 
			return new TestEvent(type, _data);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("TestEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}