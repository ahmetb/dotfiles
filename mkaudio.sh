#!/bin/bash
set -xeou pipefail
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"


rm -rf -- "${SCRIPT_DIR}/.audio"
mkdir -p -- "${SCRIPT_DIR}/.audio"
cd -- "${SCRIPT_DIR}/.audio"

youtube-dl -f 251 'https://www.youtube.com/watch?v=Up81uR5z88w' -o- > izmir.in.opus
ffmpeg -i izmir.in.opus -ss 2:07 -to 2:22 izmir.out.opus
rm izmir.in.opus

youtube-dl -f 251 'https://www.youtube.com/watch?v=NtSBJoO-pqg' -o- > plevne.opus
ffmpeg -i plevne.opus -ss 2:06.500 -to 2:26 plevne.out.opus
rm plevne.opus

youtube-dl -f 251 'https://www.youtube.com/watch?v=SZCCT2jauF8' -o- >  savas.in.webm
ffmpeg -i savas.in.webm -ss 2:10 -to 2:28 savas.out.webm
rm savas.in.webm


youtube-dl -f 251 'https://www.youtube.com/watch?v=NuT0Vd0d3qk' -o- > banzai.webm
ffmpeg -i banzai.webm -ss 01:03 -to 01:12 banzai.out.webm
rm banzai.webm
