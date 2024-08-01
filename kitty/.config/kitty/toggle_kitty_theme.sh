
if [ "$1" == "dark" ]; then
    kitty +kitten themes --reload-in=all Catppuccin-Macchiato
    echo "Switched to Macchiato theme"
elif [ "$1" == "light" ]; then
    kitty +kitten themes --reload-in=all Catppuccin-Latte
    echo "Switched to Frappe theme"
else
    echo "Usage: $0 {dark|light}"
    exit 1
fi
