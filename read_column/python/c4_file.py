#! python

class C4File:
    def __init__(self, path):
        self.path = path

    CommentLineNum = 1
    FixDataPerLine = 6
    LengthOfFixData = 6

    def to_NKC_Category(self):
        from nkc import Category
        xs = []
        ys = []
        with open(self.path) as f:
            for idx in range(self.CommentLineNum):
                f.readline()  # comment
            num_data = int(f.readline())
            num_read = 0
            for line in f:
                for idx in range(self.FixDataPerLine):
                    ixb = idx * self.LengthOfFixData * 2
                    iyb = ixb + self.LengthOfFixData
                    ixe = ixb + self.LengthOfFixData-1
                    iye = iyb + self.LengthOfFixData-1
                    x = float(line[ixb:ixe])
                    y = float(line[iyb:iye])
                    xs.append(x)
                    ys.append(y)
                    num_read += 1
                    if(num_read >= num_data):
                        break
                if(num_read >= num_data):
                    break
        return Category('c4').set_by_xs_ys(xs, ys)


if __name__ == '__main__':
    c4_path = r'inp/n1_k1.txt'
    c4_file = C4File(c4_path)
    nkc_data = c4_file.to_NKC_Category()
    for xy in nkc_data.xys:
        print(xy.x, xy.y)
