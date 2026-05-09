# -*- coding: utf-8 -*-
import os
import sys

base = os.path.dirname(os.path.abspath(__file__))
pages = os.path.join(base, "camping-wx-uniapp", "camping-wx-uniapp", "pages")
for name in ["route", "booking", "attraction"]:
    p = os.path.join(pages, name)
    os.makedirs(p, exist_ok=True)
    print("Created: " + p)
print("All done.")
