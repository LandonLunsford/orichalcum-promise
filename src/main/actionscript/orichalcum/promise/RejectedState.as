package orichalcum.promise 
{

	internal class RejectedState implements IPromiseState
	{
		
		public function propagate(context:Promise):void 
		{
			for each (var deferred:Promise in context._pending.slice(0))
			{
				deferred.reject(context._value);
			}
		}
		
		public function process(context:Promise, closure:Function, value:*):void 
		{
			
		}
		
	}

}