package async {
	import orichalcum.promise.IPromise;
	
	public class Deferred implements IPromise
	{
 
		private const _pending:Array = [];
		private var _processed:Boolean;
		private var _completed:Boolean;
		private var _completionAction:String;
		private var _completionValue:*;
		private var _onResolved:Function;
		private var _onRejected:Function;
 
		public function Deferred(onResolved:Function = null, onRejected:Function = null)
		{
			this._onResolved = onResolved;
			this._onRejected = onRejected || throwError;
		}
 
		public function resolve(result:*):void
		{
			process(_onResolved, result);
		}
 
		public function reject(error:*):void
		{
			process(_onRejected, error);
		}
 
		public function then(onResolved:Function = null, onRejected:Function = null):IPromise
		{
			if (onResolved || onRejected)
			{
				const deferred:Deferred = new Deferred(onResolved, onRejected);
				NextTick.call(schedule, [deferred]);
				return deferred;
			}
			return this;
		}
 
		private function throwError(error:*):void
		{
			throw error;
		}
 
		private function schedule(deferred:Deferred):void
		{
			_pending.push(deferred);
			_completed && propagate();
		}
 
		private function propagate():void
		{
			for each (var deferred:Deferred in _pending)
				deferred[_completionAction](_completionValue);
			_pending.length = 0;
		}
 
		private function complete(action:String, value:*):void
		{
			_onResolved = null;
			_onRejected = null;
			_completionAction = action;
			_completionValue = value;
			_completed = true;
			propagate();
		}
 
		private function completeResolved(result:*):void
		{
			complete('resolve', result);
		}
 
		private function completeRejected(error:*):void
		{
			complete('reject', error);
		}
 
		private function process(closure:Function, value:*):void
		{
			if (_processed) return;
			_processed = true;
			try
			{
				closure && (value = closure(value));
				value is IPromise
					? IPromise(value)
						.then(completeResolved, completeRejected)
					: completeResolved(value);
			}
			catch (error:*)
			{
				completeRejected(error);
			}
		}
	}
}

import flash.display.Sprite;
import flash.events.Event;

internal class NextTick
{
	private static const SPR:Sprite = new Sprite();

	private static const Q:Array = [];

	public static function call(closure:Function, args:Array = null):void
	{
		Q.push(new Scope(closure, args));
		Q.length == 1 && SPR.addEventListener(Event.ENTER_FRAME, run);
	}

	private static function run(e:Event):void
	{
		SPR.removeEventListener(Event.ENTER_FRAME, run);
		for each (var scope:Scope in Q.splice(0))
			scope.execute();
	}
}
 
class Scope
{
	private var _closure:Function;
 
	private var _args:Array;
 
	public function Scope(closure:Function, args:Array)
	{
		_closure = closure;
		_args = args;
	}
 
	public function execute():void
	{
		_args ? _closure.apply(null, _args) : _closure();
	}
}