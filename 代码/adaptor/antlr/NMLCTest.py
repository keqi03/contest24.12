import sys,io
from antlr4 import *
from antlr import NMLCLexer,NMLCParser,NMLCListener
import subprocess
import tkinter as tk
from tkinter import messagebox
from contextlib import redirect_stdout

# 验证是否符合词法规定
class NMLCPrintListener(NMLCListener.NMLCListener):
  def enterR(self, ctx):
    # 函数名enterR的R指的是非终结符r
    print("NMLC: %s" % ctx.ID())

def main():
  lexer = NMLCLexer.NMLCLexer(StdinStream())
  stream = CommonTokenStream(lexer)
  parser = NMLCParser.NMLCParser(stream)
  tree = parser.prog()
  printer = NMLCPrintListener()
  walker = ParseTreeWalker()
  walker.walk(printer, tree)
  # result = subprocess.run(['echo'], stdout=subprocess.PIPE, shell=True)
  # output = result.stdout.decode('gbk')
  # # 创建GUI界面
  # root = tk.Tk()
  # root.withdraw()  # 隐藏主窗口
  # # 创建弹窗，显示控制台输出结果
  # messagebox.showinfo('控制台输出结果', output)
  #
# def my_function():
#     print('Hello, world!')
#     print('This is a test.')



if __name__ == '__main__':
  # 用于保存控制台输出流的变量
  output = io.StringIO()
  # 捕获控制台输出流
  with redirect_stdout(output):
    main()
  # 创建弹窗并显示结果
  root = tk.Tk()
  root.geometry('800x600')
  text = tk.Text(root, font=('微软雅黑', 12))
  text.pack(expand=True, fill='both')
  text.insert('end', output.getvalue())
  root.mainloop()
