# Modified from https://www.junian.net/tech/powershell-ffmpeg-batch/    09-06-2022

# Clone this repository into a download location for the fullband audio files, then run it 

# Grabs list of files with wavpack extensions in the directory we're in context of
$originalClips = Get-ChildItem input/*.wav #-Recurse

foreach ($inputVid in $originalClips) {
    # Keep the filename, append 'converted' for easy differentiation
    # May be easiest to pre-name files before applying conversion script
    $outputClip = [io.path]::ChangeExtension($inputVid.FullName, 'converted.wav')

    # Makes assumption ffmpeg.exe is running locally to the script, but if installed globally then it'll work as well
    & "$PSScriptRoot/ffmpeg.exe" -loglevel error -hide_banner -i $inputVid.FullName -ar 8000 -ac 1 $outputClip
        # -ar 8000              = 8khz (G.711 Narrowband)
        # -ac 1                 = Stereo -> Mono (Single Channel)
        # -loglevel warning     = Reduce output to minimal possible, with only warnings and worse included
        # -hide_banner          = Remove usual compilation banner when running 
        # Source: https://ffmpeg.org/ffmpeg.html#Audio-Options 

    # Whatever file we create, move it into an output folder in context of where we call it
    Move-Item $outputClip output
}
