from PIL import Image
import os
import pyperclip

def listdir_nohidden(path):
    for f in os.listdir(path):
        if not f.startswith('.'):
            yield f

# global variables
sFolderName = "/Users/chris/Documents/Art/Goldenrod Kaleidascope/Textures/" # improvement: this can be any filepath (local or global) but warning - python will attempt to convert every file
lFileNames = listdir_nohidden(sFolderName)
iPixelSize = 10
for sFileName in lFileNames: # loop through all files
    # loop vars
    if os.path.splitext(sFileName)[1] == ".svg":
        continue
    oImage = Image.open(sFolderName + sFileName)
    sFileNameNoExtension = os.path.splitext(oImage.filename)[0]
    sFileExtension = os.path.splitext(oImage.filename)[1]
    sFileToWrite = sFileNameNoExtension + ".svg"
    oRGBAImage = oImage.convert('RGBA')
    iWidth = oImage.size[0]
    iHeight = oImage.size[1]
    oFile = open(sFileToWrite,"w")

    # begin writing of svg
    oFile.write('<svg xmlns="http://www.w3.org/2000/svg" width="'+ str(iPixelSize*iWidth) +'" height="' + str(iPixelSize*iHeight) + '">\n')

    for j in range(0, iHeight): # y
        for i in range(0, iWidth): # x
            iR, iG, iB, iA = oRGBAImage.getpixel((i,j))
            if iA > 0:
                oFile.write('\t<rect id="x' + str(i) + 'y' + str(j) + '" class="rect" fill="rgb(' + str(iR) + ',' + str(iG) + ',' + str(iB) + ')" height="' + str(iPixelSize) + '" width="' + str(iPixelSize) + '" x="' + str(i*iPixelSize) + '" y="' + str(j*iPixelSize) + '"/>\n')

    oFile.write('</svg>')
    oFile.close()
    # end writing of svg

    # copy to clipboard
    with open(sFileToWrite, 'r') as myfile:
      sData = myfile.read()
    pyperclip.copy(sData)
    print "Done! SVG was written to " + sFileToWrite + " and was copied to your keyboard!"