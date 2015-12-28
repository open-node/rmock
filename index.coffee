_         = require 'underscore'
restify   = require 'restify'
cfg       = require './package'

conf = []

module.exports =

  add: (collPath, modelPath, data) ->
    throw Error("First argument must be a string") unless _.isString(collPath)
    args = arguemnts
    # Data is second arguemnts when two arguments only and second be an array
    data = modelPath if (args.length is 2) and _.isArray(modelPath)
    data = data or []

    modelPath = collPath unless _.isString(modelPath)
    conf.push([collPath, modelPath, data])

  start: (ip, port) ->
    server = restify.createServer
      name: "rmock server powered by redstone"
      version: cfg.version

    server.use restify.acceptParser(server.acceptable)
    server.use restify.queryParser(opts.config.queryParser or null)
    server.use restify.bodyParser(opts.config.bodyParser or null)
    server.use (req, res, next) ->
      res.charSet opts.config.charset or 'utf-8'
      next()

    _.each(conf, (item) ->
      [collPath, modelPath, data] = item
      id = utils.id()

      # list api
      server.get(collPath, (req, res, next) ->
        res.header("X-Content-Record-Total", data.length)
        res.send(utils.pageData(data, req.params))
        next()
      )

      # add/create api
      server.post(collPath, (req, res, next) ->
        model = _.extend({}, req.params, {id: id()})
        data.push(model)
        res.send(201, model)
        next()
      )

      # detail api
      server.get(modelPath, (req, res, next) ->
        unless model = _.find(data, (x) -> x.id is +req.params.id)
          return next(restify.errors.NotFoundError("Not found error."))
        res.send(model)
        next()
      )

      # modify api
      handler = (req, res, next) ->
        unless model = _.find(data, (x) -> x.id is +req.params.id)
          return next(restify.errors.NotFoundError("Not found error."))
        _.extend model, req.params, {id: model.id}
        res.send(model)
        next()
      server.put(modelPath, handler)
      server.patch(modelPath, handler)

      # remove api
      server.delete(modelPath, (req, res, next) ->
        unless model = _.find(data, (x) -> x.id is +req.params.id)
          return next(restify.errors.NotFoundError("Not found error."))
        data = _.filter(data, (x) -> x.id isnt model.id)
        res.send(204)
        next()
      )
    )
