var pomelo = require('pomelo');
var logger = require('pomelo-logger').getLogger(__filename);
var userDao = require('../../../dao/userDao');
var equipDao = require('../../../dao/equipmentsDao');
var bagDao = require('../../../dao/bagDao');
var consts = require('../../../consts/consts');
var channelUtil = require('../../../util/channelUtil');
var async = require('async');
var Code = require('../../../../../shared/code');

module.exports = function(app) {
	return new Handler(app, app.get('playerService'));
};

var Handler = function(app, playerService) {
	this.app = app;
	this.playerService = playerService;
};

Handler.prototype.createPlayer = function(msg, session, next) {
	var uid = session.uid, roleId = msg.roleId, name = msg.name;

	this.playerService.createPlayer(uid, name, roleId, function(code, err, player) {
		if(code == Code.FAIL) {
			next(null, {code: consts.MESSAGE.ERR, error: err});
		}
		else if(code == Code.OK) {
			afterLogin(self.app, msg, session, {id: uid}, player.strip(), next);
		}
		else {
			logger.error('unknown code');
			throw 'unknown code';
		}
	});
};

var afterLogin = function (app, msg, session, user, player, next) {
	async.waterfall([
		function(cb) {
			session.bind(user.id, cb);
		}, 
		function(cb) {
			session.set('username', user.name);
			session.set('areaId', player.areaId);
			session.set('playername', player.name);
			session.set('playerId', player.id);
			session.on('closed', onUserLeave);
			session.pushAll(cb);
		}, 
		function(cb) {
			app.rpc.chat.chatRemote.add(session, user.id, player.name, channelUtil.getGlobalChannelName(), cb);
		}
	], 
	function(err) {
		if(err) {
			logger.error('fail to select role, ' + err.stack);
			next(null, {code: consts.MESSAGE.ERR});
			return;
		}
		next(null, {code: consts.MESSAGE.RES, user: user, player: player});
	});
};

var onUserLeave = function (session, reason) {
	if(!session || !session.uid) {
		return;
	}

	var rpc= pomelo.app.rpc;
	rpc.area.playerRemote.playerLeave(session, {playerId: session.get('playerId'), areaId: session.get('areaId')}, null);
	rpc.chat.chatRemote.kick(session, session.uid, null);
};
