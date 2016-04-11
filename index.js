var crypto = require('crypto');
var User = require('../models/user.js');
var Post = require('../models/post.js');

module.exports = function(app) {
	app.get('/', function(req, res) {
    Post.get(null, function(err, posts) {
      if (err) {
        posts = [];
      }
      res.render('index', {
        title: '首頁',
        posts: posts,
      });
    });
  });

	app.get('/login', function(req, res) {
    res.render('reg', {
      title: '登陸',
    });
  });

	}
