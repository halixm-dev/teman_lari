from PIL import Image

def pad_image(input_path, output_path, scale_factor=0.66):
    img = Image.open(input_path).convert("RGBA")
    
    # Calculate new size
    new_width = int(img.width * scale_factor)
    new_height = int(img.height * scale_factor)
    
    # Resize the original image
    resized_img = img.resize((new_width, new_height), Image.Resampling.LANCZOS)
    
    # Create a new transparent image with the original size
    new_img = Image.new("RGBA", (img.width, img.height), (0, 0, 0, 0))
    
    # Calculate position to paste the resized image in the center
    paste_x = (img.width - new_width) // 2
    paste_y = (img.height - new_height) // 2
    
    # Paste the resized image onto the transparent background
    new_img.paste(resized_img, (paste_x, paste_y), resized_img)
    
    # Save the result
    new_img.save(output_path)
    print(f"Saved padded image to {output_path}")

if __name__ == "__main__":
    pad_image("Icon.png", "Icon_foreground.png", scale_factor=0.6)
