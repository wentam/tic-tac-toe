#!/usr/bin/env python3
# -*- coding: utf-8 -*-
from setuptools import setup

setup(name='ttt',
      version='0.0',
      author='Paul Egeler',
      description='Tic Tac Toe',
      url='https://github.com/pegeler/tic-tac-toe',
      license='GPL-3',
      package_dir={'ttt': 'src'},
      packages=['ttt'],
      entry_points={'console_scripts': ['ttt = ttt.__main__:main']},
      install_requires=['pygame'])
