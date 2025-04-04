#!/bin/bash
# steam steam://rungameid/427520
# cleanup() {
#     killall factorio
#     echo "END FACTORIO OUTPUT SCRAPE"
# }
# trap cleanup EXIT
# sleep 5
echo "BEGIN FACTORIO OUTPUT SCRAPE."

# https://stackoverflow.com/a/5947802
PURPLE='\033[0;35m'
DARK_GRAY='\033[1;30m'
NC='\033[0m'

# https://regexr.com/
# https://unix.stackexchange.com/a/470629
while IFS= read -r LOGLINE || [[ -n "$LOGLINE" ]]; do
    if [[ "$LOGLINE" =~ ^[[:space:]]+[[:digit:]]+\.[[:digit:]]+[[:space:]]+Goodbye$ ]]; then
        # Game closes.
        exit 0
    fi
    if [[ "$LOGLINE" =~ [[:digit:]]+\.[[:digit:]]+[[:space:]]+Script ]]; then
        # Colorize mod output bright.
        echo -e "${PURPLE}$LOGLINE${NC}"
    else
        # Dim standard output.
        echo -e "${DARK_GRAY}$LOGLINE${NC}"
    fi    
done < <(tail -f $HOME/.factorio/factorio-current.log)

