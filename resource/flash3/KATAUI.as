package {
	import flash.display.MovieClip;
	//import scaleform.clik.motion.Tween;	//RoundTimeTween 需要
	//import fl.transitions.easing.None;	//ease:None.easeNone 需要
	import flash.events.MouseEvent;
	
	//输入一些从valve的库中提取的素材 import some stuff from the valve lib 
	import ValveLib.Globals;
	import ValveLib.ResizeManager;
	
	public class KATAUI extends MovieClip{
		
		//引擎需要这3个变量 these three variables are required by the engine
		public var gameAPI:Object;
		public var globals:Object;
		public var elementName:String;
		
		//ui的影片剪辑
		public var UI_Summary:MovieClip; //展示板主体
		//public var RoundTimeTween:Tween; //回合时间的进度条
		
		//构造函数, 通常会用加载完函数来代替 constructor, you usually will use onLoaded() instead
		public function KATAUI() : void {
		}
		
		//这个函数被调用 this function is called when the UI is loaded
		public function onLoaded() : void {			
			//使这个UI可见 make this UI visible
			visible = true;
			
			//让平台重新调节UI let the client rescale the UI
			Globals.instance.resizeManager.AddListener(this);
			
			//UI_Summary.x=stage.stageWidth/2; //居中显示 UI_Summary.x=stage.stageWidth/2 - UI_Summary.width/2;
			
			//这一步不是必须的, 但是可以显示你的UI已经加载（需要在控制台中输入'scaleform_spew 1'） this is not needed, but it shows you your UI has loaded (needs 'scaleform_spew 1' in console)
			trace("Custom UI loaded!");
			
			//监听事件，激活展示板上数据
			gameAPI.SubscribeToGameEvent( "KATA_Summary", onShowSummary );
			//gameAPI.SubscribeToGameEvent( "KATA_RoundTime", onShowRoundTimeTween );
			
			UI_Summary.Explain.visible = false;
			
			UI_Summary.TidehunterAlive.addEventListener(MouseEvent.MOUSE_OVER, onAliveOver);
			UI_Summary.KunkkaAlive.addEventListener(MouseEvent.MOUSE_OVER, onAliveOver);
			UI_Summary.TidehunterLevel.addEventListener(MouseEvent.MOUSE_OVER, onLevelOver);
			UI_Summary.KunkkaLevel.addEventListener(MouseEvent.MOUSE_OVER, onLevelOver);
			
			UI_Summary.TidehunterAlive.addEventListener(MouseEvent.MOUSE_OUT, onExplainOut);
			UI_Summary.KunkkaAlive.addEventListener(MouseEvent.MOUSE_OUT, onExplainOut);
			UI_Summary.TidehunterLevel.addEventListener(MouseEvent.MOUSE_OUT, onExplainOut);
			UI_Summary.KunkkaLevel.addEventListener(MouseEvent.MOUSE_OUT, onExplainOut);
		}
		
		//这个负责调节大小, 将UI的尺寸设置为你的电脑屏幕的尺寸（感谢Nullscope的建议） this handles the resizes - credits to Nullscope
		public function onResize(re:ResizeManager) : * {
			var rm = Globals.instance.resizeManager;
            var currentRatio:Number =  re.ScreenWidth / re.ScreenHeight;
            var divided:Number;

            // 把这个调成你的舞台高度，如果你的设备不支持1024*768尺寸，你可以修改它 Set this to your stage height, however, if your assets are too big/small for 1024x768, you can change it
			// 你的原始阶段高度 Your original stage height
            var originalHeight:Number = 900;
                    
            if(currentRatio < 1.5)
            {
                // 4:3
                divided = currentRatio / 1.333;
            }
            else if(re.Is16by9()){
                // 16:9
                divided = currentRatio / 1.7778;
            } else {
                // 16:10
                divided = currentRatio / 1.6;
            }
                    
            var correctedRatio:Number =  re.ScreenHeight / originalHeight * divided;
            //你也许想在这里把元件的尺寸也决定了，默认情况下它们保持着同样的高和宽。 You will probably want to scale your elements by here, they keep the same width and height by default.
            //即使在重新调整大小之后，引擎也会使所有元件保持同样的XY轴坐标, 所以你也可以在这里进行调整。 The engine keeps elements at the same X and Y coordinates even after resizing, you will probably want to adjust that here.
			
			//添加
			//this.UI_Summary.screenResize(re.ScreenWidth, re.ScreenHeight, correctedRatio);
			this.UI_Summary.x = re.ScreenWidth/2;
			this.UI_Summary.y = re.ScreenHeight*0.07;
			if(this.UI_Summary["originalXScale"] == null)
			{
				this.UI_Summary["originalXScale"] = this.scaleX;
				this.UI_Summary["originalYScale"] = this.scaleY;
			}
			this.UI_Summary.scaleX = this.UI_Summary.originalXScale * correctedRatio;
			this.UI_Summary.scaleY = this.UI_Summary.originalYScale * correctedRatio;
		}
		
		
		public function onShowSummary( eventData:Object )
		{
			UI_Summary.roundNumber.text = eventData.nRoundNumber;
			UI_Summary.KunkkaAlive.text = eventData.nKunkkaAlive;
			UI_Summary.KunkkaLevel.text = eventData.nKunkkaLevel;
			UI_Summary.TidehunterAlive.text = eventData.nTidehunterAlive;
			UI_Summary.TidehunterLevel.text = eventData.nTidehunterLevel;
			
			UI_Summary.timeout_bar.progress_mask.scaleX = eventData.nRoundTimePercent;
		}
		//因为倒数不会因为游戏暂停而暂停，所以放弃这个函数
		//public function onShowRoundTimeTween( eventData:Object )
		//{
			//UI_Summary.timeout_bar.progress_mask.scaleX = 1;
			//if ( RoundTimeTween != null )
			//{
				//RoundTimeTween.paused = true;
				//RoundTimeTween = null;
			//}
			//RoundTimeTween = new Tween( eventData.nRoundTimeTween * 1000, UI_Summary.timeout_bar.progress_mask, { scaleX:0 }, { ease:None.easeNone } );
		//}
		public function onAliveOver( eventData:Object )
		{
			//trace("Custom UI onOver!");
			//globals.Loader_rad_mode_panel.gameAPI.OnShowAbilityTooltip(stage.mouseX, stage.mouseY, "venomancer_venomous_gale");
			
			UI_Summary.Explain.text = "#UI_Explain_Alive";
			UI_Summary.Explain.visible = true;
		}
		public function onLevelOver( eventData:Object )
		{
			UI_Summary.Explain.text = "#UI_Explain_Level";
			UI_Summary.Explain.visible = true;
		}
		
		public function onExplainOut( eventData:Object )
		{
			UI_Summary.Explain.visible = false;
		}
        
	}
}