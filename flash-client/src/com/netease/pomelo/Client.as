﻿package com.netease.pomelo{  import com.netease.pomelo.EventManager;  import com.netease.pomelo.Protocol;  import com.netease.pomelo.events.ClientEvent;  import com.pnwrain.flashsocket.FlashSocket;  import com.pnwrain.flashsocket.events.FlashSocketEvent;  import flash.net.Socket;  import flash.events.Event;  import flash.events.EventDispatcher;  import flash.events.IOErrorEvent;  import flash.events.SecurityErrorEvent;  import flash.system.Security;  public class Client extends EventDispatcher  {    [ClientEvent(ClientEvent.ERROR)]    [ClientEvent(ClientEvent.CONNECTED)]    [ClientEvent(ClientEvent.DISCONNECTED)]    //[ClientEvent(type=ClientEvent.CONNECTING)]    //[ClientEvent(type=ClientEvent.TIMEOUT)]    protected var eventManager:EventManager;    protected var socket:FlashSocket;    protected var requestId:int;    protected var host:String;    protected var port:int;    protected var policyUrl:String;    public function Client():void {      this.requestId = 1;      this.eventManager = new EventManager();    }    // Initialize the connection.    public function init(host:String, port:int, policyUrl:String = null, action:Function = null):void {      var self:Client = this;      this.disconnect();      this.host = host;      this.port = port;      this.policyUrl = policyUrl || ("xmlsocket://" + host + ":843");      this.socket = new FlashSocket(this.host + ':' + this.port, null, null, 0, null, this.policyUrl);      this.socket.addEventListener(FlashSocketEvent.CONNECT, function(e:Event):void {        var event:ClientEvent = new ClientEvent(ClientEvent.CONNECTED);        self.dispatchEvent(event);        action();      });      this.socket.addEventListener(FlashSocketEvent.MESSAGE, this.socketInputHandler);      this.socket.addEventListener(FlashSocketEvent.IO_ERROR, this.socketErrorHandler);      this.socket.addEventListener(FlashSocketEvent.SECURITY_ERROR, this.socketSecurityErrorHandler);      //this.socket.addEventListener("my other event", myCustomMessageHandler);    }    // Free the resources.    public function disconnect():void {      if(this.socket != null) {        this.socket.close();        this.socket = null;      }    }    protected function myCustomMessageHandler(event:FlashSocketEvent):void {      //trace('we got a custom event!')        }    // Request message from server and register callback.    public function request(route:String, message:Object, action:Function):void {      var returnMessage:Object = this.sanitize(message);      this.requestId++;      this.eventManager.addCallback(requestId, action);            this.sendMessage(requestId, route, returnMessage);    }        // Notify message to server.    public function notify(route:String, msg:Object):void {      this.sendMessage(0, route, msg);    }        // Add event listener and wait for broadcast message.    public function on(eventName:String, action:Function):void {      this.eventManager.addEventHandler(eventName, action);    }    // Add msg time.    protected function sanitize(message:Object):Object {      var now:Date = new Date();      message.timestamp = now.valueOf();      return message;    }        protected function sendMessage(requestId:int, route:String, message:Object):void {      var outputMessage:String;      try {		trace(requestId, route, JSON.stringify(message));        outputMessage = Protocol.encode(requestId, route, message);      } catch(e:Error) {        trace("Error using Protocol.encode:", e);      }      this.socket.send(outputMessage);    }        // Processes the message and invoke callback or event.    protected function processMessage(message:Object):void {      if (message.id) {        // the request and notify message from server		trace(JSON.stringify(message.body));        this.eventManager.invokeCallBack(message.id, message.body);      } else {         // broadcast message from server        this.eventManager.dispatchEvent(message.route, message);      }    }        // Processes the message and invoke callback or event.    protected function processMessageBatch(messages:Object):void {      for(var i:int = 0; i < messages.length; i++) {        this.processMessage(messages[i]);      }    }        protected function socketDisconnectHandler(e:Event):void {      trace("Connection was terminated!", e);      this.dispatchEvent(new ClientEvent(ClientEvent.DISCONNECTED));    }    // When message from server comes, process it.    protected function socketInputHandler(e:FlashSocketEvent):void {        trace("socketDataHandler: " + e.data);      var data:Object = JSON.parse(e.data);      if(data.id) {        this.processMessage(data);      } else {        this.processMessageBatch(data);      }    }        protected function socketErrorHandler(e:FlashSocketEvent):void {      trace("socket error: " + e.data);      this.dispatchEvent(new ClientEvent(ClientEvent.ERROR));    }    protected function socketSecurityErrorHandler(e:FlashSocketEvent):void {      trace("socket security error: " + e.data);      this.dispatchEvent(new ClientEvent(ClientEvent.ERROR));    }  }}