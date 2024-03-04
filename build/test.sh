#!/bin/bash

## easier:  echo http://url/q?=$( rawurlencode "$args" )
## faster:  rawurlencode "$args"; echo http://url/q?${REPLY}
rawurlencode() {
    local string="${1}"
    local strlen=${#string}
    local encoded=""
    local pos c o

    for ((pos = 0; pos < strlen; pos++)); do
        c=${string:$pos:1}
        case "$c" in
        [-_.~a-zA-Z0-9]) o="${c}" ;;
        *) printf -v o '%%%02x' "'$c" ;;
        esac
        encoded+="${o}"
    done
    echo "${encoded}"  # You can either set a return variable (FASTER)
    REPLY="${encoded}" #+or echo the result (EASIER)... or both... :p
}

uriencode() {
    s="${1//'%'/%25}"
    s="${s//' '/%20}"
    s="${s//'"'/%22}"
    s="${s//'#'/%23}"
    s="${s//'$'/%24}"
    s="${s//'&'/%26}"
    s="${s//'+'/%2B}"
    s="${s//','/%2C}"
    s="${s//'/'/%2F}"
    s="${s//':'/%3A}"
    s="${s//';'/%3B}"
    s="${s//'='/%3D}"
    s="${s//'?'/%3F}"
    s="${s//'@'/%40}"
    s="${s//'['/%5B}"
    s="${s//']'/%5D}"
    printf %s "$s"
}


cat >./docs/index.html <<EOF
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Controller Gallery</title>
    <link rel="stylesheet" href="./index.css" />
  </head>

  <body>
    <section id="about" class="controller-section">
      <div class="container">
        <h2 class="section-heading">Gallery</h2>

        <div class="gallery-container">
EOF

for CSS_FileName in ./*/*.*ss; do

    args=${CSS_FileName:1}

    if [[ ${#args} == 0 ]]; then
        echo Len: ${#args} filename: $CSS_FileName CutDot: $args Path: $d
        continue

    else

        isds4w=$(cat "$CSS_FileName" | grep -E ".ds4.white {|.controller.ds4.white {")

        if [[ $isds4w ]]; then
            controller=8
            # echo true len: ${#isds4w}
            # echo value: $isds4w
            # echo filename: $CSS_FileName
        fi

        isds4=$(cat "$CSS_FileName" | grep -E ".ds4 {|.controller.ds4 {")

        if [[ $isds4 ]]; then
            controller=5
            # echo true len: ${#isds4}
            # echo value: $isds4
            # echo filename: $CSS_FileName
        fi

        isxbw=$(cat "$CSS_FileName" | grep -E ".xbox.white")
        if [[ $isxbw ]]; then
            controller=0
            # echo true len: ${#isxbw}
            # echo value: $isxbw
            # echo filename: $CSS_FileName
        fi

        isxb=$(cat "$CSS_FileName" | grep -E ".xbox {|.xbox{|.controller.xbox{")
        if [[ $isxb ]]; then
            controller=1
            # echo true len: ${#isxb}
            # echo value: $isxb
            # echo filename: $CSS_FileName
        fi

        echo $args
        Encoded_Component=$(uriencode "$args")
        # https://Wolflexx.github.io/$CSS_FileName

        cat >>./docs/index.html <<EOF
        <div class="gallery-item" >
        <iframe loading="lazy" src="https://gamepadviewer.com/?p=1&s=$controller&editcss=https://Wolflexx.github.io$Encoded_Component"></iframe>
        </div>
EOF

    fi
    # echo "$CSS_FileName";
done

## test=find ./*/ -name '*.css';

## echo $test[0];

#           <div class="gallery-item">
#            <iframe src="https://gamepadviewer.com/?p=1&s=5"></iframe>
#          </div>

cat >>./docs/index.html <<EOF
<p>Check Out All Controllers Here</p>
          <!-- Add more gallery items as needed -->
        </div>
      </div>
    </section>
  </body>
</html>

EOF
