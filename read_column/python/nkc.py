#! python

import copy


class NKC_Header:
    def __init__(self, xs_org):
        xs = copy.deepcopy(xs_org)
        self.num = int(xs.pop(0))
        self.name = xs.pop(0).strip()
        self.key = xs.pop(0).strip()

    def excel_output_path(self):
        return "out/{}_{}.xlsx".format(self.name, self.key)

    def c4_input_path(self):
        return "inp/{}_{}.txt".format(self.name, self.key)


class XY:
    def __init__(self, x, y):
        self.x = x
        self.y = y


class Category:
    def __init__(self, category_name):
        self.name = category_name

    def set_by_xs_ys(self, xs, ys):
        self.xys = []
        for x, y in zip(xs, ys):
            if type(x) in (int, float) and type(y) in (int, float):
                self.xys.append(XY(x, y))
        return self


class NKC:
    def set_data(self, column_xs_ys_list):
        from excel_input import ColumnXsYs
        self.categories = []
        category_name = None
        for idx, c_xs_ys in enumerate(column_xs_ys_list):
            c_xs = c_xs_ys.xs
            c_ys = c_xs_ys.ys
            category_name = c_xs[ColumnXsYs.RowCategory].strip()
            if idx == 0:
                self.header = NKC_Header(c_xs)
            for _idx in range(4):
                c_xs.pop(0)
                c_ys.pop(0)
            cat = Category(category_name).set_by_xs_ys(c_xs, c_ys)
            self.add_category(cat)
        return self

    def add_category(self, cat):
        self.categories.append(cat)
        return self

    def add_c4_data(self):
        from c4_file import C4File
        c4_path = self.c4_input_path()
        cat = C4File(c4_path).to_NKC_Category()
        self.add_category(cat)
        return self

    def write_excel_output(self):
        from excel_output import ExcelOputput
        xlsx_out = ExcelOputput(self.excel_output_path())
        xlsx_out.write(self)
        return self

    def c4_input_path(self):
        return self.header.c4_input_path()

    def excel_output_path(self):
        return self.header.excel_output_path()


if __name__ == '__main__':
    from excel_input import ExcelInput

    path = r'inp/data1.xlsx'
    nkc_list = ExcelInput(path).to_NKCs()

    for nkc in nkc_list:
        print(nkc.c4_input_path())
        nkc.add_c4_data()
        print(nkc.excel_output_path())
        nkc.write_excel_output()
