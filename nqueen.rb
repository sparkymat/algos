Bundler.require

BOARD_SIZE = 8

class Placement
  attr :row, :column
  def initialize(row:, column:)
    @row = row
    @column = column
  end

  def attacking?(p2)
    debugger if @row==4 && @column==1 && p2.row == 0 && p2.column == 3
    @row == p2.row ||
      @column == p2.column ||
      (@row-@column) == (p2.row-p2.column) ||
      (@row+@column) == (p2.row+p2.column)
  end

  def inspect
    "(#{@row+1},#{@column+1})"
  end
end

def place(placements, row)
  debugger if placements == [3,6,2,7,-1,-1,-1,-1]
  return placements if row >= BOARD_SIZE

  # check if valid
  placed_positions = placements.map.with_index(0) {|c,i| Placement.new(row: i, column: c) }.select{|p| p.column != -1}

  candidates = (0..BOARD_SIZE-1).map{|c| Placement.new(row: row,column: c) }

  allowed_candidates = candidates.reject do |candidate|
    placed_positions.map{|p| candidate.attacking?(p) }.reduce{ |c,i| c = c || i }
  end

  return nil if allowed_candidates.nil? || allowed_candidates.empty?

  allowed_candidates.each do |ac|
    updated_placements = [] + placements
    updated_placements[ac.row] = ac.column
    placed = place(updated_placements, row+1)
    return placed unless placed.nil?
  end

  return nil
end

placed = place([-1]*BOARD_SIZE, 0)

pp placed.map.with_index(0) { |c,i| Placement.new(row: i, column: c) }

