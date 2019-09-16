require! {
  \fs            : { read-file-cb }
  \path          : { join }
  \prelude-ls    : { tail, any, drop, obj-to-pairs, find, map, keys, values }
  \child_process : { spawn }
  \bluebird      : P
  \./config
}


read-file = P.promisify(read-file-cb)

pass-error = (msg, error) -->
  if config.debug
    console.log error

  throw new Error(msg)


read-state-file = (path) ->
  file = join(path, 'Local State')

  read-file(file, encoding:\utf8)
    .then(JSON.parse)
    .catch(pass-error("Error - Can't find 'Local State' (#{file}) file in chromium config directory"))


profile-username = (path) ->
  read-state-file(path)
    .then((local-state) ->
      local-state.profile.info_cache
      |> values
      |> map (.user_name)
      )


profile-for-username = (path, username) -->
  read-state-file(path)
    .then((local-state) ->
      profile = local-state.profile.info_cache
      |> obj-to-pairs
      |> find (pair) ->
        pair.1.user_name == username
      profile.0
      )


open-with-profile = (cmd, profile) -->
  spawn(cmd, ["--profile-directory=#{profile}"], {
    detached: true
    stdio: \ignore
    }).unref!


dmenu = (alternatives, callback) ->
  cp = spawn(config.dmenu.cmd, config.dmenu.args)
  cp.stdin.write(alternatives.join(\\n))
  cp.stdin.end()
  cp.stdout.on('data', (data) ->
    callback(data.to-string!))



