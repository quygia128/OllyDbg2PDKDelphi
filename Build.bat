del OD2DelphiPlugin.dll
del *.~*
del "Resources Backup*"
dcc32 -Q OD2DelphiPlugin.dpr -$O+
del *.~* /s
<<<<<<< HEAD
del *.dcu /s
=======
>>>>>>> git  comit
del *.ddp /s
del *.dti /s
del *.dof /s
del *.cfg /s
del *.bak /s
del *.local
del *.bdsproj
del *.identcache /s
cls
@echo off