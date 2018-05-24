call "C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\VC\Auxiliary\Build\VCVARS64.BAT"
cl /Foclipper_godot.obj /c clipper_godot.cpp /nologo -EHsc -DNDEBUG /MD /I. /I../../godot_headers
cl /Foclipper.obj /c clipper.cpp /nologo -EHsc -DNDEBUG /MD /I. /I../../godot_headers
link /nologo /dll /out:../bin/libclipper.dll /implib:../bin/libclipper.lib clipper_godot.obj clipper.obj
pause
