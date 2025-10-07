package gnoads

import (
	"chain/runtime"

	"gno.land/p/nt/ufmt"
	"gno.land/p/nt/ownable"
	"gno.land/p/leon/svgbtn"
)

var (
	OwnableAddress = ownable.NewWithAddress("g1e7r5eglptfejknps3xv2kxv6pc8wvd3wwtw6tg")

	colors = []string{"#ffffff", "#f44336", "#2196f3", "#4caf50", "#ff9800"} // blanc, rouge, bleu, vert, orange

	espace = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"

	defaultlink = ufmt.Sprintf("https://gno.land/r/leon/hor:hall")
)

// Render the grid
func RenderGrid() string {
	const cellSize = 100

	out := ""

	// Grid cells
	for y := 0; y < grid.Height; y++ {
		for x := 0; x < grid.Width; x++ {
			key := ufmt.Sprintf("%d,%d", x, y)
			color := "#ffffff"
			// If the cell is owned, use its color
			if cell, ok := grid.Cells[key]; ok {
				color = cell.Color
				caller := runtime.PreviousRealm().Address()
				link := defaultlink

				if cell.Url != "" {
					link = cell.Url
				}

				// If the cell is owned by someone else, link to their pub if set
				if cell.Owner != "" && cell.Owner != caller {
					out += svgbtn.Button(cellSize, cellSize, color, "#333333", cell.Label, link)
					out += espace
					continue
				}
			}
			link := ufmt.Sprintf("/r/gnopixel$help&func=BuyCell&x=%d&y=%d", x, y)
			out += svgbtn.Button(cellSize, cellSize, color, "#333333", "available", link)
			out += espace
		}
		out += "\n\n"
	}

	return out
}

// Function to sell a cell
func SellCell(_ realm, x, y int) string {
	if x < 0 || x >= grid.Width || y < 0 || y >= grid.Height {
		return ufmt.Sprintf("Invalid coordinate : X=%d, Y=%d", x, y)
	}

	key := ufmt.Sprintf("%d,%d", x, y)
	caller := runtime.PreviousRealm().Address()
	cell, exists := grid.Cells[key]

	if  exists && cell.Owner == caller {
		grid.Cells[key] = Cell{
			X:     x,
			Y:     y,
			Color: "",
			Owner: "",
			Url: "",
			Label: "",
		}
		return ufmt.Sprintf("The cell was successfully sold.", x, y)
	}

	return "You are not the owner of this cell."
}

// Function to update the Ads and the Label of yours cells
func UpdateCell(_ realm, x, y int, url, label string) string {
	if x < 0 || x >= grid.Width || y < 0 || y >= grid.Height {
		return ufmt.Sprintf("Invalid coordinate : X=%d, Y=%d", x, y)
	}

	key := ufmt.Sprintf("%d,%d", x, y)
	caller := runtime.PreviousRealm().Address()
	cell, exists := grid.Cells[key]

	if  exists && cell.Owner == caller {
		grid.Cells[key] = Cell{
			X:     x,
			Y:     y,
			Color: cell.Color,
			Owner: cell.Owner,
			Url: url,
			Label: label,
		}
		return ufmt.Sprintf("The cell Url was successfully Updated!")
	}

	return "You are not the owner of this cell."
}



// Cell clicked function if the cells is not owned
func BuyCell(_ realm, x, y int) string {
	if x < 0 || x >= grid.Width || y < 0 || y >= grid.Height {
		return ufmt.Sprintf("Invalid coordinate : X=%d, Y=%d", x, y)
	}

	key := ufmt.Sprintf("%d,%d", x, y)
	caller := runtime.PreviousRealm().Address()

	// If the cells is not owned, buy it
	cell, exists := grid.Cells[key]
	if !exists || cell.Owner == "" {
		grid.Cells[key] = Cell{
			X:     x,
			Y:     y,
			Color: colors[1], // red at first
			Owner: caller,
			Url: "",
			Label: "",
		}
		return ufmt.Sprintf("The cell was successfully (%d,%d) purchased!", x, y)
	}

	// if it is the person who own it, change the color
	if cell.Owner == caller {
		currentColorIndex := 0
		for i, c := range colors {
			if c == cell.Color {
				currentColorIndex = i
				break
			}
		}
		nextColorIndex := (currentColorIndex + 1) % len(colors)
		cell.Color = colors[nextColorIndex]
		grid.Cells[key] = cell
		return ufmt.Sprintf("The cells (%d,%d) was updated! New color: %s", x, y, getColorName(cell.Color))
	}

	return "This cell is owned."
}

// Reset grid (admin only)
func reset() string {
	if !isAuthorized(runtime.PreviousRealm().Address()) {
		panic("unauthorized")
	}
	grid.Cells = make(map[string]Cell)
	return "The grid was successfully reset."
}

// Stats of the grid (per cells owners)
func getStats() string {
	stats := make(map[address]int)
	for _, cell := range grid.Cells {
		if cell.Owner != "" {
			stats[cell.Owner]++
		}
	}

	out := "## Stats 📊:\n"
	if len(stats) == 0 {
		out += "No cells used.\n"
		return out
	}

	for owner, count := range stats {
		out += ufmt.Sprintf("- %s: %d cell(s)\n", owner.String(), count)
	}
	return out
}

func getColorName(color string) string {
	switch color {
	case "#f44336":
		return "Red"
	case "#2196f3":
		return "Blue"
	case "#4caf50":
		return "Green"
	case "#ff9800":
		return "Orange"
	default:
		return "White"
	}
}

func isAuthorized(addr address) bool {
	return addr == OwnableAddress.Owner()
}
