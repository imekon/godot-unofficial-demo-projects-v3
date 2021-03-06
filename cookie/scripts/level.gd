extends Node

const NumSprites = 6
const NumRows = 9
const NumColumns = 9
const SpriteWidth = 32.0
const SpriteHeight = 36.0

enum State { Idle, Empty, Filling, Dropping, Swapping, Deleting }

class Cell:
	var row
	var column
	var index
	var state
	
	func _init(r, c, i):
		row = r
		column = c
		index = i
		state = State.Idle
		
class Level:
	var points
	var cells = []
	
	func _init():
		points = 0
		for row in range(NumRows):
			var rowData = []
			for column in range(NumColumns):
				rowData.append(null)
			cells.append(rowData)
			
		for row in range(NumRows):
			for column in range(NumColumns):
				var pos = getCellPosition(row, column)
				var cell = Cell.new(row, column, -1)
				setCellAtRowColumn(row, column, cell)
	
	static func getCellPosition(r, c):
		return Vector2(c * SpriteWidth + SpriteWidth, r * SpriteHeight + 130)
		
	static func getCellAtPosition(x, y):
		var row = int((y - 130) / SpriteHeight + 0.5)
		var column = int((x - SpriteWidth) / SpriteWidth + 0.5)

		if row < 0:
			row = 0
		if row >= NumRows:
			row = NumRows - 1
			
		if column < 0:
			column = 0
		if column >= NumColumns:
			column = NumColumns - 1

		return [row, column]
		
	func dump():
		for row in range(NumRows):
			var contents = ""
			for column in range(NumColumns):
				var cell = cells[row][column]
				match cell.state:
					State.Idle:
						contents = contents + "."
					State.Empty:
						contents = contents + "E"
					State.Filling:
						contents = contents + "F"
					State.Dropping:
						contents = contents + "D"
					State.Deleting:
						contents = contents + "!"
				
				if cell.index != -1:
					contents = contents + str(cell.index)
				else:
					contents = contents + " "
					
				contents = contents + " "
			print(contents)
			
	func getCellAtRowColumn(r, c):
		return cells[r][c]
	
	func setCellAtRowColumn(r, c, cell):
		cells[r][c] = cell
		cell.row = r
		cell.column = c
		cell.index = -1
		cell.state = State.Empty
		
	func fillLevel():
		for row in range(NumRows):
			for column in range(NumColumns):
				var cell = getCellAtRowColumn(row, column)
				if cell.state == State.Empty:
					var index = randi() % NumSprites
					cell.index = index
					cell.state = State.Filling
					
	func fillTopLine():
		var filled = false
		for column in range(NumColumns):
			var cell = getCellAtRowColumn(0, column)
			if cell.state == State.Empty:
				var index = randi() % NumSprites
				cell.index = index
				cell.state = State.Filling
				filled = true
		
		return filled

	func detectDroppingCells():
		var cellsAffected = []
		for row in range(NumRows - 2, -1, -1):
			for column in range(NumColumns):
				var cell = getCellAtRowColumn(row, column)
				var cellBelow = getCellAtRowColumn(row + 1, column)
				if cell.state != State.Empty && (cellBelow.state == State.Empty || cellBelow.state == State.Dropping):
					cell.state = State.Dropping
					cellsAffected.append(cell)
		return cellsAffected
		
	func dropCells():
		for row in range(NumRows - 2, -1, -1):
			for column in range(NumColumns):
				var cell = getCellAtRowColumn(row, column)
				var cellBelow = getCellAtRowColumn(row + 1, column)
				if cell.state == State.Dropping:
					cellBelow.index = cell.index
					cellBelow.state = State.Idle
					cell.index = -1
					cell.state = State.Empty
				
	func scanForHorizontalMatch(cell):
		var row = cell.row
		var column = cell.column + 1
		var index = cell.index
		var count = 1
		while(column < NumColumns):
			var c = cells[row][column]
			if c.index != index:
				return count
			count = count + 1
			column = column + 1
		return count
		
	func scanForVerticalMatch(cell):
		var row = cell.row + 1
		var column = cell.column
		var index = cell.index
		var count = 1
		while(row < NumRows):
			var c = cells[row][column]
			if c.index != index:
				return count
			count = count + 1
			row = row + 1
		return count
		
	func markForDeleteHorizontal(r, c, count):
		for index in range(count):
			var cell = cells[r][c + index]
			cell.index = -1
			cell.state = State.Deleting
			
	func markForDeleteVertical(r, c, count):
		for index in range(count):
			var cell = cells[r + index][c]
			cell.index = -1
			cell.state = State.Deleting
							
	func scanForMatch():
		for row in range(NumRows):
			for column in range(NumColumns - 2):
				var cell = cells[row][column]
				var count = scanForHorizontalMatch(cell)
				if count >= 3:
					markForDeleteHorizontal(row, column, count)
					points += count - 2
		
		for row in range(NumRows - 2):
			for column in range(NumColumns):
				var cell = cells[row][column]
				var count = scanForVerticalMatch(cell)
				if count >= 3:
					markForDeleteVertical(row, column, count)
					points += count - 2

	func swapCells(row1, column1, row2, column2):
		var cell1 = cells[row1][column1]
		var cell2 = cells[row2][column2]
		var temp = cell1.index
		cell1.index = cell2.index
		cell2.index = temp
		cell1.state = State.Swapping
		cell2.state = State.Swapping