package orichalcum.promise.adaptor 
{
	import flash.net.URLRequest;
	import orichalcum.promise.IPromise;
	
	public interface ILoaderAdaptor 
	{
		function load(request:URLRequest, context:Object = null):IPromise;
	}
	
}