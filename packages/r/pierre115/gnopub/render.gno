package gnopub

import (
	"gno.land/p/leon/svgbtn"
)

func Render(path string) string {
	out := "# GnoADS 📺\n\n"
	out += "### ADS Grid \n\n"

	// Path handling
	if path == "stats" {
		return out + getStats() + "\n\n[← Retour](/r/gnopixel)"
	}

	// Main grid
	out += renderGrid() + "\n\n"

	// Tutorial
	out += "## Tuto 📚\n\n"

	out += "### Step 1: Buy a cell\n\n"
	out += "Click on a white cell in the grid or use the BuyCell function:\n\n"
	out += svgbtn.Button(120, 35, "#4caf50", "#ffffff", "Buy Cell (0,0)", "/r/pierre115/gnoads$help&func=BuyCell&x=0&y=0") + "\n\n"
	out += "Replace x and y with your desired coordinates.\n\n"

	out += "### Step 2: Update your cell\n\n"
	out += "Set the ads URL and label for your cell:\n\n"
	out += svgbtn.Button(120, 35, "#4caf50", "#ffffff", "Update Cell (0,0)", "/r/pierre115/gnoads$help&func=UpdateCell&x=0&y=0&url=https://github.com/gnolang/hackerspace/issues/122&label=test") + "\n\n"
	out += "- `x`, `y`: coordinates of your cell\n"
	out += "- `url`: your advertisement URL (must start with http)\n"
	out += "- `label`: text to display\n\n"

	out += "### Step 3: Change color\n\n"
	out += "Click again on your owned cell to cycle through colors:\n\n"
	out += svgbtn.Button(120, 35, "#4caf50", "#ffffff", "Change Color (0,0)", "/r/pierre115/gnoads$help&func=BuyCell&x=0&y=0") + "\n\n"

	out += "### Step 4: Sell your cell\n\n"
	out += "Release your cell back to the grid:\n\n"
	out += svgbtn.Button(120, 35, "#4caf50", "#ffffff", "Sell Cell (0,0)", "/r/pierre115/gnoads$help&func=SellCell&x=0&y=0") + "\n\n"

	// Utility buttons
	out += "---\n\n"
	out += "## Admin Pannel 🛠️\n\n"
	out += svgbtn.DangerButton(100, 30, "Reset", "/r/gnopixel$help&func=reset") + "\n\n"

	// Stats
	out += getStats()

	return out
}
