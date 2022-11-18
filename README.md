# app-communication-tldr

A simple Flutter codebase which build an Android application which:

- allows the change of a toggle, on change:
  - a value in a Firebase Database is updated (key `currentState`)
  - a call to a Firebase Function is made with a basic notification payload (title,message,topic)
  - on startup the current value of `currentState` is read and the application is bootstrapped of that.

## Notification Function

Firebase Function code can be found `./functions/index.js`.
A simple JS application which uses the Firebase Message library to send a message to the appropriate topic (with the correct title and body).

## Why does this exist?

My fiancée/wife wanted an easy way to let me know if she was ranting or actually wanted to hear solutions...do I need to say more?

## Notification App

The code for the receiver app can be found [app-communication-tldr-notifier](https://github.com/thameezb/app-communication-tldr-notifier/blob/main/README.md)
