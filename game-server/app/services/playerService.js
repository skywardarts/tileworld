var Code = require('../../../shared/code');
var utils = require('../util/utils');
var dispatcher = require('../util/dispatcher');
var pomelo = require('pomelo');
var logger = require('pomelo-logger').getLogger(__filename);
var userDao = require('../dao/userDao');
var equipDao = require('../dao/equipmentsDao');
var bagDao = require('../dao/bagDao');
var consts = require('../consts/consts');
var channelUtil = require('../util/channelUtil');
var async = require('async');

var PlayerService = function(app) {
  this.app = app;
  this.uidMap = {};
  this.nameMap = {};
  this.channelMap = {};
};

module.exports = PlayerService;

PlayerService.prototype.createPlayer = function(uid, name, roleId, cb) {
  var self = this;

  userDao.getPlayerByName(name, function(err, player) {
    if (player) {
      cb(Code.FAIL, err);
      return;
    }

    userDao.createPlayer(uid, name, roleId, function(err, player){
      if(err) {
        logger.error('[register] fail to invoke createPlayer for ' + err.stack);
        cb(Code.FAIL, err);
        return;
      }else{
        async.parallel([
        function(callback) {
          equipDao.createEquipments(player.id, callback);
        },
        function(callback) {
          bagDao.createBag(player.id, callback);
        },
        function(callback) {
          player.learnSkill(1, callback);
        }],
        function(err, results) {
          if (err) {
            logger.error('learn skill error with player: ' + JSON.stringify(player.strip()) + ' stack: ' + err.stack);
            cb(Code.FAIL, err);
            return;
          }

          cb(Code.OK, null, player);
        });
      }
    });
  });
};