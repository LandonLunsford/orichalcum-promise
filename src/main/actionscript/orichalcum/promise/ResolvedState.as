package orichalcum.promise 
{

	internal class ResolvedState implements IPromiseState
	{
		
		public function propagate(context:Promise):void 
		{
			for each (var deferred:Promise in context._pending.slice(0))
			{
				deferred.resolve(context._value);
			}
		}
		
		public function process(context:Promise, closure:Function, value:*):void 
		{
			
		}
		
	}

}