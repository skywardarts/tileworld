package tileworld.core {
    import feathers.controls.Button;
    import feathers.controls.Panel;
    import feathers.controls.ScrollText;
    import feathers.controls.TextInput;
    
    import flash.display.SimpleButton;
    import flash.events.KeyboardEvent;
    import flash.events.MouseEvent;
    import flash.globalization.DateTimeFormatter;
    import flash.text.TextFormat;
    
    import starling.core.Starling;
    import starling.display.Quad;
    import starling.display.Sprite;
    import starling.events.Event;
    import starling.text.TextField;
    import starling.utils.Color;
    
    import tileworld.core.World;
    
    public class Chat {
        protected var chatHistory:ScrollText;
        protected var chatInput:TextInput;
        protected var chatInputSubmit:Button;
        public var world:World;
        public var container:Sprite;
        
        public function Chat(world:World):void {
          this.world = world;    
        }
        
        public function initialize():void {
            var self:Chat = this;
            
            this.container = new Sprite();
            
            this.world.addChild(this.container);
            
            this.world.setChildIndex(this.container, 400);
            
            //wait message from the server
            this.world.server.client.on('onChat', function(data:Object):void {
                self.addMessage(data.msg.from, data.msg.scope, data.msg.content, new Date().valueOf() / 1000);
                // kind
                // scope
                // uid
                //$("#chatHistory").show();
                //if(data.from !== username)
                //  tip('message', data.from);
            });
            
            // update user list
            this.world.server.client.on('onAdd', function(data:Object):void {
                var user:String = data.user;
                //tip('online', user);
                //addUser(user);
            });
            
            // update user list
            this.world.server.client.on('onLeave', function(data:Object):void {
                var user:String = data.user;
                //tip('offline', user);
                //removeUser(user);
            });
            
            // handle disconect message, occours when the client is disconnect with servers
            this.world.server.client.on('disconnect', function(reason:Object):void {
                //showLogin();
            });
            
            this.createChatHistory();
            this.createChatInput();
        }
        
        
        public function createChatHistory():void {
            var f1:TextFormat = new TextFormat();
            
            f1.color = 0xffffff; 
            f1.size = 20;
            f1.italic = false;
            f1.font = "Arial";
            
            this.chatHistory = new ScrollText();
            
            this.chatHistory.width = 470;
            this.chatHistory.height = 80;
            this.chatHistory.x = 53;
            this.chatHistory.y = 80;
            this.chatHistory.textFormat = f1;
            this.chatHistory.isHTML = true;
            
            var quad:Quad = new Quad(450, 90, 0x000000);
            quad.x = 53;
            quad.y = 75;
            
            this.container.addChild(quad);
            
            this.container.addChild(this.chatHistory);
        }
        
        public function createChatInput():void {
            var self:Chat = this;
            
            this.chatInput = new TextInput();
            
            this.chatInput.text = 'Type here...';
            this.chatInput.width = 365;
            this.chatInput.height = 20;
            this.chatInput.x = 53;
            this.chatInput.y = 175;
            
            this.container.addChild(this.chatInput);
            
            Starling.current.nativeStage.addEventListener(KeyboardEvent.KEY_DOWN, function(e:KeyboardEvent):void {
                if(e.charCode == 13) { // enter key
                    self.world.server.client.request("chat.chatHandler.send", {
                        content: self.chatInput.text,
                        from: "Anonymous",
                        scope: "F7A900",
                        areaId: "1",
                        toName: ""
                    }, function(data:Object):void {
                        //handle data here
                    });
                    
                    self.chatInput.text = '';
                    self.chatInput.setFocus();
                }
            });
            
            this.chatInputSubmit = new Button();
            this.chatInputSubmit.label = "Send";
            this.chatInputSubmit.x = 425;
            this.chatInputSubmit.y = 175;
            this.chatInputSubmit.width = 80;
            this.chatInputSubmit.height = 20;
            
            this.container.addChild(this.chatInputSubmit);
            
            this.chatInputSubmit.addEventListener(Event.TRIGGERED, function(e:Event):void {
                if(!self.chatInput.text)
                    return; // no input

                self.world.server.client.request("chat.chatHandler.send", {
                    content: self.chatInput.text,
                    from: "Anonymous",
                    scope: "F7A900",
                    areaId: "1",
                    toName: ""
                }, function(data:Object):void {
                    //handle data here
                });
                
                self.chatInput.text = '';
                self.chatInput.setFocus();
            });
        }
        
        public function addMessage(from:String, target:String, msg:String, timestamp:Number):void {
            var name:String;
            
            if(target == 'D41313')
              name = 'all';
            else if(target === 'F7A900')
              name = 'area';
            else if(target === '279106')
              name = 'you';
            
            var d1:Date = new Date();
            d1.setTime(timestamp);
            
            var dtf:DateTimeFormatter = new DateTimeFormatter("en-US");
            dtf.setDateTimePattern("hh:mma");
            
            this.chatHistory.text += '<font size="16"><b><font color="#006699">' + from + '</font> says to <font color="#e2e523">' + name + '</font> (</b><font color="#999999" size="-2">' + dtf.format(d1) + '</font>): <font color="#ffffff">' + msg + '</font></font><br>'
            this.chatHistory.verticalScrollPosition = this.chatHistory.maxVerticalScrollPosition;
        }
    }
}