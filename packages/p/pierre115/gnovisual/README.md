# GnoVisual

Package `gnovisual` renders scatter plots as SVG images. It takes a list of (x, y) points and draws them as circles on a 2D canvas, with optional support for displaying a linear regression line.

## Usage

```go
import "gno.land/p/pierre115/gnovisual"

func main() {
    plot := scatterplot.ScatterPlot{
        Points: []scatterplot.Point{
            {X: 100, Y: 0, Label: "A"},
            {X: 101, Y: 20, Label: "B"},
            {X: 102, Y: 40, Label: "C"},
            {X: 103, Y: 60, Label: "D"},
        },
        Title:    "Sales Growth",
        XAxis:    "Years",
        YAxis:    "Sales",
        FlagRe:   true,
        Maxticks: 20,
        Width:    800,
        Height:   800,
    }

    svg := plot.Render()
    // Use the SVG output
}
```

## API

### Point

```go
type Point struct {
    X, Y  float64 // Coordinates of the point
    Color string  // Color of the point
    Label string  // Label associated with the point
}
```

### ScatterPlot

```go
type ScatterPlot struct {
    Points   []Point // Data points to plot
    Title    string  // Plot title
    XAxis    string  // X-axis label
    YAxis    string  // Y-axis label
    FlagRe   bool    // Enable linear regression line (default: false)
    Maxticks int     // Number of tick marks on axes
    Width    int     // Plot width in pixels
    Height   int     // Plot height in pixels
}
```

## Features

### Linear Regression

Set `FlagRe` to `true` to display a linear regression line fitted to your data points. The regression equation will be displayed in the top-left corner of the plot.

## Example

Here's a complete example showing sales growth over time:

```go
plot := scatterplot.ScatterPlot{
    Points: []scatterplot.Point{
        {X: 2020, Y: 150, Label: "Q1"},
        {X: 2021, Y: 230, Label: "Q2"},
        {X: 2022, Y: 310, Label: "Q3"},
        {X: 2023, Y: 405, Label: "Q4"},
    },
    Title:    "Quarterly Sales Performance",
    XAxis:    "Year",
    YAxis:    "Revenue (k$)",
    FlagRe:   true,
    Maxticks: 10,
    Width:    600,
    Height:   400,
}
```

This will generate an SVG scatter plot with a regression line showing the trend in sales growth.