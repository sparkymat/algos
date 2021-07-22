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

def place(board_size, placements, row)
  return placements if row >= board_size

  # check if valid
  placed_positions = placements.map.with_index(0) {|c,i| Placement.new(row: i, column: c) }.select{|p| p.column != -1}

  candidates = (0..board_size-1).map{|c| Placement.new(row: row,column: c) }

  allowed_candidates = candidates.reject do |candidate|
    placed_positions.map{|p| candidate.attacking?(p) }.reduce{ |c,i| c = c || i }
  end

  return nil if allowed_candidates.nil? || allowed_candidates.empty?

  allowed_candidates.each do |ac|
    updated_placements = [] + placements
    updated_placements[ac.row] = ac.column
    placed = place(board_size, updated_placements, row+1)
    return placed unless placed.nil?
  end

  return nil
end

def print_board(board_size, placements)
  print '┌' + ('───┬' * (board_size-1)) + '───┐' + "\n"
  (0..board_size-1).each do |row|
    print '│   '*board_size + '│' + "\n"
    if row != board_size - 1
      print '├' + ('───┼' * (board_size-1)) + '───┤' + "\n"
    end
  end
  print '└' + ('───┴' * (board_size-1)) + '───┘' + "\n"
end

placed = place(8, [-1]*8, 0)

placements = placed.map.with_index(0) { |c,i| Placement.new(row: i, column: c) }

print_board(8, placements)
