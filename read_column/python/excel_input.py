#! python

class ColumnXsYs:
    RowCategory = 3

    def __init__(self, col_num, xs, ys):
        self.num = col_num
        self.xs = xs
        self.ys = ys

    def isLastCategory(self):
        if "c3" in self.xs[self.RowCategory]:
            return True
        else:
            return False


class ExcelInput:
    def __init__(self, path):
        self.path = path
        self.parse()

    def parse(self):
        from openpyxl import load_workbook

        wb = load_workbook(filename=self.path)
        ws = wb['Digital']
        self.column_xs_ys_list = []
        for idx, col in enumerate(ws.columns):
            if idx == 0:
                # skip first column
                continue
            if idx % 2 == 1:
                col_num = idx
                xs = [cell.value for cell in col]
            if idx % 2 == 0:
                ys = [cell.value for cell in col]
                self.column_xs_ys_list.append(ColumnXsYs(col_num, xs, ys))
        return self

    def to_NKCs(self):
        from nkc import NKC
        nkc_list = []
        c_xs_ys_per_nkc = []
        for c_xs_ys in self.column_xs_ys_list:
            c_xs_ys_per_nkc.append(c_xs_ys)
            if c_xs_ys.isLastCategory():
                nkc_list.append(NKC().set_data(c_xs_ys_per_nkc))
                c_xs_ys_per_nkc = []
        return nkc_list


if __name__ == '__main__':
    path = r'inp/data1.xlsx'
    inp_exl = ExcelInput(path)
    nkc_list = inp_exl.to_NKCs()

    print(len(nkc_list))
    print()
    for nkc in nkc_list:
        print(len(nkc.categories))
        for cat in nkc.categories:
            print(cat.name)
            for xy in cat.xys:
                print(xy.x, xy.y)
        print()
