import os, json
from PIL import Image, ImageDraw

base = "Assets.xcassets/AppIcon.appiconset"
os.makedirs(base, exist_ok=True)

size = 1024
img = Image.new("RGBA", (size, size), (0,0,0,0))
draw = ImageDraw.Draw(img)

rect = [(100, 100), (924, 924)]
draw.rounded_rectangle(rect, radius=220, fill="#007AFF")

center_x, center_y = 512, 600
arm_len = 280
half_width = 140
line_width = 80

draw.line([(center_x, center_y+100), (center_x - half_width, center_y - arm_len)],
          fill="white", width=line_width, joint="curve")
draw.line([(center_x, center_y+100), (center_x + half_width, center_y - arm_len)],
          fill="white", width=line_width, joint="curve")

master_path = os.path.join(base, "appstore-1024.png")
img.save(master_path)

images = [{"size": "1024x1024", "idiom": "ios-marketing", "filename": "appstore-1024.png", "scale": "1x"}]

sizes = [
    (20, "iphone", 2), (20, "iphone", 3),
    (29, "iphone", 2), (29, "iphone", 3),
    (40, "iphone", 2), (40, "iphone", 3),
    (60, "iphone", 2), (60, "iphone", 3),
    (20, "ipad", 1), (20, "ipad", 2),
    (29, "ipad", 1), (29, "ipad", 2),
    (40, "ipad", 1), (40, "ipad", 2),
    (76, "ipad", 1), (76, "ipad", 2),
    (83.5, "ipad", 2),
    (1024, "ios-marketing", 1)
]

for size_pt, idiom, scale in sizes:
    size_px = int(size_pt * scale)
    resized = img.resize((size_px, size_px), Image.LANCZOS)
    filename = f"icon_{idiom}_{int(size_pt)}x{scale}x.png"
    resized.save(os.path.join(base, filename))
    images.append({
        "size": f"{size_pt}x{size_pt}",
        "idiom": idiom,
        "filename": filename,
        "scale": f"{scale}x"
    })

contents = {"images": images, "info": {"version": 1, "author": "veil"}}
with open(os.path.join(base, "Contents.json"), "w") as f:
    json.dump(contents, f, indent=2)

print("✅ App icon generated.")
