import subprocess

# Specify the file path
file_path = "VID-20230410-WA0001.mp4"

# Set the creation date
creation_date_str = "2023-04-10 12:30:00"

# Use exiftool to set the creation date
subprocess.run(['exiftool', '-overwrite_original', '-CreateDate=' + creation_date_str, file_path])


