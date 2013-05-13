var Token = require('../../../../../shared/token');
var userDao = require('../../../dao/userDao');
var Code = require('../../../../../shared/code');
var secret = require('../../../../../shared/config/session.json').secret;

var DEFAULT_SECRET = 'pomelo_session_secret';
var DEFAULT_EXPIRE = 6 * 60 * 60 * 1000;  // default session expire time: 6 hours

module.exports = function(app) {
  return new AuthHandler(app);
};

var AuthHandler = function(app) {
  this.app = app;
};

/**
 * register
 * name 
 * password 
 */
AuthHandler.prototype.register =function(msg, session, next) {
  var name = msg.name;
  var password = msg.password;

  userDao.createUser(name, password, '', 0, function(err, user) {
    if (err || !user) {
      console.error(err);
      if (err && err.code === 1062) {
        next(err);
      } else {
        next(err);
      }
    } else {
      console.log('A new user was created! --' + msg.name);
      next(null, {token: Token.create(user.id, Date.now(), secret), uid: user.id});
    }
  });
};

/**
 * login
 * username 
 * pwd 
 */
AuthHandler.prototype.login = function(msg, session, next) {
  var username = msg.username;
  var pwd = msg.pwd;

  if (!username) {
    console.log('no username!');
    next();
    return;
  }

  userDao.getUserByName(username, function(err, user) {
    if (err || !user) {
      console.log('username not exist, creating a temporary user: ' + username);

      userDao.createUser(username, username, '', 1, function(err, user) {
        if (err || !user) {
          console.log('Error creating an anonymous user: ' + username);
          console.error(err);
          if (err && err.code === 1062) {
            next(err);
          } else {
            next(err);
          }
        } else {
          console.log('A new anonymous user was created! --' + username);
          console.log(user);
          next(null, {token: Token.create(user.id, Date.now(), secret), uid: user.id});
        }
      });

      return;
    }

    if (!pwd || pwd !== user.password) {
      // TODO code
      // password is wrong
      console.log('password incorrect!');
      next(err);
      return;
    }

    console.log(username + ' login!');
    next(null, {token: Token.create(user.id, Date.now(), secret), uid: user.id});
  });
};