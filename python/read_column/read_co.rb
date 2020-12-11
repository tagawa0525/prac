#! ruby

require 'fileutils'
require 'scanf'

XY = Struct.new(:x, :y)
class XYArray < Array
end

# Comment for NKC
class NKC
  attr_reader :cat_data

  HeaderSize = 4
  Category = Struct.new(:c1, :c2, :c3, :t4)
  def self.parse_data(path)
    nkcs = NKCArray.new
    row_col = read_data_csv(path)
    col_row = row_col.transpose
    col_row.shift
    col_row.pop
    while (t1_x = col_row.shift)
      _no, name, key, _category = t1_x.shift(HeaderSize).map(&:strip)
      nkc = NKC.new(name, key)

      t1_y = col_row.shift; t1_y.shift(HeaderSize)
      t2_x = col_row.shift; t2_x.shift(HeaderSize)
      t2_y = col_row.shift; t2_y.shift(HeaderSize)
      t3_x = col_row.shift; t3_x.shift(HeaderSize)
      t3_y = col_row.shift; t3_y.shift(HeaderSize)

      [[:c1, t1_x, t1_y], [:c2, t2_x, t2_y], [:c3, t3_x, t3_y]].each do |t, xs, ys|
        xs.map(&:strip).zip(ys.map(&:strip)) do |x, y|
          nkc.cat_data[t] << XY.new(x.to_f, y.to_f) unless x.empty?
        end
      end
      nkcs << nkc
    end
    nkcs
  end

  def initialize(name, key)
    @name = name
    @key = key

    @cat_data = Category.new(XYArray.new, XYArray.new, XYArray.new, XYArray.new)
  end

  def to_s
    sprintf("%4s, %4s", @name, @key)
  end

  DataPerLine = 6
  def write_t4_file
    t4_path = File.join('inp', format('%s_%s.txt', @name, @key))
    c4_size = @cat_data.c1.size
    File.open(t4_path, 'w') do |f|
      f.puts '# comment'
      f.puts format('%-4i', c4_size)
      c4_size.times do |idx|
        f.printf('%6.3f%6.3f', idx + 1, 40 + idx)
        f.puts if idx % DataPerLine == (DataPerLine - 1)
      end
    end
    t4_path
  end

  def read_t4_file
    t4_path = File.join('inp', format('%s_%s.txt', @name, @key))
    File.open(t4_path) do |f|
      f.gets # comment
      t4_size = f.gets.to_i
      while f.gets
        xy_6 = $_.scanf('%6c%6c' * DataPerLine).map(&:to_f)
        DataPerLine.times do
          x, y = xy_6.shift(2)
          @cat_data[:t4] << XY.new(x, y) if x
        end
      end
      unless @cat_data[:t4].size == t4_size
        pp @cat_data[:t4].size
        pp t4_size
        pp @cat_data[:t4]
        raise
      end
    end
    t4_path
  end

  def write_csv_file
    csv_data = make_csv_data
    csv_path = File.join('out', format('%s_%s.csv', @name, @key))
    FileUtils.mkdir_p('out')
    File.open(csv_path, 'w') do |f|
        f.puts csv_data.join("\n")
    end
    return csv_path
  end

  def make_csv_data
    csv_data = []
    fmt = (["%8s"] * 9).join(',')
    name_key = sprintf("%s & %s", @name, @key)
    csv_data << sprintf(fmt, "name key", name_key, '', name_key, '', name_key, '', name_key, '')
    csv_data << sprintf(fmt, "category", "c1", '', "c2", '', "c3", '', "c4", '')
    title = 'data'
    @cat_data.map{|cd| cd.size}.max.times do |idx|
      row = []
      row << format('%8s', title)
      @cat_data.each do |cd|
        row << if cd[idx]
                 format('%8s,%8s', cd[idx].x, cd[idx].y)
               else
                 format('%8s,%8s', '', '')
               end
      end
      csv_data << row.join(',')
      title = ''
    end
    csv_data
  end
end

class NKCArray < Array
  def to_s
    str = []
    str << format('%4s, %4s', :name, :key)
    each do |nkc|
      str << nkc.to_s
    end
    str.join("\n")
  end
end

def read_data_csv(path)
  row_col = []
  File.open(path) do |f|
    while f.gets
      row = $_.split(',')
      row_col << row
    end
  end
  row_col
end

nkcs = NKC.parse_data('inp/data1.csv')
nkcs.each do |nkc|
  nkc.write_t4_file
  nkc.read_t4_file
  nkc.write_csv_file
end
puts nkcs.to_s
