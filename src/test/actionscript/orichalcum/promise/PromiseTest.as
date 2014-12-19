package orichalcum.promise
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.setTimeout;
	import org.flexunit.async.Async;
	import org.hamcrest.assertThat;
	import org.hamcrest.object.equalTo;
	import orichalcum.promise.Promise;
	import orichalcum.promise.IPromise;

	public class PromiseTest 
	{
		
		[Before]
		public function before():void
		{
			
		}
		
		private function future(value:*, timeout:int = 0):IPromise
		{
			const deferred:Promise = new Promise;
			setTimeout(deferred.resolve, timeout, value);
			return deferred;
		}
		
		[Test]
		public function synchronousPromiseDoesntResolveImmediately():void
		{
			const deferred:Promise = new Promise;
			
			var value:* = 1;
			var future:* = null;
			
			deferred.then(function(value:*):*{ future = value; } )
			deferred.resolve(value);
			
			assertThat(future, equalTo(null));
		}
		
		[Test(async)]
		public function thenablesPipe():void
		{
			const dispatcher:IEventDispatcher = new EventDispatcher;
			const deferred:Promise = new Promise;
			
			Async.handleEvent(this, dispatcher, Event.COMPLETE, function(event:TestEvent, ...args):void {
				assertThat(event.data, equalTo(3));
			}, 0);
			
			deferred.then(function(value:*):*{ return value + 1; } )
				.then(function(value:*):*{ return value + 1; } )
				.then(function(value:*):*{ return value + 1; } )
				.then(function(value:*):*{ dispatcher.dispatchEvent(new TestEvent(Event.COMPLETE, value)); } )
				
			deferred.resolve(0);
		}
		
	}

}