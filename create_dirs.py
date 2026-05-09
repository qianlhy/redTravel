import subprocess
import sys
import os

dirs_to_create = [
    r"C:\Users\Administrator\Desktop\2026年1月7日\卡歌\红色旅游小网站\camping-wx-uniapp\camping-wx-uniapp\pages\route",
    r"C:\Users\Administrator\Desktop\2026年1月7日\卡歌\红色旅游小网站\camping-wx-uniapp\camping-wx-uniapp\pages\booking",
    r"C:\Users\Administrator\Desktop\2026年1月7日\卡歌\红色旅游小网站\camping-wx-uniapp\camping-wx-uniapp\pages\attraction",
]

for path in dirs_to_create:
    parent = os.path.dirname(path)
    name = os.path.basename(path)
    # Use cmd /c md which works with Unicode paths
    result = subprocess.run(
        ["cmd", "/c", "mkdir", path],
        capture_output=True,
        text=True,
        encoding="utf-8",
        errors="replace"
    )
    if result.returncode == 0:
        print(f"Created: {path}")
    else:
        print(f"Failed: {path}")
        print(f"  stdout: {result.stdout}")
        print(f"  stderr: {result.stderr}")

print("Done.")
