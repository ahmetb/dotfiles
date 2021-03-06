#!/bin/bash
set -xeou pipefail
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

rm -rf -- "${SCRIPT_DIR}/.audio"
mkdir -p -- "${SCRIPT_DIR}/.audio"
cd -- "${SCRIPT_DIR}/.audio"

youtube-dl -q -f 251 'https://www.youtube.com/watch?v=7ivcvcWmOPI' -o- > sedat.in.opus
ffmpeg -loglevel fatal -i sedat.in.opus -ss 0:00.20 -to 0:07.70 -f mp3 sedat.mp3
rm sedat.in.opus

youtube-dl -q -f 251 'https://www.youtube.com/watch?v=Up81uR5z88w' -o- > izmir.in.opus
ffmpeg -loglevel fatal -i izmir.in.opus -ss 2:08 -to 2:22 -f mp3 izmir.mp3
rm izmir.in.opus

youtube-dl -q -f 251 'https://www.youtube.com/watch?v=NtSBJoO-pqg' -o- > plevne.opus
ffmpeg -loglevel fatal -i plevne.opus -ss 2:06.500 -to 2:15 -f mp3 plevne.mp3
rm plevne.opus

youtube-dl -q -f 251 'https://www.youtube.com/watch?v=SZCCT2jauF8' -o- >  savas.in.webm
ffmpeg -loglevel fatal -i savas.in.webm -ss 2:10 -to 2:28 -f mp3 savas.mp3
rm savas.in.webm

youtube-dl -q -f 251 https://www.youtube.com/watch\?v\=j6jL95BaSeM -o- > recep.m4a
ffmpeg -loglevel fatal -i recep.m4a -ss 1:19 -to 1:31.50 -f mp3 recep.mp3
rm recep.m4a

youtube-dl -q -f 251 https://www.youtube.com/watch\?v\=Q997SPR0BaA -o- > dansedenkurt.webm
ffmpeg -loglevel fatal -i dansedenkurt.webm -ss 0:15.200 -to 0:23 -f mp3 dansedenkurt.mp3
rm dansedenkurt.webm
