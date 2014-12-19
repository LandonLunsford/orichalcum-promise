package orichalcum.promise 
{

	public interface IPromise 
	{
		
		function then(onSuccess:Function = null, onFailure:Function = null):IPromise;
		
	}

}