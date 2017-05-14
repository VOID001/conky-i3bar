# conky-i3bar

Real conky window as i3bar replacement, works with trayer.

![screenshot](https://u.nya.is/buemoq.png)

# Feature

- i3wm workspace status
- system load diagram
- NVIDIA graphic card load diagram
- date & time
- Clementine current playing music



# Dependencies

- Conky with Lua binding, of course !
- luajson (for processing i3's output)
- Python3 (for python script to get Clementine status)
- trayer (if you want a systray)
- lua-date, lua-http (install from luarocks, needed by github_alert)
- font-awesome (show icons font, needed by github_alert)


# Usage

```
git clone https://github.com/frantic1048/conky-i3bar.git
conky -c conky-i3bar/conkyrc.lua &

# show sys tray wit trayer
trayer --edge bottom \
    # more options you like
    --aligin right \
    --SetDockType true &


# forget about i3bar (｢・ω・)｢
```

# Components Configuration

## Github alert

This is a tool that remind you to **commit** to github everyday :P


* Get a Personal Access Token from [here](https://github.com/settings/tokens/new)
* tick repo, user and notifications
* then you will get a 40 characters access_token
* copy the file called config.json.sample to .config.json
* Modify the **gh_token**, **gh_user** to match your token and username.
* Then you are all set


# Credits

- [anowplaying.py](https://github.com/diadara/conky-clementine/blob/master/anowplaying.py) script for Clementine status.
