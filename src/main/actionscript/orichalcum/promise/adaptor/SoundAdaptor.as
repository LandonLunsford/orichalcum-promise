package orichalcum.promise.adaptor 
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.media.Sound;
	import flash.media.SoundLoaderContext;
	import flash.net.URLRequest;
	import orichalcum.promise.IPromise;
	import orichalcum.promise.Promise;
	
	public class SoundAdaptor implements ILoaderAdaptor
	{
		
		public function load(request:URLRequest, context:Object = null):IPromise
		{
			const deferred:Promise = new Promise;
			const loader:Sound = new Sound;
			
			const loader_error:Function = function(event:IOErrorEvent):void
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
				deferred.resolve(target);
			}
			
			loader.addEventListener(IOErrorEvent.IO_ERROR, loader_error);
			loader.addEventListener(ProgressEvent.PROGRESS, loader_progress);
			loader.addEventListener(Event.COMPLETE, loader_complete);
			loader.load(request, context as SoundLoaderContext);
			
			return deferred;
		}
		
	}

}