package orichalcum.promise 
{

	public class PromiseState
	{
		
		public static const PENDING:IPromiseState = new PendingState;
		public static const PROCESSING:IPromiseState = new ProcessingState;
		public static const RESOLVED:IPromiseState = new ResolvedState;
		public static const REJECTED:IPromiseState = new RejectedState;
		
	}

}