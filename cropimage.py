mport numpy as np

# Load the image
image = Image.open(image_path)
image_data = np.array(image)

# Find the bounding box of the non-white region
non_white_pixels = np.where(np.all(image_data != [255, 255, 255], axis=-1))
top_left = np.min(non_white_pixels, axis=1)
bottom_right = np.max(non_white_pixels, axis=1)

# Crop the image to the bounding box
cropped_image = image.crop((top_left[1], top_left[0], bottom_right[1] + 1, bottom_right[0] + 1))

# Save the cropped image
cropped_output_path = '/mnt/data/HOMO_cropped.png'
cropped_image.save(cropped_output_path)

cropped_output_path
