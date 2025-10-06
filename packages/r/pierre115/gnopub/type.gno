package gnopub

// Cell structure
type Cell struct {
	X     int
	Y     int
	Color string  // colors of the cells if owned
	Owner address // address of the owner
	Url   string  // url of the pub
	Label string  // pseudo of the owner / name of the pub
}

// Global grid variable
var grid = struct {
	Width  int
	Height int
	Cells  map[string]Cell
}{
	Width:  5, // init params
	Height: 3,
	Cells:  make(map[string]Cell),
}
