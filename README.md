# simple-user-simulation

powershell script to simulate activity by a user

## Why fork

- I wanted to add the possibily to grab the urls from a specific endpoint. Change it in Config.ps1 (variable : ```$IE_URIs_link```). Also hardcode some urls in Config.ps1 (variable : ```$IE_URIs```) if error while accessible the endpoint. Change it too if needed.
- Remove some "write-host" because I think this is why sometimes, the powershell script "hangs" and stop unless you refresh with "enter" the powershell window.
- Script output is probably ugly now, but doesn't matter as long as it works (not enough tests right now to tell if it's working good without unknown error).
- Oh, and something, script is (sometimes?) retrying to download multiples time the url file from "http://something/urls.txt" but honestly, I don't care.


## Why does it exist?

Improve the experience of cybersecurity exercises. The script can be run on multiples VM/PCs to simulate the activity of real users, and generate traffic on the network.

## This set of powershell scripts simulate on W10/W7 the activity of an user

It is strongly recommended you read the documentation in Docs before attempting anything.

###  Usage
- Edit "Config.ps1" (mainly: ```$IE_URIs``` and ```$IE_URIs_link```)
- Run : RunUserSimulation.ps1
```powershell
powershell.exe -nop -exec bypass .\RunUserSimulation.ps1
```

## Features

- Run automatically for a specified time
- No-fail policy, the parts of the script can fail (for eg if network is too slow) but whatever can still run will keep running
- Log everthing, logs can be emailed (experimental)
- Run locally or on multiple (networked) machines
- Simulate: Internet Explorer browsing, Typing, accessing a shared drive, open outlook (desktop, tested on W7) and open any (executable) attachment, and any link.
