var Code = require('../../../../../shared/code');
var userDao = require('../../../dao/userDao');
var async = require('async');
var channelUtil = require('../../../util/channelUtil');
var logger = require('pomelo-logger').getLogger(__filename);

module.exports = function(app) {
	return new Handler(app);
};

var Handler = function(app) {
	this.app = app;
};

var pro = Handler.prototype;

/**
 * New client entry game server. Check token and bind user info into session.
 * 
 * @param  {Object}   msg     request message
 * @param  {Object}   session current session object
 * @param  {Function} next    next stemp callback
 * @return {Void}
 */
pro.entry = function(msg, session, next) {
	var token = msg.token, self = this;

	this.playerService = this.app.get('playerService');

	if(!token) {
		next(new Error('invalid entry request: empty token'), {code: Code.FAIL});
		return;
	}

	var uid, user, player;
	async.waterfall([
		function(cb) {
			console.log(session, token);
			// auth token
			self.app.rpc.auth.authRemote.auth(session, token, cb);
		}, function(code, user2, cb) {
			// query player info by user id
			if(code !== Code.OK) {
				next(null, {code: code});
				return;
			}

			if(!user2) {
				next(null, {code: Code.ENTRY.FA_USER_NOT_EXIST});
				return;
			}
			
			user = user2;
			uid = user.id;
			userDao.getPlayersByUid(uid, cb);
		}, function(res, cb) {
			// generate session and register chat status
			if(!res || res.length === 0) {
        console.log('Creating default player: ' + user.name);

				self.playerService.createPlayer(user.id, user.name, 210, function(code, err, res) {
					player = res;

					if(code == Code.OK) {
						cb();
					}
					else if(code == Code.FAIL) {
						next(null, {code: consts.MESSAGE.ERR, error: err});
					}
					else {
						logger.error('unknown code');
						throw 'unknown code';
					}
				});

				return;
			}

			player = res[0];

			self.app.get('sessionService').kick(uid, cb);
		}, function(cb) {
			session.bind(uid, cb);
		}, function(cb) {
			session.set('areaId', player.areaId);
			session.set('playername', player.name);
			session.set('playerId', player.id);
			session.on('closed', onUserLeave.bind(null, self.app));
			session.pushAll(cb);
		}, function(cb) {
			self.app.rpc.chat.chatRemote.add(session, player.userId, player.name, 
				channelUtil.getGlobalChannelName(), cb);
		}
	], function(err) {
		if(err) {
			next(err, {code: Code.FAIL});
			return;
		}
		
		next(null, {code: Code.OK, player: player});
	});
};

var onUserLeave = function (app, session, reason) {
	if(!session || !session.uid) {
		return;
	}

	app.rpc.area.playerRemote.playerLeave(session, {playerId: session.get('playerId'), areaId: session.get('areaId')}, function(err){
		if(!!err){
			logger.error('user leave error! %j', error);
		}
	});
	app.rpc.chat.chatRemote.kick(session, session.uid, null);
};
