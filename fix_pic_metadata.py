from datetime import datetime, timedelta
from PIL import Image, ExifTags
import piexif
import os

path = '/home/user/pictures/.'

h_offset = -9.0
m_offset = 0.0

files = []
files += [each for each in os.listdir(path) if each.endswith('.JPG') or each.endswith('.jpg') or each.endswith('.JPEG') or each.endswith('.jpeg')]

for fname in files:
    print(fname + '...')
    img = Image.open(os.path.join(path,fname))
    exif_dict = piexif.load(img.info['exif'])
    
    # time data
    t_offset = timedelta(hours=h_offset, minutes=m_offset)
    keys = [piexif.ExifIFD.DateTimeOriginal, piexif.ExifIFD.DateTimeDigitized]
    for key in keys:
        str_time = exif_dict['Exif'][key]
        #str_time = str_time.decode('UTF-8')  # if string is of the form b'...'
        time = datetime.strptime(str_time, '%Y:%m:%d %H:%M:%S')
        time += t_offset
        exif_dict['Exif'][key] = time.strftime('%Y:%m:%d %H:%M:%S')
    exif_bytes = piexif.dump(exif_dict)
    
    #fname = fname.split('.')[0]+'_2.'+fname.split('.')[1]
    img.save('%s' % os.path.join(path,fname), "JPEG", exif=exif_bytes)
    piexif.insert(exif_bytes, os.path.join(path,fname))
    
    ## GPS data
    #exif = { ExifTags.TAGS[k]: v for k, v in img._getexif().items() if k in ExifTags.TAGS }
    #gpsinfo = {}
    #for key in exif['GPSInfo'].keys():
    #    decode = ExifTags.GPSTAGS.get(key,key)
    #    gpsinfo[decode] = exif['GPSInfo'][key]
    ##print gpsinfo
    #for key in gpsinfo.keys():
    #    print '{}: {}'.format(key, gpsinfo[key])
    #print ''

