nasm -fwin32 fizzbuzz.asm
alink -oPE -entry _main -subsys char fizzbuzz.obj win32.lib