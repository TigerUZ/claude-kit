---
name: ffmpeg-video
description: FFmpeg and media-automation playbook - probing, cutting, vertical 9:16 shorts, burned-in subtitles, Whisper transcription, loudness, silence removal, thumbnails, batch scripts. Use whenever a task involves processing video or audio files.
---

# FFmpeg / video automation

Workflow rules
1. `ffprobe` every input first; decide from facts (codec, resolution, fps, rotation, audio).
2. Prototype on a short sample (`-ss 30 -t 10`) and show the command before running on full files.
3. Build pipelines as scripts in `scripts/` (bash `set -euo pipefail` or Python with argument lists). Never interpolate user-provided names into shell strings.
4. Output to `out/`, never overwrite originals; make reruns idempotent (skip existing outputs).
5. Prefer existing tools: `auto-editor` (silence cuts), `faster-whisper` (transcripts/subtitles), `yt-dlp` (download media you have rights to), Remotion (templated/branded video in React).
6. Finish by reporting each output with duration, resolution, size.

Recipes are in [reference.md](reference.md) - read the relevant section before writing commands.
