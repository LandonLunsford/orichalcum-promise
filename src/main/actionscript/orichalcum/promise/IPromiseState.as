package orichalcum.promise
{

	public interface IPromiseState
	{
		
		function process(context:Promise, closure:Function, value:*):void;
		
		function propagate(context:Promise):void;
		
	}
	
}