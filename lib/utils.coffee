module.exports =
  pageData: (data, params) ->
    startIndex = Math.max(0, +params.startIndex or 0)
    maxResults = Math.max(1, +params.maxResults or 10)
    data.slice(startIndex, Math.min(startIndex + maxResults, data.length))

  # generater auto increament id
  id: (initValue = 0) ->
    -> initValue += 1

