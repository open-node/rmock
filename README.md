# RestAPI mock

## Quick start

* installation
<pre>npm install rmock --save-dev</pre>

* useage
<pre>
var rmock = require('rmock');
rmock.add(collctionRoutePath, modelRoutePath, initData)
rmock.add(routePath, initData)
rmock.add(routePath)
</pre>

* examples
<pre>
var rmock = require('rmock');
rmock.add('/users', []);
//GET/POST: /users
//GET/PUT/DELETE: /users/:id

rmock.add('/users/:userId/books', '/users/books', [{
  id: 1,
  userId: 32,
  name: 'Javascript 权威指南'
}])
// GET/POST: /users/:userId/books
// GET/PUT/DELETE: /users/books/:id

rmock.add('/users/:userId/books', [{
  id: 1,
  userId: 32,
  name: 'Javascript 权威指南'
}])
// GET/POST: /users/:userId/books
// GET/PUT/DELETE: /users/:userId/books/:id
</pre>

* Dont support cluster mode, beause data is stored in memory variable
