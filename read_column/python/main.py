#! python

def convert_data1_to_each_data(path):
    from excel_input import ExcelInput
    xlsx_inp = ExcelInput(path)
    nkc_list = xlsx_inp.to_NKCs()

    for nkc in nkc_list:
        nkc.add_c4_data()
        nkc.write_excel_output()


if __name__ == '__main__':
    path = r'inp/data1.xlsx'
    convert_data1_to_each_data(path)
