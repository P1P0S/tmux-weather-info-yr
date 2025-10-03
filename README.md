# tmux-weather-info-yr
Displays the current temperature and weather based on your location. The weather data is provided by the Norwegian Meteorological Institute.
![](https://feqzz.no/img/tmux-weather-info-yr.png)

## Installation
Dependencies:
* curl
* jq

### Installation with Tmux Plugin Manager
Edit your `.tmux.conf` and append the plugin to your TPM list.

```tmux
set -g @plugin 'P1P0S/tmux-weather-info-yr'
```
Remember to hit `<prefix> + I` to install the plugin.

### Manual
Clone the repo:
``` bash
git clone https://github.com/P1P0S/tmux-weather-info-yr ~/.tmux/
```
Edit your `.tmux.conf` and add this line at the bottom.
``` bash
run-shell ~/.tmux/tmux-weather-info-yr/tmux-weather-info-yr.tmux
```
Last step is to reload the tmux config file.
``` bash
tmux source-file ~/.tmux.conf
```

## Usage
Edit your `.tmux.conf` file and add `#{weather_temperature}` to your `status-right`. Simple example:
``` tmux
set -g status-right "#{weather_temperature}"
```

## Available Options
It is important that `#{weather_temperature}` is included in the status bar. Otherwise none of the other options will work. I might fix this in the future if there is any interest.
| Command | Example |
| --- | --- |
| #{weather_temperature} | -1°C |
| #{weather_city} | Kongsberg |
| #{weather_symbol} | 🌤️ |
| #{weather_symbol_plaintext} | fair_day |

## New Icon Style Option
You can configure how weather icons are displayed in tmux. Add this line to your `.tmux.conf`:
``` tmux
set -g @weather_icon_style "nerd"  # options: "nerd" or "unicode"
```
* "nerd": shows Nerd Font icons
* "unicode": shows standard Unicode emoji

## Credits
[Feqzz](https://github.com/Feqzz)

## License
[MIT](LICENSE.md)
