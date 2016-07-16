# hubot-relevant-dilbert

A Hubot script to find the relevant Dilbert strip for a phrase

It finds the image by screen scraping the official website [dilbert.com](http://dilbert.com).

If things don't work anymore, it's most probably because the website has changed

See [`src/relevant-dilbert.coffee`](src/relevant-dilbert.coffee) for full documentation.

## Installation

In hubot project repo, run:

`npm install hubot-relevant-dilbert --save`

Then add **hubot-relevant-dilbert** to your `external-scripts.json`:

```json
[
  "hubot-relevant-dilbert"
]
```

## Sample Interaction

```
user1>> hubot relevant dilbert robot rules
hubot>> http://assets.amuniversal.com/b09d3db017610133f882005056a9545d
```

## NPM Module

https://www.npmjs.com/package/hubot-relevant-dilbert
