#!/usr/bin/env bash
CACHE_OUTPUT=/tmp/weather-result-cache.txt
CACHE_OUTPUT_CITY=/tmp/tmux-weather-info-yr-city.txt
CACHE_OUTPUT_SYMBOL=/tmp/tmux-weather-info-yr-symbol.txt
CACHE_OUTPUT_SYMBOL_PLAINTEXT=/tmp/tmux-weather-info-yr-symbol-plaintext.txt
AGE_TO_CACHE="600" # 10 minutes

if [ -f "$CACHE_OUTPUT" ] && [ $(($(date +%s) - $(stat --format=%Y "$CACHE_OUTPUT"))) -le "$AGE_TO_CACHE" ]; then
  cat "$CACHE_OUTPUT"
  exit 0
fi

(
IP_API=$(curl -s 'http://ip-api.com/json/')
LATITUDE=$(echo "$IP_API" | jq -r '.lat')
LONGITUDE=$(echo "$IP_API" | jq -r '.lon')
CITY=$(echo "$IP_API" | jq -r '.city')
echo "$CITY" > "$CACHE_OUTPUT_CITY"

YR_QUERY="curl -s 'https://api.met.no/weatherapi/locationforecast/2.0/compact?lat=$LATITUDE&lon=$LONGITUDE'"
YR=$(eval $YR_QUERY)
TEMPERATURE=$(echo "$YR" | jq -r '.properties.timeseries[0].data.instant.details.air_temperature')
SYMBOL=$(echo "$YR" | jq -r '.properties.timeseries[0].data.next_1_hours.summary.symbol_code')
TEMP_INTEGER=${TEMPERATURE%.*}
echo "$SYMBOL" > "$CACHE_OUTPUT_SYMBOL_PLAINTEXT"

if [ "$TEMP_INTEGER" -eq "-0" ]; then
  TEMP_INTEGER="0"
fi

# get user preference from tmux
ICON_STYLE=$(tmux show-option -gqv "@weather_icon_style")

case $SYMBOL in
  clearsky*)
    case $ICON_STYLE in
      nerd)  SYMBOL="" ;;   # nf-weather-day_sunny
      *)     SYMBOL="☀️" ;;
    esac
    ;;
  cloudy|fog)
    case $ICON_STYLE in
      nerd)  SYMBOL="" ;;   # nf-weather-cloud
      *)     SYMBOL="☁️" ;;
    esac
    ;;
  fair*)
    case $ICON_STYLE in
      nerd)  SYMBOL="" ;;   # nf-weather-day_sunny_overcast
      *)     SYMBOL="🌤️" ;;
    esac
    ;;
  heavyrain|lightrain|rain|sleet)
    case $ICON_STYLE in
      nerd)  SYMBOL="" ;;   # nf-weather-rain
      *)     SYMBOL="🌧️" ;;
    esac
    ;;
  heavysleetshowers*|heavyrainshowers*|lightrainshowers*|rainshowers*|sleetshowers*)
    case $ICON_STYLE in
      nerd)  SYMBOL="" ;;   # nf-weather-showers
      *)     SYMBOL="🌦️" ;;
    esac
    ;;
  partlycloudy*)
    case $ICON_STYLE in
      nerd)  SYMBOL="" ;;   # nf-weather-day_sunny_overcast
      *)     SYMBOL="🌥️" ;;
    esac
    ;;
  heavysleetandthunder|heavyrainandthunder|heavyrainshowersandthunder*|heavysleetshowersandthunder*|lightrainshowersandthunder*|rainshowersandthunder*)
    case $ICON_STYLE in
      nerd)  SYMBOL="" ;;   # nf-weather-thunderstorm
      *)     SYMBOL="⛈️" ;;
    esac
    ;;
  heavysnow|lightsleet|lightsnow|snow)
    case $ICON_STYLE in
      nerd)  SYMBOL="" ;;   # nf-weather-snow
      *)     SYMBOL="🌨️" ;;
    esac
    ;;
esac

echo "$SYMBOL" > "$CACHE_OUTPUT_SYMBOL"

printf "%s\n" "$TEMP_INTEGER°C "
) > "$CACHE_OUTPUT"
