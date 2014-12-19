package orichalcum.promise.adaptor 
{
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import orichalcum.promise.IPromise;
	import orichalcum.promise.Promise;
	
	public class LoaderAdaptor implements ILoaderAdaptor
	{
		
		public function load(request:URLRequest, context:Object = null):IPromise
		{
			const deferred:Promise = new Promise;
			const loader:Loader = new Loader;
			const loaderInfo:LoaderInfo = loader.contentLoaderInfo;
			
			const loader_error:Function = function(event:ErrorEvent):void
			{
				const target:Object = event.target;
				target.removeEventListener(IOErrorEvent.IO_ERROR, loader_error);
				target.removeEventListener(ProgressEvent.PROGRESS, loader_progress);
				target.removeEventListener(Event.COMPLETE, loader_complete);
				deferred.reject(new Error(event.text, event.errorID));
			};
			
			const loader_progress:Function = function(event:ProgressEvent):void
			{
				/*
					Future promise implementation will have progress callback
				 */
			}
			
			const loader_complete:Function = function(event:Event):void
			{
				const target:Object = event.target;
				target.removeEventListener(IOErrorEvent.IO_ERROR, loader_error);
				target.removeEventListener(ProgressEvent.PROGRESS, loader_progress);
				target.removeEventListener(Event.COMPLETE, loader_complete);
				deferred.resolve(target.loader.content);
			}
			
			loaderInfo.addEventListener(IOErrorEvent.IO_ERROR, loader_error);
			loaderInfo.addEventListener(ProgressEvent.PROGRESS, loader_progress);
			loaderInfo.addEventListener(Event.COMPLETE, loader_complete);
			loader.load(request, context as LoaderContext);
			
			return deferred;
		}
		
	}

}