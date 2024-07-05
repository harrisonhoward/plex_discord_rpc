# Discord Rich Presence for Plex built with Gleam

[![MIT license](https://img.shields.io/badge/License-MIT-blue.svg)](https://lbesson.mit-license.org/)
[![Made with Gleam](https://img.shields.io/badge/Made%20with-Gleam-ffaff3.svg)](https://shields.io/)
[![Status](https://img.shields.io/badge/Status-Completed-green.svg)](https://shields.io/)

## Scope

For this project to be successful I need to create in alignment the following projects

-   Plex Pin auth
    -   [![Status](https://img.shields.io/badge/Status-Work%20in%20progress-yellow.svg)](https://shields.io/)
-   Plex Websocket
    -   [![Status](https://img.shields.io/badge/Status-Not%20started-red.svg)](https://shields.io/)

These projects are the ground for working with Plex and making something like this Discord RPC. Along with this no known Discord RPC library exists within Gleam at the moment making this project a lot larger in scope. At the moment I'm aiming to get this project into a means where I depend on these other packages. If I get to the point where these packages are setup within the project I will work on a Discord RPC. Keeping in mind I will not be able to maintain these packages alone due to full-time job, in any case I will do my best to complete them.

This will take time especially as a solo runner but I am determined that I will be able to complete this project. I do not have a time frame, it could take me to the end of the year I really don't know. Hopefully by the time I get anywhere meaningful packages make already exist for the other dependents of this project.

### JavaScript alternatives

The work will be based on these JavaScript repositories. JavaScript is what I would call my 'native' programming language so that what I'll use to translate existing work. I've been using Gleam for a couple days since writing this..

-   [node-plex-api-pinauth](https://github.com/Zefau/node-plex-api-pinauth) created by Zefau
-   [plex-websocket](https://github.com/harrisonhoward/plex-websocket) created by me (harrisonhoward)
-   [plex-rpc-js](https://github.com/harrisonhoward/plex-rpc-js) created by me (harrisonhoward)

### Plex Pin Auth Documentation

It appears the API isn't officially documented however I found some third-party documentation website. This website will be used in the creation of the pin authentication.

-   [get-pin](https://plexapi.dev/docs/plex/get-pin)
-   [get-token](https://plexapi.dev/docs/plex/get-token)

## Development

Requires Gleam to be installed to run the project\
[How to install Gleam](https://gleam.run/getting-started/installing/)

```sh
# Runs the project
gleam run
```

## Contributing

1. [Fork it](https://github.com/harrisonhoward/plex_discord_rpc/fork)
2. Clone your forked repository `git clone https://github.com/YOUR_USERNAME/plex_discord_rpc.git`
3. Create your feature branch `git checkout -b feature/my-new-feature`
4. Commit your changes `git commit -am 'Add some feature'`
5. Push to the branch `git push origin feature/my-new-feature`
6. Create a new Pull Request

## Author

[Harrison Howard](https://github.com/harrisonhoward)

> harrison.howard00707@gmail.com
