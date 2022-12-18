extends Node2D

var gridStartPosition = Vector2(0,0)

export (Color) var gridColor
export (Color) var cellColor

var cellMatrix = []

var  columnCount = 6
var  rowCount = 6

var cellSize = 50

func _draw():
	CenterGrid()
	
	DrawGridRowLines(gridStartPosition)
	DrawGridColumnLines(gridStartPosition)
	
	DrawCells()
	pass

func DrawCells() -> void:
	for rowIndex in rowCount:
		for columnIndex in columnCount:
			var points = PoolVector2Array()
			
			var rowOffset = rowIndex * cellSize
			var columnOffset = columnIndex * cellSize
			
			points = [Vector2(gridStartPosition.x + columnOffset, gridStartPosition.y + rowOffset),
			Vector2(gridStartPosition.x + cellSize + columnOffset, gridStartPosition.y + rowOffset),
			Vector2(gridStartPosition.x + cellSize + columnOffset, gridStartPosition.y + cellSize + rowOffset),
			Vector2(gridStartPosition.x + columnOffset, gridStartPosition.y + cellSize + rowOffset)]
			
			if cellMatrix[rowIndex][columnIndex] == true:
				draw_colored_polygon(points, cellColor)

func DrawGridRowLines(point1: Vector2) -> void:
	var point2 = point1
	point2.x += cellSize * rowCount
	for rowIndex in rowCount + 1:
		draw_line(point1, point2, gridColor, 1.0, false)
		point1.y += cellSize
		point2.y += cellSize

func DrawGridColumnLines(point1: Vector2) -> void:
	var point2 = point1
	point2.y += cellSize * rowCount
	for rowIndex in rowCount + 1:
		draw_line(point1, point2, gridColor, 1.0, false)
		point1.x += cellSize
		point2.x += cellSize
	pass

func _ready():
	InitializeCellMatrix()
	pass

func _process(_delta):
	update()
	GetMouseClick()
	pass

func CenterGrid() -> void:
	gridStartPosition.x = get_viewport().size.x / 2 - (cellSize * columnCount) / 2
	gridStartPosition.y = get_viewport().size.y / 2 - (cellSize * rowCount) / 2
	pass

func InitializeCellMatrix() -> void:
	for rowIndex in rowCount:
		cellMatrix.append([])
		for columnIndex in columnCount:
			cellMatrix[rowIndex].append(false)

func SetGridSize(newRowCount: int, newColumnCount: int) -> void:
	rowCount = newRowCount
	columnCount = newColumnCount
	InitializeCellMatrix()

func SetCellSize(newCellSize: int) -> void:
	cellSize = newCellSize

func UpdateCellState(rowIndex: int, columnIndex: int) -> void:
	cellMatrix[rowIndex][columnIndex] = !cellMatrix[rowIndex][columnIndex]

func GetMouseClick() -> void:
	var mousePosition = get_viewport().get_mouse_position()
	
	if !MouseIsInGrid(mousePosition):
		return
	if Input.is_action_just_pressed("mouse_click"):
		var columnIndex = int((mousePosition.x - gridStartPosition.x) / cellSize)
		var rowIndex = int((mousePosition.y - gridStartPosition.y) / cellSize)
		UpdateCellState(rowIndex,columnIndex)

func MouseIsInGrid(mousePosition: Vector2) -> bool:
	if mousePosition.x < gridStartPosition.x:
		return false
	if mousePosition.y < gridStartPosition.y:
		return false
	if mousePosition.x > gridStartPosition.x + columnCount * cellSize:
		return false
	if mousePosition.y > gridStartPosition.y + rowCount * cellSize:
		return false
	
	return true
