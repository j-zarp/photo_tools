from datetime import datetime, timedelta
from PIL import Image, ExifTags
import piexif
import os

# rename a file using the time metadata in format '%Y-%m-%d_%H%M%S' + unique_number

path = './'

files = []
files += [each for each in os.listdir(path) if each.endswith('.JPG') or each.endswith('.jpg') or each.endswith('.JPEG') or each.endswith('.jpeg')]

for k, fname in enumerate(files):
    print(fname + '...', end=' --> ')
    img = Image.open(os.path.join(path,fname))
    exif_dict = piexif.load(img.info['exif'])
    
    # time data
    key = piexif.ExifIFD.DateTimeOriginal # = piexif.ExifIFD.DateTimeDigitized
    str_time = exif_dict['Exif'][key]
    str_time = str_time.decode('UTF-8')  # if string is of the form b'...'
    time = datetime.strptime(str_time, '%Y:%m:%d %H:%M:%S')
    
    fname_new = f"{time.strftime('%Y-%m-%d_%H%M%S')}_{k}.{fname.split('.')[1]}"
    print(fname_new)
    os.system(f"cp {os.path.join(path,fname)} {os.path.join(path,fname_new)}")


