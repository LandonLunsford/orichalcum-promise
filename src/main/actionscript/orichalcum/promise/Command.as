package orichalcum.promise 
{

	internal class Command
	{
		private var _callback:Function;
		private var _arguments:Array;
	 
		public function Command(callback:Function, args:Array)
		{
			_callback = callback;
			_arguments = args;
		}
	 
		public function execute():void
		{
			_arguments
				? _callback.apply(null, _arguments)
				: _callback();
		}
	}

}