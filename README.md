# FFmpeg Video Converter
A video converter Script using FFmpeg for Linux

**NOTE** that FFmpeg is needed for this script to work!
But the script can download it for you if you don't have it installed.

## Features
* Convert videos from different file formats
* Add metadata
* Add subtitles
* Add cover art
* No re-encoding needed

### Conversion
FFmpeg supports many video formats.

#### Examples
* .mkv to .mp4
* .avi to .mkv
* .mp4 to .mkv

All video codecs can be found [here](https://www.ffmpeg.org/general.html#Video-Codecs).

It even works with supported [audio codecs](https://www.ffmpeg.org/general.html#Audio-Codecs).

### Metadata
Current supported metadata
* title
* date
* genre
* show
* season_number
* episode_id
* episode_sort
* language
* hd_video

### Cover Art
Add cover art to your videos or audio files instead of the boring auto generated icon.

Recommended formats for cover art is .png or .jpg files.

## Coming Features

### Very Likley
* More metadata
* More Optimized code
* Looping through full directory
* Multiple subtitles

### Possibly
* .bat version for Windows
* C# version with GUI
