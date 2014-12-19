package 
{
	import flash.display.Sprite;
	import flash.utils.setTimeout;
	import org.flexunit.internals.TraceListener;
	import org.flexunit.runner.FlexUnitCore;
	import orichalcum.promise.PromiseTest;

	public class TestRunner extends Sprite
	{
		public function TestRunner()
		{
			const core:FlexUnitCore = new FlexUnitCore;
			core.addListener(new TraceListener);
			core.run(TestSuite);
		}
		
	}

}
