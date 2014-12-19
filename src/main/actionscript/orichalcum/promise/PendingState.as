package orichalcum.promise 
{

	internal class PendingState implements IPromiseState
	{
		public function process(context:Promise, closure:Function, value:*):void 
		{
			context._state = PromiseState.PROCESSING;
			try
			{
				closure && (value = closure(value));
				
				value is IPromise
					? (value as IPromise)
						.then(context.completeResolved, context.completeRejected)
					: context.completeResolved(value);
			}
			catch (error:Error)
			{
				context.completeRejected(error);
			}
		}
		
		public function propagate(context:Promise):void 
		{
			
		}
		
	}

}