require! {
  'fsrc-config'  : fsrc-config
}

module.exports = fsrc-config(
  \chromium-profiles,
  {
    "browsers" : [
      {
        "name" : "chromium",
        "cmd"  : "/usr/bin/chromium",
        "profiles-path" : "$HOME/.config/chromium",
        "profiles" : [
          { "display" : "My profile", "name" : "my-email@gmail" }
        ]
      }
    ],
    "shortcuts" : [
      {
        "name" : "Private mail",
        "browser" : "chromium",
        "profile" : "my-email@gmail.com",
        "url" : "https://mail.google.com/mail/u/0/\#inbox"
      }
    ],
    "dmenu" : {
      "cmd": "rofi",
      "args": ["-dmenu"]
    },
    "debug": false
  })

