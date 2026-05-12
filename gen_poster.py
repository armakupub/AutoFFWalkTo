from PIL import Image, ImageDraw, ImageFont
import os

SIZE = 256
BG = (30, 30, 35)
ORANGE = (220, 160, 40)
WHITE = (255, 255, 255)
GRAY = (70, 70, 75)

img = Image.new("RGB", (SIZE, SIZE), BG)
draw = ImageDraw.Draw(img)

# --- Icon area (centered vertically in upper portion, y ~60-150) ---
icon_cy = 100  # vertical center of icon area

# Dotted path (centered horizontal line)
path_y = icon_cy + 20
dash_w = 12
gap = 8
x = 45
while x < 210:
    draw.rectangle([x, path_y - 2, x + dash_w, path_y + 2], fill=GRAY)
    x += dash_w + gap

# Start point
draw.ellipse([35, path_y - 7, 49, path_y + 7], fill=GRAY)

# End point (destination marker)
draw.ellipse([207, path_y - 7, 221, path_y + 7], fill=ORANGE)
draw.rectangle([211, path_y - 13, 217, path_y - 5], fill=ORANGE)

# Fast-forward symbol (two triangles) - centered above path
ff_cx = SIZE // 2
ff_cy = icon_cy - 25

tri_h = 20  # half height
tri_w = 24  # width of each triangle
gap_tri = 4

# First triangle
x1 = ff_cx - gap_tri // 2 - tri_w
tri1 = [(x1, ff_cy - tri_h), (x1, ff_cy + tri_h), (x1 + tri_w, ff_cy)]
draw.polygon(tri1, fill=ORANGE)

# Second triangle
x2 = ff_cx + gap_tri // 2
tri2 = [(x2, ff_cy - tri_h), (x2, ff_cy + tri_h), (x2 + tri_w, ff_cy)]
draw.polygon(tri2, fill=ORANGE)

# End bar (vertical line after triangles)
bar_x = x2 + tri_w + 4
draw.rectangle([bar_x, ff_cy - tri_h, bar_x + 6, ff_cy + tri_h], fill=ORANGE)

# --- Text at bottom (matching PassThroughWindow style) ---
try:
    font = ImageFont.truetype("arial.ttf", 22)
except:
    font = ImageFont.load_default()

text1 = "Auto Fast Forward"
text2 = "Walk To"

bbox1 = draw.textbbox((0, 0), text1, font=font)
bbox2 = draw.textbbox((0, 0), text2, font=font)
tw1 = bbox1[2] - bbox1[0]
tw2 = bbox2[2] - bbox2[0]
th = bbox1[3] - bbox1[1]

# Position text at bottom, centered (matching PassThroughWindow: text starts at y=205)
text_y = 205
draw.text(((SIZE - tw1) / 2, text_y), text1, fill=WHITE, font=font)
draw.text(((SIZE - tw2) / 2, text_y + th + 6), text2, fill=WHITE, font=font)

out = os.path.join(os.path.dirname(__file__), "poster.png")
img.save(out)
print(f"Saved to {out}")
