package utils
{
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author lizhi
	 */
	public class FileUtils 
	{
		
		public function FileUtils() 
		{
			
		}
		
		static public function getBytesFromFile(file:File, bytes:ByteArray = null):ByteArray {
			var fs:FileStream=new FileStream();
			
			try{
				bytes=bytes||new ByteArray();
				
				fs.open(file,FileMode.READ);
				fs.readBytes(bytes);
				fs.close();
				bytes.position = 0;
				
				return bytes;
			}catch (e:Error) {
				
			}finally{
				fs.close();
			}
			return null;
		}
		
		static public function getStringFromFile(file:File,charSet:String="utf-8"):String {
			var fs:FileStream=new FileStream();
			try{
				fs.open(file,FileMode.READ);
				
				return fs.readMultiByte(fs.bytesAvailable,charSet);
			}catch (e:Error) {
				
			}finally{
				fs.close();
			}
			return null;
		}
		
		static public function save(bytes:ByteArray, url:String):void {
			var file:File=new File(url);
			var fs:FileStream=new FileStream();
			try{
				fs.open(file, FileMode.WRITE);
				bytes.position = 0;
				fs.writeBytes(bytes);
			}catch(e:Error){
				
			}finally{
				fs.close();
			}
		}
		
		static public function saveString(str:String, url:String):void {
			var bytes:ByteArray = new ByteArray;
			bytes.writeUTFBytes(str);
			bytes.position = 0;
			save(bytes, url);
		}
	}
	
}