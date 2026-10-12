# FFmpeg recipes

## Probe
```bash
ffprobe -v error -show_entries format=duration,size:stream=index,codec_type,codec_name,width,height,r_frame_rate,channels \
  -of json in.mp4
```

## Cut
```bash
# fast, keyframe-accurate only (no re-encode)
ffmpeg -ss 00:01:00 -to 00:02:00 -i in.mp4 -c copy out/cut.mp4
# frame-accurate (re-encode)
ffmpeg -ss 60 -i in.mp4 -t 45 -c:v libx264 -crf 20 -preset veryfast -c:a aac -b:a 160k out/cut.mp4
```

## Social/web delivery preset
```bash
ffmpeg -i in.mp4 -c:v libx264 -crf 21 -preset medium -pix_fmt yuv420p -movflags +faststart \
  -c:a aac -b:a 160k -af loudnorm=I=-14:TP=-1.5:LRA=11 out/web.mp4
```
Hardware encoders: macOS `-c:v h264_videotoolbox -b:v 8M`; NVIDIA `-c:v h264_nvenc -preset p5 -cq 21`.

## Vertical 9:16 (1080x1920)
```bash
# center crop from 16:9
ffmpeg -i in.mp4 -vf "crop=ih*9/16:ih,scale=1080:1920,setsar=1" -c:a copy out/vertical_crop.mp4

# full frame over blurred background
ffmpeg -i in.mp4 -filter_complex \
 "[0:v]scale=1080:1920:force_original_aspect_ratio=increase,crop=1080:1920,boxblur=20:2[bg];\
  [0:v]scale=1080:-2[fg];[bg][fg]overlay=(W-w)/2:(H-h)/2,setsar=1" \
 -c:v libx264 -crf 21 -pix_fmt yuv420p -c:a aac -b:a 160k out/vertical_blur.mp4
```
For speaker tracking crops, detect faces per scene (e.g. mediapipe/opencv) and generate a crop x-offset per segment; do not crop blindly.

## Transcribe -> SRT (faster-whisper)
```bash
ffmpeg -i in.mp4 -vn -ac 1 -ar 16000 -c:a pcm_s16le out/audio.wav
pip install faster-whisper
```
```python
from faster_whisper import WhisperModel
m = WhisperModel("large-v3", device="auto", compute_type="auto")   # "small" for speed on CPU
segments, info = m.transcribe("out/audio.wav", language=None, vad_filter=True, word_timestamps=True)
def ts(t): h,r=divmod(t,3600); m_,s=divmod(r,60); return f"{int(h):02}:{int(m_):02}:{s:06.3f}".replace(".",",")
with open("out/subs.srt","w",encoding="utf-8") as f:
    for i,s in enumerate(segments,1):
        f.write(f"{i}\n{ts(s.start)} --> {ts(s.end)}\n{s.text.strip()}\n\n")
```
Short-form captions: regroup `word_timestamps` into 2-4 word chunks for punchy subtitles.

## Burn subtitles
```bash
ffmpeg -i in.mp4 -vf "subtitles=out/subs.srt:force_style='FontName=Inter,FontSize=16,Bold=1,Outline=3,Shadow=0,Alignment=2,MarginV=120'" \
  -c:v libx264 -crf 20 -pix_fmt yuv420p -c:a copy out/subbed.mp4
```
Needs FFmpeg built with libass. For animated word-highlight captions generate an `.ass` file (karaoke `\k` tags) or render with Remotion.

## Loudness (two-pass, accurate)
```bash
ffmpeg -i in.mp4 -af loudnorm=I=-14:TP=-1.5:LRA=11:print_format=json -f null - 2>&1 | tail -12
# feed measured_I/TP/LRA/thresh/offset back into: loudnorm=I=-14:TP=-1.5:LRA=11:measured_I=..:measured_TP=..:measured_LRA=..:measured_thresh=..:offset=..:linear=true
```

## Silence removal
```bash
pip install auto-editor
auto-editor in.mp4 --margin 0.2sec -o out/tight.mp4
# or just detect:
ffmpeg -i in.mp4 -af silencedetect=noise=-35dB:d=0.6 -f null - 2>&1 | grep -E 'silence_(start|end)'
```

## Concat
```bash
printf "file '%s'\n" part1.mp4 part2.mp4 > list.txt
ffmpeg -f concat -safe 0 -i list.txt -c copy out/joined.mp4      # same codecs/params only
```
Different sources: normalise each to the same preset first, or use the `concat` filter.

## Thumbnails / frames
```bash
ffmpeg -ss 5 -i in.mp4 -frames:v 1 -q:v 2 out/thumb.jpg
ffmpeg -i in.mp4 -vf "select='gt(scene,0.4)',scale=640:-2" -fps_mode vfr out/scene_%03d.jpg
```

## Overlay logo / watermark
```bash
ffmpeg -i in.mp4 -i logo.png -filter_complex "[1]scale=180:-1[l];[0][l]overlay=W-w-40:40" -c:a copy out/branded.mp4
```

## Speed / GIF preview
```bash
ffmpeg -i in.mp4 -filter_complex "[0:v]setpts=0.5*PTS[v];[0:a]atempo=2.0[a]" -map "[v]" -map "[a]" out/2x.mp4
ffmpeg -ss 3 -t 4 -i in.mp4 -vf "fps=12,scale=480:-1:flags=lanczos,split[a][b];[a]palettegen[p];[b][p]paletteuse" out/preview.gif
```

## Download (only content you own or may reuse)
```bash
yt-dlp -f "bv*[height<=1080]+ba/b" --merge-output-format mp4 -o "in/%(id)s.%(ext)s" "<url>"
```
