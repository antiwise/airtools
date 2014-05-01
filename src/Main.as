package 
{
	import flash.display.Sprite;
	import flash.filesystem.File;
	import flash.text.TextField;
	import ui.DragOpen;
	import ui.NativeAlert;
	import utils.FileUtils;
	
	/**
	 * ...
	 * @author lizhi
	 */
	public class Main extends Sprite 
	{
		
		public function Main():void 
		{
			var s:Sprite = new Sprite;
			addChild(s);
			s.graphics.beginFill(0xaaaaaa);
			s.graphics.drawRect(0, 0, 200, 200);
			var tf:TextField = new TextField;
			tf.wordWrap = true;
			tf.text = "air打包器，拖swf到此处。会生成air文件夹。运行run.bat";
			s.addChild(tf);
			new DragOpen(s, doFile);
		}
		
		private function doFile(files:Object):void 
		{
			var file:File = files[0];
			var dir:File;
			if (file.isDirectory) {
				dir = file;
			}else{
				if (file.extension!="swf") {
					dir = file.parent;
				}else {
					var swf:File = file;
				}
			}
			if (dir) {
				for each(file in dir.getDirectoryListing()) {
					if (file.extension == "swf") {
						swf = file;
						break;
					}
				}
			}
			if (swf) {
				trace(swf.name);
				var template:File = File.applicationDirectory.resolvePath("template");
				var temp:File = File.createTempDirectory();
				template.copyTo(temp, true);
				var tempswf:File = temp.resolvePath("bin");
				swf.parent.copyTo(tempswf,true);
				var tempair:File = tempswf.resolvePath("air");
				if (tempair.exists) {
					tempair.deleteDirectory(true);
				}
				
				var id:String = "airtools." + swf.name;
				
				var appxml:File = temp.resolvePath("application.xml");
				var appstr:String = FileUtils.getStringFromFile(appxml);
				appstr = appstr.replace(/{id}/g, id);
				appstr = appstr.replace(/{content}/g, swf.name);
				FileUtils.saveString(appstr, appxml.url);
				
				var appbat:File = temp.resolvePath("bat").resolvePath("SetupApplication.bat");
				appstr = FileUtils.getStringFromFile(appbat);
				appstr = appstr.replace(/{id}/g,id );
				FileUtils.saveString(appstr, appbat.url);
				
				var air:File = swf.parent.resolvePath("air");
				temp.copyTo(air, true);
				NativeAlert.alert("生成成功。运行air/run.bat");
			}else {
				trace("not");
				NativeAlert.alert("找不到swf文件");
			}
		}
		
	}
	
}