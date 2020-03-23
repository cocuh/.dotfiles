function ffmpeg-conv2ogg(){
    cmd=$0
    Usage() {
        echo "USAGE: $cmd [-s] [-m] input output"
    }
    inputfile= outputfile= symmetry=false
    metadata="-map_metadata -1"

    while getopts sm opt
    do
        case "$opt" in
            "s") symmetry=true;;
            "m") metadata="";;
        esac
    done

    shift $((OPTIND -1))

    case $# in
        1 )
            if ! $symmetry; then
                Usage
                return 1
            fi
            inputfile=$1
            outputfile=${inputfile%.*}.ogg
            ;;
        2 )
            inputfile=$1
            outputfile=$2
            ;;
        * )
            Usage
            return 1
            ;;
    esac
    ffmpeg -i $inputfile ${=metadata} -acodec libvorbis -vn -ab 256k $outputfile
}

function ffmpeg-conv2mp3(){
    cmd=$0
    Usage() {
        echo "USAGE: $cmd [-s] [-m] input output"
        return 1
    }
    inputfile= outputfile= symmetry=false
    metadata="-map_metadata -1"

    while getopts sm opt
    do
        case "$opt" in
            "s") symmetry=true;;
            "m") metadata="";;
        esac
    done

    shift $((OPTIND -1))

    case $# in
        1 )
            if ! $symmetry; then
                Usage
                return 1
            fi
            inputfile=$1
            outputfile=${inputfile%.*}.mp3
            ;;
        2 )
            inputfile=$1
            outputfile=$2
            ;;
        * )
            Usage
            return 1
            ;;
    esac
    ffmpeg -i $inputfile ${=metadata} -acodec mp3 -vn -ab 256k $outputfile
}

function ffmpeg-conv2twitter(){
  ffmpeg -i $1 -vcodec h264 $2
}
