/*
 * Derivation of https://gist.github.com/darscan/4519372
 */
package orichalcum.promise 
{
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.IEventDispatcher;

	public class Promise implements IPromise
	{
		private static const _enterFrameEventDispatcher:IEventDispatcher = new Shape;
		private static const _commands:Array = [];
		
		private static function executeNextFrame(callback:Function, args:Array = null):void
		{
			_commands[_commands.length] = new Command(callback, args);
			if (_commands.length == 1)
			{
				_enterFrameEventDispatcher.addEventListener(Event.ENTER_FRAME, _executeCommands);
			}
		}
		
		private static function _executeCommands(event:Event):void
		{
			_enterFrameEventDispatcher.removeEventListener(Event.ENTER_FRAME, _executeCommands);
			for each (var command:Command in _commands.splice(0))
			{
				command.execute();
			}
		}
		
		public function when(value:*):IPromise
		{
			if (value is IPromise)
				return value;
			
			const deferred:Promise = new Promise;
			deferred.resolve(value);
			return deferred;
		}
		
		internal var _state:IPromiseState = PromiseState.PENDING;
		internal var _pending:Array = [];
		internal var _onResolved:Function;
		internal var _onRejected:Function;
		internal var _value:*;
		
		public function Promise(onResolved:Function = null, onRejected:Function = null)
		{
			_onResolved = onResolved || returnValue;
			_onRejected = onRejected || throwError;
		}
		
		public function then(onResolved:Function = null, onRejected:Function = null):IPromise
		{
			if (onResolved != null || onRejected != null)
			{
				const deferred:Promise = new Promise(onResolved, onRejected);
				executeNextFrame(add, [deferred]);
				return deferred;
			}
			return this;
		}
		
		public function resolve(value:*):void
		{
			_state.process(this, _onResolved, value);
		}
		
		public function reject(value:*):void
		{
			_state.process(this, _onRejected, value);
		}
		
		private function add(deferred:Promise):void
		{
			_pending[_pending.length] = deferred;
			_state.propagate(this);
		}
		
		private function complete(state:IPromiseState, value:*):void
		{
			_onResolved = null;
			_onRejected = null;
			_value = value;
			_state = state;
			_state.propagate(this);
		}
		
		internal function completeResolved(value:*):void
		{
			complete(PromiseState.RESOLVED, value);
		}
		
		internal function completeRejected(value:*):void
		{
			complete(PromiseState.REJECTED, value);
		}
		
		private function returnValue(value:*):*
		{
			return value;
		}
		
		private function throwError(error:*):void
		{
			throw error;
		}
		
	}

}
