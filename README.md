# Build-A-Bot
Bootstrap a Discord++ bot

Only compatible with Bash on Linux


## Community & Support <sup>Some incredibly nice people here!</sup>
[Discord++ Discord Server](https://discord.gg/VHAyrvspCx)


## Usage
Follow the [Discord++ *Basic Setup* guide](https://github.com/DiscordPP/discordpp/wiki/Basic-Setup)

`buildabot.sh` doesn't take any arguments. Instead it parses `selection.json` with `jq` (which it will temprarily download if you don't already have it installed) to give you options to choose from as you run it. It'll propmpt you to pick one item each from list of base Discord++ repositories, WebSocket modules, REST modules, and Ratelimiter plugins (though currently there's only one option for each) and then any number of plugins (use the last item in the list to stop picking plugins). Once you select an item from a category Build-A-Bot will query GitHub for the repository's avalible branches and prompt you to pick one. Once it's one, Build-A-Bot will clean up itself, `selection.json`, all insertion keywords, and `jq` if it was downloaded and commit the changes it made. You can now continue with the [Discord++ *Basic Setup* guide](https://github.com/DiscordPP/discordpp/wiki/Basic-Setup)!
