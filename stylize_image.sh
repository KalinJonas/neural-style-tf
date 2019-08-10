set -e
# Get a carriage return into `cr`
cr=`echo $'\n.'`
cr=${cr%.}

if [ "$#" -le 1 ]; then
   echo "Usage: bash stylize_image.sh <path_to_content_image> <path_to_style_image> <max_iterations>"
   exit 1
fi

#echo ""
#read -p "Did you install the required dependencies? [y/n] $cr > " dependencies
dependencies="y"

if [ "$dependencies" != "y" ]; then
  echo "Error: Requires dependencies: tensorflow, opencv2 (python), scipy"
  exit 1;
fi

#echo ""
#read -p "Do you have a CUDA enabled GPU? [y/n] $cr > " cuda
cuda="n"

if [ "$cuda" != "y" ]; then
  device='/cpu:0'
else
  device='/gpu:0'
fi

# Parse arguments
content_image="$1"
content_dir=$(dirname "$content_image")
content_filename=$(basename "$content_image")

style_image="$2"
style_dir=$(dirname "$style_image" )
style_filename=$(basename "$style_image")

max_iterations="$3"

echo "Rendering stylized image. This may take a while..."
python neural_style.py \
--max_iterations "${max_iterations}" \
--content_img "${content_filename}" \
--content_img_dir "${content_dir}" \
--style_imgs "${style_filename}" \
--style_imgs_dir "${style_dir}" \
--device "${device}" \
--verbose;
