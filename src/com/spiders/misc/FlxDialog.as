package com.spiders.misc{
	import org.flixel.*;
	
	/**
	 * ...
	 * @author Adam Bielinski
	 */
	/**
	 * This is the default flixel dialog screen.
	 * It is used to show dialogs and pause the game
	 */
	public class FlxDialog extends FlxGroup{
		
		public var messages:Array;
		
		public var background:FlxSprite;
		public var msg_txt:FlxText;
		public var _done:Boolean;
		
		private var current_message:String;
		public var _scrolling_timer:Number;
		
		public static var _lps:Number = 45; // letters per second
		public static var _skip_delay:Number = 0.25; // time the user has to wait before pressing skip
		
		public function FlxDialog() {
			super();
			//scrollFactor.x = 0;
			//scrollFactor.y = 0;
			_scrolling_timer = 0;
			current_message = new String();
			var margin:uint = 16;
			_done = true;
			
			var w:uint = FlxG.width - margin * 2;
			var h:uint = FlxG.height / 4;
			//x = margin;
			//y = (FlxG.height - h) - margin;
			
			background = new FlxSprite();
			background.makeGraphic(w, h, 0xaa000000);
			background.x = margin;
			background.y = (FlxG.height - h) - margin;
			background.scrollFactor = new FlxPoint;
			
			msg_txt = new FlxText(0, 0, w, "");
			msg_txt.alignment = "left";
			msg_txt.x = margin;
			msg_txt.y = (FlxG.height - h) - margin;
			msg_txt.scrollFactor = new FlxPoint;
			
			// removed , true from the add statements
			add(background);
			add(msg_txt);   
		}
		
		public function undialog():Boolean {
			return (messages.length <= 0 && _done);
		}
		
		public function set message(Message:Array):void {
			this.visible = true;
			messages = Message.slice(); // copy the array!
			
			///
			for(var i:int=0 ; i<messages.length ; i++){
				messages[i] = (messages[i] as String) + "\n\n(Press X or Space to continue)"; 
			}
			///
			
			_done = true;
			_scrolling_timer = 0;
		}
		override public function update():void {
			if (messages == null) {
				messages = [""];
			}
			
			if (_done && messages.length > 0) {
				current_message = messages.shift();
				_done = false;
				_scrolling_timer = 0;
			}
			
			if (FlxG.keys.justPressed("X") || FlxG.keys.justPressed("DOWN")  || FlxG.keys.justPressed("CONTROL") || FlxG.keys.justPressed("SPACE")  ){
				//advance the dialogs
				if ((_scrolling_timer-_skip_delay) * _lps < current_message.length) {
					_scrolling_timer = current_message.length / _lps +1;
				}else if (messages.length <= 0) {
					_done = true;
					this.visible = false;
				}else{
					current_message = messages.shift();
					_scrolling_timer = 0;
				}
			}
			fill_text();
			super.update();
		}
		
		private function fill_text():void {
			_scrolling_timer += FlxG.elapsed;
			msg_txt.text = current_message.slice(0, _scrolling_timer * _lps);
		}
		
	}
	
}