package {
	import flash.display.MovieClip;
	//import scaleform.clik.motion.Tween;	//RoundTimeTween 需要
	//import fl.transitions.easing.None;	//ease:None.easeNone 需要
	import flash.events.MouseEvent;
	
	import flash.geom.Point;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	
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
		
		public var buttons:Vector.<MovieClip>; //商店的按钮s
		public var ShopCost:Array; //商店价格
		public var ShopItemName:Array; //物品名称
		public var timerGetGold:Timer = new Timer(1000, 0); //检测玩家金钱的变化的时间
		
		//构造函数, 通常会用加载完函数来代替 constructor, you usually will use onLoaded() instead
		public function KATAUI() : void {
			//商店按钮1-10
			var _loc_1:MovieClip   =  null;
			this.buttons   = new Vector.<MovieClip>;
			this.buttons.push(this.UI_Shop.shopitem1);
			this.buttons.push(this.UI_Shop.shopitem2);
			this.buttons.push(this.UI_Shop.shopitem3);
			this.buttons.push(this.UI_Shop.shopitem4);
			this.buttons.push(this.UI_Shop.shopitem5);
			this.buttons.push(this.UI_Shop.shopitem6);
			this.buttons.push(this.UI_Shop.shopitem7);
			this.buttons.push(this.UI_Shop.shopitem8);
			this.buttons.push(this.UI_Shop.shopitem9);
			this.buttons.push(this.UI_Shop.shopitem10);
			for each (_loc_1  in this.buttons)
			{
				_loc_1.gotoAndStop(1);
				_loc_1.buttonMode  = true;
				_loc_1.addEventListener(MouseEvent.ROLL_OVER,	this.onRollOver);
				_loc_1.addEventListener(MouseEvent.ROLL_OUT,	this.onRollOut);
				_loc_1.addEventListener(MouseEvent.MOUSE_DOWN,	this.onMouseDown);
				_loc_1.addEventListener(MouseEvent.MOUSE_UP,	this.onMouseUp);
			}
			
			this.ShopCost  = new  Array(); //商店价格
		}
		
		//这个函数被调用 this function is called when the UI is loaded
		public function onLoaded() : void {			
			//使这个UI可见 make this UI visible
			visible = true;
			
			//让平台重新调节UI let the client rescale the UI
			Globals.instance.resizeManager.AddListener(this);
			
			//UI_Summary.x=stage.stageWidth/2; //居中显示 UI_Summary.x=stage.stageWidth/2 - UI_Summary.width/2;
			
			//这一步不是必须的, 但是可以显示你的UI已经加载（需要在控制台中输入'scaleform_spew 1'） this is not needed, but it shows you your UI has loaded (needs 'scaleform_spew 1' in console)
			trace("KATA Custom UI loaded!");
			
			//监听事件，激活展示板上数据
			gameAPI.SubscribeToGameEvent( "KATA_Summary", onShowSummary );
			//gameAPI.SubscribeToGameEvent( "KATA_RoundTime", onShowRoundTimeTween );
			gameAPI.SubscribeToGameEvent( "KATA_Shop", onShowShop );
			
			//隐藏说明文
			UI_Summary.Explain.visible = false;
			//监听鼠标悬浮
			UI_Summary.TidehunterAlive.addEventListener(MouseEvent.MOUSE_OVER,	onAliveOver);
			UI_Summary.KunkkaAlive.addEventListener(MouseEvent.MOUSE_OVER,		onAliveOver);
			UI_Summary.TidehunterLevel.addEventListener(MouseEvent.MOUSE_OVER,	onLevelOver);
			UI_Summary.KunkkaLevel.addEventListener(MouseEvent.MOUSE_OVER,		onLevelOver);
			//监听鼠标离开
			UI_Summary.TidehunterAlive.addEventListener(MouseEvent.MOUSE_OUT,	onExplainOut);
			UI_Summary.KunkkaAlive.addEventListener(MouseEvent.MOUSE_OUT,		onExplainOut);
			UI_Summary.TidehunterLevel.addEventListener(MouseEvent.MOUSE_OUT,	onExplainOut);
			UI_Summary.KunkkaLevel.addEventListener(MouseEvent.MOUSE_OUT,		onExplainOut);
			
			timerGetGold.addEventListener(TimerEvent.TIMER_COMPLETE, this.GoldChanged);
			timerGetGold.start();
			
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
			//globals.Loader_rad_mode_panel.gameAPI.OnShowAbilityTooltip(stage.mouseX, stage.mouseY, "venomancer_venomous_gale");	//显示技能说明文
			
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
		
		//====商店函数
		
		public function onShowShop( eventData:Object )
		{
			var _iii:int = 1;
			var _nShopCost_temp:Array = eventData.nShopCost.split(",");
			var _mc:MovieClip = null;
			trace("onShowShop");
			trace("_nShopCost_temp" + _nShopCost_temp.length);
			
			//读取 商店价格
			while ( _iii <= _nShopCost_temp.length )
			{
				this.ShopCost[_iii] = Number(_nShopCost_temp[_iii]);
				_iii++;
			}
			trace("onShowShop" + this.ShopCost[6]);
			_iii = 1;
			for each  ( _mc in this.buttons)
			{
				_mc.goldtext.text = this.ShopCost[_iii];	//价格
				Globals.instance.LoadImage("images/ui/shopitem"+ _iii +".png",_mc.shopicon,false);	//图标
				_iii++;
			}
			//this.setIcons();
		}
		
		//public function setIcons()
		//{
			//var _loc_1:int = 1;
			//var _loc_2:MovieClip = null;
			//for each  (_loc_2  in this.buttons)
			//{
				//Globals.instance.LoadImage("images/ui/shopitem"+ _loc_1 +".png",_loc_2.shopicon,false);
				//_loc_1++;
			//}
		//}
		
		public function onRollOver(event:MouseEvent)
		{
			var _loc_2:* =  event.currentTarget  as MovieClip;
			var _cost:int = _loc_2.goldtext.text
			if (!event.buttonDown)
			{
				_loc_2.gotoAndStop(2);
				_loc_2.goldtext.text = _cost;
				//globals.Loader_rad_mode_panel.gameAPI.OnShowAbilityTooltip(stage.mouseX, stage.mouseY, "venomancer_venomous_gale");	//显示技能说明文
				//globals.Loader_rad_mode_panel.gameAPI.OnShowAbilityTooltip(stage.mouseX, stage.mouseY, "item_npc_gnoll_assassin");	//显示技能说明文
				//globals.Loader_gameend.gameAPI.ShowItemTooltip(stage.mouseX, stage.mouseY, "item_npc_gnoll_assassin");	//显示物品说明文
			}
			return;
		}

		public function onRollOut(event:MouseEvent)
		{
			var _loc_2:* =  event.currentTarget  as MovieClip;
			var _cost:int = _loc_2.goldtext.text
			 
			_loc_2.gotoAndStop(1);
			_loc_2.goldtext.text = _cost;
			return;
		}
		public function onMouseDown(event:MouseEvent)
		{
			//var _loc_3:MouseEventEx  = null;
			var _loc_2:* =  event.currentTarget  as MovieClip;
			var _cost:int = _loc_2.goldtext.text
			 
			trace("" + (this.buttons.indexOf(_loc_2) +1)); //this.buttons.indexOf(_loc_2) +1,当前按钮的序号
			this.gameAPI.SendServerCommand("kata_shop_buy " + (this.buttons.indexOf(_loc_2) +1) );
			 
			_loc_2.gotoAndStop(3);
			_loc_2.goldtext.text = _cost;
			this.globals.GameInterface.PlaySound("General.ButtonClick");
			return;
		}
		public  function onMouseUp(event:MouseEvent)
		{
			var _loc_2:* =  event.currentTarget  as MovieClip;
			var _cost:int = _loc_2.goldtext.text
			 
			_loc_2.gotoAndStop(2);
			_loc_2.goldtext.text = _cost;
			this.globals.GameInterface.PlaySound("General.ButtonClickRelease");
			return;
		}
		
		public function GoldChanged( e:TimerEvent )
		{
			// UI拥有者
			var pID = this.globals.Players.GetLocalPlayer();
			//trace("" + pID); //从0开始
			
			if( pID != null ) var pGold = this.globals.Players.GetGold(pID);
			trace("pGold =" + pGold);
			//trace( String(pGold) );
			
			var _iii:int = 1;
			var _cost:int = null;
			var _mc:MovieClip = null;
			for each  (_mc  in this.buttons)
			{
				_cost = _mc.goldtext.text
				
				if( _cost <= pGold ) {
					Globals.instance.LoadImage("images/ui/frame_gold.png",_mc.frame,false);
				}
				else{
					Globals.instance.LoadImage("images/ui/frame_default.png",_mc.frame,false);
				}
				_iii++;
			}
			
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
			
			//数据面板
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
			//商店
			this.UI_Shop.x = re.ScreenWidth/2;
			this.UI_Shop.y = re.ScreenHeight*0.76;
			if(this.UI_Shop["originalXScale"] == null)
			{
				this.UI_Shop["originalXScale"] = this.scaleX;
				this.UI_Shop["originalYScale"] = this.scaleY;
			}
			this.UI_Shop.scaleX = this.UI_Shop.originalXScale * correctedRatio;
			this.UI_Shop.scaleY = this.UI_Shop.originalYScale * correctedRatio;
		}
        
	}
}